"""Contratos de importación de texto Garmin; solo requiere Python estándar."""
from pathlib import Path
import re
import struct
import unittest
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]


def png_header(path):
    header = path.read_bytes()[:29]
    if header[:8] != b"\x89PNG\r\n\x1a\n" or header[12:16] != b"IHDR":
        raise ValueError(f"No es un PNG válido: {path}")
    return struct.unpack(">IIBB", header[16:26])


class GarminTextAssets(unittest.TestCase):
    def test_font_coverage_is_grayscale_not_rgba(self):
        # El importador BMFont consume cobertura gris, no un atlas de color.
        for resource in ET.parse(ROOT / "resources/fonts/fonts.xml").getroot():
            fnt = ROOT / "resources/fonts" / resource.attrib["filename"]
            content = fnt.read_text(encoding="utf-8")
            page = re.search(r'page id=0 file="([^"]+)"', content)[1]
            width, height, depth, color_type = png_header(fnt.parent / page)
            with self.subTest(font=fnt.name):
                self.assertEqual((depth, color_type), (8, 0), "BMFont debe usar PNG gris de 8 bits, sin RGBA")
                self.assertEqual(resource.attrib.get("antialias"), "true")
                for glyph in re.findall(r"^char .*", content, re.M):
                    fields = {k: int(v) for k, v in re.findall(r"(\w+)=(-?\d+)", glyph)}
                    self.assertLessEqual(fields["x"] + fields["width"], width)
                    self.assertLessEqual(fields["y"] + fields["height"], height)

    def test_numerals_preserve_smooth_opaque_edges(self):
        for bitmap in ET.parse(ROOT / "resources/drawables/drawables.xml").getroot():
            if not re.fullmatch(r"N\d+", bitmap.attrib["id"]):
                continue
            with self.subTest(numeral=bitmap.attrib["id"]):
                path = ROOT / "resources/drawables" / bitmap.attrib["filename"]
                self.assertEqual(png_header(path)[2:], (8, 2), "Número RGB sobre fondo negro, sin máscara alfa de 1 bit")
                self.assertEqual(bitmap.attrib.get("dithering"), "none")
                self.assertEqual(bitmap.attrib.get("automaticPalette"), "false")


if __name__ == "__main__":
    unittest.main()
