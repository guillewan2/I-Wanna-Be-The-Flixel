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

		// Si el jugador se teletransporta lejos (cambio de sala, spawn, etc.), reposicionar de inmediato
		var distSq = (xVal - this.x) * (xVal - this.x) + (yVal - this.y) * (yVal - this.y);
		if (distSq > 150 * 150) {
			this.x = xVal;
			this.y = yVal;
			netVelX = 0;
			netVelY = 0;
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
			// --- Movimiento continuo por predicción local ---
			var speedX = 0.0;
			var speedY = 0.0;

			if (netAnim == "walking") {
				speedX = netFacingRight ? WALK_SPEED : -WALK_SPEED;
			} else if (netAnim == "jumpUp" || netAnim == "jumpDown") {
				speedX = netVelX;
				// Simular gravedad localmente sobre la velocidad recibida
				var gravMult = netFlipped ? -1.0 : 1.0;
				netVelY += GRAVITY * gravMult * elapsed;
				if (netFlipped) {
					if (netVelY < -MAX_FALL_SPEED) netVelY = -MAX_FALL_SPEED;
				} else {
					if (netVelY > MAX_FALL_SPEED) netVelY = MAX_FALL_SPEED;
				}
				speedY = netVelY;
			}

			// Aplicar movimiento físico predicho
			this.x += speedX * elapsed;
			this.y += speedY * elapsed;

			// Corrección suave hacia la posición de red (para absorber errores de predicción)
			this.x += (netX - this.x) * LERP_SPEED * elapsed;
			this.y += (netY - this.y) * LERP_SPEED * elapsed;
		}

		if (netAnim != null && netAnim != "" && (animation.curAnim == null || animation.curAnim.name != netAnim))
			animation.play(netAnim);

		super.update(elapsed);
	}
}
