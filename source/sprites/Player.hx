package sprites;

import haxe.ds.IntMap;
import flixel.FlxG;
import flixel.FlxObject;
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
  public static inline var DEFAULT_SKIN = "assets/images/person-male-1.png";
  public static inline var DEFAULT_SPEED = 200;

  public var points:Int;

  private var state:PlayState;
  private var graphic_path:String;
  public var current_direction:Direction;
  public var attacking:Bool;
  private var base_speed:Int;
  private var speed:Int;
  private var spawn_position:FlxPoint;
  private var walkRot:Float;
  private var walkHopY:Float;
  private var interacted:InteractableSprite;
  private var collected:CollectableSprite;
  private var collected_asset:String;
  public var inventory:List<CollectableSprite>;
  public var weapon:Equippable;

  public var life(get,set):Int;
  private var _life:Int;
  private inline function set_life(val:Int):Int{
    this._life = val;
    this.state.hud.life = val;
    if( this._life <= 0 ){
      this.die();
    }
    return this._life;
  }
  private inline function get_life():Int{
    return this._life;
  }

  public var coins(default,set):Int;
  private inline function set_coins(val:Int):Int{
    this.coins = val;
    this.state.hud.coins = val;
    return this.coins;
  }

  public function new(state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN) {
    super(x, y, skin);
    this.state = state;

    this.scale.set(.5,.5);
    this.updateHitbox();
    this.height /= 4;
    this.width /= 4;
    this.centerOffsets();
    this.centerOrigin();
    this.attacking = false;
    this.current_direction = Direction.DOWN;

    this.life = 3;
    this.coins = 0;

    this.inventory = new List<CollectableSprite>();
    this.spawn_position = FlxPoint.weak(x, y);
    this.base_speed = DEFAULT_SPEED;
    this.speed = DEFAULT_SPEED;
    this.drag = FlxPoint.weak(this.speed*10, this.speed*10);
    this.points = 0;
    this.walkRot = 0;
    this.walkHopY = 0;

  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
    if(!this.state.paused) {
      movement();
      attack();
      collect_item();
      interact_collision();
      collectable_collision();
      interact(); // must be after collect_item()
    }
  }

  private inline function equipWeapon(item:Weapon):Void
  {
    if(this.weapon != null){
      drop(this.weapon);
    }

    // overwrite any onCollect callbacks after the first call
    item.onCollect = function(){ return true; };

    this.weapon = item;
    this.state.collectables.remove(item);
  }

  public inline function drop(item:CollectableSprite):Void
  {
    if(this.hasItem(item)){
      this.state.hud.removeInventoryItem(item);
      item.immovable = false;
      this.inventory.remove(item);
      this.state.collectables.add(item);
      this.state.add(item);
      item.x = this.x;
      item.y = this.y;
    } else if( this.hasEquipped(item) ){
      if(this.weapon == item){
        this.weapon = null;
      }
      item.x = this.x;
      item.y = this.y;
      item.immovable = false;
      this.state.collectables.add(item);
      this.state.add(item);
    }
  }

  public inline function collect_item():Void
  {
    if(this.collected != null) {
      if(FlxG.keys.anyJustPressed([PlayerInput.interact])) {
        var item = this.collected;
        if( item.onCollect() != false ){
          if( Std.is(item, Equippable )){
            // equip it
            if( Std.is(item, Weapon) ){
              equipWeapon(cast(item, Weapon));
            } else {
              trace("equipping non-weapon not yet implemented!");
            }
          }else{
            item.immovable = true;
            this.inventory.push(item);
            this.state.collectables.remove(item);
            this.state.remove(item);
            this.state.hud.addInventoryItem(item);
          }

          this.collected = null;
        }
      }
    }
  }

  private inline function collectable_collision():Void
  {
    for(sprite in state.collectables) {
      var spritePosition = new FlxPoint(sprite.x+sprite.width/2, sprite.y+sprite.height/2);
      if(this.pixelsOverlapPoint(spritePosition)){
        collected = sprite;
        collected_asset = sprite.graphic.assetsKey;
      }
    }
  }


  private inline function attack():Void
  {
    if(FlxG.keys.anyJustPressed([PlayerInput.attack])){
      this.attacking = true;
      }
    if(FlxG.keys.anyJustReleased([PlayerInput.attack])){
      this.attacking = false;
    }
  }

  public inline function interact():Void
  {
    if(interacted != null && FlxG.keys.anyJustPressed([PlayerInput.interact])){
      interacted.interact();
      interacted = null;
    }
  }

  private inline function interact_collision():Void
  {
    for(sprite in state.interactableSprites) {
      if( FlxG.collide(this, sprite) ){
        interacted = sprite;
      }
    }
  }

  public inline function hasItem(inventory_item:CollectableSprite):
Bool
  {
    return this.inventory.has(inventory_item);
  }

  public inline function hasEquipped(item:CollectableSprite):
Bool
  {
    return this.weapon == item;
  }

  public inline function giveItem( inventory_item:CollectableSprite, receiver:InteractableSprite):Bool
  {
    if(this.hasItem(inventory_item)){
      this.state.hud.removeInventoryItem(inventory_item);
      this.inventory.remove(inventory_item);
      receiver.receiveItem(inventory_item);
      return true;
    } else {
      trace("WARNING: Player cannot giveItem that is not in player's inventory.");
      return false;
    }
  }

  private inline function movement():Void
  {
    var moving_h = false
      , moving_v = false;

    if(!this.attacking){
      if (FlxG.keys.anyPressed([
        PlayerInput.up,
        PlayerInput.left,
        PlayerInput.right,
        PlayerInput.down])){
        if(!isTouching(FlxObject.ANY)){
          interacted = null;
          collected = null;
        }
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

      }
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
    this.alive = false;
    Spawn.gameOver();
    this.destroy();
  }
}

