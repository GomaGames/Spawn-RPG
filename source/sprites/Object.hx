package sprites;

import flixel.FlxSprite;

class Object extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/tile-white-circle-x.png";

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, ?graphic:String = DEFAULT_SKIN){
    super(x, y, graphic);
    this.state = state;
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
  }

  public function despawn(){
    this.state.objects.remove(this);
    this.destroy();
  }

}
