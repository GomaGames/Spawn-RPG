package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Equippable extends CollectableSprite{

  public function new( state:PlayState, x:Int, y:Int, skin:String){
    super(state, x,y, skin);
    this.scale.set(0.5,0.5);
    this.flipX = false;
    this.flipY = false;
    this.height *= 2;
    this.width *= 2;
    this.centerOrigin();
    this.solid = false;
    this.updateHitbox();
  }

}
