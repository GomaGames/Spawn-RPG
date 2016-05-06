package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import sprites.Map;
import sprites.Player;

class PlayState extends FlxState
{
  private var map:Map;
  private var player_1:Player;
  private var player_2:Player;
  private var spawn_engine:Spawn;


	override public function create():Void
	{

		super.create();
    map = new Map(this);
    add(map);

    player_1 = new Player(this,1,10,10);
    add(player_1);

    player_2 = new Player(this,2,100,100);
    add(player_2);

    // Spawn.state = this;
    spawnAll();
	}

  public inline function spawnAll():Void
  {
    // walls
    for( wall in Spawn.walls ){
      // trace(wall);
      // add(wall);
      add( new FlxSprite(wall.x, wall.y, wall.graphic) );
    }

    // pickups

    // enemies

    // heros

  }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
