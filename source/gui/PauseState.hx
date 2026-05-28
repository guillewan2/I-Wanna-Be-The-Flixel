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
    var btnTitle:FlxButton;
    var activeTweens:Map<FlxButton, FlxTween> = new Map();
    var activeLabelTweens:Map<FlxText, FlxTween> = new Map();



    override public function create()
    {
        super.create();
        openfl.ui.Mouse.show();

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

        btnTitle = new FlxButton(0, 0, "Return to Menu", clickMainMenu);
        btnTitle.screenCenter();
        btnTitle.y += 200;
        customizeButton(btnTitle);
        add(btnTitle);
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
            openfl.ui.Mouse.hide();
            close();

        }

    }

    function clickMainMenu():Void
    {
        remove(assetsGroup, true);
        FlxG.switchState(MenuState.new);
        close();

    }

    function customizeButton(btn:FlxButton):Void
    {
        var w:Int = 400;
        var h:Int = 60;

        btn.loadGraphic(AssetPaths.buttonTitle__png, false, w, h);
        // btn.makeGraphic(w, h, FlxColor.fromRGB(255, 255, 255, 128));

        if (btn.label != null) 
        {
            btn.label.setFormat(null, 28, FlxColor.WHITE, CENTER);

            btn.label.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);

            btn.label.fieldWidth = w;
            btn.label.alignment = CENTER;

            for (offset in btn.labelOffsets)
            {
                offset.y += 10;
            }

            btn.label.centerOrigin();
            btn.label.centerOffsets();

            
        }

        btn.onOver.callback = function()
        {
            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.BUTTON;

            FlxTween.tween(btn.label.scale, {x: 1.1, y: 1.1}, 0.05, {ease: FlxEase.quadOut});
            FlxTween.tween(btn.scale, {x: 1.1, y: 1.1}, 0.05, {ease: FlxEase.quadOut});

            var btnTwn = FlxTween.angle(btn, -5, 5, 0.6, {type: PINGPONG, ease: FlxEase.sineInOut});
            var txtTwn = FlxTween.angle(btn.label, -5, 5, 0.6, {type: PINGPONG, ease: FlxEase.sineInOut});

            activeTweens.set(btn, btnTwn);
            activeLabelTweens.set(btn.label, txtTwn);
            FlxG.sound.play(AssetPaths.trigger__ogg, 0.1, false);
        };

        btn.onOut.callback = function()
        {
            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;

            FlxTween.tween(btn.label.scale, {x: 1.0, y: 1.0}, 0.05, {ease: FlxEase.quadIn});
            FlxTween.tween(btn.scale, {x: 1.0, y: 1.0}, 0.05, {ease: FlxEase.quadIn});

            if (activeTweens.exists(btn))
            {
                activeTweens.get(btn).cancel();
                activeTweens.remove(btn);
            }

            if (activeLabelTweens.exists(btn.label))
            {
                activeLabelTweens.get(btn.label).cancel();
                activeLabelTweens.remove(btn.label);
            }

            FlxTween.tween(btn, {angle: 0}, 0.1, {ease: FlxEase.quadOut});
            FlxTween.tween(btn.label, {angle: 0}, 0.1, {ease: FlxEase.quadOut});
            
        };
    }

    

}