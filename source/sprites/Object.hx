package sprites;

class Object extends InteractableSprite implements IDespawnableSprite{

  public static inline var DEFAULT_SKIN = "assets/images/44.png";

  public function new(state:PlayState, x:Int, y:Int, graphic:String){
    super(state, x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
  }

  public override function despawn(){
    this.state.objects.remove(this);
    this.destroy();
  }

}
