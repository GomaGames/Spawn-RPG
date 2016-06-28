package sprites;

import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
using Lambda;

class Projectile extends FlxSprite implements IDespawnableSprite
{
  private var state:PlayState;
  private var duration:Float;
  public static inline var DEFAULT_SKIN_PROJECTILE = "assets/images/item-fireball-red.png";

  public function new(state:PlayState, x:Float, y:Float, ?skin:String = DEFAULT_SKIN_PROJECTILE, ?duration:Float = 5 ) {
    super(x, y, skin);
    this.state = state;
    this.scale.set(.5,.5);
    this.loadGraphic( skin );
    this.centerOffsets();
    this.centerOrigin();
    this.updateHitbox();
    this.duration = duration;
    this.solid = true;
    this.alpha = 1.0;
  }
  private function check_duration():Void
  {
    if( this.duration <= 0 ){
      this.state.projectiles.remove(this);
      this.destroy();
    } else {
      this.duration -= 0.1;
    }
  }
  // public dynamic function interact():Void{ }

  // public function spawn(:String):Void
  // {
  //   this.state.projectiles();
  // }
  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
    if(!this.state.paused){
      this.alpha -= 0.01;
      check_duration();
    }
  }

  public function despawn(){
    this.state.projectiles.remove(this);
    this.destroy();
  }
}
