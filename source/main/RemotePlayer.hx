package main;

import flixel.FlxG;
import flixel.FlxSprite;
import main.mods.ModLoader;

class RemotePlayer extends FlxSprite {
	public var skinName:String = "";

	// Last network package
	var netX:Float = 0;
	var netY:Float = 0;
	var netVelX:Float = 0; // estimated horizontal speed
	var netVelY:Float = 0; // estimated vertical speed
	var netAnim:String = "idle";
	var netFacingRight:Bool = true;
	var netFlipped:Bool = false;

	var prevNetX:Float = 0;
	var prevNetY:Float = 0;
	var lastPacketTime:Float = 0; // accumulated time since last packet
	var timeSincePacket:Float = 0; // seconds since last packet received

	// Simulation constants
	static inline var GRAVITY:Float = 2000; // same as Player
	static inline var WALK_SPEED:Float = 300; // estimated walking speed
	static inline var MAX_FALL_SPEED:Float = 1000;
	static inline var PACKET_TIMEOUT:Float = 0.5; // no package on that time = freeze
	static inline var LERP_SPEED:Float = 12.0;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadSkin("thekid");
		netX = x;
		netY = y;
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

	/**
	 * Estimated network speed from the movement between the previous and current packet.
	 */
	public function applyNetworkPacket(xVal:Float, yVal:Float, flipVal:Bool, facingRightVal:Bool, animVal:String):Void {
		// The position difference between the previous and current packet
		if (timeSincePacket > 0.001) {
			netVelX = (xVal - netX) / timeSincePacket;
			netVelY = (yVal - netY) / timeSincePacket;
		}

		prevNetX = netX;
		prevNetY = netY;
		netX = xVal;
		netY = yVal;
		netAnim = (animVal != null && animVal != "") ? animVal : "idle";
		netFacingRight = facingRightVal;
		netFlipped = flipVal;
		timeSincePacket = 0;

		// Apply orientation and flip immediately
		this.flipY = flipVal;
		this.offset.y = flipVal ? 0 : 20;
		this.facing = facingRightVal ? RIGHT : LEFT;
		this.offset.x = facingRightVal ? 20 : 10;

		setFacingFlip(LEFT, true, flipVal);
		setFacingFlip(RIGHT, false, flipVal);
	}

	override public function update(elapsed:Float):Void {
		timeSincePacket += elapsed;

		if (timeSincePacket < PACKET_TIMEOUT) {
			// --- Dead reckoning: extrapolar posición ---
			var extraX = netX;
			var extraY = netY;

			switch (netAnim) {
				case "walking":
					// Continuar andando en la misma dirección horizontal
					var walkVel = netFacingRight ? WALK_SPEED : -WALK_SPEED;
					extraX = netX + walkVel * timeSincePacket;
					// Pequeña caída si está andando (rozamiento suelo)
					extraY = netY;

				case "jumpUp":
					// Simular arco de salto hacia arriba
					var gravMult = netFlipped ? -1.0 : 1.0;
					extraX = netX + netVelX * timeSincePacket;
					extraY = netY + netVelY * timeSincePacket + 0.5 * GRAVITY * gravMult * timeSincePacket * timeSincePacket;

				case "jumpDown":
					// Caída: aplicar gravedad desde la velocidad vertical que traía
					var gravMult = netFlipped ? -1.0 : 1.0;
					extraX = netX + netVelX * timeSincePacket;
					extraY = netY + netVelY * timeSincePacket + 0.5 * GRAVITY * gravMult * timeSincePacket * timeSincePacket;

				default: // "idle"
					extraX = netX;
					extraY = netY;
			}

			// Smoothly interpolate to the extrapolated position to avoid sudden jumps
			this.x += (extraX - this.x) * LERP_SPEED * elapsed;
			this.y += (extraY - this.y) * LERP_SPEED * elapsed;
		}

		if (netAnim != null && netAnim != "")
			animation.play(netAnim, false);

		super.update(elapsed);
	}
}
