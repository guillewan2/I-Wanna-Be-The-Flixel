package main;

class ChapterConfig 
{
    public var chapterId:Int;
    public var defaultMusic:String;

    public function new(id:Int, music:String)
    {
        this.chapterId = id;
        this.defaultMusic = music;
    }

    public function cacheAssets():Void {}

    public function customUpdate(elapsed:Float, state:main.ChapterState):Void {}
}