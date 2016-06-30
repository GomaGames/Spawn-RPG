package sprites;

import flixel.FlxSprite;

class Object extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/wall-stone.png";

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, ?graphic:String = DEFAULT_SKIN){
    super(x, y, graphic);
    this.state = state;
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
  }

  public function despawn(){
    Spawn.enqueue(function(){
      this.state.objects.remove(this);
      this.destroy();
    });
  }

}
