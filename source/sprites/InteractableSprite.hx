package sprites;

import flixel.FlxSprite;

class InteractableSprite extends FlxSprite implements IDespawnableSprite{

  private var state:PlayState;

  public function new(state:PlayState, x:Int, y:Int, graphic:String) {
    super(x, y, graphic);
    this.state = state;
    this.immovable = true;
    this.scale.set(.5,.5);
    this.updateHitbox();
  }

  public dynamic function interact():Void{ }

  public function talk(message:String):Void
  {
    this.state.show_dialogue(message, Std.int(this.x), Std.int(this.y));
  }

  public function despawn(){
    this.state.interactableSprites.remove(this);
    this.destroy();
  }
}