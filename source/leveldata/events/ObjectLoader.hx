package leveldata.events;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import leveldata.blockdata.*;
import leveldata.deco.*;
import leveldata.events.*;
import leveldata.hazards.*;
import leveldata.misc.*;
import main.ChapterState;
import main.PlayerData;

class ObjectLoader
{
    public static function loadEverything(tiledData:TiledMap, state:ChapterState, offsetX:Float, offsetY:Float):Void
    {

        for (layer in tiledData.layers)
        {
            if (layer.type == TiledLayerType.OBJECT)
            {
                var objectLayer:TiledObjectLayer = cast layer;

                for (obj in objectLayer.objects)
                {
                    var spawnX = obj.x + offsetX;
                    var spawnY = obj.y + offsetY;

                    if (obj.gid > 0) 
                    {
                        spawnY -= obj.height;
                    }

                    switch (obj.name)
                    {
                        case "warp":
                        var target = obj.properties.get("target");
                        var dir = obj.properties.get("direction");
                        var newChapter = obj.properties.get("newChapter");
                        
                        var warp = new WarpTrigger(spawnX, spawnY, obj.width, obj.height, target, dir);
                        warp.newChapter = newChapter;
                        state.warpsGroup.add(warp);

                        case "spike":
                        var localID:Int = 0;
                        if (obj.properties.contains("id")) 
                        {
                            localID = Std.parseInt(obj.properties.get("id"));
                        } 
                        else 
                        {
                            var tileset = tiledData.getGidOwner(obj.gid);
                            localID = obj.gid - tileset.firstGID;
                        }
                            var spike = new NormalSpike(spawnX, spawnY, localID);
                            state.dangerObjects.add(spike);

                        case "small-spike":
                        var localID:Int = 0;
                        if (obj.properties.contains("id")) 
                        {
                            localID = Std.parseInt(obj.properties.get("id"));
                        } 
                        else 
                        {
                            var tileset = tiledData.getGidOwner(obj.gid);
                            localID = obj.gid - tileset.firstGID;
                        }
                            var smallSpike = new SmallSpike(spawnX, spawnY, localID);
                            state.dangerObjects.add(smallSpike);

                        case "switch-spike":
                            var localID:Int = 0;
                            var status:String = "none";
                            if (obj.properties.contains("status"))
                            {
                                status = obj.properties.get("status");
                            }
                            if (obj.properties.contains("id")) 
                            {
                                localID = Std.parseInt(obj.properties.get("id"));
                            } 
                            var sSpike = new SwitchSpike(spawnX, spawnY, localID, status);
                            state.dangerObjects.add(sSpike);

                        case "save":
                            var save = new SavePoint(spawnX, spawnY);
                            if (PlayerData.currentRoom != state.currentRoomName)
                            {
                                state.savesGroup.add(save);
                            }

                        case "doubleJump":
                            var doubleJump = new DoubleJumpObj(spawnX, spawnY);
                            state.doubleJumpGroup.add(doubleJump);
                            
                        case "flip":
                            var flip = new FlipSwitch(spawnX, spawnY);
                            state.flipGroup.add(flip);

                        case "portal":
                            var portal = new PortalWarp(spawnX, spawnY);
                            state.portalGroup.add(portal);

                        case "laser":
                            var dir:String = "hor";
                            if (obj.properties.contains("direction")) { dir = obj.properties.get("direction"); }
                            var laser = new YellowLaser(spawnX, spawnY, dir); 
                            state.dangerObjects.add(laser);

                        case "trampoline":
                            var tramp = new NormalTrampoline(spawnX, spawnY);
                            state.trampolines.add(tramp);
                        
                        case "trampoline-mini":
                            var dir:String = "up";
                            if (obj.properties.contains("direction"))
                            {
                                dir = obj.properties.get("direction");
                            } 
                                
                            var trampMini = new NormalTrampolineMini(spawnX, spawnY, dir);
                                state.trampolinesMini.add(trampMini);

                        case "platform":
                            var dir = obj.properties.get("direction");
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;
                            var plat = new MovingBlock(spawnX, spawnY, dir, localID);
                            state.platforms.add(plat);

                        case "falling":
                            var dir = obj.properties.get("direction");
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;
                            var fall = new FallingBlock(spawnX, spawnY, dir, localID);
                            state.fallingBlock.add(fall);

                        case "light":
                            var light = new LightTorch(spawnX, spawnY);
                            light.x -= light.width / 2;
                            light.y -= light.height / 2;
                            state.lightsGroup.add(light);
                        case "slab":
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;
                            var slab = new NormalSlab(spawnX, spawnY, localID);
                            state.slabs.add(slab);

                        case "solid_block":
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;
                            var solid = new SolidBlock(spawnX, spawnY, localID);
                            state.solidBlock.add(solid);
                    }
                }
            }
        }
    }
}