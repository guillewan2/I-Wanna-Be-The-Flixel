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
        animation.frameIndex = LocalID;

        // Reset Hitbox to full size for Pixel Perfect detection
        width = 50;
        height = 50;
        offset.set(0, 0);

        homeX = x;
        homeY = y;
        shiftedX = homeX;
        shiftedY = homeY;

        switch (LocalID)
        {
            case 0, 4: shiftedY += 50; // Down
            case 1, 5: shiftedX -= 50; // Left
            case 2, 6: shiftedY -= 50; // Up
            case 3, 7: shiftedX += 50; // Right
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

        if (activeTween != null) activeTween.cancel();

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
                spike.toggle(spikesCurrentlyShifted);
        }
    }

    public static function clear():Void
    {
        allSpikes = [];
        spikesCurrentlyShifted = false;
    }

    override public function destroy():Void
    {
        if (activeTween != null) activeTween.cancel();
        allSpikes.remove(this);
        super.destroy();
    }
}