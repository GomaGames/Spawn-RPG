package;

import flixel.FlxSprite;
import sprites.Object;

enum PickupType{
  GEM;
  FREEZE;
  SLOW;
  SPEED;
}

typedef Placeable = {
  x : Int,
  y : Int,
  skin : String
}

typedef Wall = Placeable;

typedef PlacePickup = { > Placeable,
  type : PickupType,
  ?points : Int,
  ?duration : Int
}

typedef HeroSetting = {
  x : Int,
  y : Int
}

typedef Enemy = {
  x : Int,
  y : Int,
  direction : String,
  skin : String,
  speed : Int
}

typedef InteractableSprite = {
  x : Int,
  y : Int,
  graphic: String
}

typedef CollectableSprite = {
  x : Int,
  y : Int,
  graphic: String
}

@:expose class Spawn {

  public static inline var DEFAULT_WALL_SKIN = "assets/images/17.png";
  private static inline var TOPBAR_Y_OFFSET = 40; // pixels from top

  public static var hero_1_setting:HeroSetting;
  public static var hero_2_setting:HeroSetting;
  public static var state:PlayState;
  public static var pickups = new List<PlacePickup>();
  public static var walls = new List<Wall>();
  public static var enemies = new List<Enemy>();
  public static var interactableSprites = new List<InteractableSprite>();
  public static var objects = new List<Object>();
  public static var collectables = new List<CollectableSprite>();

  public static inline function hero_1(x:Int, y:Int):Void
  {
    hero_1_setting = { x : x, y : y + TOPBAR_Y_OFFSET };
  }

  public static inline function hero_2(x:Int, y:Int):Void
  {
    hero_2_setting = { x : x, y : y + TOPBAR_Y_OFFSET };
  }

  public static inline function wall(x:Int, y:Int, ?skin:String):Void
  {
    walls.add({
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.wall.default_skin,
    });
  }

  public static inline function freeze(x:Int, y:Int, ?duration:Int, ?skin:String):Void
  {
    pickups.add({
      type: FREEZE,
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.freeze.default_skin,
      duration : duration != null ? duration : Settings.freeze.default_duration
    });
  }

  public static inline function speed(x:Int, y:Int, ?duration:Int, ?skin:String):Void
  {
    pickups.add({
      type: SPEED,
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.speed.default_skin,
      duration : duration != null ? duration : Settings.speed.default_duration
    });
  }


  public static inline function slow(x:Int, y:Int, ?duration:Int, ?skin:String):Void
  {
    pickups.add({
      type: SLOW,
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.slow.default_skin,
      duration : duration != null ? duration : Settings.slow.default_duration
    });
  }

  public static inline function gem(x:Int, y:Int, ?points:Int, ?skin:String):Void
  {
    pickups.add({
      type: GEM,
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.gem.default_skin,
      points : points != null ? points : Settings.gem.default_points
    });
  }

  public static inline function enemy(x:Int, y:Int, ?direction:String, ?speed:Int, ?skin:String):Void
  {
    enemies.add({
      direction: direction,
      x : x,
      y : y + TOPBAR_Y_OFFSET,
      skin : skin != null ? skin : Settings.enemy.default_skin,
      speed : speed != null ? speed : Settings.enemy.default_speed
    });
  }

  public static inline function interactableSprite(x:Int, y:Int, graphic:String):Void
  {
    interactableSprites.add({
      x : x,
      y : y,
      graphic: graphic
    });
  }

  public static inline function collectableSprite(x:Int, y:Int, graphic:String):Void
  {
    collectables.add({
      x : x,
      y : y,
      graphic: graphic
    });
  }

  public static inline function object(x:Int, y:Int, ?skin:String):Object
  {
    var newObj = new Object(x, y, skin);

    objects.add(newObj);

    return newObj;
  }

#if neko
  private static var diddev:Bool = false;
  public static inline function dev():Void
  {
    if( !diddev ){
      hero_1( 0, 50 );
      // hero_2( 400, 50 );
      // wall( 120, 240 );
      // wall( 160, 200 );
      // freeze( 200, 200 );
      // speed( 160, 100 );
      // slow( 160, 300 );
      // gem( 200, 100 );
      // gem( 200, 400 );
      // enemy( 650, 500 , "down");
      // wall( 650, 600 );
      // wall( 240, 0 );
      // enemy( 500, 550 , "right");
      // enemy( 600, 500 , "up");
      // enemy( 500, 450 , "left");
      // enemy( 400, 450 );

      var quest_1_complete = false;
      var quest_2_complete = false;
      // new in RPG version
      var myObj = object(300, 50, 'assets/images/17.png');
      myObj.y = 300;
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
