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
  private var bg:FlxSprite;

  public function new(status:VictoryStatus){
    super();
    this.status = status;
  }

  override public function create():Void
  {
    
    super.create();
    bg = new FlxSprite();
    bg.makeGraphic(Main.VIEWPORT_WIDTH, Main.VIEWPORT_HEIGHT, Main.BACKGROUND_GREY);
    bg.screenCenter();
    add(bg);

    // var endgameText = new FlxText( 200, 100 );
    var endgameText = new FlxText( ( Main.VIEWPORT_WIDTH / 4 ), 100 );
    switch(status){
      case WIN:
        endgameText.setFormat( "Arial", 48, Main.FONT_BLUE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
        endgameText.text = Settings.gameWinText;
      case LOSE:
        endgameText.setFormat( "Arial", 48, Main.FONT_RED, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
        endgameText.text = Settings.gameOverText;
    }
    add( endgameText );

    resolve_timer = new FlxTimer();
    resolve_timer.start(resolve_delay, function(t){
      allow_continue = true;

      var playAgain = new FlxText( 600,600, "PLAY AGAIN?" );
      // var playAgain = new FlxText( 3*(Main.VIEWPORT_WIDTH/5), Main.VIEWPORT_HEIGHT * (3/4), "PLAY AGAIN?" );
      playAgain.setFormat( "Arial", 60, Main.FONT_YELLOW, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
      playAgain.screenCenter( FlxAxes.X );
      add( playAgain );

    },1);
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
      ) FlxG.switchState( new IntroState() );
    super.update(elapsed);
  }

}
