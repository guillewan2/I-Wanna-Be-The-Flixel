import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
// import main.ChapterState;
import main.DebugState;
import gui.MenuState;
import openfl.Lib;

class Main extends Sprite
{
	public function new()
	{
		super();

		var gameWidth:Int = 1280;
		var gameHeight:Int = 720;
		var initialState = MenuState;
		var debugState = DebugState;
		var zoom:Float = 1;
		var refreshRate:Int = Lib.current.stage.window.displayMode.refreshRate;
		if (refreshRate <= 0) refreshRate = 60;
		var updateFramerate:Int = refreshRate;
		var drawFramerate:Int = refreshRate;
		var skipSplash:Bool = true;
		var startFullscreen:Bool = false;

		#if html5
			var document = js.Browser.document;
			document.addEventListener("contextmenu", function(event:js.html.Event) { event.preventDefault(); });
		#end
		
		#if !debug
		addChild(new FlxGame(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen));
			flixel.FlxG.fixedTimestep = true;
		#end

		#if debug
			addChild(new FlxGame(gameWidth, gameHeight, debugState, updateFramerate, drawFramerate, skipSplash, startFullscreen));
			flixel.FlxG.fixedTimestep = true;
		#end

		#if !mobile
			addChild(new FPS(10, 10, 0xffffff));
		#end

		flixel.FlxG.autoPause = false;
		
	}
}
