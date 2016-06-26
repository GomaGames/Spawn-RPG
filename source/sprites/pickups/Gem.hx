package sprites.pickups;

import flixel.FlxSprite;

class Gem extends Pickup {

  public static inline var DEFAULT_POINTS = 1;
  public static inline var DEFAULT_SKIN = "assets/images/item-gem-yellow.png";

  public function new(state:PlayState, x:Int, y:Int, ?graphic:String = DEFAULT_SKIN, value:Int){
    super(state, x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    if(value != null){
      this.value = value;
    }
  }

}

