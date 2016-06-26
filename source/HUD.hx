package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup
{
  private static inline var HUD_HEIGHT = 40;
  private var background:FlxSprite;
  //                           original   clone
  private var inventoryMap:Map<FlxSprite, FlxSprite>;
  public var top_bar_bg:FlxSprite;
  public var inventoryDisplay:FlxSpriteGroup;
  public var lifeDisplay:FlxSpriteGroup;
  public var lifeText:FlxText;
  public var coinsDisplay:FlxSpriteGroup;
  public var coinsText:FlxText;

  public var life(default, set):Int;
  private inline function set_life(val:Int):Int
  {
    lifeText.text = '${val} / 3';
    return life = val;
  }

  public var coins(default, set):Int;
  private inline function set_coins(val:Int):Int
  {
    coinsText.text = Std.string(val);
    return coins = val;
  }

  public function new(x:Float, y:Float)
  {
    super(-10000,-10000);
    inventoryMap = new Map<FlxSprite, FlxSprite>();

    background = new FlxSprite(); // background is needed for camera to follow
    background.makeGraphic(Main.VIEWPORT_WIDTH, Main.VIEWPORT_HEIGHT, FlxColor.TRANSPARENT);
    top_bar_bg = new FlxSprite(0, -100);
    top_bar_bg.makeGraphic(Main.STAGE_WIDTH, HUD_HEIGHT, FlxColor.BLACK);

    var inventoryText = new FlxText(10,-82,"Inventory");
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    inventoryDisplay = new FlxSpriteGroup(110, -114);

    lifeDisplay = new FlxSpriteGroup(760, -114);
    lifeText = new FlxText(60,28);
    lifeText.setFormat( null, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    var heart = new FlxSprite(0,0,'assets/images/item-heart.png');
    heart.scale.set(0.25,0.25);
    lifeDisplay.add(heart);
    lifeDisplay.add(lifeText);

    coinsDisplay = new FlxSpriteGroup(680, -114);
    coinsText = new FlxText(34,28);
    coinsText.setFormat( null, 18, Main.FONT_GREY, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.WHITE, true);
    var coin = new FlxSprite(0,30,'assets/images/item-coin.png');
    coin.scale.set(0.1,0.1);
    coin.updateHitbox();
    coinsDisplay.add(coin);
    coinsDisplay.add(coinsText);

    add(background);
    add(top_bar_bg);
    add(inventoryText);
    add(inventoryDisplay);
    add(lifeDisplay);
    add(coinsDisplay);
  }

  public inline function addInventoryItem(originalSprite:FlxSprite):Void
  {
    var spriteClone = originalSprite.clone();
    spriteClone.x = this.inventoryDisplay.length * 24;
    spriteClone.scale = FlxPoint.weak(.25,.25);
    this.inventoryDisplay.add(spriteClone);
    // make a map so we can remove it
    inventoryMap.set(originalSprite, spriteClone);
  }

  public inline function removeInventoryItem(originalSprite:FlxSprite):Void
  {
    this.inventoryDisplay.remove(inventoryMap.get(originalSprite));
    inventoryMap.remove(originalSprite);
  }
}
