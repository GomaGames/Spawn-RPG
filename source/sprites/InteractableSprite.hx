package sprites;

import flixel.FlxSprite;

using Lambda;

class InteractableSprite extends FlxSprite implements IDespawnableSprite{

  private var state:PlayState;
  private var inventory:List<CollectableSprite>;

  public function new(state:PlayState, x:Int, y:Int, graphic:String) {
    super(x, y, graphic);
    this.state = state;
    this.inventory = new List<CollectableSprite>();
    this.immovable = true;
    this.scale.set(.5,.5);
    this.updateHitbox();
  }

  public dynamic function interact():Void{ }

  public function talk(message:String):Void
  {
    this.state.show_dialogue(message, Std.int(this.x), Std.int(this.y));
  }

  public inline function receiveItem(item:CollectableSprite):Void
  {
    this.inventory.add(item);
  }

  public inline function hasItem(inventory_item:CollectableSprite):Bool
  {
    return this.inventory.has(inventory_item);
  }

  public function despawn(){
    this.state.interactableSprites.remove(this);
    this.destroy();
  }
}
