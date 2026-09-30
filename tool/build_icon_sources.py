"""Builds the launcher-icon sources in assets/icon from assets/icon/source.webp.

    py -m pip install pillow
    py tool/build_icon_sources.py
    dart run flutter_launcher_icons

Outputs:
  app_icon.png             full-bleed square (iOS, web, desktop)
  app_icon_rounded.png     rounded square with transparent corners (old Android)
  app_icon_foreground.png  white symbol on transparent (Android adaptive icon)
"""
import os

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
BRAND = (0x00, 0x64, 0xF6)
SIZE = 1024


def symbol_mask(source):
    """Alpha mask of the white symbol, without the white page corners."""
    red = source.convert('RGB').split()[0]
    # Blue has almost no red; white has full red. Antialiased edges in between.
    alpha = red.point(lambda v: max(0, min(255, (v - 40) * 255 // 190)))
    # The white outside the rounded square touches the image border: flood it.
    solid = alpha.point(lambda v: 255 if v > 20 else 0)
    w, h = solid.size
    for corner in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]:
        ImageDraw.floodfill(solid, corner, 128)
    outside = solid.point(lambda v: 255 if v == 128 else 0)
    outside = outside.filter(ImageFilter.MaxFilter(9))  # swallow the edge ring
    return ImageChops.subtract(alpha, outside)


def place(mask, canvas, fraction):
    """Centers the symbol so its larger side is `fraction` of the canvas."""
    box = mask.getbbox()
    glyph = mask.crop(box)
    scale = canvas * fraction / max(glyph.size)
    glyph = glyph.resize(
        (round(glyph.width * scale), round(glyph.height * scale)),
        Image.LANCZOS,
    )
    layer = Image.new('L', (canvas, canvas), 0)
    layer.paste(glyph, ((canvas - glyph.width) // 2,
                        (canvas - glyph.height) // 2))
    return layer


def main():
    mask = symbol_mask(Image.open(os.path.join(ROOT, 'source.webp')))
    white = Image.new('RGB', (SIZE, SIZE), (255, 255, 255))

    # Full-bleed square: the symbol at the same size as in the artwork.
    full = Image.new('RGB', (SIZE, SIZE), BRAND)
    full.paste(white, (0, 0), place(mask, SIZE, 0.62))
    full.save(os.path.join(ROOT, 'app_icon.png'))

    # Rounded square for launchers without adaptive icons.
    corners = Image.new('L', (SIZE, SIZE), 0)
    ImageDraw.Draw(corners).rounded_rectangle(
        (0, 0, SIZE - 1, SIZE - 1), radius=int(SIZE * 0.22), fill=255)
    rounded = full.convert('RGBA')
    rounded.putalpha(corners)
    rounded.save(os.path.join(ROOT, 'app_icon_rounded.png'))

    # Adaptive foreground: flutter_launcher_icons insets it by 16% per side
    # (68% of the 108 dp canvas) and launchers show the middle 72 dp, so the
    # symbol keeps the same share of the visible icon as in the artwork.
    foreground = Image.new('RGBA', (SIZE, SIZE), (255, 255, 255, 0))
    foreground.putalpha(place(mask, SIZE, 0.62 * 72 / (108 * 0.68)))
    foreground.save(os.path.join(ROOT, 'app_icon_foreground.png'))
    print('icon sources written to', os.path.normpath(ROOT))


if __name__ == '__main__':
    main()
