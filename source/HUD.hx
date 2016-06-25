package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup
{
  private static inline var HUD_HEIGHT = 40;
  private var background:FlxSprite;
  public var top_bar_bg:FlxSprite;
  public var inventoryDisplay:FlxSpriteGroup;
  public var lifeDisplay:flixel.group.FlxSpriteGroup;
  public var lifeText:FlxText;

  public var life(default, set):Int;
  private inline function set_life(val:Int):Int
  {
    lifeText.text = '${val} / 3';
    return life = val;
  }

  public function new(x:Float, y:Float)
  {
    super(-10000,-10000);

    background = new FlxSprite(); // background is needed for camera to follow
    background.makeGraphic(Main.VIEWPORT_WIDTH, Main.VIEWPORT_HEIGHT, FlxColor.TRANSPARENT);
    top_bar_bg = new FlxSprite(0, -100);
    top_bar_bg.makeGraphic(Main.STAGE_WIDTH, HUD_HEIGHT, FlxColor.BLACK);
    var inventoryText = new FlxText(10,-82,"Inventory");
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    inventoryDisplay = new FlxSpriteGroup(110, -114);
    lifeDisplay = new FlxSpriteGroup(200, -114);
    lifeText = new FlxText(200,-82);
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    var heart = new FlxSprite(0,0,'assets/images/item-heart.png');
    heart.scale.set(0.25,0.25);
    lifeDisplay.add(heart);
    // lifeDisplay.add(lifeText);
    add(background);
    add(top_bar_bg);
    add(inventoryText);
    add(inventoryDisplay);
    add(lifeDisplay);
    add(lifeText);
  }

  public inline function addInventoryItem(spriteClone:FlxSprite):Void
  {
    spriteClone.x = this.inventoryDisplay.length * 24;
    spriteClone.scale = FlxPoint.weak(.25,.25);
    this.inventoryDisplay.add(spriteClone);
  }
}
