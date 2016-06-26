package sprites;

class CollectableSprite extends InteractableSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/item-sword-idle.png";

  public function new(state:PlayState, x:Int, y:Int, graphic:String){
    super(state, x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
    this.solid = false;
  }

  public override function despawn(){
    this.state.collectables.remove(this);
    this.destroy();
  }

  // if return false, player does not pick up!
  public dynamic function onCollect():Bool{
    return true;
  }

}
