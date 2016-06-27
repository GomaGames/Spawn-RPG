package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Weapon extends Equippable{

  public static inline var DEFAULT_SKIN = "assets/images/item-sword-blue.png";

  public function new( state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN ){
    super(state, x, y, skin);
  }

  public inline function update_weapon():Void
  {
    var p:Player = state.player;
    if( p.attacking ){
      this.solid = true;
      var x_inc:Float = 0;
      var y_inc:Float = 0;

      switch( p.current_direction ){
        case UP:
          this.flipX = false;
          this.flipY = false;
          this.x = p.x + 5;
          this.y = p.y - 40;
          y_inc = -50;
        case DOWN:
          this.flipX = true;
          this.flipY = true;
          this.x = p.x - 15;
          this.y = p.y + 10;
          y_inc = 50;
        case LEFT:
          this.flipX = true;
          this.flipY = true;
          this.x = p.x - 40;
          this.y = p.y + 5;
          x_inc = -50;
        case RIGHT:
          this.flipX = false;
          this.flipY = true;
          this.x = p.x + 10;
          this.y = p.y + 10;
          x_inc = 50;
        default: null;
      }
      var weapon_tween = FlxTween.tween(this, { x: this.x + x_inc, y: this.y + y_inc }, 0.3, { ease: FlxEase.elasticOut });
      weapon_tween.start();

    } else {
      this.solid = false;
      switch( p.current_direction ){
        case UP:
          this.flipX = true;
          this.flipY = false;
          this.x = p.x - 20;
          this.y = p.y - 30;
        case DOWN:
          this.flipX = false;
          this.flipY = true;
          this.x = p.x + 5;
          this.y = p.y + 5;
        case LEFT:
          this.flipX = true;
          this.flipY = false;
          this.x = p.x - 35;
          this.y = p.y - 20;
        case RIGHT:
          this.flipX = false;
          this.flipY = false;
          this.x = p.x + 5;
          this.y = p.y - 20;
        default: null;
      }

      this.updateHitbox();
    }
  }

  override public function update(elapsed:Float):Void
  {
    if(state.player.hasEquipped(this)){
      update_weapon();
    }
    super.update(elapsed);
  }
}

