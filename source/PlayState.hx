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
import sprites.Equippable;
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
  private var dialogue_boxes:List<DialogueBox>; // queue
  private var current_dialogue_box:DialogueBox; // the open one
  public var player:Player;
  public var pickups:List<Pickup>;
  public var enemies:List<Enemy>;
  public var objects:List<Object>;
  public var interactableSprites:List<InteractableSprite>;
  public var collectables:List<CollectableSprite>;
  public var weapon:Equippable;
  public var paused:Bool;
  public var survival_type:Bool; // true? only one life
  public var collected:CollectableSprite;
  public var collected_asset:String;
  public var hud:HUD;

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
    dialogue_boxes = new List<DialogueBox>();
    survival_type = true;
    collected = null;
    paused = false;
		super.create();
    map = new Map(this);
    map.makeGraphic( Main.STAGE_WIDTH, Main.STAGE_HEIGHT, Main.BACKGROUND_GREY );
    Map.drawGridLines( this, map );
    weapon = new Equippable( this );
    add(weapon);

    hud = new HUD(-10000, -10000);

    add(hud);

    bgColor = Main.BACKGROUND_GREY;
    add(map);
    add(flixel.util.FlxCollision.createCameraWall(FlxG.camera, true, 1));

#if neko
    Spawn.dev();
#else
    Spawn.game();
#end
    // FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X , LEVEL_MIN_Y , LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
    FlxG.camera.follow(player, TOPDOWN, 1);
    // FlxG.camera.setScrollBoundsRect(0, 0, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);
    var topBarCam = new FlxCamera(0, 0, Main.STAGE_WIDTH, Main.STAGE_HEIGHT, 2);
    topBarCam.bgColor = FlxColor.TRANSPARENT;

    topBarCam.follow(hud);
    FlxG.cameras.add(topBarCam);
	}

  /*
    queue up dialogue boxes so one can show at a time
  */
  public inline function queue_dialogue(message:String, x:Int, y:Int):Void
  {
    dialogue_boxes.add(new DialogueBox(message, x, y));
  }

  public inline function close_dialogue():Void
  {
    if(current_dialogue_box != null){
      current_dialogue_box.close();
      current_dialogue_box = null;
    }
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
            player.coins += pickup.value;
        }
      }
    }
  }

  private inline function touch_enemy():Void
  {
    for( enemy in enemies ){
      if( FlxG.collide(player, enemy) ){
        player.life--;
      }
    }
  }

  private inline function kill_enemy():Void
  {
    for( enemy in enemies ){
      if( FlxG.collide(enemy, weapon) && player.attacking ){
        trace('HIT!');
        enemy.despawn();
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
    collected = null;
    dialogue_boxes = null;
    current_dialogue_box = null;
    super.destroy();
	}

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if( current_dialogue_box != null && FlxG.keys.anyJustPressed([PlayerInput.interact])){ // wait for unpause
      remove(current_dialogue_box);
      close_dialogue();
      paused = false;
    } else if( current_dialogue_box == null && dialogue_boxes.length > 0 ){ // process queue
      current_dialogue_box = dialogue_boxes.pop();
      add(current_dialogue_box);
      paused = true;

    } else if( this.player.alive ){
      
      kill_enemy();

      pickup_collision();

      item_pickup();

      touch_enemy(); // must be last, cause can die!

    }

    FlxG.collide();
  }
}
