package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.util.FlxColor;
class Main extends Sprite
{
  public static inline var VIEWPORT_WIDTH = 920;
  public static inline var VIEWPORT_HEIGHT = 680;
  public static inline var STAGE_WIDTH = 1840;
  public static inline var STAGE_HEIGHT = 1360;
  public static var BACKGROUND_GREY:FlxColor = FlxColor.fromString('#333333');
  public static var FONT_GREY:FlxColor = FlxColor.fromString('#6d6e70');
  public static var FONT_RED:FlxColor = FlxColor.fromString('#e76924');
  public static var FONT_YELLOW:FlxColor = FlxColor.fromString('#fec256');
  public static var FONT_BLUE:FlxColor = FlxColor.fromString('#5dc3ce');

  public static var intro_watched:Bool = false;

	public function new()
	{
		super();


#if neko
    Spawn.dev_settings();
#end

    FlxG.stage.quality = openfl.display.StageQuality.BEST;

    if(Settings.skipIntro){
      //                                skip splash -------------------------------V
      addChild(new FlxGame(STAGE_WIDTH, STAGE_HEIGHT, PlayState, null, null, null, true));
    } else {
      addChild(new FlxGame(STAGE_WIDTH, STAGE_HEIGHT, TitleState, null, null, null, true));
    }

    FlxG.camera.antialiasing = true;
    FlxG.camera.setScale(2, 2);

  }
}
