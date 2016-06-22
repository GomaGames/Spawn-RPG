package sprites;

import flixel.FlxSprite;

class InteractableSprite extends FlxSprite{
  public function new(x:Int, y:Int, graphic:String) {
    super(x, y, graphic);
    this.immovable = true;
    this.scale.set(.5,.5);
    this.updateHitbox();
  }

  public function interact(cb:Void->Void):Void
  {
    cb();
  }
}