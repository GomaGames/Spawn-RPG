package;

import flixel.FlxG;
import flixel.FlxSprite;
import sprites.Player;
import sprites.Enemy;
import sprites.DialogueBox;
import sprites.Object;
import sprites.pickups.*;
import sprites.InteractableSprite;
import sprites.CollectableSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

enum PickupType{
  GEM;
  FREEZE;
  SLOW;
  SPEED;
}

@:expose class Spawn {

  public static var state:PlayState;

  public static var introText:String = IntroState.DEFAULT_INTRO_TEXT;
  public static var gameWinText:String = EndState.DEFAULT_WIN_TEXT;
  public static var gameOverText:String = EndState.DEFAULT_LOSE_TEXT;

  public static dynamic function game():Void{}

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
      y,
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
      y,
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
      y,
      skin != null ? skin : Settings.slow.default_skin,
      duration != null ? duration : Settings.slow.default_duration);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }

  public static inline function gem(x:Int, y:Int, ?value:Int, ?skin:String):Gem
  {
    var new_pickup = new Gem(
      state,
      x,
      y,
      skin != null ? skin : Settings.gem.default_skin,
      value != null ? value : Settings.gem.default_points);
    state.pickups.add(new_pickup);
    state.add(new_pickup);
    return new_pickup;
  }

  public static inline function enemy(x:Int, y:Int, ?direction:String, ?speed:Int, ?skin:String):Enemy
  {
    var new_enemy = new Enemy(
      state,
      x,
      y,
      speed != null ? speed : Settings.enemy.default_speed,
      skin != null ? skin : Settings.enemy.default_skin,
      direction);
    state.enemies.add(new_enemy);
    state.add(new_enemy);
    return new_enemy;
  }

  public static inline function interactableSprite(x:Int, y:Int, graphic:String):InteractableSprite
  {
    var new_sprite = new InteractableSprite(state, x, y, graphic);
    state.interactableSprites.add(new_sprite);
    state.add(new_sprite);
    return new_sprite;
  }

  public static inline function collectableSprite(x:Int, y:Int, graphic:String):CollectableSprite
  {
    var new_sprite = new CollectableSprite(state, x, y, graphic);
    state.collectables.add(new_sprite);
    state.add(new_sprite);
    return new_sprite;
  }

  public static inline function object(x:Int, y:Int, ?skin:String):Object
  {
    var new_obj = new Object(state, x, y, skin);
    state.objects.add(new_obj);
    state.add(new_obj);
    return new_obj;
  }

  /*
     if x is null, set to center of the screen
     if y is null, set to 20% from top of screen
  */
  public static inline function message(message:String, ?x:Int, ?y:Int):Void
  {
    if(x == null) x = 200; // #TODO
    if(y == null) y = 200; // #TODO
    state.queue_dialogue(message, x, y);
  }

  public static inline function gameWin():Void
  {
    FlxG.switchState(new EndState(EndState.VictoryStatus.WIN));
  }

  public static inline function gameOver():Void
  {
    FlxG.switchState(new EndState(EndState.VictoryStatus.LOSE));
  }

#if neko
  public static inline function dev_intro():Void
  {
    introText = "This is my game.\n\nThere are many games like it.\n\nThis one is mine";
    gameWinText = "Good Job!";
    gameOverText = "You died!";
  }

  private static var diddev:Bool = false;
  public static inline function dev():Void
  {
    if( !diddev ){

      var wall_skin = "assets/images/terrain-wall-stone.png";
      var player = hero( 0, 50 );
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
      function completeQuest(number){
        if(number == 1){
          quest_1_complete = true;
          message("Quest 1 complete!");
        }else if(number == 2){
          quest_2_complete = true;
          message("Quest 2 complete!");
        }
        if(quest_1_complete && quest_2_complete){
          gameWin();
        }
      }

      // new in RPG version
      collectableSprite( 200, 5, "assets/images/nature-rock-smooth-grey.png");
      var sword1 = collectableSprite( 300, 200, "assets/images/item-sword-blue.png");
      sword1.onCollect = function(){
        Spawn.message("You got the magic sword!");
        return true;
      }
      var sword2 = collectableSprite( 50, 100, "assets/images/item-sword-green.png");
      sword2.onCollect = function(){
        if( quest_1_complete ){
          Spawn.message("You got the super sword!");
          return true;
        } else {
          Spawn.message("Only those who are worthy may wield this sword.");
          return false;
        }
      }
      var girl = interactableSprite( 400, 50, "assets/images/person-female-2.png");
      var mirror = collectableSprite( 800, 400, "assets/images/item-mirror-blue.png");
      interactableSprite( 20, 400, "assets/images/item-mirror-blue.png");
      girl.interact = function(){
        if(!player.hasItem(mirror)){
          girl.talk("Killer robots? Do I LOOK dumb?");
        } else {
          player.giveItem(mirror, girl);
          girl.talk("Wow, the girl in this picture looks so clueless.");
          completeQuest(1);
          girl.talk("If you give the red blockhead guy a sword, he'll kill all the robots.");
        }
      }

      var messageFlag = interactableSprite( 100, 50, "assets/images/item-flag-red.png");
      messageFlag.interact = function(){
        message('bring ...');
        message('the sword ...');
        message('to the red square.');
      }

      var enemyBomb = interactableSprite(300, 50, 'assets/images/creature-cube-yellow.png');
      enemyBomb.y = 300;
      enemyBomb.interact = function(){
        if(player.hasItem(sword1) || player.hasItem(sword2)){
          e1.despawn();
          e2.despawn();
          e3.despawn();
          e4.despawn();
          e5.despawn();
          enemyBomb.despawn();
          completeQuest(2);
        }
      }


      // need this for dev, just leave it, make sure it's always here
      diddev = true;
    }
  }
#end

}
