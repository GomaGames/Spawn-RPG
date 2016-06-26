package sprites.pickups;

import flixel.FlxSprite;

class Pickup extends FlxSprite implements IDespawnableSprite{

  public var DURATION:Float;
  public var value:Int;

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, graphic:String){
    super(x, y, graphic);
    this.state = state;
  }

  public function despawn(){
    this.state.pickups.remove(this);
    this.destroy();
  }

}
