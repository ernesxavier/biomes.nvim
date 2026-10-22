"""Dibuja las capturas del README a partir del resaltado real de Neovim.

Uso, desde la raíz del repositorio (requiere Pillow y la fuente JetBrains Mono Nerd Font):

    python3 scripts/screenshots/render.py

1. Ejecuta extract.lua en Neovim sin interfaz: cada carácter de samples/ con
   el color que le da el tema, para las seis variantes.
2. Dibuja una ventana por variante en assets/screenshots/<variante>.png y la
   cuadrícula con las seis en assets/screenshots/overview.png.

Variables de entorno opcionales:
    NVIM_TS_RUNTIME  carpeta runtime de nvim-treesitter (consultas de Julia)
    SCREENSHOT_FONT  carpeta con JetBrainsMonoNerdFontMono-*.ttf
"""

import json
import os
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[2]
HERE = ROOT / "scripts" / "screenshots"
OUT = ROOT / "assets" / "screenshots"

TS_RUNTIME = os.environ.get("NVIM_TS_RUNTIME", str(Path.home() / ".local/share/nvim/lazy/nvim-treesitter/runtime"))
FONT_DIR = Path(os.environ.get("SCREENSHOT_FONT", "/usr/share/fonts/TTF"))

SCALE = 2                       # se dibuja al doble para pantallas de alta densidad
SIZE = 13 * SCALE               # tamaño de letra
LINE = round(SIZE * 1.55)       # alto de línea
RADIUS = 12 * SCALE             # esquinas redondeadas de la ventana
CURSOR_ROW = 11                 # línea del cursor en el panel izquierdo (1-based)
TITLES = {"plains": "Plains", "cherry": "Cherry Grove", "snowy": "Snowy",
          "nether": "Nether", "end": "The End", "deep_dark": "Deep Dark"}


def font(style):
    return ImageFont.truetype(str(FONT_DIR / f"JetBrainsMonoNerdFontMono-{style}.ttf"), SIZE)


FONTS = {(False, False): font("Regular"), (True, False): font("Bold"),
         (False, True): font("Italic"), (True, True): font("BoldItalic")}
CHAR = FONTS[(False, False)].getlength("M")


def extract():
    """Corre extract.lua y devuelve el resaltado de las seis variantes."""
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp) / "highlights.json"
        subprocess.run(
            ["nvim", "--headless", "-u", "NONE", "--cmd", "set rtp^=.", "--cmd", f"set rtp+={TS_RUNTIME}",
             "-c", f"luafile {HERE / 'extract.lua'}", "-c", "q"],
            cwd=ROOT, env={**os.environ, "SCREENSHOT_JSON": str(out)}, check=True, capture_output=True,
        )
        return json.loads(out.read_text())


def text(draw, x, y, s, fg, bold=False, italic=False, bg=None, underline=False):
    """Escribe s en la celda (x, y) en píxeles y devuelve la x siguiente."""
    width = CHAR * len(s)
    if bg:
        draw.rectangle([x, y, x + width, y + LINE], fill=bg)
    f = FONTS[(bool(bold), bool(italic))]
    draw.text((x, y + (LINE - SIZE) / 2 - SCALE), s, font=f, fill=fg)
    if underline:
        draw.line([x, y + LINE - 4 * SCALE, x + width, y + LINE - 4 * SCALE], fill=fg, width=SCALE)
    return x + width


def pane(draw, x0, y0, cols, rows, lines, p, cursor=None):
    """Un panel con números de línea; cursor es la fila resaltada (o None)."""
    gutter = 4
    for row in range(rows):
        y = y0 + row * LINE
        current = cursor == row + 1
        if current:
            draw.rectangle([x0, y, x0 + (gutter + cols) * CHAR, y + LINE], fill=p["cursorline"])
        if row < len(lines):
            num = f"{row + 1:>3} "
            text(draw, x0, y, num, p["yellow"] if current else p["line_nr"], bold=current)
            x = x0 + gutter * CHAR
            for run in lines[row]:
                a = run["a"]
                bg = a.get("bg")
                if bg == p["bg"] or current and bg == p["bg"]:
                    bg = None
                x = text(draw, x, y, run["t"], a.get("fg") or p["fg"], a.get("bold"), a.get("italic"), bg, a.get("underline"))


def window(v):
    p, lualine = v["palette"], v["lualine"]
    left, right = v["files"]
    lcols = max(sum(len(r["t"]) for r in line) for line in left["lines"]) + 2
    rcols = max(sum(len(r["t"]) for r in line) for line in right["lines"]) + 2
    rows = max(len(left["lines"]), len(right["lines"])) + 1
    gutter = 4
    width = round((gutter + lcols + 1 + gutter + rcols) * CHAR)
    title_h = round(LINE * 1.3)
    height = title_h + LINE + rows * LINE + LINE

    img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, width - 1, height - 1], RADIUS, fill=255)
    canvas = Image.new("RGB", (width, height), p["bg"])
    d = ImageDraw.Draw(canvas)

    # Barra de título de la terminal: el nombre del tema
    d.rectangle([0, 0, width, title_h], fill=p["bg_float"])
    for i, c in enumerate((p["red"], p["yellow"], p["green"])):
        cx, cy, r = (14 + i * 18) * SCALE, title_h / 2, 5 * SCALE
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=c)
    name = f"minecraft-{v['variant']}"
    text(d, (width - CHAR * len(name)) / 2, (title_h - LINE) / 2, name, p["fg_dim"])

    # Pestañas
    y = title_h
    d.rectangle([0, y, width, y + LINE], fill=p["bg_alt"])
    x = text(d, 0, y, f"  {left['name']}  ", p["bg"], bold=True, bg=p["accent"])
    text(d, x, y, f"  {right['name']}  ", p["fg_dim"])

    # Paneles
    y += LINE
    pane(d, 0, y, lcols, rows, left["lines"], p, cursor=CURSOR_ROW)
    sep_x = (gutter + lcols) * CHAR
    for row in range(rows):
        text(d, sep_x, y + row * LINE, "│", p["border"])
    pane(d, sep_x + CHAR, y, rcols, rows, right["lines"], p)

    # Barra de estado de lualine (modo normal)
    y += rows * LINE
    n = lualine["normal"]
    d.rectangle([0, y, width, y + LINE], fill=n["c"]["bg"] if n["c"]["bg"] != "NONE" else p["bg_alt"])
    x = text(d, 0, y, " NORMAL ", n["a"]["fg"], bold=True, bg=n["a"]["bg"])
    x = text(d, x, y, "  main ", n["b"]["fg"], bg=n["b"]["bg"])
    text(d, x, y, f" {left['name']}", n["c"]["fg"])
    pos = f" {CURSOR_ROW}:9 "
    rx = width - CHAR * len(pos)
    text(d, rx, y, pos, n["a"]["fg"], bold=True, bg=n["a"]["bg"])
    ft = f" {left['filetype']} "
    text(d, rx - CHAR * len(ft), y, ft, n["b"]["fg"], bg=n["b"]["bg"])

    img.paste(canvas, (0, 0), mask)
    return img


def overview(images):
    """Cuadrícula de 3 × 2 con las seis variantes a menor tamaño."""
    scale = 0.5
    w, h = (round(images[0].width * scale), round(images[0].height * scale))
    gap = 16 * SCALE
    grid = Image.new("RGBA", (3 * w + 2 * gap, 2 * h + gap), (0, 0, 0, 0))
    for i, im in enumerate(images):
        thumb = im.resize((w, h), Image.LANCZOS)
        grid.paste(thumb, ((i % 3) * (w + gap), (i // 3) * (h + gap)), thumb)
    return grid


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    images = []
    for v in extract():
        im = window(v)
        im.save(OUT / f"{v['variant']}.png", optimize=True)
        images.append(im)
        print(f"{v['variant']:10s} {im.width}×{im.height}")
    overview(images).save(OUT / "overview.png", optimize=True)
    print(f"escritas en {OUT}")


if __name__ == "__main__":
    main()
