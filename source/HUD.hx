package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
// import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

class HUD extends FlxSpriteGroup
{
  private static inline var HUD_HEIGHT = 40;
  private var background:FlxSprite;
  public var top_bar_bg:FlxSprite;
  public var inventoryDisplay:FlxSpriteGroup;

  public function new(x:Float, y:Float)
  {
    super(-10000,-10000);

    background = new FlxSprite(); // background is needed for camera to follow
    background.makeGraphic(Std.int(Main.STAGE_WIDTH/2), Std.int(Main.STAGE_HEIGHT/2), FlxColor.TRANSPARENT);
    top_bar_bg = new FlxSprite(0, -100);
    top_bar_bg.makeGraphic(Main.STAGE_WIDTH, HUD_HEIGHT, FlxColor.BLACK);
    var inventoryText = new FlxText(10,-82,"Inventory");
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    inventoryDisplay = new FlxSpriteGroup(110, -114);
    add(background);
    add(top_bar_bg);
    add(inventoryText);
    add(inventoryDisplay);
  }

  public inline function addInventoryItem(spriteClone:FlxSprite):Void
  {
    spriteClone.x = this.inventoryDisplay.length * 24;
    spriteClone.scale = FlxPoint.weak(.25,.25);
    this.inventoryDisplay.add(spriteClone);
  }
}
