package coop;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ServerCoopSubState extends FlxSubState 
{
    override public function create() 
    {
        super.create();
        
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
        add(bg);
        
        var txt = new FlxText(0, FlxG.height / 2, FlxG.width, "Server Co-op Screen Placeholder\nPress ESC to Go Back");
        txt.setFormat(null, 32, FlxColor.CYAN, CENTER, OUTLINE, FlxColor.BLACK);
        add(txt);
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.ESCAPE) 
        {
            close();
        }
    }
}