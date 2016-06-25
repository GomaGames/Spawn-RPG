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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import sprites.Map;

using Lambda;

class PlayerInput {
  // map Int-> Player number
  public static var up:FlxKey = FlxKey.UP;
  public static var down:FlxKey = FlxKey.DOWN;
  public static var left:FlxKey = FlxKey.LEFT;
  public static var right:FlxKey = FlxKey.RIGHT;
  public static var interact:FlxKey = FlxKey.ENTER;
  public static var attack:FlxKey = FlxKey.SPACE;
}

enum Direction {
  UP;
  DOWN;
  LEFT;
  RIGHT;
}
class Player extends FlxSprite{

  private static inline var DIAGONAL_MOVEMENT = 1.41421356237;  // divide by sqrt(2)
  public static inline var DEFAULT_SKIN = "assets/images/person-male-blondehair-blueshirt.png";
  public static inline var DEFAULT_SPEED = 200;

  public var points:Int;

  private var state:PlayState;
  private var graphic_path:String;
  private var current_direction:Direction;
  private var attacking:Bool;
  private var base_speed:Int;
  private var speed:Int;
  private var weapon:FlxSprite;
  private var spawn_position:FlxPoint;
  private var walkRot:Float;
  private var walkHopY:Float;
  public var inventory:List<CollectableSprite>;
  public var healthDisplay:flixel.group.FlxSpriteGroup;
  public var healthText:FlxText;

  public function new(state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN) {
    super(x, y, skin);

    this.scale.set(.5,.5);
    this.updateHitbox();
    this.height /= 4;
    this.width /= 4;
    this.centerOffsets();
    this.centerOrigin();
    this.attacking = false;
    this.current_direction = Direction.DOWN;

    this.inventoryDisplay = new FlxSpriteGroup(80,0);
    this.inventoryDisplay.color = 0xffffff;
    state.add(this.inventoryDisplay);

    this.health = 3;
    this.healthDisplay = new FlxSpriteGroup(500, 0);
    healthText = new FlxText(30,0);
    var heart = new FlxSprite(0,0,'assets/images/item-heart.png');
    heart.scale.set(0.3,0.3);
    heart.updateHitbox();
    this.healthDisplay.add(heart);
    healthText.text = Std.string(this.health) + " / 3";
    this.healthDisplay.add(healthText);
    state.add(this.healthDisplay);

    this.inventory = new List<CollectableSprite>();
    this.spawn_position = FlxPoint.weak(x, y);
    this.base_speed = DEFAULT_SPEED;
    this.speed = DEFAULT_SPEED;
    this.drag = FlxPoint.weak(this.speed*10, this.speed*10);
    this.points = 0;
    this.walkRot = 0;
    this.walkHopY = 0;
    this.state = state;

    weapon = new FlxSprite();
    weapon.loadGraphic( "assets/images/item-sword-idle.png" );
    weapon.x = this.x;
    weapon.y = this.y - 20;
    weapon.solid = false;
    weapon.allowCollisions = 0x0000;
    weapon.scale.set(0.5, 0.5);
    weapon.height /= 3;
    weapon.width /= 3;
    weapon.updateHitbox();
    state.add( weapon );
  }

  override public function update(elapsed:Float):Void
  {
    if(!this.state.paused) {
      movement();
    }
    interact();
    attack();
    collect_item();
    update_weapon();

    super.update(elapsed);
  }


  private inline function update_weapon():Void
  {
    if( this.attacking ){
      var x_inc:Int = 0;
      var y_inc:Int = 0;
      switch( this.current_direction ){
        case UP:
          x_inc = -Std.int(this.width);
          y_inc = -50;
        case DOWN:
          x_inc = -Std.int(this.width);
          y_inc = 20;
        case LEFT:
          x_inc = -50;
          y_inc = -Std.int(this.height);
        case RIGHT:
          x_inc = 20;
          y_inc = -Std.int(this.height);
        default: null;
      }
      var weapon_tween = FlxTween.tween(weapon, { x: this.x + x_inc, y: this.y + y_inc }, 0.3, { ease: FlxEase.elasticOut });
      weapon_tween.start();

    } else {
      weapon.centerOffsets();
      weapon.centerOrigin();
      weapon.x = this.x - this.width;
      weapon.y = this.y - this.height;
    }
  }

  public inline function interact():Void
  {
    if(this.state.interacted != null) {
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
        this.state.interacted.interact();
        this.state.interacted = null;
      }
    }
    else if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
      // remove dialogue box
      if(this.state.dialogue_box != null){
        this.state.dialogue_box.close();
      }
    } 
  }

  public inline function collect_item():Void
  {
    if(this.state.collected != null) {
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
        var item = this.state.collected;
        item.immovable = true;
        this.inventory.push(item);
        this.state.collectables.remove(item);
        this.state.remove(item);
        this.state.hud.addInventoryItem(item.clone());

        this.state.collected = null;
        trace('item added to inventory');
      }
    }
  }
  public inline function hasItem(inventory_item:CollectableSprite):
Bool
  {
    return this.inventory.has(inventory_item);
  }

  public inline function giveItem( inventory_item:CollectableSprite, receiver:InteractableSprite):Bool
  {
    if(this.hasItem(inventory_item)){
      this.inventory.remove(inventory_item);
      receiver.receiveItem(inventory_item);
      return true;
    } else {
      trace("WARNING: Player cannot giveItem that is not in player's inventory.");
      return false;
    }
  }

  private inline function attack():Void
  {
    if(FlxG.keys.anyJustPressed([PlayerInput.attack])) {
      weapon.reset(this.x,this.y);
      this.attacking = true;
      var time = new FlxTimer();
      time.start(0.1,function(timer){
        this.attacking = false;
        // weapon.kill();
      },3);
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
        this.current_direction = Direction.UP;
        this.acceleration.y = -this.speed *10;
        moving_v = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.down])){
        this.current_direction = Direction.DOWN;
        this.acceleration.y = this.speed *10;
        moving_v = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.left])){
        // this.acceleration.y = -GG.hero_speed;
        this.current_direction = Direction.LEFT;
        this.acceleration.x = -this.speed *10;
        moving_h = true;
      }
      if (FlxG.keys.anyPressed([PlayerInput.right])){
        this.current_direction = Direction.RIGHT;
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
    if( this.health == 0 ){
      this.alive = false;
      this.destroy();
    }
    // } else { // respawn
    //   this.x = spawn_position.x;
    //   this.y = spawn_position.y;
    //   this.velocity.set(0,0);
    // }
  }
}

