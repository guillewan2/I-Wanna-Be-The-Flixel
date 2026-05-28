package leveldata.hazards;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class SwitchSpike extends FlxSprite
{
    public static var allSpikes:Array<SwitchSpike> = [];
    public static var spikesCurrentlyShifted:Bool = false;

    public var homeX:Float;
    public var homeY:Float;
    public var shiftedX:Float;
    public var shiftedY:Float;
    public var invertToggle:Bool = false;

    var activeTween:FlxTween;

    public function new(X:Float, Y:Float, LocalID:Int, status:String = "disabled")
    {
        super(X, Y);
        loadGraphic(AssetPaths.spikes__png, true, 50, 50);
        frame = frames.frames[LocalID];

        setupHitbox(LocalID);

        homeX = x;
        homeY = y;

        shiftedX = homeX;
        shiftedY = homeY;

        switch (LocalID)
        {
            case 0, 4: shiftedY += 50; 
            case 1, 5: shiftedX -= 50; 
            case 2, 6: shiftedY -= 50; 
            case 3, 7: shiftedX += 50; 
        }

        immovable = true;

        if (status == "active")
        {
            invertToggle = true; 
            x = shiftedX;
            y = shiftedY;
        }

        if (allSpikes.indexOf(this) == -1)
        {
            allSpikes.push(this);
        }
    }

    public function toggle(globalShifted:Bool):Void
    {
        var shouldBeRetracted = invertToggle ? !globalShifted : globalShifted;

        var startX = shouldBeRetracted ? homeX : shiftedX;
        var startY = shouldBeRetracted ? homeY : shiftedY;
        var destX = shouldBeRetracted ? shiftedX : homeX;
        var destY = shouldBeRetracted ? shiftedY : homeY;

        if (activeTween != null)
        {
            activeTween.cancel();
        }

        activeTween = FlxTween.num(0.0, 1.0, 0.15, {ease: FlxEase.linear}, function(v:Float)
        {
            x = startX + (destX - startX) * v;
            y = startY + (destY - startY) * v;
        });
    }

    public static function toggleAll():Void
    {
        spikesCurrentlyShifted = !spikesCurrentlyShifted;
        
        for (spike in allSpikes)
        {
            if (spike != null && spike.exists && spike.alive)
            {
                spike.toggle(spikesCurrentlyShifted);
            }
        }
    }

    public static function clear():Void
    {
        allSpikes = [];
        spikesCurrentlyShifted = false;
    }

    override public function destroy():Void
    {
        if (activeTween != null)
        {
            activeTween.cancel();
        }
        allSpikes.remove(this);
        super.destroy();
    }

    function setupHitbox(LocalID:Int):Void
    {
        switch (LocalID)
        {
            case 0: width = 45; height = 25; offset.set(2, 25); 
            case 1: width = 35; height = 35; offset.set(0, 8);
            case 2: width = 40; height = 40; offset.set(6, 0);
            case 3: width = 35; height = 35; offset.set(12, 10);
            case 4: width = 30; height = 15; offset.set(10, 32);
            case 5: width = 15; height = 30; offset.set(0, 10);
            case 6: width = 30; height = 15; offset.set(10, 0);
            case 7: width = 15; height = 30; offset.set(33, 10);
        }
        x += offset.x;
        y += offset.y;
    }
}