package gui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import main.ChapterState;

class PauseState extends FlxSubState
{
    var bg:FlxSprite;
    var assetsGroup:FlxGroup;
    var pauseText:FlxText;
	var bgFadeTimer:Float = 0.005;

    override public function create()
    {
        super.create();

        assetsGroup = new FlxGroup();

        bg = new FlxSprite();
        bg.makeGraphic(1300,800, FlxColor.BLACK, false);
        bg.screenCenter();
        bg.alpha = 0;
        assetsGroup.add(bg);

        pauseText = new FlxText("Game Paused");
		pauseText.size = 80;
		pauseText.color = FlxColor.WHITE;
		pauseText.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		pauseText.screenCenter();
		pauseText.y -= 240;
        pauseText.scrollFactor.set(0, 0);
        FlxTween.angle(pauseText, -10, 10, 1, {type: PINGPONG, ease: FlxEase.sineInOut});
		assetsGroup.add(pauseText);

        add(assetsGroup);

        // btnTitle = new FlxButton(400, 500, "Return to Menu", clickNewGame);
        // customizeButton(btnTitle);
        // add(btnTitle);
    }

	override public function update(elapsed:Float)
	{

        super.update(elapsed);

        if (bg.alpha < 0.50)
        {
            bg.alpha += bgFadeTimer;
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            remove(assetsGroup, true);
            close();
        }

    }

}