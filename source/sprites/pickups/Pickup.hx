package sprites.pickups;

import flixel.FlxSprite;

class Pickup extends FlxSprite implements IDespawnableSprite{
  public static inline var DEFAULT_SKIN = "assets/images/abstract-circlex-green.png";
  public var DURATION:Float;
  public var value:Int;

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, ?graphic:String = DEFAULT_SKIN ){
    super(x, y, graphic);
    this.state = state;
    this.updateHitbox();
  }

  public function despawn(){
    this.state.pickups.remove(this);
    this.destroy();
  }

}
