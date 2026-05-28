package main;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DebugState extends FlxState
{
    var boyfriend:FlxSprite;
    var statusText:FlxText;

    override public function create():Void
    {
        super.create();

        // 1. Set the background color to white
        FlxG.cameras.bgColor = FlxColor.WHITE;

        // 2. Initialize the sprite
        boyfriend = new FlxSprite();

        // 3. Load the Texture Atlas 
        // Assumes BOYFRIEND.png and BOYFRIEND.xml are inside your 'assets/images/' folder
        boyfriend.frames = FlxAtlasFrames.fromSparrow('assets/debug/texture-atlas/BOYFRIEND.png', 'assets/debug/texture-atlas/BOYFRIEND.xml');

        // 4. Bind the animations based on your XML subtexture prefixes
        boyfriend.animation.addByPrefix('idle', 'BF idle dance', 24, true);
        boyfriend.animation.addByPrefix('shaking', 'BF idle shaking', 24, true);
        boyfriend.animation.addByPrefix('hey', 'BF HEY!!', 24, false);
        boyfriend.animation.addByPrefix('hit', 'BF hit', 24, false);
        boyfriend.animation.addByPrefix('dies', 'BF dies', 24, false);
        boyfriend.animation.addByPrefix('dead-loop', 'BF Dead Loop', 24, true);
        boyfriend.animation.addByPrefix('dead-confirm', 'BF Dead confirm', 24, false);
        
        // Note Animations (Using '0' at the end isolates them from matching 'MISS')
        boyfriend.animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
        boyfriend.animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
        boyfriend.animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
        boyfriend.animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
        
        // Miss Animations
        boyfriend.animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
        boyfriend.animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
        boyfriend.animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
        boyfriend.animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
        
        // Extra Combat Actions
        boyfriend.animation.addByPrefix('pre-attack', 'bf pre attack', 24, false);
        boyfriend.animation.addByPrefix('attack', 'boyfriend attack', 24, false);
        boyfriend.animation.addByPrefix('dodge', 'boyfriend dodge', 24, false);

        // 5. Center the sprite on screen and add it to the state
        boyfriend.screenCenter();
        add(boyfriend);

        // Start with the standard idle loop
        playAnim('idle');

        // 6. Setup an on-screen debug display
        statusText = new FlxText(20, 20, FlxG.width - 40, "", 16);
        statusText.setFormat(null, 16, FlxColor.BLACK, LEFT);
        add(statusText);
        // updateText('idle');
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Check if Shift is held down to trigger alternative "Miss" notes
        var isShiftHeld:Bool = FlxG.keys.pressed.SHIFT;

        // Arrow Key Mapping
        if (FlxG.keys.justPressed.LEFT) {
            playAnim(isShiftHeld ? 'singLEFTmiss' : 'singLEFT');
        }
        else if (FlxG.keys.justPressed.DOWN) {
            playAnim(isShiftHeld ? 'singDOWNmiss' : 'singDOWN');
        }
        else if (FlxG.keys.justPressed.UP) {
            playAnim(isShiftHeld ? 'singUPmiss' : 'singUP');
        }
        else if (FlxG.keys.justPressed.RIGHT) {
            playAnim(isShiftHeld ? 'singRIGHTmiss' : 'singRIGHT');
        }
        
        // Numeric Key Mapping
        else if (FlxG.keys.justPressed.ONE) {
            playAnim('shaking');
        }
        else if (FlxG.keys.justPressed.TWO) {
            playAnim('hey');
        }
        else if (FlxG.keys.justPressed.THREE) {
            playAnim('hit');
        }
        else if (FlxG.keys.justPressed.FOUR) {
            playAnim('dies');
        }
        else if (FlxG.keys.justPressed.FIVE) {
            playAnim('dead-loop');
        }
        else if (FlxG.keys.justPressed.SIX) {
            playAnim('dead-confirm');
        }
        else if (FlxG.keys.justPressed.SEVEN) {
            playAnim('pre-attack');
        }
        else if (FlxG.keys.justPressed.EIGHT) {
            playAnim('attack');
        }
        else if (FlxG.keys.justPressed.NINE) {
            playAnim('dodge');
        }
        else if (FlxG.keys.justPressed.ZERO) {
            playAnim('idle');
        }
    }

    function playAnim(animName:String):Void
    {
        boyfriend.animation.play(animName, true);
        
        /* 
           FNF sprites frames change dimensions drastically across actions.
           Re-centering on play prevents the sprite from awkwardly drifting.
        */
        boyfriend.screenCenter();
        // updateText(animName);
    }

    // function updateText(currentAnim:String):Void
    // {
    //     statusText.text = "Current Animation: " + currentAnim + "\n\n"
    //         + "CONTROLS:\n"
    //         + "• Arrow Keys : Sing Notes\n"
    //         + "• Shift + Arrow Keys : Miss Notes\n"
    //         + "• 0 : Idle Dance\n"
    //         + "• 1 : Idle Shaking    • 2 : Hey!           • 3 : Hit Reaction\n"
    //         + "• 4 : Dies            • 5 : Dead Loop      • 6 : Dead Confirm\n"
    //         + "• 7 : Pre-Attack      • 8 : Attack         • 9 : Dodge";
    // }
}