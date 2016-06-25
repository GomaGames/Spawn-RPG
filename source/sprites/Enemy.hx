package sprites;

import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/tile-orange-circle-white-x.png";
  public static inline var DEFAULT_SPEED = 100;
  public static inline var UP = "up";
  public static inline var DOWN = "down";
  public static inline var LEFT = "left";
  public static inline var RIGHT = "right";
  public var speed:Int;
  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, speed:Int, skin:String = DEFAULT_SKIN, ?direction:String ){
    this.speed = speed;
    this.state = state;
    super(x, y, skin);
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.height /= 2;
    this.width /= 2;
    this.centerOffsets();
    this.centerOrigin();
    this.elasticity = 1;
    if(direction != null){
      switch(direction){
        case UP : this.velocity.set(0,-speed);
        case DOWN : this.velocity.set(0,speed);
        case LEFT : this.velocity.set(-speed, 0);
        case RIGHT : this.velocity.set(speed, 0);
      }
    }
  }

  public function interact(cb:Void->Void):Void
  {
    cb();
  }

  public function despawn(){
    this.state.enemies.remove(this);
    this.destroy();
  }

  public override function update(_:Float):Void
  {
    if(!this.state.paused) {
      this.flipX = this.velocity.x > 0;
      super.update(_);
    }
  }

}


