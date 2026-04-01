import PIL
from PIL import Image, ImageDraw, ImageFont
import os

def create_icon():
    size = 1024
    
    # 1. Background (Gradient)
    bg_img = Image.new('RGB', (size, size), color=(25, 25, 35))
    bg_draw = ImageDraw.Draw(bg_img)
    for y in range(size):
        r = int(25 + (20 * y / size))
        g = int(25 + (30 * y / size))
        b = int(45 + (100 * y / size))
        bg_draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # 2. Foreground (Stylized "H" on transparent background)
    fg_img = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))
    fg_draw = ImageDraw.Draw(fg_img)
    
    center_x = size // 2
    center_y = size // 2
    
    # Scaled up by 1.6x
    # Left pillar
    fg_draw.rounded_rectangle([center_x - 320, center_y - 400, center_x - 160, center_y + 400], fill=(255, 152, 0, 255), radius=32)
    # Right pillar
    fg_draw.rounded_rectangle([center_x + 160, center_y - 400, center_x + 320, center_y + 400], fill=(255, 152, 0, 255), radius=32)
    # Crossbar
    fg_draw.rounded_rectangle([center_x - 240, center_y - 80, center_x + 240, center_y + 80], fill=(255, 152, 0, 255), radius=32)
    
    # Accent
    fg_draw.ellipse([center_x - 48, center_y - 48, center_x + 48, center_y + 48], fill=(255, 255, 255, 255))
    
    # 3. Combined legacy icon
    combined_img = Image.alpha_composite(bg_img.convert('RGBA'), fg_img)
    
    # Save all
    if not os.path.exists('assets'):
        os.makedirs('assets')
    
    bg_img.save('assets/icon_background.png')
    fg_img.save('assets/icon_foreground.png')
    combined_img.convert('RGB').save('assets/icon.png')

if __name__ == '__main__':
    create_icon()
