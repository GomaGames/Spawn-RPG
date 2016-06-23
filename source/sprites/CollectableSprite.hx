package sprites;

class CollectableSprite extends InteractableSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/37.png";

  public function new(state:PlayState, x:Int, y:Int, graphic:String){
    super(state, x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
  }

  public function collect(cb:Void->Void):Void
  {
    cb();
    this.despawn();
  }

  public override function despawn(){
    this.state.collectables.remove(this);
    this.destroy();
  }

}
