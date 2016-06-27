package sprites;

import flixel.FlxG; 
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class Equippable extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/item-sword-blue.png";

  private var state:PlayState;
  private var swipe:FlxSprite;

  public function new( state:PlayState, ?skin:String = DEFAULT_SKIN ){
    super(0,0, skin);
    this.state = state;
    this.scale.set(0.5,0.5);
    this.flipX = false;
    this.flipY = false;
    this.centerOrigin();
    this.solid = false;
    this.updateHitbox();
    state.add( this );

    swipe = new FlxSprite();
    swipe.loadGraphic("assets/images/swipe.png");
    swipe.scale.set(0.5,0.5);
    swipe.updateHitbox();
    swipe.solid = false;
    swipe.alpha = 0;
    state.add( swipe );
  }

  public function despawn(){
    this.state.remove(this);
    this.destroy();
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
          swipe.y = p.y - 20;
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
      
      this.updateHitbox();
    }
  }
  
  override public function update(elapsed:Float):Void
  {
    // if(!this.state.paused) {
    //   movement();
    // }
    swipe.alpha -= 0.15;
    swipe.scale.set( swipe.scale.x + 0.05, swipe.scale.y + 0.05 );
    update_weapon();
    FlxG.collide();
    super.update(elapsed);
  }
}