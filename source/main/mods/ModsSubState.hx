package main.mods;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import openfl.display.BitmapData;
import haxe.io.Path;

#if sys
import sys.FileSystem;
#end

class ModsSubState extends FlxSubState
{
    var assetsGroup:FlxGroup;
    var bgOption:FlxSprite;
    var title:FlxText;
    var closeBoton:FlxSprite;
    var previewSprite:FlxSprite;
    
    var modsList:Array<String> = [];
    var modTexts:Array<FlxText> = [];
    var currentHoveredIndex:Int = -1;

    override public function create()
    {
        openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;

        super.create();
        assetsGroup = new FlxGroup();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        assetsGroup.add(bg);

        bgOption = new FlxSprite();
        bgOption.loadGraphic(AssetPaths.OptionBG__png);
        bgOption.alpha = 0.85;
        bgOption.screenCenter();
        assetsGroup.add(bgOption);

        title = new FlxText(0, 80, FlxG.width, "Loaded Mods");
        title.setFormat(null, 64, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        assetsGroup.add(title);

        closeBoton = new FlxSprite();
        closeBoton.loadGraphic(AssetPaths.menuClose__png, true, 63, 63);
        closeBoton.animation.add("normal", [0], 1, false);
        closeBoton.animation.add("active", [1], 1, false);
        closeBoton.screenCenter();
        closeBoton.y -= 265;
        closeBoton.x += 520;
        assetsGroup.add(closeBoton);

        previewSprite = new FlxSprite();
        previewSprite.makeGraphic(350, 350, FlxColor.TRANSPARENT);
        assetsGroup.add(previewSprite);

        #if sys
        var modsPath = Path.normalize(Sys.getCwd() + "../../../mods");
        if (FileSystem.exists(modsPath))
        {
            for (mod in FileSystem.readDirectory(modsPath))
            {
                if (mod.charAt(0) == ".") continue;
                var root = modsPath + "/" + mod + "/assets";
                if (FileSystem.exists(root))
                {
                    modsList.push(mod);
                }
            }
        }
        #end

        var startX = bgOption.x + 80;
        var startY = bgOption.y + 160;
        var spacingY = 42;

        for (i in 0...modsList.length)
        {
            var txt = new FlxText(startX, startY + (i * spacingY), 450, modsList[i]);
            txt.setFormat(null, 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            assetsGroup.add(txt);
            modTexts.push(txt);
        }

        add(assetsGroup);

        updatePreviewImage("");
    }

    function updatePreviewImage(modName:String):Void
    {
        var loaded = false;

        #if sys
        if (modName != "")
        {
            var modsPath = Path.normalize(Sys.getCwd() + "../../../mods");
            var iconPath = modsPath + "/" + modName + "/mod-icon.png";
            
            if (FileSystem.exists(iconPath))
            {
                var bmp = BitmapData.fromFile(iconPath);
                if (bmp != null)
                {
                    previewSprite.loadGraphic(bmp);
                    loaded = true;
                }
            }
        }
        #end

        if (!loaded)
        {
            var fallbackPath = "C:\\HaxeFlixel\\IWBTF\\assets\\images\\title\\thumbnails\\thumbnail_default.png";
            #if sys
            if (FileSystem.exists(fallbackPath))
            {
                var bmp = BitmapData.fromFile(fallbackPath);
                if (bmp != null)
                {
                    previewSprite.loadGraphic(bmp);
                    loaded = true;
                }
            }
            #end
        }

        if (!loaded)
        {
            previewSprite.makeGraphic(350, 350, FlxColor.GRAY);
        }

        previewSprite.setGraphicSize(350, 350);
        previewSprite.updateHitbox();
        previewSprite.x = bgOption.x + bgOption.width - 430;
        previewSprite.y = bgOption.y + 160;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var anyHovered = false;
        
        for (i in 0...modTexts.length)
        {
            var txt = modTexts[i];
            if (FlxG.mouse.overlaps(txt))
            {
                anyHovered = true;
                txt.color = FlxColor.YELLOW;
                openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.BUTTON;
                
                if (currentHoveredIndex != i)
                {
                    currentHoveredIndex = i;
                    updatePreviewImage(modsList[i]);
                }
            }
            else
            {
                txt.color = FlxColor.WHITE;
            }
        }

        if (FlxG.mouse.overlaps(closeBoton))
        {
            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.BUTTON;
            closeBoton.animation.play("active");
            if (FlxG.mouse.justPressed)
            {
                openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;
                close();
            }
        }
        else
        {
            if (!anyHovered) openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;
            closeBoton.animation.play("normal");
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            openfl.ui.Mouse.cursor = openfl.ui.MouseCursor.ARROW;
            close();
        }
    }
}