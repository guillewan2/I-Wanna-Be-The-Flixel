package leveldata.hazards;

import flixel.FlxSprite;

class SolidBlock extends FlxSprite
{
    public function new(x:Float, y:Float, TileID:Int)
    {
        super(x, y);
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = TileID;
        immovable = true;
    }
}