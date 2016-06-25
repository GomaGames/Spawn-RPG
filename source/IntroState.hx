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
  private static inline var TIMEOUT = 2; // seconds
  private var intro_text:FlxText;
  private var ready:Bool;

	override public function create():Void
	{
#if neko
    Spawn.dev_intro();
#end
		super.create();
    bgColor = Main.BACKGROUND_GREY;

    intro_text = new FlxText( 400, 600, Std.string( Spawn.intro ) );
    intro_text.setFormat( "Arial", 30, Main.FONT_BLUE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
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

