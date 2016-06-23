package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import sprites.Map;
import sprites.Player;
import sprites.Enemy;
import sprites.DialogueBox;
import sprites.Object;
import sprites.pickups.Pickup;
import sprites.InteractableSprite;
import sprites.CollectableSprite;

class PlayState extends FlxState
{
  private var map:Map;
  public var player:Player;
  public var pickups:List<Pickup>;
  public var enemies:List<Enemy>;
  public var objects:List<Object>;
  public var survival_type:Bool; // true? only one life
  public var interacted:InteractableSprite;
  public var collected:CollectableSprite;
  public var paused:Bool;
  public var interactableSprites:List<InteractableSprite>;
  public var collectables:List<CollectableSprite>;
  public var collected_asset:String;

  public function new(){
    Spawn.state = this;
    super();
  }
	override public function create():Void
	{
    pickups = new List<Pickup>();
    enemies = new List<Enemy>();
    objects = new List<Object>();
    interactableSprites = new List<InteractableSprite>();
    collectables = new List<CollectableSprite>();
    survival_type = true;
    interacted = null;
    collected = null;
    paused = false;
		super.create();
    map = new Map(this);
    map.makeGraphic( Main.STAGE_WIDTH, Main.STAGE_HEIGHT, Main.BACKGROUND_GREY );
    Map.drawGridLines( this, map );
    Map.drawTopBar( this, map );

    bgColor = Main.BACKGROUND_GREY;
    add(map);
    add(flixel.util.FlxCollision.createCameraWall(FlxG.camera, true, 1));

    // p1score = new FlxText( Main.STAGE_WIDTH - 2 * ( Main.STAGE_WIDTH / Map.GRID_LINES_X ) , 10, '0');
    // p1score.setFormat( "Arial", 18, Main.FONT_BLUE, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    // add(p1score);

#if neko
    Spawn.dev();
#end
	}

  private inline function pickup_collision():Void
  {
    for( pickup in pickups ){
      if( FlxG.collide(player, pickup) ){
        remove(pickup);
        pickups.remove(pickup);
        switch(Type.getClass(pickup)){
          case sprites.pickups.Speed:
            player.speed_boost(pickup.DURATION);
          case sprites.pickups.Slow:
            player.slow_down(pickup.DURATION);
          case sprites.pickups.Freeze:
            player.freeze(pickup.DURATION);
          case sprites.pickups.Gem:
            player.score(pickup.POINTS);
            // victory_check();
        }
      }
    }
  }

  private inline function touch_enemy():Void
  {
    for( enemy in enemies ){
      if( FlxG.collide(player, enemy) ){
        player.die();
        survival_check();
      }
    }
  }

  private inline function interact_collision():Void //for interacting
  {
    for(sprite in interactableSprites) {
      if( FlxG.collide(player, sprite) ){
        interacted = sprite;
      }
    }
  }

  private inline function item_pickup():Void //for interacting
  {
    for(sprite in collectables) {
      if( FlxG.collide(player, sprite) ){
        collected = sprite;
        collected_asset = sprite.graphic.assetsKey;
      }
    }
  }

  private inline function survival_check():Void
  {
    if( !player.alive ){
      FlxG.switchState(new EndState(player, EndState.EndType.NO_SURVIVORS));
    }
  }

  // private inline function victory_check():Void
  // {
  //   if( Lambda.filter(pickups, function(p){
  //     return Type.getClass(p) == sprites.pickups.Gem;
  //   }).length == 0 ){
  //     FlxG.switchState(new EndState(player, EndState.EndType.FINISH));
  //   }
  // }

  override public function destroy():Void
	{
    map = null;
    player = null;
    pickups = null;
    enemies = null;
    objects = null;
    interactableSprites = null;
    collectables = null;
    survival_type = null;
    interacted = null;
    collected = null;
    super.destroy();
	}

  override public function update(elapsed:Float):Void
  {
    // if( player != null ){
    //   p1score.text = Std.string(player.points);
    // }
    super.update(elapsed);

    pickup_collision();

    interact_collision();

    touch_enemy();

    item_pickup();

    FlxG.collide();
  }
}
