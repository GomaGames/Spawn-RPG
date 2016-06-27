package sprites;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;

class DialogueBox extends FlxSpriteGroup{

  private var dialogue:String;
  private static inline var padding = 20;

  public function new(input:String, x:Float, y:Float) {
    super(x+15, y-15);

    var dialogue = new FlxText();
    dialogue.text = input;
    var _slice:Array<Int> = [10,10,40,40];
    var _graphic:String = "assets/images/tile-grey-square.png";
    var bg = new FlxUI9SliceSprite(0, 0, _graphic, new Rectangle(0,0,dialogue.width+padding,dialogue.height+padding), _slice);

    dialogue.x = padding/2;
    dialogue.y = padding/2;

    add(bg);
    add(dialogue);
    immovable = true;
    dialogue.allowCollisions =
    bg.allowCollisions = FlxObject.NONE;
  }

  public inline function close():Void
  {
    this.destroy();
  }
}
