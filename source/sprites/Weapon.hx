package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class Weapon extends Equippable{
  private var swipe:FlxSprite;
  private var on_cooldown:Bool;
  public static inline var DEFAULT_SKIN = "assets/images/item-sword-blue.png";

  public var power:Int;

  public function new( state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN, ?power:Int = 1 ){
    super(state, x, y, skin);
    this.on_cooldown = false;
    this.power = power;
    swipe = new FlxSprite();
    swipe.loadGraphic("assets/images/swipe.png");
    swipe.scale.set(0.5,0.5);
    swipe.updateHitbox();
    swipe.solid = false;
    swipe.alpha = 0;
    this.state.add( swipe );
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
          swipe.x = p.x - 20;
          swipe.y = p.y - 60;
          swipe.flipX = true;
          swipe.flipY = false;
          swipe.angle = 90;
        case DOWN:
          this.flipX = true;
          this.flipY = true;
          this.x = p.x - 15;
          this.y = p.y + 10;
          y_inc = 50;
          swipe.x = p.x - 5;
          swipe.y = p.y - 10;
          swipe.flipX = false;
          swipe.flipY = true;
          swipe.angle = 90;
        case LEFT:
          this.flipX = true;
          this.flipY = true;
          this.x = p.x - 40;
          this.y = p.y + 5;
          x_inc = -50;
          swipe.x = p.x - 50;
          swipe.y = p.y - 35;
          swipe.flipX = true;
          swipe.flipY = true;
          swipe.angle = 0;
        case RIGHT:
          this.flipX = false;
          this.flipY = true;
          this.x = p.x + 10;
          this.y = p.y + 10;
          x_inc = 50;
          swipe.x = p.x - 5;
          swipe.y = p.y - 25;
          swipe.flipX = false;
          swipe.flipY = true;
          swipe.angle = 0;
        default: null;
      }
      swipe.scale.set(0.5,0.5);
      swipe.alpha = 1.0;
      var weapon_tween:FlxTween = FlxTween.tween(this, { x: this.x + x_inc, y: this.y + y_inc }, 0.3, { ease: FlxEase.elasticOut });
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
    }

  }

  override public function update(elapsed:Float):Void
  {
    swipe.alpha -= 0.15;
    swipe.scale.set( swipe.scale.x + 0.05, swipe.scale.y + 0.05 );
    if(state.player.hasEquipped(this)){
      update_weapon();
    }
    super.update(elapsed);
  }
}

