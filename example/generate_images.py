from PIL import Image, ImageDraw, ImageFont
import os

WIDTH, HEIGHT = 512, 300

ribbons = [
    ('top_left', (0, 0), -45),
    ('top_right', (WIDTH, 0), 45),
    ('bottom_left', (0, HEIGHT), 45),
    ('bottom_right', (WIDTH, HEIGHT), -45),
]

# Choose text color and background
bg_color = (230, 230, 230)

# Output directory (relative to repo root). Use example/assets so README images resolve.
assets_dir = os.path.join('example', 'assets')
os.makedirs(assets_dir, exist_ok=True)

for name, origin, angle in ribbons:
    img = Image.new('RGB', (WIDTH, HEIGHT), color=bg_color)
    draw = ImageDraw.Draw(img)

    # Draw a diagonal rectangle as a ribbon
    ribbon_width = 120
    ribbon_color = (200, 50, 50) if 'top' in name else (50, 120, 200)

    # create a temp image for the ribbon and rotate it then paste
    ribbon = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
    rd = ImageDraw.Draw(ribbon)
    # Draw rectangle center to center
    center_x = WIDTH // 2
    center_y = HEIGHT // 2
    rd.rectangle((center_x - ribbon_width, center_y - 30, center_x + ribbon_width, center_y + 30), fill=ribbon_color)
    ribbon = ribbon.rotate(angle, center=(center_x, center_y), expand=False)

    img.paste(ribbon, (0, 0), ribbon)

    # Draw text
    try:
        font = ImageFont.truetype('DejaVuSans-Bold.ttf', 36)
    except Exception:
        font = ImageFont.load_default()

    text = name.replace('_', ' ').upper()
    # Determine text size in a way compatible across Pillow versions
    try:
        bbox = draw.textbbox((0, 0), text, font=font)
        text_w = bbox[2] - bbox[0]
        text_h = bbox[3] - bbox[1]
    except Exception:
        try:
            # Older versions used textsize on the draw object
            text_w, text_h = draw.textsize(text, font=font)
        except Exception:
            # Fallback to font.getsize
            text_w, text_h = font.getsize(text)

    # Put the descriptive text near our bottom-right corner with padding
    draw.text((WIDTH - text_w - 32, HEIGHT - text_h - 24), text, font=font, fill=(255, 255, 255))

    outfile = os.path.join(assets_dir, f'banner_{name}.png')
    img.save(outfile)

print('Images written to ' + assets_dir + ':')
for name, _, _ in ribbons:
    print('- ' + os.path.join(assets_dir, 'banner_' + name + '.png'))
