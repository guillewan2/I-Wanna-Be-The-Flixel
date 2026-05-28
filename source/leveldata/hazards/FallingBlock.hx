package leveldata.hazards;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
using flixel.util.FlxDirectionFlags;
using flixel.FlxG;

class FallingBlock extends FlxSprite
{
    var moveDir:String;
    var speed:Float = 600;
    var activeMoving:Bool = false;

    public function new(X:Float, Y:Float, MoveDir:String, TileID:Int)
    {
        super(X, Y);
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = TileID;
        FlxTween.tween(this, {x: x + 1}, 0.25, {type: PINGPONG, ease: FlxEase.sineInOut});
        
        this.moveDir = MoveDir;
        immovable = true;
    }

    override public function update(elapsed:Float):Void
    {
        if (!activeMoving && touching.has(FlxDirectionFlags.UP))
        {
            FlxG.sound.play(AssetPaths.break_block__ogg, 0.5, false);
            activeMoving = true;
        }

        if (activeMoving)
        {

            switch (moveDir)
            {
                case "up":    velocity.y = -700; 
                case "down":  velocity.y = 700;
                case "left":  velocity.x = -700;
                case "right": velocity.x = 700;
            }
        }

        super.update(elapsed);

        if (x < -500 || x > FlxG.worldBounds.width + 100 || y < -100 || y > FlxG.worldBounds.height + 100) { kill(); }
        
        touching = FlxDirectionFlags.NONE;

    }
}