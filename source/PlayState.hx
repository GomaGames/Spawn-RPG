package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import sprites.Map;
import sprites.Player;
import sprites.Enemy;
import sprites.DialogueBox;
import sprites.Object;
import sprites.pickups.Pickup;
import sprites.InteractableSprite;
import flixel.math.FlxRect;

class PlayState extends FlxState
{
  private var map:Map;
  private var player_1:Player;
  private var spawn_engine:Spawn;
  private var pickups:List<Pickup>;
  private var enemies:List<Enemy>;
  private var object:List<Object>;
  public var survival_type:Bool; // true? only one life
  private var p1score:FlxText;
  public var interacted:InteractableSprite;
  public var paused:Bool;
  private var interactableSprites:List<InteractableSprite>;

	override public function create():Void
	{
    pickups = new List<Pickup>();
    enemies = new List<Enemy>();
    interactableSprites = new List<InteractableSprite>();
    survival_type = true;
    interacted = null;
    paused = false;
		super.create();
    map = new Map(this);
    map.makeGraphic( 20000, 20000, Main.BACKGROUND_GREY );
    Map.drawGridLines( this, map );
    Map.drawTopBar( this, map );

    bgColor = Main.BACKGROUND_GREY;
    add(map);
    add(flixel.util.FlxCollision.createCameraWall(FlxG.camera, true, 1));

    p1score = new FlxText( Main.STAGE_WIDTH - 2 * ( Main.STAGE_WIDTH / Map.GRID_LINES_X ) , 10, '0');
    p1score.setFormat( "Arial", 18, Main.FONT_BLUE, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    add(p1score);

#if neko
    Spawn.dev();
#end
    spawnAll();

    FlxG.camera.follow(player_1, TOPDOWN, 1);
    // FlxG.camera.setScrollBoundsRect(0, 0, 200, 200);
    // FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height); Cannot access field or identifier worldBounds for writing??
	}

  private inline function spawnAll():Void
  {
    // walls
    for( wall in Spawn.walls ){
      var wall = new FlxSprite(wall.x, wall.y, wall.skin);
      wall.immovable = true;
      wall.scale.set(.5,.5);
      wall.updateHitbox();
      add( wall );
    }

    // pickups
    for( pickup in Spawn.pickups ){
      var new_pickup:Pickup = switch(pickup.type){

        case GEM:
          survival_type = false;
          new sprites.pickups.Gem(pickup.x, pickup.y, pickup.skin, pickup.points);

        case FREEZE:
          new sprites.pickups.Freeze(pickup.x, pickup.y, pickup.skin, pickup.duration);

        case SLOW:
          new sprites.pickups.Slow(pickup.x, pickup.y, pickup.skin, pickup.duration);

        case SPEED:
          new sprites.pickups.Speed(pickup.x, pickup.y, pickup.skin, pickup.duration);

      }

      pickups.add(new_pickup);
      add(new_pickup);
    }

    // enemies
    for( enemy in Spawn.enemies ){
      var new_enemy = new Enemy(this, enemy.x, enemy.y, enemy.speed, enemy.skin, enemy.direction);
      enemies.add(new_enemy);
      add(new_enemy);
    }

    // interactable sprites
    for( sprite in Spawn.interactableSprites ) {
      var new_sprite = new InteractableSprite(sprite.x, sprite.y, sprite.graphic);
      interactableSprites.add(new_sprite);
      add(new_sprite);
    }

    // object
    for( object in Spawn.objects ){
      // var new_enemy = new Enemy(this, enemy.x, enemy.y, enemy.speed, enemy.skin, enemy.direction);
      Spawn.objects.add(object);
      add(object);
    }

    // heros
    if( Spawn.hero_1_setting != null ){
      player_1 = new Player(this,1,Spawn.hero_1_setting.x,Spawn.hero_1_setting.y);
      add(player_1);
    }

  }

  private inline function pickup_collision():Void
  {
    for( pickup in pickups ){
      for( hero in [player_1] ){
        if( FlxG.collide(hero, pickup) ){
          remove(pickup);
          pickups.remove(pickup);
          switch(Type.getClass(pickup)){
            case sprites.pickups.Speed:
              hero.speed_boost(pickup.DURATION);
            case sprites.pickups.Slow:
              hero.slow_down(pickup.DURATION);
            case sprites.pickups.Freeze:
              hero.freeze(pickup.DURATION);
            case sprites.pickups.Gem:
              hero.score(pickup.POINTS);
              victory_check();
          }
        }
      }

    }
  }

  private inline function touch_enemy():Void
  {
    for( enemy in enemies ){
      for( hero in [player_1] ){
        if( FlxG.collide(hero, enemy) ){
          hero.die();
          survival_check();
        }
      }
    }
  }

  private inline function interact_collision():Void //for interacting
  {
    for(sprite in interactableSprites) {
      if( FlxG.collide(player_1, sprite) ){
        interacted = sprite;
      }
    }
  }

  private inline function survival_check():Void
  {
    if( Lambda.filter([player_1], function(p){
      return p.alive;
    }).length == 0 ){
      FlxG.switchState(new EndState(player_1, EndState.EndType.NO_SURVIVORS));
    }
  }

  private inline function victory_check():Void
  {
    if( Lambda.filter(pickups, function(p){
      return Type.getClass(p) == sprites.pickups.Gem;
    }).length == 0 ){
      FlxG.switchState(new EndState(player_1, EndState.EndType.FINISH));
    }
  }

  override public function destroy():Void
	{
    map = null;
    player_1 = null;
    spawn_engine = null;
    pickups = null;
    enemies = null;
    survival_type = null;
    p1score = null;
    interacted = null;
    super.destroy();
	}

  override public function update(elapsed:Float):Void
  {
    if( player_1 != null ){
      p1score.text = Std.string(player_1.points);
    }
    super.update(elapsed);

    pickup_collision();

    interact_collision();

    touch_enemy();

    FlxG.collide();
  }
}
