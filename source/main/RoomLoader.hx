package main;

import flixel.FlxG;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.effects.particles.FlxEmitter;
import flixel.tile.FlxTilemap;
import leveldata.background.BackgroundManager;
import leveldata.events.EventLoader;
import leveldata.events.ObjectLoader;
import leveldata.events.SavePoint;
import main.ChapterState;
import main.PlayerData;

class RoomLoader 
{
    public static function loadRoom(state:ChapterState, roomName:String):Void
    {
        flixel.tweens.FlxTween.globalManager.forEach(function(twn) twn.cancel());

        if (state.roomAcid != null) 
        {
            state.remove(state.roomAcid);
            state.roomAcid.destroy();
            state.roomAcid = null;
        }
        #if !linux
            var chartPath = "assets/data/chapters/chapter" + PlayerData.currentChapter + "/ch" + PlayerData.currentChapter + "-" + roomName + ".tmx";
        #else
            var chartPath = "assets/data/chapters_mobile/chapter" + PlayerData.currentChapter + "/ch" + PlayerData.currentChapter + "-" + roomName + "-mobile" + ".tmx";
        #end

        state.currentRoomName = roomName;

        /* Character Unlocks */
        if (roomName == "map25" && PlayerData.currentChapter == 1)
        {
            if (!PlayerData.reachedSewers)
            {
                PlayerData.reachedSewers = true;
                trace("Sewers reached! Skin Unlocked.");
            }
        }

        // ##########################

        state.tiledData = new TiledMap(chartPath);

        if (state.map != null) { state.remove(state.map); state.map.destroy(); }
        if (state.mapDeco != null) { state.remove(state.mapDeco); state.mapDeco.destroy(); }
        if (state.mapDeco2 != null) { state.remove(state.mapDeco2); state.mapDeco2.destroy(); }

        var mainLayer:TiledTileLayer = cast state.tiledData.getLayer("tiles-main");
        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, state.tiledData.width, state.tiledData.height, state.mainTilesPath, 50, 50, OFF, 1);
        state.map.x = -60; state.map.y = -65;
        FlxG.worldBounds.set(state.map.x, state.map.y, state.map.width, state.map.height);
        state.add(state.map);

        var decoLayer = state.tiledData.getLayer("tiles-deco");
        if (decoLayer != null)
        {
            state.mapDeco = new FlxTilemap();
            state.mapDeco.loadMapFromArray(cast(decoLayer, TiledTileLayer).tileArray, state.tiledData.width, state.tiledData.height, state.mainTilesPath, 50, 50, OFF, 1);
            state.mapDeco.x = -60; state.mapDeco.y = -65;
            state.add(state.mapDeco);
        }

        var decoLayer2 = state.tiledData.getLayer("tiles-deco2");
        if (decoLayer2 != null)
        {
            state.mapDeco2 = new FlxTilemap();
            state.mapDeco2.loadMapFromArray(cast(decoLayer2, TiledTileLayer).tileArray, state.tiledData.width, state.tiledData.height, state.mainTilesPath, 50, 50, OFF, 1);
            state.mapDeco2.x = -60; state.mapDeco2.y = -65;
            state.add(state.mapDeco2);
        }

        FlxG.bitmap.clearUnused();
        state.redCoinsGroup.clear();
        state.redCoinParticlesGroup.clear();
        state.dangerObjects.clear();
        state.doubleJumpGroup.clear();
        state.flipGroup.clear();
        state.portalGroup.clear();
        state.warpsGroup.clear();
        state.platforms.clear();
        state.trampolines.clear();
        state.trampolinesMini.clear();
        state.lightsGroup.clear();
        state.fallingBlock.clear();
        state.solidBlock.clear();
        state.slabs.clear();
        state.popups.clear();
        state.saveParticlesGroup.clear();
        state.redCoinParticlesGroup.clear();
        state.hud.clear();
        leveldata.hazards.SwitchSpike.clear();

        if (state.saveParticlesGroup != null)
        {
            state.saveParticlesGroup.forEachExists(function(p:FlxEmitter)
        {
            p.active = false;
            p.visible = false;
            p.exists = false;
        });
        state.saveParticlesGroup.clear();
        }

        if (state.redCoinParticlesGroup != null)
        {
            state.redCoinParticlesGroup.forEachExists(function(p:FlxEmitter)
        {
            p.active = false;
            p.visible = false;
            p.exists = false;
        });
        state.redCoinParticlesGroup.clear();
        }

        if (state.redCoinsGroup != null)
        {
            state.redCoinsGroup.forEach(function(c:leveldata.collectibles.RedCoin)
            {
                c.destroy();
            });
            state.redCoinsGroup.clear();
        }

        if (state.savesGroup != null)
        {
            state.savesGroup.forEachExists(function(s:SavePoint)
            {
                s.exists = false;
            });
        state.savesGroup.clear();
        }

        state.bullets.forEachAlive((bullet) ->
        {
            bullet.kill();
        });        

        ObjectLoader.loadEverything(state.tiledData, state, state.map.x, state.map.y);
        EventLoader.loadEvents(state.tiledData, state);
        state.add(state.redCoinsGroup);
        state.add(state.redCoinParticlesGroup);
		state.add(state.slabs);
        state.add(state.playerTrail);
        state.add(state.player);
        state.add(state.dangerObjects);
        state.add(state.player.doubleJumpEffect);
        state.add(state.doubleJumpGroup);
        state.add(state.saveParticlesGroup);
        state.add(state.savesGroup);
        state.add(state.popups);
		state.add(state.warpsGroup);
        state.add(state.platforms);
        state.add(state.solidBlock);
        state.add(state.fallingBlock);
        state.add(state.flipGroup);
        state.add(state.portalGroup);
        state.add(state.trampolines);
        state.add(state.trampolinesMini);
        state.add(state.playerGlow);
        state.add(state.eventEffectGroup);
        state.add(state.hud);
        state.cameraSnapTimer = 1;

        state.savesGroup.forEach(function(save:SavePoint)
        {
            state.saveParticlesGroup.add(save.particle);
        });

        BackgroundManager.updateAllEffects(state, state.tiledData);
        state.add(state.lightsGroup);
        if (state.vignite != null)
        {
            if (state.members.contains(state.vignite))
            state.remove(state.vignite);
        }
        state.add(state.vignite);
        state.setupHUD();
        state.autoScroll();
        state.cameraScroll();
        state.updateMusic();
        state.add(state.saveAnimation);

        #if !debug
            PlayerData.saveCooldown = 0.1;
            state.spawnTimer = 0.1;
        #else
            PlayerData.saveCooldown = 9999;
            state.spawnTimer = 0.1;
        #end

        state.hudGroup.clear();
        state.hudGroup.add(state.virtualPad);
        state.hudGroup.add(state.currentChapter);
        state.hudGroup.add(state.lastSave);
        state.hudGroup.add(state.playerDeaths);
        state.add(state.hudGroup);
        state.layoutVirtualPad();
        state.virtualPad.active = false;
        state.virtualPad.visible = false;

        #if mobile
            state.virtualPad.visible = true;
            state.virtualPad.active = true;
            state.player.pad = state.virtualPad;
            // state.player.pad.alpha = state.padAlpha;
        #end

        if (state.currentChapter != null) state.currentChapter.text = "Chapter: " + PlayerData.currentChapter;
        #if mobile
            // if (playerDeaths != null) playerDeaths.text = "Total Deaths: " + PlayerData.totalDeaths;
        #else
            if (state.playerDeaths != null) state.playerDeaths.text = "Total Resets: " + PlayerData.totalDeaths;
        #end
        if (state.lastSave != null) state.lastSave.text = "Last Save: " + PlayerData.currentRoom;

    }


}