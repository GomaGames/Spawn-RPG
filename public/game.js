Spawn.intro = "This is my game.\n\nThere are many games like it.\n\nThis one is mine";

Spawn.game = function(){

  var wall_skin = "assets/images/terrain-wall-stone.png";
  var player = Spawn.hero( 0, 50 );
  Spawn.object(120, 240, wall_skin);
  Spawn.object(160, 200, wall_skin);
  Spawn.object(650, 600, wall_skin);
  Spawn.object(240, 0, wall_skin);
  var e1 = Spawn.enemy( 650, 500 , "down");
  var e2 = Spawn.enemy( 500, 550 , "right");
  var e3 = Spawn.enemy( 600, 500 , "up");
  var e4 = Spawn.enemy( 500, 450 , "left");
  var e5 = Spawn.enemy( 400, 450 );

  var quest_1_complete = false;
  var quest_2_complete = false;
  function completeQuest(number){
    if(number == 1){
      quest_1_complete = true;
      Spawn.message("Quest 1 complete!");
    }else if(number == 2){
      quest_2_complete = true;
      Spawn.message("Quest 2 complete!");
    }
    if(quest_1_complete && quest_2_complete){
      Spawn.gameWin();
    }
  }

  var sword1 = Spawn.collectableSprite( 300, 200, "assets/images/item-sword-idle.png");
  var sword2 = Spawn.collectableSprite( 50, 100, "assets/images/item-sword-idle.png");
  var girl = Spawn.interactableSprite( 400, 50, "assets/images/person-female-blackhair-orangeshirt.png");
  var mirror = Spawn.collectableSprite( 800, 400, "assets/images/item-mirror-blue.png");
  girl.interact = function(){
    if(!player.hasItem(mirror)){
      girl.talk("How do I look?");
    } else {
      player.giveItem(mirror, girl);
      girl.talk("Thank you!");
      completeQuest(1);
      girl.talk("If you give the red blockhead guy a sword, he'll kill all the robots.");
    }
  }

  var messageFlag = Spawn.interactableSprite( 100, 50, "assets/images/object-flag-orange.png");
  messageFlag.interact = function(){
    Spawn.message('Finish 2 quests to win the game.');
  }

  var enemyBomb = Spawn.interactableSprite(300, 50, 'assets/images/creature-rock-cube-orange.png');
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
