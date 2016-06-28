package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class RangedWeapon extends Weapon{
  private var range:Float;
  private var ranged_skin:String;
  private var cooldown:Float;
  public static inline var DEFAULT_SKIN = "assets/images/item-staff.png";
  public static inline var DEFAULT_SKIN_PROJECTILE = "assets/images/item-fireball-red.png";

  public function new( state:PlayState, x:Int, y:Int, ?skin:String = DEFAULT_SKIN, ?ranged_skin:String = DEFAULT_SKIN_PROJECTILE, ?power:Int = 2, ?range:Float = 3, ?cooldown:Float = 1 ){
    super(state, x, y, skin, power);
    this.range = range;
    this.ranged_skin = ranged_skin;
    this.cooldown = cooldown; // seconds
  }

  public inline function update_projectile():Void
  { 
    var p:Player = state.player;
    var ranged_attack:FlxTween = FlxTween.tween({}, {}, 0);
    if( p.attacking == true && this.on_cooldown == false ){

      this.on_cooldown = true;
      var projectile:Projectile = new Projectile( this.state, this.x, this.y, this.ranged_skin );
      this.state.projectiles.add( projectile );
      this.state.add( projectile );
      var x_inc:Float = 0;
      var y_inc:Float = 0;
      switch( p.current_direction ){
        case UP:
          y_inc = -this.range * 40;
          projectile.x = p.x - 20;
          projectile.y = p.y - 50;
          projectile.flipX = true;
          projectile.flipY = false;
          projectile.angle = 90;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 2, { ease: FlxEase.backOut });
        case DOWN:
          y_inc = this.range * 40;
          projectile.x = p.x - 5;
          projectile.y = p.y + 80;
          projectile.flipX = false;
          projectile.flipY = true;
          projectile.angle = 90;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 2, { ease: FlxEase.backOut });
        case LEFT:
          x_inc = -this.range * 40;
          projectile.x = p.x - 80;
          projectile.y = p.y - 25;
          projectile.flipX = true;
          projectile.flipY = true;
          projectile.angle = 0;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 2, { ease: FlxEase.backOut });
        case RIGHT:
          x_inc = this.range * 40;
          projectile.x = p.x + 60;
          projectile.y = p.y - 10;
          projectile.flipX = false;
          projectile.flipY = true;
          projectile.angle = 0;
          ranged_attack = FlxTween.tween(projectile, { x: Math.ffloor(projectile.x + x_inc), y: Math.ffloor(projectile.y + y_inc) }, 2, { ease: FlxEase.backOut });
        default: null;
      }
      projectile.reset( projectile.x, projectile.y );
    }
    
     if ( this.on_cooldown == true ){
      var cd_timer:FlxTimer = new FlxTimer();
      cd_timer.start(this.cooldown,function(timer){
        ranged_attack.start();
        this.on_cooldown = false;
      },1);
    }
  }

  override public function update(elapsed:Float):Void
  {
    super.update(elapsed);
    if(state.player.hasEquipped(this) == true && state.player.weapon.on_cooldown == false){
      update_projectile();
    }
    FlxG.collide();
  }
}

