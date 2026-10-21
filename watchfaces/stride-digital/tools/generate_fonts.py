"""Genera los recursos BMFont numéricos propios de Stride Digital con Pillow."""

from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont, ImageOps, PngImagePlugin

ROOT = Path(__file__).resolve().parents[1]
FONTS = ROOT / "resources" / "fonts"
SOURCE = FONTS / "BarlowCondensed-ExtraBold.ttf"
CHARACTERS = "0123456789:.-%"
SCALE = 4


def generate(name: str, size: int, tabular: bool = False,
             outline: bool = False, characters: str = CHARACTERS,
             condense: float = 1.0) -> None:
    font = ImageFont.truetype(str(SOURCE), size * SCALE)
    boxes = {char: font.getbbox(char) for char in characters}
    # Todos los glifos comparten la caja de las cifras; el guion y los dos
    # puntos mantienen su línea base dentro de ella, sin centrados separados.
    top = min(boxes[char][1] for char in "0123456789")
    bottom = max(boxes[char][3] for char in "0123456789")
    line_height = round((bottom - top) / SCALE)
    digit_advance = round(max(font.getlength(char) for char in "0123456789") / SCALE * condense)
    glyphs = []
    for char in characters:
        left, glyph_top, right, glyph_bottom = boxes[char]
        width = max(1, right - left)
        height = max(1, glyph_bottom - glyph_top)
        mask = Image.new("L", (width, height), 0)
        ImageDraw.Draw(mask).text((-left, -glyph_top), char, font=font, fill=255)
        target = (max(1, round(width / SCALE * condense)), max(1, round(height / SCALE)))
        mask = mask.resize(target, Image.Resampling.LANCZOS)
        advance = round(font.getlength(char) / SCALE * condense)
        offset_x = round(left / SCALE * condense)
        offset_y = round((glyph_top - top) / SCALE)
        if outline:
            # Contorno interior de tres píxeles, sin ampliar caja ni avance.
            padded = ImageOps.expand(mask, border=3, fill=0)
            edge = ImageChops.subtract(padded, padded.filter(ImageFilter.MinFilter(7)))
            mask = edge.crop((3, 3, mask.width+3, mask.height+3))
        if tabular and (char.isdigit() or char == "-"):
            advance = digit_advance
            offset_x = round((advance - mask.width) / 2)
            if offset_x < 0 or offset_x + mask.width > advance:
                raise ValueError(f"{name}: tinta fuera de la celda de {char}")
        if mask.getbbox() is None:
            raise ValueError(f"{name}: glifo vacío {char}")
        glyphs.append((char, mask, offset_x, offset_y, advance))

    atlas_width = 1024 if size > 100 else 512
    padding = 2
    positions = []
    x = padding
    y = padding
    row_height = 0
    for char, mask, offset_x, offset_y, advance in glyphs:
        if x + mask.width + padding > atlas_width:
            x = padding
            y += row_height + padding
            row_height = 0
        positions.append((char, mask, x, y, offset_x, offset_y, advance))
        x += mask.width + padding
        row_height = max(row_height, mask.height)
    atlas_height = y + row_height + padding
    atlas = Image.new("L", (atlas_width, atlas_height), 0)
    for char, mask, x, y, offset_x, offset_y, advance in positions:
        atlas.paste(mask, (x, y))

    metadata = PngImagePlugin.PngInfo()
    metadata.add_text("Source", "https://github.com/google/fonts/tree/main/ofl/barlowcondensed; SIL OFL 1.1")
    metadata.add_text("Copyright", "Copyright 2017 The Barlow Project Authors (https://github.com/jpt/barlow)")
    metadata.add_text("Generator", f"tools/generate_fonts.py; Barlow Condensed ExtraBold; horizontal scale={condense}; 4x supersampling; tabular digits={tabular}; upright; inner outline={3 if outline else 0}px")
    atlas.save(FONTS / f"{name}.png", pnginfo=metadata)
    lines = [
        f'info face="Stride Barlow Numeric" size={size} bold=1 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=0,0',
        f"common lineHeight={line_height} base={line_height} scaleW={atlas_width} scaleH={atlas_height} pages=1 packed=0",
        f'page id=0 file="{name}.png"',
        f"chars count={len(positions)}",
    ]
    for char, mask, x, y, offset_x, offset_y, advance in positions:
        lines.append(f"char id={ord(char)} x={x} y={y} width={mask.width} height={mask.height} xoffset={offset_x} yoffset={offset_y} xadvance={advance} page=0 chnl=8")
    (FONTS / f"{name}.fnt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    advances = {char: advance for char, mask, offset_x, offset_y, advance in glyphs}
    print(f"{name}: height={line_height}, 88={sum(advances[c] for c in '88')}, outline={outline}")


if __name__ == "__main__":
    generate("Time", 179, tabular=True, characters="0123456789-", condense=0.97)
    generate("TimeOutline", 179, tabular=True, outline=True, characters="0123456789-", condense=0.97)
    generate("Value", 42)
    generate("Compact", 26)
