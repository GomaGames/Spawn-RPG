package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class RangedWeapon extends Weapon{
  public var projectile:FlxSprite;
  private var range:Float;
  private var ammo:Int;
  public static inline var DEFAULT_SKIN = "assets/images/item-staff.png";
  public static inline var DEFAULT_SKIN_PROJECTILE = "assets/images/item-fireball-red.png";

  public function new( state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN, ?range:Float = 3, ?ranged_skin:String = DEFAULT_SKIN_PROJECTILE, ?ammo:Int = 20 ){
    super(state, x, y, skin);
    this.range = range;
    this.ammo = ammo;

    var _projectile:FlxSprite = new FlxSprite();
    _projectile.loadGraphic( ranged_skin );
    _projectile.scale.set(0.5,0.5);
    _projectile.centerOffsets();
    _projectile.centerOrigin();
    _projectile.updateHitbox();
    _projectile.solid = false;
    _projectile.alpha = 0;
    this.projectile = _projectile;
  }

  public inline function update_projectile():Void
  { 
    var projectile:FlxSprite = this.projectile;
    this.state.add( projectile );
    var ranged_attack:FlxTween = FlxTween.tween(projectile, {}, 2);
    var p:Player = state.player;

    if( p.attacking ){
      var x_inc:Float = 0;
      var y_inc:Float = 0;
      var time:FlxTimer = new FlxTimer();
      projectile.solid = true;
      time.start(1.5,function(timer){
        projectile.solid = false;
      },1);
      switch( p.current_direction ){
        case UP:
          // this.flipX = false;
          // this.flipY = false;
          // this.x = p.x + 5;
          // this.y = p.y - 40;
          y_inc = -this.range * 40;
          projectile.x = p.x - 20;
          projectile.y = p.y - 40;
          projectile.flipX = true;
          projectile.flipY = false;
          projectile.angle = 90;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 1, { ease: FlxEase.backOut });
        case DOWN:
          // this.flipX = true;
          // this.flipY = true;
          // this.x = p.x - 15;
          // this.y = p.y + 10;
          y_inc = this.range * 40;
          projectile.x = p.x - 5;
          projectile.y = p.y + 80;
          projectile.flipX = false;
          projectile.flipY = true;
          projectile.angle = 90;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 1, { ease: FlxEase.backOut });
        case LEFT:
          // this.flipX = true;
          // this.flipY = true;
          // this.x = p.x - 40;
          // this.y = p.y + 5;
          x_inc = -this.range * 40;
          projectile.x = p.x - 80;
          projectile.y = p.y - 35;
          projectile.flipX = true;
          projectile.flipY = true;
          projectile.angle = 0;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 1, { ease: FlxEase.backOut });
        case RIGHT:
          // this.flipX = false;
          // this.flipY = true;
          // this.x = p.x + 10;
          // this.y = p.y + 10;
          x_inc = this.range * 40;
          projectile.x = p.x + 60;
          projectile.y = p.y + 10;
          projectile.flipX = false;
          projectile.flipY = true;
          projectile.angle = 0;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 1, { ease: FlxEase.backOut });
        default: null;
      }
      projectile.reset( projectile.x, projectile.y );
      projectile.alpha = 1.0;
    } else {
      ranged_attack.start();
      
      this.updateHitbox();
    }
  }

  override public function update(elapsed:Float):Void
  {
    // projectile.alpha -= 0.01;
    if(state.player.hasEquipped(this)){
      update_projectile();
    }
    super.update(elapsed);
  }
}

