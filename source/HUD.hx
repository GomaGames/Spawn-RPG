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

class HUD extends FlxSpriteGroup
{
  public var background:FlxSprite;
  // public var width:Int = Main.STAGE_WIDTH;
  // public var height:Int = 40;
  public var inventoryDisplay:FlxSpriteGroup;

  public function new(x:Float, y:Float)
  {
    super(x, y);

    background = new FlxSprite();
    background.makeGraphic(Main.STAGE_WIDTH, 40, FlxColor.BLACK);
    var inventoryText = new FlxText(0,0,"Inventory");
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    inventoryDisplay = new FlxSpriteGroup(80,0);
    inventoryDisplay.color = 0xffffff;
    add(this.inventoryDisplay);
    add(inventoryText);
    add(background);
  }  
}
