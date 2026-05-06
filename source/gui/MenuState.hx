package gui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import leveldata.misc.SaveManager;
import main.ChapterState;
import main.PlayerData;
import openfl.ui.MouseCursor;

class MenuState extends FlxState
{
    var scanline:FlxBackdrop;
    var scanline2:FlxBackdrop;
    var flixelIcon:FlxSprite;
    var versionText:FlxText;
    var vignite:FlxSprite;
    var logo:FlxSprite;
    var effectLogo:FlxEffectSprite;
    var glitchEffect:FlxGlitchEffect;
    var player:FlxSprite;
    var globe:FlxSprite;
    var bg:FlxSprite;

    var isActiveNew:Bool = false;
    var isActiveCont:Bool = false;

    var btnNewGame:FlxButton;
    var btnContinue:FlxButton;
    var btnSpriteNew:FlxSprite;
    var btnSpriteCont:FlxSprite;
    var btnExit:FlxButton;

    var activeTweens:Map<FlxButton, FlxTween> = new Map();
    var activeLabelTweens:Map<FlxText, FlxTween> = new Map();

    var outlineColors:Array<FlxColor> =
    [
        FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE, FlxColor.YELLOW, FlxColor.CYAN
    ];

    override public function create():Void
    {
        FlxG.scaleMode = new RatioScaleMode();

        #if !mobile
        FlxG.mouse.visible = true;
        FlxG.mouse.useSystemCursor = true;
        #end

        bg = new FlxSprite();
        bg.makeGraphic(1280, 720, 0xFF1B76FF, false);
        bg.screenCenter();
        bg.alpha = 0.25;
        add(bg);

        player = new FlxSprite();
        player.loadGraphic(AssetPaths.thekid__png, true, 50, 50);
        player.animation.add("walking", [8, 9, 10, 11, 12, 13], 14, true);
        player.animation.play("walking");
        player.scale.set(1.2, 1.2);
        player.screenCenter();
        player.y = player.y + 122;
        player.x = player.x - 15;
        player.updateHitbox();
        insert(2, player);

        globe = new FlxSprite();
        globe.loadGraphic(AssetPaths.globe__png, false);
        globe.screenCenter();
        globe.y = globe.y + 650;
        globe.x = globe.x - 5;
        FlxTween.angle(globe, 0, -360, 18.0, { type: LOOPING } );
        insert(3, globe);

        scanline = new FlxBackdrop(AssetPaths.scanline__png, Y);
        scanline.velocity.set(0, 40);
        scanline.scrollFactor.set(0, 0);
        scanline.alpha = 0.1;
        insert(1, scanline);

        scanline2 = new FlxBackdrop(AssetPaths.scanline__png, Y);
        scanline2.velocity.set(0, 40);
        scanline2.scrollFactor.set(0, 0);
        scanline2.alpha = 0.05;
        scanline2.y = 10;
        insert(1, scanline2);

        flixelIcon = new FlxSprite();
        flixelIcon.loadGraphic(AssetPaths.haxeflixelLogo__png);
        flixelIcon.updateHitbox();

        effectLogo = new FlxEffectSprite(flixelIcon);
        glitchEffect = new FlxGlitchEffect(10, 2, 0.035);
        effectLogo.effects = [glitchEffect];
        effectLogo.screenCenter();
        effectLogo.y = effectLogo.y - 50;
        effectLogo.x = effectLogo.x - 240;
        effectLogo.scale.set(1.35, 1.35);
        insert(0, effectLogo);

        vignite = new FlxSprite();
        vignite.loadGraphic(AssetPaths.vigniteTitle__png, false);
        vignite.scrollFactor.set(0, 0);
        vignite.screenCenter();
        vignite.alpha = 0.65;
        add(vignite);

        logo = new FlxSprite(-50, 50);
        logo.loadGraphic(AssetPaths.logo__png, false);
        logo.scale.set(0.65, 0.65);
        FlxTween.tween(logo, {y: logo.y - 3}, 0.8, {type: PINGPONG, ease: FlxEase.sineInOut});
        add(logo);

        versionText = new FlxText(0, 0, FlxG.width, "v.0.15");
        versionText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        versionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        versionText.x = 350;
        versionText.y = 160;
        add(versionText);


        btnSpriteNew = new FlxSprite(200, 290);
        btnSpriteNew.loadGraphic(AssetPaths.miniClickV2__png, true, 213);
        btnSpriteNew.animation.add("idle", [0], false);
        btnSpriteNew.animation.add("hover", [1], false);
        btnSpriteNew.animation.play("idle");
        btnSpriteNew.scale.set(1.15, 1.15);
        btnSpriteNew.updateHitbox();
        // add(btnSpriteNew);

        btnSpriteCont = new FlxSprite(200, 390);
        btnSpriteCont.loadGraphic(AssetPaths.miniClickV2__png, true, 213);
        btnSpriteCont.animation.add("idle", [0], false);
        btnSpriteCont.animation.add("hover", [1], false);
        btnSpriteCont.animation.play("idle");
        btnSpriteCont.scale.set(1.15, 1.15);
        btnSpriteCont.updateHitbox();
        // add(btnSpriteCont);

        btnNewGame = new FlxButton(150, 300, "New Game", clickNewGame);
        customizeButton(btnNewGame);
        add(btnNewGame);

        #if mobile
            btnContinue = new FlxButton(150, 450, "Continue", clickContinue);
        #else
            btnContinue = new FlxButton(150, 400, "Continue", clickContinue);
        #end
        customizeButton(btnContinue);
        add(btnContinue);

        #if mobile
            btnExit = new FlxButton(1050, 640, "Quit Game", clickQuit);
        #else
            btnExit = new FlxButton(1020, 650, "Quit Game", clickQuit);
        #end
        customizeButton(btnExit);

        #if !html5
            add(btnExit);
        #end

        playMenuMusic();

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        #if !mobile
        if (FlxG.mouse.overlaps(btnSpriteNew))
        {
            btnSpriteNew.animation.play("hover");
        }

        else
        {
            btnSpriteNew.animation.play("idle");
        }

        if (FlxG.mouse.overlaps(btnSpriteCont))
        {
            btnSpriteCont.animation.play("hover");
        }

        else
        {
            btnSpriteCont.animation.play("idle");
        }

        if (FlxG.keys.justPressed.F11)
        {
            if (FlxG.fullscreen == false) FlxG.fullscreen = true;
            else FlxG.fullscreen = false;
        }
        #end

        if (FlxG.random.bool(10)) glitchEffect.strength = FlxG.random.int(5, 40);
        else glitchEffect.strength = 3;

        scanline.alpha = 0.1 - (Math.random() * 0.05);
        scanline2.alpha = 0.1 - (Math.random() * 0.1);
        effectLogo.alpha = 0.35 - (Math.random() * 0.25);
        player.alpha = 1 - Math.random() * 0.2;
        globe.alpha = 1 - Math.random() * 0.2;
    }

    function customizeButton(btn:FlxButton):Void
    {
        var w:Int = 250;
        var h:Int = 60;

        btn.loadGraphic(AssetPaths.buttonTitle__png, false, w, h);
        // btn.makeGraphic(w, h, FlxColor.fromRGB(255, 255, 255, 128));

        if (btn.label != null) 
        {
            #if mobile
                btn.label.setFormat(null, 36, FlxColor.WHITE, CENTER);
            #else
                btn.label.setFormat(null, 28, FlxColor.WHITE, CENTER);
            #end

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
            openfl.ui.Mouse.cursor = MouseCursor.BUTTON;

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
            openfl.ui.Mouse.cursor = MouseCursor.ARROW;

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

    function clickNewGame():Void
    {
        PlayerData.currentChapter = 1;
        PlayerData.currentRoom = "map" + "01";
        PlayerData.spawnX = 250;
        PlayerData.spawnY = 450 + 5;
        PlayerData.totalDeaths = 0;
        if (FlxG.sound.music != null) { FlxG.sound.music.stop(); }
        FlxG.switchState(ChapterState.new);
    }

    function clickContinue():Void
    {
        if (SaveManager.loadGame())
        {
            if (FlxG.sound.music != null) { FlxG.sound.music.stop(); }
            FlxG.switchState(ChapterState.new);
        }
            
        else
        {
            btnContinue.color = FlxColor.GRAY;
            FlxG.camera.shake(0.01, 0.05);
            FlxG.sound.play(AssetPaths.error__ogg, 1, false);
        }
    }

    function clickQuit():Void
    {
        #if sys
            Sys.exit(0);
        #else trace("Quit not supported.");
        #end
    }

    function playMenuMusic():Void
    {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing)
        {
            FlxG.sound.playMusic(AssetPaths.mainMenu__ogg, 0.7, true);
        }
            
    }
}