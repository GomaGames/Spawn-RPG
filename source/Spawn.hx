package;

import flixel.FlxSprite;
import sprites.Player;
import sprites.Enemy;
import sprites.DialogueBox;
import sprites.Object;
import sprites.pickups.*;
import sprites.InteractableSprite;
import sprites.CollectableSprite;

enum PickupType{
  GEM;
  FREEZE;
  SLOW;
  SPEED;
}

@:expose class Spawn {

  private static inline var TOPBAR_Y_OFFSET = 40; // pixels from top

  public static var state:PlayState;

  // only allow if hero is not spawned yet
  public static inline function hero(x:Int, y:Int):Player
  {
    if(state.player == null){
      var new_player = new Player(state,x,y);
      state.player = new_player;
      state.add(new_player);
      return new_player;
    }else{
      trace("WARNING: hero is already spawned!");
      return state.player;
    }
  }

  public static inline function freeze(x:Int, y:Int, ?duration:Int, ?skin:String):Freeze
  {
    var new_pickup = new Freeze(
      state,
      x,
      y + TOPBAR_Y_OFFSET,
      skin != null ? skin : Settings.freeze.default_skin,
      duration != null ? duration : Settings.freeze.default_duration);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }

  public static inline function speed(x:Int, y:Int, ?duration:Int, ?skin:String):Speed
  {
    var new_pickup = new Speed(
      state,
      x,
      y + TOPBAR_Y_OFFSET,
      skin != null ? skin : Settings.speed.default_skin,
      duration != null ? duration : Settings.speed.default_duration);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }


  public static inline function slow(x:Int, y:Int, ?duration:Int, ?skin:String):Slow
  {
    var new_pickup = new Slow(
      state,
      x,
      y + TOPBAR_Y_OFFSET,
      skin != null ? skin : Settings.slow.default_skin,
      duration != null ? duration : Settings.slow.default_duration);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }

  public static inline function gem(x:Int, y:Int, ?points:Int, ?skin:String):Gem
  {
    var new_pickup = new Gem(
      state,
      x,
      y + TOPBAR_Y_OFFSET,
      skin != null ? skin : Settings.gem.default_skin,
      points != null ? points : Settings.gem.default_points);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }

  public static inline function enemy(x:Int, y:Int, ?direction:String, ?speed:Int, ?skin:String):Enemy
  {
    var new_enemy = new Enemy(
      state,
      x,
      y + TOPBAR_Y_OFFSET,
      speed != null ? speed : Settings.enemy.default_speed,
      skin != null ? skin : Settings.enemy.default_skin,
      direction);
    state.enemies.add(new_enemy);
    state.add(new_enemy);
    return new_enemy;
  }

  public static inline function interactableSprite(x:Int, y:Int, graphic:String):InteractableSprite
  {
    var new_sprite = new InteractableSprite(state, x, y + TOPBAR_Y_OFFSET, graphic);
    state.interactableSprites.add(new_sprite);
    state.add(new_sprite);
    return new_sprite;
  }

  public static inline function collectableSprite(x:Int, y:Int, graphic:String):CollectableSprite
  {
    var new_sprite = new CollectableSprite(state, x, y + TOPBAR_Y_OFFSET, graphic);
    state.collectables.add(new_sprite);
    state.add(new_sprite);
    return new_sprite;
  }

  public static inline function object(x:Int, y:Int, ?skin:String):Object
  {
    var new_obj = new Object(state, x, y + TOPBAR_Y_OFFSET, skin);
    state.objects.add(new_obj);
    state.add(new_obj);
    return new_obj;
  }

#if neko
  private static var diddev:Bool = false;
  public static inline function dev():Void
  {
    if( !diddev ){
      var wall_skin = "assets/images/17.png";
      hero( 0, 50 );
      object(120, 240, wall_skin);
      object(160, 200, wall_skin);
      object(650, 600, wall_skin);
      object(240, 0, wall_skin);
      freeze( 200, 200 );
      speed( 160, 100 );
      slow( 160, 300 );
      gem( 200, 100 );
      gem( 200, 400 );
      var e1 = enemy( 650, 500 , "down");
      var e2 = enemy( 500, 550 , "right");
      var e3 = enemy( 600, 500 , "up");
      var e4 = enemy( 500, 450 , "left");
      var e5 = enemy( 400, 450 );

      var quest_1_complete = false;
      var quest_2_complete = false;

      // new in RPG version

      var enemyBomb = interactableSprite(300, 50, 'assets/images/09.png');
      enemyBomb.y = 300;
      enemyBomb.interact = function(){
        e1.despawn();
        e2.despawn();
        e3.despawn();
        e4.despawn();
        e5.despawn();
        enemyBomb.despawn();
      }

      // myObj.interact = function(){
      //   if(player.items.has('scroll')){
      //     quest_1_complete = true;
      //     dialogue('hello wall');
      //   }else{

      //     dialogue('hello wall');
      //   }
      // };
      interactableSprite( 400, 50, "assets/images/04.png");
      collectableSprite( 300, 200, "assets/images/37.png");
      collectableSprite( 100, 50, "assets/images/16.png");
      collectableSprite( 50, 100, "assets/images/37.png");

      // myObj.interact = function(){
      //   dialogue('something else');
      // };


      // victory_condition = function(){
      //   return quest_1_complete && quest_2_complete;
      // };



      // need this for dev, just leave it, make sure it's always here
      diddev = true;
    }
  }
#end

}
