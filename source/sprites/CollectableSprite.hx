package sprites;

import flixel.FlxSprite;

class CollectableSprite extends FlxSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/item-sword-yellow.png";

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, ?graphic:String = DEFAULT_SKIN ){
    super(x, y, graphic);
    this.state = state;
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
    this.solid = false;
  }

  public inline function despawn(){
    Spawn.enqueue(function(){
      this.state.collectables.remove(this);
      this.destroy();
    });
  }

  // if return false, player does not pick up!
  public dynamic function onCollect():Bool{
    return true;
  }

}
