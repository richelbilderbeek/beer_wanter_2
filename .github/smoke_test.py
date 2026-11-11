"""Check that the game runs in a browser and that the arrow keys work.

Run scripts/create_game_html.sh first and serve docs/game on port 8000.
"""
import io
import sys
import time

from PIL import Image
from playwright.sync_api import sync_playwright

URL = "http://localhost:8000/beer_wanter_2.html"

# The hand starts in the top-left quarter, the beer in the middle.
# Only the hand is in the rows above this one
HAND_ROWS = 220


def tap(page, key):
    """Press a key for about one frame: the game checks keys once per frame."""
    page.keyboard.down(key)
    time.sleep(0.03)
    page.keyboard.up(key)


def hand_x(png):
    """The mean x coordinate of the hand (the dark pixels at the top)."""
    img = Image.open(io.BytesIO(png)).convert("L")
    xs = [
        x
        for y in range(0, HAND_ROWS, 2)
        for x in range(0, img.width, 2)
        if img.getpixel((x, y)) < 64
    ]
    if not xs:
        sys.exit("The hand is not visible")
    return sum(xs) / len(xs)


with sync_playwright() as p:
    browser = p.chromium.launch()
    # The same size as the iframe on the website
    page = browser.new_page(viewport={"width": 800, "height": 600})
    errors = []
    page.on("pageerror", lambda e: errors.append(str(e)))
    page.goto(URL)
    time.sleep(3)
    page.mouse.click(700, 550)
    start = hand_x(page.screenshot())
    # One press of Right makes the hand drift to the right
    tap(page, "ArrowRight")
    time.sleep(0.3)
    after_right = hand_x(page.screenshot())
    # More presses of Left make the hand drift to the left
    tap(page, "ArrowLeft")
    tap(page, "ArrowLeft")
    tap(page, "ArrowLeft")
    time.sleep(0.1)
    before_left = hand_x(page.screenshot())
    time.sleep(0.3)
    after_left = hand_x(page.screenshot())
    browser.close()

if errors:
    sys.exit(f"Page errors: {errors}")
if not after_right > start:
    sys.exit("Pressing Right did not move the hand to the right")
if not after_left < before_left:
    sys.exit("Pressing Left did not move the hand to the left")
print("OK")
