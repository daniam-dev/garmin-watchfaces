"""Recursos de texto originales desde Roboto OFL. Requiere Pillow 13.x."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FONT = ROOT / "resources/fonts/Roboto.ttf"
SCALE = 4


def font(size):
    result = ImageFont.truetype(str(FONT), size * SCALE)
    result.set_variation_by_axes([700, 100])  # wght, wdth
    return result


def glyph(text, size):
    face = font(size)
    box = face.getbbox(text)
    # Garmin interpreta el PNG de BMFont como cobertura en un solo canal.
    image = Image.new("L", (box[2] - box[0] + 8, box[3] - box[1] + 8), 0)
    ImageDraw.Draw(image).text((4 - box[0], 4 - box[1]), text, font=face, fill=255)
    return image


def bitmap_font(name, size, chars):
    face = font(size)
    atlas = Image.new("L", (256, 128), 0)
    lines = []
    x = y = max_x = 0
    row_height = size + 4
    cap_top = face.getbbox("0")[1]
    for char in chars:
        box = face.getbbox(char)
        image = glyph(char, size)
        image = image.resize((round(image.width / SCALE), round(image.height / SCALE)), Image.Resampling.LANCZOS)
        if x + image.width >= atlas.width:
            x, y = 0, y + row_height
        atlas.paste(image, (x, y))
        advance = round(face.getlength(char) / SCALE)
        lines.append(f'char id={ord(char)} x={x} y={y} width={image.width} height={image.height} xoffset=-1 yoffset={round((box[1]-cap_top)/SCALE)} xadvance={advance} page=0 chnl=15')
        x += image.width + 2
        max_x = max(max_x, x)
    atlas = atlas.crop((0, 0, max_x, y + row_height))
    atlas.save(ROOT / f"resources/fonts/{name}.png")
    header = [f'info face="Roboto" size={size} bold=1 italic=0 unicode=1',
              f'common lineHeight={size} base={size} scaleW={atlas.width} scaleH={atlas.height} pages=1 packed=0',
              f'page id=0 file="{name}.png"', f'chars count={len(chars)}']
    (ROOT / f"resources/fonts/{name}.fnt").write_text("\n".join(header + lines) + "\n", encoding="utf-8")


bitmap_font("Value", 28, "-.0123456789°")
bitmap_font("Label", 23, "-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
bitmap_font("Small", 18, "-.0123456789")
resources = ['<drawables>', '    <bitmap id="LauncherIcon" filename="launcher_icon.svg"/>']
for number, angle in [(1, 30), (2, 60), (4, -60), (5, -30), (7, 30), (8, 60), (10, -60), (11, -30)]:
    image = glyph(str(number), 40).rotate(-angle, Image.Resampling.BICUBIC, expand=True)
    image = image.resize((round(image.width / SCALE), round(image.height / SCALE)), Image.Resampling.LANCZOS)
    # El dial bajo los números siempre es negro. Componer aquí evita reducir
    # el alfa a una máscara tramada y conserva bordes suaves al importar.
    image = Image.composite(Image.new("RGB", image.size, (243, 241, 236)),
                            Image.new("RGB", image.size, (0, 0, 0)), image)
    image.save(ROOT / f"resources/drawables/n{number}.png")
    resources.append(f'    <bitmap id="N{number}" filename="n{number}.png" dithering="none" automaticPalette="false"/>')
resources.append('</drawables>')
(ROOT / 'resources/drawables/drawables.xml').write_text('\n'.join(resources) + '\n', encoding='utf-8')
(ROOT / 'resources/fonts/fonts.xml').write_text('<fonts>\n' + ''.join(
    f'    <font id="{name}" filename="{name}.fnt" antialias="true"/>\n' for name in ['Value', 'Label', 'Small']) + '</fonts>\n', encoding='utf-8')
