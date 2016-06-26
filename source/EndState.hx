package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;
import sprites.Player;

enum VictoryStatus {
  WIN;
  LOSE;
}

class EndState extends FlxState
{
  public static inline var DEFAULT_WIN_TEXT = "You Win!";
  public static inline var DEFAULT_LOSE_TEXT = "Game Over!";
  private var status:VictoryStatus;
  private var allow_continue:Bool; // don't allow rapid continue while holding buttons
  private var resolve_timer:FlxTimer; // don't allow rapid continue while holding buttons
  private static inline var resolve_delay:Int = 3; // seconds

  public function new(status:VictoryStatus){
    super();
    this.status = status;
  }

  override public function create():Void
  {
    super.create();
    bgColor = Main.BACKGROUND_GREY;

    var endgameText = new FlxText( ( Main.STAGE_WIDTH / 8 ), ( Main.STAGE_HEIGHT / 10 ) );
    endgameText.setFormat( "Arial", 42, Main.FONT_GREY, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    endgameText.screenCenter( FlxAxes.X );
    add( endgameText );
    endgameText.text = switch(status){
      case WIN: Spawn.gameWinText;
      case LOSE: Spawn.gameOverText;
    }

    resolve_timer = new FlxTimer();
    resolve_timer.start(resolve_delay, function(t){
      allow_continue = true;

      var playAgain = new FlxText( 3*(Main.STAGE_WIDTH/5), Main.STAGE_HEIGHT * (3/4), "PLAY AGAIN?" );
      playAgain.setFormat( "Arial", 60, Main.FONT_YELLOW, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
      playAgain.screenCenter( FlxAxes.X );
      add( playAgain );

    });
  }

  override public function destroy():Void
  {
    status = null;
    resolve_timer = null;
    super.destroy();
  }
  override public function update(elapsed:Float):Void
  {
    if( allow_continue &&
      ( FlxG.keys.getIsDown().length > 0 || FlxG.mouse.pressed )
      ) FlxG.switchState( new MenuState() );
    super.update(elapsed);
  }

}
