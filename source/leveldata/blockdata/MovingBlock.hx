package leveldata.blockdata;

import flixel.FlxSprite;
using flixel.util.FlxDirectionFlags;
using flixel.FlxG;

class MovingBlock extends FlxSprite
{
    var moveDir:String;
    var speed:Float = 200;
    var activeMoving:Bool = false;

    public function new(X:Float, Y:Float, MoveDir:String, TileID:Int)
    {
        super(X, Y);
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = TileID;
        
        this.moveDir = MoveDir;
        immovable = true;
    }

    public function stopMovement():Void
    {
        activeMoving = false;
        velocity.set(0, 0);
    }

    override public function update(elapsed:Float):Void
    {
        if (!activeMoving && touching.has(FlxDirectionFlags.UP))
        {
            FlxG.sound.play(AssetPaths.platform_activated__ogg, 0.5, false);
            activeMoving = true;
        }

        if (activeMoving)
        {
            switch (moveDir)
            {
                case "up":    velocity.y = -180; 
                case "down":  velocity.y = 180;
                case "left":  velocity.x = -180;
                case "right": velocity.x = 180;
            }
        }


        super.update(elapsed);

        if ((velocity.y < 0 && touching.has(UP)) || 
            (velocity.y > 0 && touching.has(DOWN)) || 
            (velocity.x < 0 && touching.has(LEFT)) || 
            (velocity.x > 0 && touching.has(RIGHT)))
        {
            stopMovement();
        }

        if (x < -500 || x > FlxG.worldBounds.width + 100 || y < -100 || y > FlxG.worldBounds.height + 100) { kill(); }

    
        touching = FlxDirectionFlags.NONE;
    }
}