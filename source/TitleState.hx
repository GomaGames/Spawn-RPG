package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
  private var titleImage:FlxSprite;

  override public function create():Void
  {
    super.create();
    bgColor = Main.BACKGROUND_GREY;

    titleImage = new FlxSprite();
    titleImage.loadGraphic( AssetPaths.TITLE_SCREEN );
    titleImage.screenCenter();
    add( titleImage );
  }

  override public function update(elapsed:Float):Void
  {
    if(
      FlxG.keys.getIsDown().length > 0 ||
      FlxG.mouse.pressed
      ) FlxG.switchState( new IntroState() );
    super.update(elapsed);
  }

  override public function destroy():Void
	{
    titleImage = null;
    super.destroy();
	}
}
