import PIL
from PIL import Image, ImageDraw, ImageFont

def create_icon():
    size = 1024
    img = Image.new('RGB', (size, size), color=(25, 25, 35))
    draw = ImageDraw.Draw(img)
    
    # Simple linear gradient
    for y in range(size):
        r = int(25 + (20 * y / size))
        g = int(25 + (30 * y / size))
        b = int(45 + (100 * y / size))
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Draw a stylized "H"
    center_x = size // 2
    center_y = size // 2
    
    # Left pillar
    draw.rounded_rectangle([center_x - 200, center_y - 250, center_x - 100, center_y + 250], fill=(255, 152, 0), radius=20)
    # Right pillar
    draw.rounded_rectangle([center_x + 100, center_y - 250, center_x + 200, center_y + 250], fill=(255, 152, 0), radius=20)
    # Crossbar
    draw.rounded_rectangle([center_x - 150, center_y - 50, center_x + 150, center_y + 50], fill=(255, 152, 0), radius=20)
    
    # Some accent
    draw.ellipse([center_x - 30, center_y - 30, center_x + 30, center_y + 30], fill=(255, 255, 255))
    
    # Save
    import os
    if not os.path.exists('assets'):
        os.makedirs('assets')
    
    img.save('assets/icon.png')

if __name__ == '__main__':
    create_icon()
