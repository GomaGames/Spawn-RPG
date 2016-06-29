package;

import flixel.FlxG;
import flixel.FlxSprite;
import sprites.Player;
import sprites.Enemy;
import sprites.DialogueBox;
import sprites.Object;
import sprites.Weapon;
import sprites.Projectile;
import sprites.RangedWeapon;
import sprites.pickups.*;
import sprites.InteractableSprite;
import sprites.CollectableSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

enum PickupType{
  COIN;
  FREEZE;
  SLOW;
  SPEED;
}

@:expose class Spawn {

  public static var state:PlayState;
  private static var queue:List<Void->Void> = new List<Void->Void>();
  public static inline function enqueue(func:Void->Void):Void
    queue.add(func);

  public static inline function process_queue():Void{
    if(!queue.isEmpty()){
      queue.pop()();
    }
  }

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
    enqueue(function(){
      state.pickups.add(new_pickup);
      state.add(new_pickup);
    });
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
    enqueue(function(){
      state.pickups.add(new_pickup);
      state.add(new_pickup);
    });
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
    enqueue(function(){
      state.pickups.add(new_pickup);
      state.add(new_pickup);
    });
    return new_pickup;
  }

  public static inline function coin(x:Int, y:Int, ?value:Int, ?skin:String):Coin
  {
    var new_pickup = new Coin(
      state,
      x,
      y,
      skin != null ? skin : Settings.coin.default_skin,
      value != null ? value : Settings.coin.default_value);
    enqueue(function(){
      state.pickups.add(new_pickup);
      state.add(new_pickup);
    });
    return new_pickup;
  }

  public static inline function enemy(x:Int, y:Int, ?direction:String, ?speed:Int, ?skin:String, ?health:Int = 1):Enemy
  {
    var new_enemy = new Enemy(
      state,
      x,
      y,
      speed != null ? speed : Settings.enemy.default_speed,
      skin != null ? skin : Settings.enemy.default_skin,
      direction,
      health);
    enqueue(function(){
      state.enemies.add(new_enemy);
      state.add(new_enemy);
    });
    return new_enemy;
  }

  public static inline function interactableSprite(x:Int, y:Int, graphic:String):InteractableSprite
  {
    var new_sprite = new InteractableSprite(state, x, y, graphic);
    enqueue(function(){
      state.interactableSprites.add(new_sprite);
      state.add(new_sprite);
    });
    return new_sprite;
  }

  public static inline function collectableSprite(x:Int, y:Int, graphic:String):CollectableSprite
  {
    var new_sprite = new CollectableSprite(state, x, y, graphic);
    enqueue(function(){
      state.collectables.add(new_sprite);
      state.add(new_sprite);
    });
    return new_sprite;
  }

  public static inline function weapon(x:Int, y:Int, graphic:String, ?power:Int = 1):Weapon
  {
    var new_sprite = new Weapon(state, x, y, graphic, power);
    enqueue(function(){
      state.collectables.add(new_sprite);
      state.add(new_sprite);
    });
    return new_sprite;
  }

  public static inline function rangedWeapon(x:Int, y:Int, graphic:String, ?ranged_graphic:String, ?power:Int, ?range:Float, ?duration:Float ):RangedWeapon
  {
    var new_sprite = new RangedWeapon(state, x, y, graphic, ranged_graphic, power, range, duration);
    enqueue(function(){
      state.collectables.add(new_sprite);
      state.add(new_sprite);
    });
    return new_sprite;
  }

  public static inline function object(x:Int, y:Int, ?skin:String):Object
  {
    var new_obj = new Object(state, x, y, skin);
    enqueue(function(){
      state.objects.add(new_obj);
      state.add(new_obj);
    });
    return new_obj;
  }

  /*
     if x is null, set to center of the screen
     if y is null, set to 20% from top of screen
  */
  public static inline function message(message:String, ?x:Int, ?y:Int):Void
  {
    if(x == null) x = Std.int( Main.VIEWPORT_WIDTH - ( message.length * 4 ) );
    if(y == null) y = Std.int( Main.VIEWPORT_HEIGHT + 100 );
    enqueue(function(){
      state.queue_dialogue(message, TYPE.HUD, x, y);
    });
  }

  public static inline function gameWin():Void
  {
    enqueue(function(){
      FlxG.switchState(new EndState(EndState.VictoryStatus.WIN));
    });
  }

  public static inline function gameOver():Void
  {
    enqueue(function(){
      FlxG.switchState(new EndState(EndState.VictoryStatus.LOSE));
    });
  }

#if neko
  public static inline function dev_settings():Void
  {
    Settings.introText = "This is my game.\n\nThere are many games like it.\n\nThis one is mine";
    Settings.gameWinText = "Good Job!";
    Settings.gameOverText = "You died ladidadidah!";
    Settings.skipIntro = true;

    Settings.hero.default_skin = "assets/images/creature-trex.png";
    Settings.hero.default_speed = 499;
    Settings.hero.default_life = 10;
  }

  public static inline function dev():Void
  {
    var wall_skin = "assets/images/terrain-wall-stone.png";
    var player = Spawn.hero( 100, 150 );

    object(160, 200, wall_skin);
    object(650, 600, wall_skin);
    object(240, 0, wall_skin);
    freeze( 200, 200, 60 );
    speed( 160, 100 );
    speed( 1160, 100 );
    speed( 2160, 100 );
    speed( 160, 1100 );
    speed( 160, 2100 );
    speed( 760, 500 );
    speed( 460, 900 );
    slow( 160, 300 );
    coin( 200, 100 );
    coin( 200, 400 );
    var trex = "assets/images/creature-trex.png";
    var e1 = enemy( 650, 500 , "down", trex, 4);
    var e2 = enemy( 500, 550 , "right", trex, 4);
    var e3 = enemy( 600, 500 , "up", trex, 4);
    var e4 = enemy( 500, 450 , "left", trex, 4);
    var e5 = enemy( 400, 450 , null, trex, 4 );
    e5.onDeath = function(){
      Spawn.message("noooooooo");
    }

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

    var badGuy = enemy( 700, 750 , null, "assets/images/creature-robot-yellow.png", 999 );
    badGuy.hit = function(?weapon:Weapon){
      if( quest_1_complete ){
        badGuy.hurt( 9999 );
      } else {
        badGuy.hurt( 0 );
      }
    }

    // badGuy.hit = function(weapon){
    //   if( weapon == staff ){
    //     badGuy.hurt( 9999 );
    //   } else {
    //     badGuy.hurt( 1 );
    //   }
    // }

    collectableSprite( 200, 5, "assets/images/nature-rock-smooth-grey.png");
    var sword1 = weapon( 300, 200, "assets/images/item-sword-blue.png", 2);
    sword1.onCollect = function(){
      Spawn.message("You got the magic sword!");
      return true;
    }
    var badgirl = interactableSprite( 30, 60, "assets/images/person-female-2.png");
    badgirl.interact = function(){
      gameOver();
    }
    var sword2 = weapon( 50, 100, "assets/images/item-sword-green.png", 4);
    var staff = weapon( 150, 400, "assets/images/item-staff-brown.png", 1);
    var ranged1 = rangedWeapon( 50, 50, "assets/images/item-bow-and-arrow.png", "assets/images/item-arrow.png");


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
    var thingNextToGirl = coin(Std.int(girl.x) + 50, 50);

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
      message('1.test queueing');
      messageFlag.talk('2. next spawn freeze');
      freeze(300, 300);
      messageFlag.talk('3. next spawn speed');
      speed(340, 300);
      messageFlag.talk('4. next spawn slow');
      slow(380, 300);
      messageFlag.talk('5. next spawn coin');
      coin(420, 300);
      messageFlag.talk('6. next spawn enemy');
      enemy(300, 340, "right", 2, trex);
      messageFlag.talk('7. next spawn interactable');
      interactableSprite(300, 380, "assets/images/item-potion-green.png");
      messageFlag.talk('8. next spawn collectable');
      collectableSprite(340, 380, "assets/images/item-gem-blue.png");
      messageFlag.talk('9. next spawn weapon');
      weapon(380, 380, "assets/images/item-sword-white.png");
      messageFlag.talk('10. next spawn ranged weapon');
      rangedWeapon(420, 380, "assets/images/item-bow-and-arrow.png");
      messageFlag.talk('11. next spawn object');
      object(300, 420, "assets/images/nature-flower1-blue.png");
      message('finally, end game with gameWin()');
      gameWin();
    }

    var enemyBomb = interactableSprite(220, 50, 'assets/images/creature-cube-yellow.png');
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


  }
#end

}
