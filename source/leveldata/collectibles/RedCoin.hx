package leveldata.collectibles;

import main.ChapterState;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import main.Player;

class RedCoin extends FlxSprite
{
    public var particle:FlxEmitter;
    public var coinID:String;
    var words:Array<String> = ["Secret!", "Shiny!", "Yes!"];

    public function new(x:Float, y:Float, id:String)
    {
        super(x, y);
        this.coinID = id;

        loadGraphic(AssetPaths.coins__png, true, 50, 50);
        animation.add("spin", [4, 5, 6, 7], 10, true);
        animation.play("spin");
        scale.set(0.85, 0.85);
        this.x += 3; this.y += 3;
        updateHitbox();
        centerOffsets();

        particle = new FlxEmitter(x + (width / 2), y + (height / 2), 40);
        particle.makeParticles(4, 4, FlxColor.WHITE, 20);
        particle.color.set(FlxColor.RED, FlxColor.YELLOW, FlxColor.RED, FlxColor.WHITE);
        particle.lifespan.set(0.5, 1.0);
        particle.speed.set(200, 400);
        particle.launchMode = CIRCLE;
        
        particle.acceleration.set(0, 500); 
        particle.drag.set(100, 100);
        
        particle.angularVelocity.set(-300, 300);

        immovable = true;

    }

    public function pop(playerRef:FlxSprite):Void
    {
        FlxG.log.add("RedCoin pop triggered");
        FlxG.log.add(FlxG.state.members.indexOf(particle));
        particle.start(true, 0, 20);

        var randomWord = words[FlxG.random.int(0, words.length - 1)];
        var popup = new FlxText(0, 0, 0, randomWord, 20);
        popup.setBorderStyle(OUTLINE, FlxColor.BLACK, 0);

        popup.x = playerRef.x + (playerRef.width / 2) - (popup.width / 2);
        popup.y = playerRef.y - 30;
        
        var state = cast(FlxG.state, ChapterState);
        state.popups.add(popup);

        FlxTween.num(0, 60, 0.8,
        {
            ease: FlxEase.circOut, 
            onComplete: function(twn:FlxTween)
            { 
                popup.destroy(); 
            }
        }, 
        function(v:Float)
        {
            if (popup != null && popup.exists && playerRef != null && playerRef.exists)
            {
                popup.alpha = 1 - (v / 60);
                
                popup.x = playerRef.x + (playerRef.width / 2) - (popup.width / 2);
                popup.y = playerRef.y - 30 - v;
            }
        });

    }

    override function destroy()
    {
        super.destroy();
        if (particle != null) particle.destroy();
    }


    
}