package sprites;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;

class DialogueBox extends FlxSprite{

  private var state:PlayState;
  private var dialogue:String;
  private var group:flixel.group.FlxSpriteGroup;
  private static inline var padding = 20;

  public function new(state:PlayState, input:String, x:Float, y:Float) {
    super(0, 0);

    this.state = state;
    this.x = x;
    this.y = y;
    var dialogue = new FlxText();
    dialogue.text = input;
    var _slice:Array<Int> = [10,10,40,40];
    var _graphic:String = "assets/images/tile-blue-square-button.png";
    var bg = new FlxUI9SliceSprite(0, 0, _graphic, new Rectangle(0,0,dialogue.width+padding,dialogue.height+padding), _slice);
    group = new FlxSpriteGroup(this.x+15, this.y-15);

    dialogue.x = padding/2;
    dialogue.y = padding/2;

    group.add(bg);
    group.add(dialogue);
    group.immovable = true;
    state.add(group);
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
  }

  public inline function close():Void
  {
    state.remove(group);
    state.dialogue_box = null;
    this.destroy();
    state.paused = false;
  }
}
