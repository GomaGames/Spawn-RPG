package sprites;

class CollectableSprite extends InteractableSprite {

  public static inline var DEFAULT_SKIN = "assets/images/37.png";

  public function new(x:Int, y:Int, graphic:String){
    super(x, y, graphic);
    this.scale.set(.5,.5);
    this.updateHitbox();
    this.immovable = true;
  }

  public function collect(cb:Void->Void):Void
  {
    this.destroy();
    cb();
  }
 
}