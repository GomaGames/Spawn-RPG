# Usage:
#   make [platform]
#
# where [platform] is one of
#   ✅  all [all available platforms]
#   ✅  html5
#   🔴  Mac64
#   🔴  Mac
#   🔴  Linux64
#   🔴  Linux
#   🔴  Win64
#   🔴  Win
#      and -debug counterparts
#
GAME_DIST_ZIP := SpawnHeroRPG.zip

all: html5

html5:
	lime build -minify -yui html5
	rm -rf public/{assets,flixel,lib,SpawnHeroRPG.js}
	cp -a export/$@/bin/{assets,flixel,lib,SpawnHeroRPG.js} public/

html5-debug:
	lime build -debug html5

clean:
	rm -rf export/*
