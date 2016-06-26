package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
  private var titleImage:FlxSprite;
  private var ready_text:FlxText; // don't allow rapid continue while holding buttons
  private var bg:FlxSprite;

	override public function create():Void
	{
    super.create();
    bg = new FlxSprite();
    bg.makeGraphic(Main.STAGE_WIDTH, Main.STAGE_HEIGHT, Main.BACKGROUND_GREY);
    bg.screenCenter();
    add(bg);

    titleImage = new FlxSprite();
    titleImage.loadGraphic( AssetPaths.INSTRUCTION_SCREEN );
    titleImage.scale.set(0.5, 0.5);
    titleImage.screenCenter();
    add( titleImage );

    ready_text = new FlxText( 400, 600, Std.string( "READY?" ) );
    ready_text.setFormat( "Arial", 50, Main.FONT_BLUE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    ready_text.screenCenter();
    ready_text.y = 1000;
    add( ready_text );

	}

	override public function update(elapsed:Float):Void
	{
    if( FlxG.keys.getIsDown().length > 0 || FlxG.mouse.pressed ){
      FlxG.switchState( new PlayState() );
    }

		super.update(elapsed);
	}

  override public function destroy():Void
	{
    titleImage = null;
    ready_text = null;
    super.destroy();
	}
}
