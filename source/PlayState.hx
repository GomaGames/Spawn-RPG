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
import flixel.math.FlxRect;
import sprites.CollectableSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flash.Lib;
import flixel.FlxCamera;

class PlayState extends FlxState
{
  // Demo arena boundaries
  static var LEVEL_MIN_X;
  static var LEVEL_MAX_X;
  static var LEVEL_MIN_Y;
  static var LEVEL_MAX_Y;

  private var map:Map;
  public var dialogue_box:DialogueBox;
  public var player:Player;
  public var pickups:List<Pickup>;
  public var enemies:List<Enemy>;
  public var objects:List<Object>;
  public var interactableSprites:List<InteractableSprite>;
  public var collectables:List<CollectableSprite>;

  public var paused:Bool;
  public var survival_type:Bool; // true? only one life
  public var interacted:InteractableSprite;
  public var collected:CollectableSprite;
  public var collected_asset:String;

  public function new(){
    Spawn.state = this;
    super();
  }
	override public function create():Void
	{
    FlxG.mouse.visible = false;
    FlxG.camera.setScale(2, 2);
    FlxG.camera.setPosition(0,0);
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

#if neko
    Spawn.dev();
#else
    Spawn.game();
#end
    FlxG.camera.follow(player, LOCKON, 1);
	}

  public inline function show_dialogue(message:String, x:Int, y:Int):Void
  {
    dialogue_box = new DialogueBox(this, message, x, y);
    paused = true;
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
        player.health = player.health- 1;
        trace('health: ', player.health);
        player.die();
        survival_check();
      }
    }
  }

  private inline function interact_collision():Void
  {
    for(sprite in interactableSprites) {
      if( FlxG.collide(player, sprite) ){
        interacted = sprite;
        trace('interacting');
      }
    }
  }

  private inline function item_pickup():Void
  {
    for(sprite in collectables) {
      var spritePosition = new FlxPoint(sprite.x+sprite.width/2, sprite.y+sprite.height/2);
      if(player.pixelsOverlapPoint(spritePosition)){
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
    super.update(elapsed);

    pickup_collision();

    interact_collision();

    touch_enemy();

    item_pickup();

    FlxG.collide();
  }
}
