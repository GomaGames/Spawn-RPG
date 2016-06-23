package sprites.pickups;

import flixel.FlxSprite;

class Speed extends Pickup {

  public static inline var DEFAULT_SKIN = "assets/images/19.png";
  public static inline var DEFAULT_DURATION = 2; // seconds

  public function new(state:PlayState, x:Int, y:Int, graphic:String, ?duration:Float = DEFAULT_DURATION){
    super(state, x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    if(duration != null){
      DURATION = duration;
    }
  }

}
