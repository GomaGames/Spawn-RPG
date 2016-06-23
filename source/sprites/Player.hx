package sprites;

import haxe.ds.IntMap;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUI9SliceSprite;
import flash.geom.Rectangle;
import flixel.text.FlxText;
import sprites.Map;

class PlayerInput {
  // map Int-> Player number
  public static var up:FlxKey = FlxKey.UP;
  public static var down:FlxKey = FlxKey.DOWN;
  public static var left:FlxKey = FlxKey.LEFT;
  public static var right:FlxKey = FlxKey.RIGHT;
  public static var interact:FlxKey = FlxKey.ENTER;
  public static var attack:FlxKey = FlxKey.SPACE;
}

class Player extends FlxSprite{

  private static inline var DIAGONAL_MOVEMENT = 1.41421356237;  // divide by sqrt(2)
  public static inline var DEFAULT_SKIN = "assets/images/01.png";
  public static inline var DEFAULT_SPEED = 200;

  public var points:Int;

  private var state:PlayState;
  private var graphic_path:String;
  private var attacking:Bool;
  private var base_speed:Int;
  private var speed:Int;
  private var spawn_position:FlxPoint;
  private var walkRot:Float;
  private var walkHopY:Float;
  public var dialogueBox:DialogueBox;
  public var inventory:Array<Dynamic>;
  public var inventoryDisplay:flixel.group.FlxSpriteGroup;

  public function new(state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN) {
    super(x, y, skin);

    this.scale.set(.5,.5);
    this.updateHitbox();
    this.height /= 4;
    this.width /= 4;
    this.centerOffsets();
    this.centerOrigin();

    this.inventoryDisplay = new FlxSpriteGroup(80,-20);
    this.inventoryDisplay.color = 0xffffff;
    state.add(this.inventoryDisplay);

    this.inventory = [];
    this.spawn_position = FlxPoint.weak(x, y);
    this.base_speed = DEFAULT_SPEED;
    this.speed = DEFAULT_SPEED;
    this.drag = FlxPoint.weak(this.speed*10, this.speed*10);
    this.points = 0;
    this.walkRot = 0;
    this.walkHopY = 0;
    this.state = state;
  }

  override public function update(elapsed:Float):Void
  {
    if(!this.state.paused) {
      movement();
    }
    interact();
    attack();
    collect_item();

    super.update(elapsed);
  }

  public inline function interact():Void
  {
    if(this.state.paused && FlxG.keys.anyJustPressed([PlayerInput.interact])) {
      // dialogueBox.end_dialogue();
      this.state.paused = false;
    }
    else if(!this.state.paused && this.state.interacted != null) {
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
        this.state.interacted.interact();
        // dialogueBox = new DialogueBox(this.state, 'Hello, Hero!\nlook how awesome this dialogue box is!', this.state.interact_person.x, this.state.interact_person.y);
        this.state.paused = true;
      }
    }
  }

  public inline function collect_item():Void
  {
    if(this.state.collected != null) {
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
        this.state.collected.collect(function() {
          var item = new FlxSprite(this.inventoryDisplay.x, 0, this.state.collected_asset);
          for(i in 0...this.inventory.length) {
            item.x = this.inventoryDisplay.x + 24*(i+1);
          }
          item.scale.set(.3,.3);
          this.updateHitbox();
          item.immovable = true;
          this.inventory.push(item);
          this.inventoryDisplay.add(item);
          trace('item added to inventory');
        });
      }
    }
  }

  private inline function attack():Void
  {
    if(FlxG.keys.anyJustPressed([PlayerInput.attack])) {
      trace('attacking');
    }
  }

  private inline function movement():Void
  {
    // this.velocity.set(0,0);
    var moving_h = false
      , moving_v = false;

    if(!this.attacking){
      if (FlxG.keys.anyPressed([PlayerInput.up])){
        // this.acceleration.y = -GG.hero_speed;
        this.acceleration.y = -this.speed *10;
        moving_v = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.down])){
        this.acceleration.y = this.speed *10;
        moving_v = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.left])){
        // this.acceleration.y = -GG.hero_speed;
        this.acceleration.x = -this.speed *10;
        moving_h = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.right])){
        this.acceleration.x = this.speed *10;
        moving_h = true;
      }
      // if (game.input.space){
      //   this.attack();
      // }
    }

    // funner walking
    if(moving_h || moving_v){
      this.angle = Math.cos(++this.walkRot)  * 10; // 100 tumbles
      this.y += Math.sin(--this.walkHopY) * 3;
    }else{
      this.angle = 0;
    }

    if(!moving_h) this.acceleration.x = 0;
    else this.flipX = this.acceleration.x > 0;
    if(!moving_v) this.acceleration.y = 0;


    // orthagonal movement goes faster
    this.maxVelocity = if(moving_h && moving_v){
      FlxPoint.weak(this.speed/DIAGONAL_MOVEMENT, this.speed/DIAGONAL_MOVEMENT);
    } else {
      FlxPoint.weak(this.speed, this.speed);

    }

  }

  public inline function speed_boost(duration:Float):Void
  {
    this.speed = base_speed * 2;
    new FlxTimer().start(duration, function(timer){
      this.speed = base_speed;
    });
  }

  public inline function slow_down(duration:Float):Void
  {
    this.speed = Std.int(base_speed / 2);
    new FlxTimer().start(duration, function(timer){
      this.speed = base_speed;
    });
  }

  public inline function freeze(duration:Float):Void
  {
    this.velocity.set(0,0);
    this.acceleration.set(0,0);
    this.speed = 0;
    new FlxTimer().start(duration, function(timer){
      this.speed = base_speed;
    });
  }

  public inline function score(points:Int):Void
  {
    this.points += points;
  }

  public inline function die():Void
  {
    if( this.state.survival_type ){
      this.alive = false;
      this.destroy();
    } else { // respawn
      this.x = spawn_position.x;
      this.y = spawn_position.y;
      this.velocity.set(0,0);
    }
  }
}

