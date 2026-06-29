package main;

import flixel.FlxSprite;
import main.mods.ModLoader;

class RemotePlayer extends FlxSprite {
	public var skinName:String = "";

	public function new(x:Float, y:Float) {
		super(x, y);
		loadSkin("thekid");
	}

	public function loadSkin(skin:String):Void {
		if (skinName == skin)
			return;
		skinName = skin;
		ModLoader.loadModGraphic(this, "images/skins/" + skin + ".png", "skin_" + skin, 50, 50);
		animation.add("idle", [0, 1, 2, 3], 11, true);
		animation.add("jumpUp", [6], 16, false);
		animation.add("jumpDown", [7], 1, false);
		animation.add("walking", [8, 9, 10, 11, 12, 13], 24, true);

		width = 20;
		height = 30;
		offset.set(20, 20);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
	}

	public function updateProperties(xVal:Float, yVal:Float, flipVal:Bool, facingRightVal:Bool, animVal:String):Void {
		this.x = xVal;
		this.y = yVal;
		this.flipY = flipVal;

		this.offset.y = flipVal ? 0 : 20;

		this.facing = facingRightVal ? RIGHT : LEFT;

		this.offset.x = facingRightVal ? 20 : 10;

		if (animVal != null && animVal != "") {
			animation.play(animVal);
		}
	}
}
