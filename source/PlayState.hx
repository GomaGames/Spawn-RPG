package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
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
import sprites.Projectile;
import flixel.math.FlxRect;
import sprites.CollectableSprite;
import flixel.math.FlxPoint;
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
  public var projectiles:List<Projectile>;
  public var pickups:List<Pickup>;
  public var enemies:List<Enemy>;
  public var objects:List<Object>;
  public var interactableSprites:List<InteractableSprite>;
  public var collectables:List<CollectableSprite>;
  public var paused:Bool;
  public var survival_type:Bool; // true? only one life
  public var hud:HUD;
  public var hud_cam:FlxCamera;

  public function new(){
    Spawn.state = this;
    super();
  }
	override public function create():Void
	{
		super.create();
    pickups = new List<Pickup>();
    enemies = new List<Enemy>();
    objects = new List<Object>();
    projectiles = new List<Projectile>();
    interactableSprites = new List<InteractableSprite>();
    collectables = new List<CollectableSprite>();
    dialogue_boxes = new List<DialogueBox>();
    survival_type = true;
    paused = false;
    bgColor = Main.BACKGROUND_GREY;

    map = new Map();
    add(map);

    hud = new HUD();
    add(hud);

    FlxG.worldBounds.set(0,0,Main.STAGE_WIDTH,Main.STAGE_HEIGHT);

    // add(flixel.util.FlxCollision.createCameraWall(FlxG.camera, true, 10));

#if neko
    Spawn.dev();
#else
    Spawn.game();
#end
    // FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X , LEVEL_MIN_Y , LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
    // FlxG.camera.setScrollBoundsRect(0, 0, Main.STAGE_WIDTH, Main.STAGE_HEIGHT);

    FlxG.camera.follow(player, TOPDOWN, 1);
    FlxG.camera.bgColor = Main.BACKGROUND_GREY;


    hud_cam = new FlxCamera(0, 0, Main.VIEWPORT_WIDTH, Main.VIEWPORT_HEIGHT, 1);
    hud_cam.bgColor = FlxColor.TRANSPARENT;
    hud_cam.focusOn(FlxPoint.weak(hud.getMidpoint().x + Main.VIEWPORT_WIDTH/2, hud.getMidpoint().y + Main.VIEWPORT_HEIGHT/2));
    FlxG.cameras.add(hud_cam);

    drawBounds(this);
	}

  /*
    FlxG.collide() does not work in areas outside of the FlxG.worldBounds
  */
  private static inline function drawBounds(state:PlayState):Void
  {
    var leftBounds = new FlxObject(-999,0, 1000, FlxG.worldBounds.height);
    var rightBounds = new FlxObject(FlxG.worldBounds.width-1,0, 1000, FlxG.worldBounds.height);
    var topBounds = new FlxObject(0,-999, FlxG.worldBounds.width, 1000 );
    var bottomBounds = new FlxObject(0, FlxG.worldBounds.height-1, FlxG.worldBounds.width, 1000);
    leftBounds.solid =
    leftBounds.immovable =
    rightBounds.solid =
    rightBounds.immovable =
    topBounds.solid =
    topBounds.immovable =
    bottomBounds.solid =
    bottomBounds.immovable = true;

    state.add(leftBounds);
    state.add(rightBounds);
    state.add(topBounds);
    state.add(bottomBounds);
  }

  /*
    queue up dialogue boxes so one can show at a time
  */
  public inline function queue_dialogue(message:String, type:TYPE, x:Int, y:Int):Void
  {
    dialogue_boxes.add(new DialogueBox(message, type, x, y));
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
      if( FlxG.overlap(player, pickup) ){
        remove(pickup);
        pickups.remove(pickup);
        switch(Type.getClass(pickup)){
          case sprites.pickups.Speed:
            player.speed_boost(pickup.DURATION);
          case sprites.pickups.Slow:
            player.slow_down(pickup.DURATION);
          case sprites.pickups.Freeze:
            player.freeze(pickup.DURATION);
          case sprites.pickups.Coin:
            player.coins += pickup.value;
        }
      }
    }
  }

  private inline function touch_enemy():Void
  {
    for( enemy in enemies ){
      if( enemy.alive && FlxG.overlap(player, enemy) ){
        player.hit();
      }
    }
  }

  private inline function attack_enemy():Void
  {
    if( player.weapon != null ){
      for( enemy in enemies ){
        if( FlxG.overlap(enemy, player.weapon) && player.attacking ){
          enemy.hit(player.weapon);
          player.attacking = false;
        }
        for( projectile in projectiles ){
          if( FlxG.overlap(projectile, enemy) ){
            enemy.hit(player.weapon);
            projectile.destroy();
          }
        }
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
    dialogue_boxes = null;
    current_dialogue_box = null;
    hud_cam = null;
    super.destroy();
	}

  /*
     process dialogue queues first
     to block, and wait for user interaction
  */
  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if( current_dialogue_box != null ){
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])){ // wait for unpause
        if(current_dialogue_box.type == TYPE.HUD){
          hud.remove(current_dialogue_box);
        } else {
          remove(current_dialogue_box);
        }
        close_dialogue();
        paused = false;
      }
      // still reading, do nothing
    } else if( current_dialogue_box == null && dialogue_boxes.length > 0 ){ // process queue
      current_dialogue_box = dialogue_boxes.pop();
      if(current_dialogue_box.type == TYPE.HUD){
        hud.add(current_dialogue_box);
      } else {
        add(current_dialogue_box);
      }
      paused = true;

    } else if( this.player.alive ){

      // process Spawn queue
      Spawn.process_queue();

      attack_enemy();

      pickup_collision();

      touch_enemy(); // must be last, cause can die!

    }

    FlxG.collide();
  }
}
