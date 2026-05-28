package main.chapterconfig;

import flixel.FlxG;

class Chapter1Config extends ChapterConfig
{
    public function new()
    {
        trace("Initializing Chapter 1 configuration...");
        super(1, "castle1.ogg");
    }

    override function cacheAssets():Void
    {
        trace("Caching Chapter 1 assets...");
        FlxG.bitmap.add(AssetPaths.ch1tiles__png);
    }
}