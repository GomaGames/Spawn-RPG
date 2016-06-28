package sprites;

import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/abstract-circlex-red.png";
  public static inline var DEFAULT_SPEED = 100;
  public static inline var DEFAULT_HEALTH = 1;
  public static inline var UP = "up";
  public static inline var DOWN = "down";
  public static inline var LEFT = "left";
  public static inline var RIGHT = "right";
  public var speed:Int;
  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, speed:Int, ?skin:String = DEFAULT_SKIN, ?direction:String, ?health:Int = 1){
    this.speed = speed;
    this.state = state;
    super(x, y, skin);
    this.scale.set(.5,.5);
    this.height /= 2;
    this.width /= 2;
    this.centerOffsets();
    this.centerOrigin();
    this.updateHitbox();
    this.elasticity = 1;
    this.health = health;
    if(direction != null){
      switch(direction){
        case UP : this.velocity.set(0,-speed);
        case DOWN : this.velocity.set(0,speed);
        case LEFT : this.velocity.set(-speed, 0);
        case RIGHT : this.velocity.set(speed, 0);
      }
    }
  }

  public function despawn(){
    this.state.enemies.remove(this);
    this.destroy();
  }

  public override function update(_:Float):Void
  {
    super.update(_);

    if(!this.state.paused) {
      this.flipX = this.velocity.x > 0;

      if(!this.alive){
        this.angle += this.angle + 20;
        this.scale.set( this.scale.x - .05, this.scale.y - .05 );
        if(this.scale.x < 0){
          this.despawn();
        }
      }
    }
  }

  public dynamic function hit(?weapon:Weapon):Void
  {
    hurt(
      if( weapon != null ){
        weapon.power;
      } else if( state.player.weapon != null ){
        state.player.weapon.power;
      } else {
        1;
      }
    );
  }

  public override function kill():Void
  {
    this.centerOffsets(); // for spinning
    this.alive = false;
  }
}
