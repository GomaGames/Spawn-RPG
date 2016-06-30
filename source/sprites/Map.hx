package sprites;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using flixel.util.FlxSpriteUtil;

class Map extends FlxSprite {
  public static inline var GRID_SIZE:Int = 40;
  public static var LINES_GREY:FlxColor = FlxColor.fromString('#6d6e70');

  private var bg:flixel.graphics.FlxGraphic;

  public function new()
  {
    super(0,0, flixel.graphics.FlxGraphic.fromRectangle(Main.STAGE_WIDTH, Main.STAGE_HEIGHT, Main.BACKGROUND_GREY ));
    drawGridLines();
    this.immovable = true;
    this.moves = this.solid = false;
  }

  private inline function drawGridLines():Void
  {
    var GRID_LINES_X:Int = Std.int(Main.STAGE_WIDTH / GRID_SIZE) + 1;
    var GRID_LINES_Y:Int = Std.int(Main.STAGE_HEIGHT / GRID_SIZE) + 1;

    // DRAWING GRID LINES
    var line_style:flixel.util.LineStyle = { color: LINES_GREY, thickness: 0.5 };
    for( x in 0...GRID_LINES_X ) {
      this.drawLine(( x * GRID_SIZE ) + GRID_SIZE , 0, ( x * GRID_SIZE ) + GRID_SIZE, Main.STAGE_HEIGHT, line_style );
    }
    for( y in 0...GRID_LINES_Y ) {
      this.drawLine(0, ( y * GRID_SIZE ) + GRID_SIZE , Main.STAGE_WIDTH,  ( y * GRID_SIZE ) + GRID_SIZE , line_style );
    }
  }

}
