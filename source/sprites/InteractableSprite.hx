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
    Spawn.enqueue(function(){
      this.state.queue_dialogue(message, DialogueBox.TYPE.STAGE, Std.int(this.x + 25), Std.int(this.y + 15));
    });
  }

  public inline function receiveItem(item:CollectableSprite):Void
  {
    Spawn.enqueue(function(){
      this.inventory.add(item);
    });
  }

  public inline function hasItem(inventory_item:CollectableSprite):Bool
  {
    return this.inventory.has(inventory_item);
  }

  public function despawn(){
    Spawn.enqueue(function(){
      this.state.interactableSprites.remove(this);
      this.destroy();
    });
  }
}
