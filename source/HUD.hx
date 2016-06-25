package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
  private var inventoryItem:FlxSprite;

  public function new( state: PlayState) {
    super();
    inventoryItem = new FlxText('test');
    add(inventoryItem);

    forEach(function(spr:FlxSprite)
    {
      spr.scrollFactor.set(0,0);
    });
  }

  public function update(inventoryItem:FlxSprite):Void
  {

  }
}