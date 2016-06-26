package sprites;

import flixel.FlxG; 
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Equippable extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/item-sword-blue.png";

  private var state:PlayState;

  public function new( state:PlayState, ?skin:String = DEFAULT_SKIN ){
    super(0,0, skin);
    this.state = state;
    this.scale.set(0.5,0.5);
    this.flipX = false;
    this.flipY = false;
    // this.centerOffsets();
    this.height *= 2;
    this.width *= 2;
    this.centerOrigin();
    this.solid = false;
    this.updateHitbox();

    state.add( this );
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
      // this.updateHitbox();
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
    // if(!this.state.paused) {
    //   movement();
    // }
    update_weapon();
    FlxG.collide();
    super.update(elapsed);
  }
}