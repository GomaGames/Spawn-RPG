package;

import flixel.FlxSprite;

enum PickupType{
  GEM;
  FREEZE;
  SLOW;
  SPEED;
}

typedef Placeable = {
  x : Int,
  y : Int,
  graphic : String
}

typedef Wall = Placeable;

typedef Pickup = { > Placeable,
  type : PickupType
}

@:expose class Spawn {

  private static inline var WALL_GRAPHIC = "assets/images/game_wall.png";
  private static inline var FREEZE_GRAPHIC = "assets/images/graphic-49.png";

  public static var state:PlayState;
  public static var pickups = new List<Pickup>();
  public static var walls = new List<Wall>();

  public static inline function wall(x:Int, y:Int):Void
  {
    walls.add( { x : x, y : y, graphic : WALL_GRAPHIC } );
  }

  public static inline function freeze(x:Int, y:Int):Void
  {
    pickups.add( { type: FREEZE, x : x, y : y, graphic : FREEZE_GRAPHIC } );
  }

  public static inline function gem(x:Int, y:Int):Void
  {
    trace('spawning gem at $x $y');

  }

#if neko
  public static inline function dev():Void
  {
    wall( 120, 240 );
    wall( 160, 200 );
    freeze( 200, 200 );
  }
#end

}
