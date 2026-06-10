package leveldata.hazards;

import flixel.FlxSprite;

class NormalSpike extends FlxSprite
{
    public function new(X:Float, Y:Float, LocalID:Int)
    {
        super(X, Y);

        loadGraphic(AssetPaths.spikes__png, true, 50, 50);
        this.animation.frameIndex = LocalID;

        width = 50; 
        height = 50;
        offset.set(0, 0);
        immovable = true;
    }

        
}
