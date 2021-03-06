package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import sprites.CollectableSprite;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup
{
  private static inline var HUD_HEIGHT = 40;
  private var background:FlxSprite;
  //                           original           clone
  private var inventoryMap:Map<CollectableSprite, FlxSprite>;
  public var top_bar_bg:FlxSprite;
  public var inventoryDisplay:FlxSpriteGroup;
  public var lifeDisplay:FlxSpriteGroup;
  public var lifeText:FlxText;
  public var coinsDisplay:FlxSpriteGroup;
  public var coinsText:FlxText;

  public var life(default, set):Int;
  private inline function set_life(val:Int):Int
  {
    lifeText.text = '${val} / ${Settings.hero.default_life}';
    return life = val;
  }

  public var coins(default, set):Int;
  private inline function set_coins(val:Int):Int
  {
    coinsText.text = Std.string(val);
    return coins = val;
  }

  public function new()
  {
    super(-10000,-10000);
    inventoryMap = new Map<CollectableSprite, FlxSprite>();

    background = new FlxSprite(); // background is needed for camera to follow
    // add y offset (226px) to let the camera follow the HUD at the correct point
    background.makeGraphic(Main.VIEWPORT_WIDTH, Main.VIEWPORT_HEIGHT, FlxColor.TRANSPARENT);

    top_bar_bg = new FlxSprite(0, 0);
    top_bar_bg.makeGraphic(Main.VIEWPORT_WIDTH, HUD_HEIGHT, FlxColor.fromString('#222222'));

    var inventoryText = new FlxText(15,10,"Inventory");
    inventoryText.setFormat( AssetPaths.CHUNKY_FONT, 18, FlxColor.fromString('#808080'), FlxTextAlign.LEFT, null, null, true);
    inventoryDisplay = new FlxSpriteGroup(590, 350);

    lifeDisplay = new FlxSpriteGroup(760, 0);
    lifeText = new FlxText(60,10);
    lifeText.setFormat( AssetPaths.CHUNKY_FONT, 18, FlxColor.fromString('#808080'), FlxTextAlign.LEFT, null, null, true);
    var heart = new FlxSprite(30,10,'assets/images/item-heart-red.png');
    heart.scale.set(0.25,0.25);
    heart.updateHitbox();
    lifeDisplay.add(heart);
    lifeDisplay.add(lifeText);

    coinsDisplay = new FlxSpriteGroup(680, 0);
    coinsText = new FlxText(34,8);
    coinsText.setFormat( null, 18, FlxColor.fromString('#808080'), FlxTextAlign.LEFT, null, null, true);
    var coin = new FlxSprite(0,10,'assets/images/item-gem-yellow.png');
    coin.scale.set(0.25,0.25);
    coin.updateHitbox();
    coinsDisplay.add(coin);
    coinsDisplay.add(coinsText);

    add(background);
    add(top_bar_bg);
    add(inventoryText);
    add(inventoryDisplay);
    add(lifeDisplay);
    add(coinsDisplay);

    this.updateHitbox();
  }

  public inline function addInventoryItem(originalSprite:CollectableSprite):Void
  {
    var spriteClone:FlxSprite = originalSprite.clone();
    spriteClone.x = this.inventoryDisplay.length * 24;
    spriteClone.scale = FlxPoint.weak(.25,.25);
    spriteClone.updateHitbox();
    this.inventoryDisplay.add(spriteClone);
    // make a map so we can remove it
    inventoryMap.set(originalSprite, spriteClone);
  }

  public inline function removeInventoryItem(originalSprite:CollectableSprite):CollectableSprite
  {
    this.inventoryDisplay.remove(inventoryMap.get(originalSprite));
    inventoryMap.remove(originalSprite);
    return originalSprite;
  }
}
