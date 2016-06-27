package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class IntroState extends FlxState
{
  public static inline var DEFAULT_INTRO_TEXT = "Welcome to Spawn Hero RPG!";
  private static inline var TIMEOUT = 2; // seconds
  private var intro_text:FlxText;
  private var ready:Bool;
  private var bg:FlxSprite;

	override public function create():Void
	{
#if neko
    Spawn.dev_intro();
#end
		super.create();
    bg = new FlxSprite();
    bg.makeGraphic(Main.STAGE_WIDTH, Main.STAGE_HEIGHT, Main.BACKGROUND_GREY);
    bg.screenCenter();
    add(bg);

    intro_text = new FlxText( 400, 600, Settings.introText );
    intro_text.setFormat( "Arial", 50, Main.FONT_BLUE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    intro_text.screenCenter();
    add( intro_text );

    var timeout = new FlxTimer();
    timeout.start(TIMEOUT, function(t:FlxTimer){
      ready = true;
    });
	}

	override public function update(elapsed:Float):Void
	{
    if( ready && FlxG.keys.getIsDown().length > 0 || FlxG.mouse.pressed ){
      FlxG.switchState( new MenuState() );
    }

		super.update(elapsed);
	}

  override public function destroy():Void
	{
    intro_text = null;
    super.destroy();
	}
}

