#!/bin/bash
#
# Puts the game in docs/game, so that it can be played in a browser
# using Processing.js. See docs/play.md for the iframe that shows it.
#
# Usage, from the project root:
#
#   ./scripts/create_game_html.sh

set -e

if [ ! -f beer_wanter_2.pde ]; then
    echo "FATAL ERROR: run this script from the project root, e.g.:"
    echo " "
    echo "  ./scripts/create_game_html.sh"
    exit 42
fi

# The images
cp PicBeer.png PicHand.png docs/game/

# Processing.js has no 'fullScreen', so use a fixed size,
# and it must preload the images before 'setup' uses their sizes
{
  echo '/* @pjs preload="PicBeer.png,PicHand.png"; */'
  sed 's/fullScreen();/size(800, 600);/' beer_wanter_2.pde
} > docs/game/beer_wanter_2.pde

# Processing.js, served by the website itself
tmp_folder=$(mktemp -d)
(cd "$tmp_folder" && npm pack --silent processing-js@1.6.6 > /dev/null && tar xzf processing-js-1.6.6.tgz)
cp "$tmp_folder/package/processing.min.js" docs/game/
rm -rf "$tmp_folder"

# The page that runs the game
cat > docs/game/beer_wanter_2.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>BeerWanter2</title>
<script src="processing.min.js"></script>
<style>body { margin: 0; overflow: hidden; }</style>
</head>
<body>
<canvas id="game" data-processing-sources="beer_wanter_2.pde" tabindex="0"></canvas>
</body>
</html>
EOF
