package;

import sprites.Player;
import sprites.Enemy;
import sprites.pickups.*;

@:expose class Settings {

  public static var time_limit = 40; // seconds

  public static var enemy = {
    default_skin : Enemy.DEFAULT_SKIN,
    default_speed : Enemy.DEFAULT_SPEED
  }

  public static var coin = {
    default_skin : Coin.DEFAULT_SKIN,
    default_points : Coin.DEFAULT_POINTS
  }

  public static var freeze = {
    default_skin : Freeze.DEFAULT_SKIN,
    default_duration : Freeze.DEFAULT_DURATION
  }

  public static var speed = {
    default_skin : Speed.DEFAULT_SKIN,
    default_duration : Speed.DEFAULT_DURATION
  }

  public static var slow = {
    default_skin : Slow.DEFAULT_SKIN,
    default_duration : Slow.DEFAULT_DURATION
  }

  public static var world_size = {
    width: 2000,
    height: 2000
  }

}
