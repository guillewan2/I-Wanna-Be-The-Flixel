package leveldata.hazards;

import flixel.FlxSprite;

class SmallSpike extends FlxSprite
{
    public function new(X:Float, Y:Float, LocalID:Int)
    {
        super(X, Y);

        loadGraphic(AssetPaths.small_spikes__png, true, 25, 25);
        this.animation.frameIndex = LocalID;

        // Pixel-perfect collision handles the shape
        width = 25;
        height = 25;
        offset.set(0, 0);

        immovable = true;
    }
}