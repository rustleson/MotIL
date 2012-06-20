//---------------------------------------------------------------------------
//
//    Copyright 2011-2012 Reyna D "rustleson"
//
//---------------------------------------------------------------------------
//
//    This file is part of MotIL.
//
//    MotIL is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MotIL is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MotIL.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------------------------

package Engine.Objects {
	
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
    import General.Input;
    import General.Rndm;
    import flash.display.*;
    import Engine.Objects.Utils;
    import Engine.Worlds.*;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.filters.*;

    public class Room extends WorldObject {

	public static const ROOM_TYPE_OPEN:int = 1;
	public static const ROOM_TYPE_EMPTY:int = 2;
	public static const ROOM_TYPE_TUNNEL:int = 3;
	public static const ROOM_TYPE_RUBBLE:int = 4;

	public static var textures:Object = new Object();
	
	public var birthX:Number;
	public var birthY:Number;

	public var map:Array = new Array();
	public var mapWidth:int = 4;
	public var mapHeight:int = 4;

	public static const textureWidth:Number = 400;
	public static const textureHeight:Number = 400;

	public function Room(world:b2World, x:Number, y:Number, width:Number, height:Number, thickness:Number, c:uint = 0xDDEEEE, a:Number = 0.8, freedomTop:uint = 0, freedomBottom:uint = 0, freedomLeft:uint = 0, freedomRight:uint = 0, roomType:int = 2){
			
	    this.color = c;
	    this.alpha = a;
	    var holePos:Number;
	    var holeLen:Number;
	    var minSize:Number = width / 4;

	    // remember whole room size
	    var roomX:Number = x;
	    var roomY:Number = y;
	    var roomWidth:Number = width;
	    var roomHeight:Number = width;
	    if (roomType == Room.ROOM_TYPE_TUNNEL) {
		var minX:Number = x + width;
		var minY:Number = y + height;
		var maxX:Number = x;
		var maxY:Number = y;
		// calculate minimized room border
		if (freedomTop) {
		    holeLen = getHoleLen(freedomTop, width);
		    holePos = getHolePos(width, holeLen);
		    if (x + holePos < minX)
			minX = x + holePos;
		    if (x + holePos + holeLen > maxX)
			maxX = x + holePos + holeLen;
		}
		if (freedomBottom) {
		    holeLen = getHoleLen(freedomBottom, width);
		    holePos = getHolePos(width, holeLen);
		    if (x + holePos < minX)
			minX = x + holePos;
		    if (x + holePos + holeLen > maxX)
			maxX = x + holePos + holeLen;
		}
		if (freedomRight) {
		    holeLen = getHoleLen(freedomRight, height);
		    holePos = getHolePos(height, holeLen);
		    if (y + holePos < minY)
			minY = y + holePos;
		    if (y + holePos + holeLen > maxY)
			maxY = y + holePos + holeLen;
		}
		if (freedomLeft) {
		    holeLen = getHoleLen(freedomLeft, height);
		    holePos = getHolePos(height, holeLen);
		    if (y + holePos < minY)
			minY = y + holePos;
		    if (y + holePos + holeLen > maxY)
			maxY = y + holePos + holeLen;
		}
		// prevent room from being lesser than allowed min size
		if (maxX - minX < minSize) {
		    var midX:Number = (minX + maxX) / 2;
		    minX = midX - minSize / 2;
		    maxX = midX + minSize / 2;
		}
		if (maxY - minY < minSize) {
		    var midY:Number = (minY + maxY) / 2;
		    minY = midY - minSize / 2;
		    maxY = midY + minSize / 2;
		}
		// adjust border thickness 
		minX = Math.max(roomX, minX - thickness);
		minY = Math.max(roomY, minY - thickness);
		maxX = Math.min(roomX + roomWidth, maxX + thickness);
		maxY = Math.min(roomY + roomHeight, maxY + thickness);
		x = minX;
		y = minY;
		width = maxX - minX;
		height = maxY - minY;
	    }

	    // Top
	    var topHoleX1:Number = -1;
	    var topHoleX2:Number = -1;
	    if (!freedomTop) {
		this.buildWall(world, x, y, width, thickness, 'wallTop', -Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomTop, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    topHoleX1 = holePos;
		    topHoleX2 = holePos + holeLen;
		    this.buildWall(world, x, y, holePos - x + roomX, thickness, 'wallTop1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y, x - roomX + width - holePos - holeLen, thickness, 'wallTop2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, roomY, thickness, y - roomY, 'tunnelTop1', Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, roomY, thickness, y - roomY, 'tunnelTop2', Math.PI);
		}
	    }
	    // Right
	    var rightHoleY1:Number = -1;
	    var rightHoleY2:Number = -1;
	    if (!freedomRight) {
		this.buildWall(world, x + width - thickness, y, thickness, height, 'wallRight', 0);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomRight, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    rightHoleY1 = holePos;
		    rightHoleY2 = holePos + holeLen;
		    this.buildWall(world, x + width - thickness, y, thickness, holePos - y + roomY, 'wallRight1', 0);
		    this.buildWall(world, x + width - thickness, roomY + holePos + holeLen, thickness, y - roomY + height - holePos - holeLen, 'wallRight2', 0);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, x + width, roomY + holePos - thickness, roomWidth - x + roomX - width, thickness, 'tunnelRight1', -Math.PI/2);
		    this.buildWall(world, x + width, roomY + holePos + holeLen, roomWidth - x + roomX - width, thickness, 'tunnelRight2', -Math.PI/2);
		}
	    } 
	    // Bottom
	    var bottomHoleX1:Number = -1;
	    var bottomHoleX2:Number = -1;
	    if (!freedomBottom) {
		this.buildWall(world, x, y + height - thickness, width, thickness, 'wallBottom', Math.PI/2);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomBottom, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    bottomHoleX1 = holePos;
		    bottomHoleX2 = holePos + holeLen;
		    this.buildWall(world, x, y + height - thickness, holePos - x + roomX, thickness, 'wallBottom1', -Math.PI/2);
		    this.buildWall(world, roomX + holePos + holeLen, y + height - thickness, x - roomX + width - holePos - holeLen, thickness, 'wallBottom2', -Math.PI/2);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX + holePos - thickness, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom1', -Math.PI);
		    this.buildWall(world, roomX + holePos + holeLen, y + height, thickness, roomHeight - y + roomY - height, 'tunnelBottom2', -Math.PI);
		}
	    }
	    // Left
	    var leftHoleY1:Number = -1;
	    var leftHoleY2:Number = -1;
	    if (!freedomLeft) {
		this.buildWall(world, x, y, thickness, height, 'wallLeft', Math.PI);
	    } else {
		if (roomType != Room.ROOM_TYPE_OPEN) {
		    holeLen = getHoleLen(freedomLeft, roomWidth);
		    holePos = getHolePos(roomWidth, holeLen);
		    leftHoleY1 = holePos;
		    leftHoleY2 = holePos + holeLen;
		    this.buildWall(world, x, y, thickness, holePos - y + roomY, 'wallLeft1', 0);
		    this.buildWall(world, x, roomY + holePos + holeLen, thickness, y - roomY + height - holePos - holeLen, 'wallLeft2', 0);
		}
		if (roomType == Room.ROOM_TYPE_TUNNEL) {
		    this.buildWall(world, roomX, roomY + holePos - thickness, x - roomX, thickness, 'tunnelLeft1', Math.PI/2);
		    this.buildWall(world, roomX, roomY + holePos + holeLen, x - roomX, thickness, 'tunnelLeft2', Math.PI/2);
		}
	    } 

	    this.birthX = x + width / 2;
	    this.birthY = y + height / 2;

	    if (roomType == Room.ROOM_TYPE_RUBBLE) {
		// build rubble
		for (var j:int = 0; j < this.mapHeight; j++) {
		    this.map[j] = new Array();
		    for (var i:int = 0; i < this.mapWidth; i++) {
			var room:WorldRoom = new EmptyRoom(null, 0, 0, 0, 0, 0, "", 0);
			this.map[j].push(room);
		    }
		}
		this.generateDFSMaze(0, 0);
		var cellWidth:Number = roomWidth / this.mapWidth;
		var cellHeight:Number = roomHeight / this.mapHeight;
		for (j = 0; j < this.mapHeight; j++) {
		    for (i = 0; i < this.mapWidth; i++) {
			if (!this.map[j][i].freedomRight && i < this.mapWidth - 1 &&
			    !(j == 0 && ((i + 1) * cellWidth) > topHoleX1 - thickness && ((i + 1) * cellWidth) < topHoleX2) &&
			    !(j == this.mapHeight - 1 && ((i + 1) * cellWidth) > bottomHoleX1 - thickness && ((i + 1) * cellWidth) < bottomHoleX2) ) {
			    this.buildWall(world, roomX + (i + 1) * cellWidth, roomY + j * cellHeight, thickness, cellHeight + (j == this.mapHeight - 1 ? 0 : thickness), 'rubbleWallRight' + j.toString() + "-" + i.toString(), Math.PI);    
			}
			if (!this.map[j][i].freedomBottom && j < this.mapHeight - 1 &&
			    !(i == 0 && ((j + 1) * cellHeight) > leftHoleY1 - thickness && ((j + 1) * cellHeight) < leftHoleY2) &&
			    !(i == this.mapWidth - 1 && ((j + 1) * cellHeight) > rightHoleY1 - thickness && ((j + 1) * cellHeight) < rightHoleY2) ) {
			    this.buildWall(world, roomX + i * cellWidth, roomY + (j + 1) * cellHeight, cellWidth, thickness, 'rubbleWallBottom' + j.toString() + "-" + i.toString(), Math.PI/2);    
			}
		    }
		}		
		this.birthX -= cellWidth / 2;
		this.birthY -= cellHeight / 2;
	    }
	    
	}

	public static function buildTextures(typeIndex:int):Boolean {
	    var texturesFunctions:Object = new Object();
	    texturesFunctions[WorldRoom.SPACE_TYPE] = Room.drawSpaceTexture;
	    texturesFunctions[WorldRoom.WATER_TYPE] = Room.drawWaterTexture;
	    texturesFunctions[WorldRoom.EARTH_TYPE] = Room.drawEarthTexture;
	    texturesFunctions[WorldRoom.FIRE_TYPE] = Room.drawFireTexture;
	    texturesFunctions[WorldRoom.AIR_TYPE] = Room.drawAirTexture;
	    texturesFunctions[WorldRoom.PURITY_TYPE] = Room.drawPurityTexture;
	    texturesFunctions[WorldRoom.BALANCE_TYPE] = Room.drawBalanceTexture;
	    texturesFunctions[WorldRoom.CORRUPTION_TYPE] = Room.drawCorruptionTexture;
	    var i:int = 0;
	    for (var roomType:String in texturesFunctions) {
		if (i == typeIndex) {
		    var mainBitmap:BitmapData = new BitmapData(textureWidth, textureHeight, true, 0x00111111);
		    var c:Sprite = new Sprite();
		    c.graphics.clear();
		    texturesFunctions[roomType](c, mainBitmap);
		    //bitmap.draw(c);
		    Room.textures[roomType] = mainBitmap;
		    return true;
		}
		i++;
	    }
	    return false;
	}

	private static function drawSpaceTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.RED | BitmapDataChannel.BLUE;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(5, 5, 3, seed, true, false, 7, true, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    var bmd2:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    var bmd3:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    var threshold:uint =  0xFF999999; 
	    var color:uint = 0x11000000;
	    var maskColor:uint = 0xffffffff;
	    b.threshold(b, rect, pt, "<", threshold, color, maskColor, true);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		    bmd2.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		    bmd3.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array();
            matrix = matrix.concat([2, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 2, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 2, 0, 0]); // blue
            matrix = matrix.concat([1, 0, 0, 0, 0]); // alpha
	    var filter2:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd2.applyFilter(bmd1, rect, pt, filter2);
	    var filter3:BlurFilter = new BlurFilter(2, 2, flash.filters.BitmapFilterQuality.HIGH);
	    bmd3.applyFilter(bmd3, rect, pt, filter3);
	    bmd3.applyFilter(bmd3, rect, pt, filter2);
	    //var filter:GlowFilter = new GlowFilter(0xffffff, 0.5, 13, 13, 127, BitmapFilterQuality.HIGH, true, true);
	    var filter:BlurFilter = new BlurFilter(10, 10, flash.filters.BitmapFilterQuality.HIGH);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd2.draw(bmd3, null, null, BlendMode.ADD);
	    bmd1.draw(bmd2, null, null, BlendMode.ADD);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawWaterTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.BLUE;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 15, 1, seed, true, true, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array(-1,  0, -1,  0,  0,  1,
					  0,  1,  0,  1, -1,  0,
					  0,  0,  0,  0,  0,  0,
					  0,  0,  0,  0,  0,  0,
					  0, -1,  1,  1,  1,  0,
					  1,  0,  0, -1,  0, -1);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 1, 0);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0, 0, 0.7, 0, -73]); // red
            matrix = matrix.concat([0, 0, 0.7, 0, -73]); // green
            matrix = matrix.concat([0, 0, 1, 0, 44]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawEarthTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.GREEN;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 15, 3, seed, true, false, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 0,  0,  0,  0,  0,  0,
					  0,  0,  0,  0,  0,  0,
					  0, -1, -1,  0,  0,  0,
					 -1,  0,  1,  0,  0,  0,
					 -1,  1,  1,  0,  0,  0,
					  1,  1,  1,  0,  0,  0);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 2, 15);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0, 1, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0.8, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawFireTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.RED;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(6, 25, 3, seed, true, true, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 0,  0,  1,  1,  0,  0,
					  0,  1, -1, -1,  1,  0,
					  1, -1,  0,  1, -1,  1,
					  1, -1,  0,  0, -1,  1,
					  0,  1, -1, -1,  1,  0,
					  0,  0,  1,  1,  0,  0);

	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 5, 0);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([1.5, 0, 0, 0, 20]); // red
            matrix = matrix.concat([1.5, 0, 0, 0, -140]); // green
            matrix = matrix.concat([0, 0, 0, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);

	}

	private static function drawAirTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.GREEN;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 15, 3, seed, true, true, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 0,  0, -1,  0,  0,  0,
					  0,  0, -1, -1,  0,  0,
					 -1, -1,  1, -1,  1,  0,
					 -1,  1,  1,  1,  0,  0,
					  1,  1,  1, -1,  0,  0,
					  2,  1, -1, -1,  0,  0);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 3, 0);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0, 0.1, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0.9, 0, 0, 0x22]); // green
            matrix = matrix.concat([0, 0.1, 2, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawPurityTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.GREEN;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 45, 3, seed, true, false, channels, false, null);
	    var threshold:uint =  0xFF009900; 
	    var color:uint = 0x11000000;
	    var maskColor:uint = 0xffffffff;
	    //b.threshold(b, rect, pt, "<", threshold, color, maskColor, true);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 0,  0,  0, -1,  0,  0,
					  0,  0,  0,  1,  0,  0,
					  0,  1, -1,  1, -1,  0,
					  0,  1,  1,  1,  1,  0,
					  0,  0, -1,  1, -1,  0,
					  0,  0,  0, -1,  0,  0);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 1.3, 30);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0, 0.4, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0.8, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0.66, 0, 0, 0]); // blue
            matrix = matrix.concat([0, 1, 0, 0, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawBalanceTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.GREEN;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 15, 3, seed, true, false, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 0,  0, -1,  1,  0,  0,
					  0,  0,  0,  0,  0,  0,
					 -1,  0,  0,  0,  0, -1,
					  1,  0,  0,  0,  0,  1,
					  0,  0,  0,  0,  0,  0,
					  0,  0, -1,  1,  0,  0);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 1, 15);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0, 0.6, 0, 0, 30]); // red
            matrix = matrix.concat([0, 0.8, 0, 0, 30]); // green
            matrix = matrix.concat([0, 0.4, 0, 0, 30]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);
	}

	private static function drawCorruptionTexture(spr:Sprite, b:BitmapData):void {
	    var seed:Number = Math.floor(Math.random() * 10000);
	    var channels:uint = BitmapDataChannel.RED | BitmapDataChannel.BLUE;
	    var pt:Point = new Point(0, 0);
	    var rect0:Rectangle = new Rectangle(0, 0, textureWidth, textureHeight);
	    var rectM:Rectangle = new Rectangle(textureWidth, textureHeight, textureWidth, textureHeight);
	    var rect:Rectangle = new Rectangle(0, 0, textureWidth * 3, textureHeight * 3);
	    b.perlinNoise(15, 15, 3, seed, true, false, channels, false, null);
	    var bmd1:BitmapData = new BitmapData(textureWidth * 3, textureHeight * 3, true, 0x00CCCCCC);
	    for (var i:int = 0; i < 3; i++) {
		for (var j:int = 0; j < 3; j++) {
		    bmd1.copyPixels(b, rect0, new Point(i * textureWidth, j * textureHeight));
		}
	    }
	    var matrix:Array = new Array( 1, -1, -1,  2,  1, -1,
					  2, -1,  1,  1, -1,  2,
					 -1, -1,  0, -1,  1, -1,
					 -1,  1,  1,  1, -1, -1,
					  1, -1,  1,  1, -2,  2,
					  2, -1, -1, -1,  1, -1);
	    var filter2:ConvolutionFilter = new ConvolutionFilter(6, 6, matrix, 3, 0);
	    bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    //bmd1.applyFilter(bmd1, rect, pt, filter2);
	    matrix = new Array();
            matrix = matrix.concat([0.5, 0.1, 0.5, 0, 0]); // red
            matrix = matrix.concat([0.1, 0.3, 0.5, 0, 0]); // green
            matrix = matrix.concat([0.5, 0.1, 0.5, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
	    var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	    bmd1.applyFilter(bmd1, rect, pt, filter);
	    b.copyPixels(bmd1, rectM, pt);

	}

	private function buildWall(world:b2World, x:Number, y:Number, width:Number, height:Number, name:String, gradientRot:Number):void {
	    if (width > 0 && height > 0 ) {
		var wall:b2PolygonShape= new b2PolygonShape();
		var wallBd:b2BodyDef = new b2BodyDef();
		var fixtureDef:b2FixtureDef = new b2FixtureDef();
		wallBd.type = b2Body.b2_staticBody;
		fixtureDef.density = 0.0;
		fixtureDef.friction = 0.4;
		fixtureDef.restitution = 0.3;
		fixtureDef.filter.categoryBits = 0x0004;
		fixtureDef.filter.maskBits = 0x0002;
		wall.SetAsArray(Utils.getBoxVertices(x, y, width, height), 4);
		fixtureDef.shape = wall;
		wallBd.userData = {gradientType: GradientType.LINEAR, gradientColors: [Utils.colorLight(this.color, 0.5), this.color, Utils.colorDark(this.color, 0.3)], gradientAlphas: [1, 1, this.alpha], gradientRatios: [0x00, 0x23, 0xFF], gradientRot: gradientRot, curved: false}
		bodies[name] = world.CreateBody(wallBd);
		bodies[name].CreateFixture(fixtureDef);
		bodies[name].drawingFunction = this.drawWall as Function;
		bodiesOrder.push(name);
	    }	    
	}
	    
	private function getHoleLen(seed:uint, lengthTotal:Number):Number {
	    Rndm.seed = seed;
	    return Rndm.float(lengthTotal * 0.1, lengthTotal * 0.4);
	}

	private function getHolePos(lengthTotal:Number, lengthHole:Number):Number {
	    return Rndm.float(lengthTotal * 0.03, lengthTotal * 0.97 - lengthHole);
	}

	private function generateDFSMaze(x:int, y:int):void {
	    var curX:int = x;
	    var curY:int = y;
	    var cellStackX:Array = new Array();
	    var cellStackY:Array = new Array();
	    while (true) {
		this.map[curY][curX].visited = true;
		// calculate unvisited neighbours
		var neighbours:Array = new Array();
		if (!this.cellVisited(curX - 1, curY)) {
		    neighbours.push({x: curX - 1, y: curY, curAttr: "freedomLeft", nextAttr: "freedomRight"});
		}
		if (!this.cellVisited(curX + 1, curY)) {
		    neighbours.push({x: curX + 1, y: curY, curAttr: "freedomRight", nextAttr: "freedomLeft"});
		}
		if (!this.cellVisited(curX, curY - 1)) {
		    neighbours.push({x: curX, y: curY - 1, curAttr: "freedomTop", nextAttr: "freedomBottom"});
		}
		if (!this.cellVisited(curX, curY + 1)) {
		    neighbours.push({x: curX, y: curY + 1, curAttr: "freedomBottom", nextAttr: "freedomTop"});
		}
		if (neighbours.length > 0) {
		    // move to random unvisited neighbour
		    var rn:int = Rndm.integer(0, neighbours.length);
		    var nextX:int = neighbours[rn].x;
		    var nextY:int = neighbours[rn].y;
		    cellStackX.push(curX);
		    cellStackY.push(curY);
		    var rSeed:uint = Rndm.integer(1, 10000000);
		    this.map[curY][curX][neighbours[rn].curAttr] = rSeed;
		    this.map[nextY][nextX][neighbours[rn].nextAttr] = rSeed;
		    curX = nextX;
		    curY = nextY;
		} else if (cellStackX.length > 0) {
		    // no neighbours, back to previous cell
		    curX = cellStackX.pop();
		    curY = cellStackY.pop();
		} else {
		    // generation finished
		    break;
		}
	    }
	}

	private function cellVisited(x:int, y:int):Boolean {
	    
	    if (x < 0 || x > this.mapWidth - 1 || y < 0 || y > this.mapHeight - 1)
		return true;
	    if (this.map[y][x].visited)
		return true;
	    return false;
	}

        public function drawWall(shape:b2Shape, xf:b2Transform, c:uint, drawScale:Number, dx:Number, dy:Number, udata:Object, spr:Sprite):void{
	    var gradMatrix:Matrix = new Matrix();
	    spr.cacheAsBitmap = true;
	    spr.graphics.clear();

	    var i:int;
	    var poly:b2PolygonShape = (shape as b2PolygonShape);
	    var vertexCount:int = poly.GetVertexCount();
			
	    var orig_vertices:Vector.<b2Vec2> = poly.GetVertices();
	    var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>(vertexCount);
	    if (udata.curved) {
		for (i = 0; i < vertexCount; i++){
		    vertices[i] = new b2Vec2(orig_vertices[i].x * udata.curveAdjust, orig_vertices[i].y * udata.curveAdjust);
		}
	    } else {
		vertices = orig_vertices;
	    }
		    
	    var localBounds:b2AABB = new b2AABB();
	    var auraBounds:b2AABB = new b2AABB();
	    localBounds.lowerBound = new b2Vec2(vertices[0].x, vertices[0].y);
	    localBounds.upperBound = new b2Vec2(vertices[0].x, vertices[0].y);
	    for (i = 1; i < vertexCount; i++){
		if (vertices[i].x < localBounds.lowerBound.x) localBounds.lowerBound.x = vertices[i].x;
		if (vertices[i].y < localBounds.lowerBound.y) localBounds.lowerBound.y = vertices[i].y;
		if (vertices[i].x > localBounds.upperBound.x) localBounds.upperBound.x = vertices[i].x;
		if (vertices[i].y > localBounds.upperBound.y) localBounds.upperBound.y = vertices[i].y;
	    }
	    spr.graphics.lineStyle(1, c, 0);
	    spr.graphics.moveTo((vertices[0].x - dx) * drawScale, (vertices[0].y - dy) * drawScale);
	    if (textures.hasOwnProperty(this.color)) {
		var matrix:Matrix = new Matrix();
		matrix.translate(-dx * drawScale, -dy * drawScale);
		spr.graphics.beginBitmapFill(textures[this.color], matrix.clone(), true);
	    } else {
		gradMatrix.createGradientBox((localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale, udata.gradientRot, (localBounds.lowerBound.x - dx) * drawScale, (localBounds.lowerBound.y - dy) * drawScale);
		spr.graphics.beginGradientFill(udata.gradientType, udata.gradientColors, udata.gradientAlphas, udata.gradientRatios, gradMatrix);
	    }
	    for (i = 1; i < vertexCount; i++){
		spr.graphics.lineTo((vertices[i].x - dx) * drawScale, (vertices[i].y - dy) * drawScale);
	    }
	    spr.graphics.lineTo((vertices[0].x - dx) * drawScale, (vertices[0].y - dy) * drawScale);
	    spr.graphics.endFill();

	    // smooth wall edges are commented to investigate if it cause sporadic app crashes
	    // UPD: game didn't crashed after 30 mins of gameplay without smooth wall edges. 
	    // TODO: re-think masking concept or just left it unmasked
	    /*
	    var maskSpr:Sprite = new Sprite();
	    while (spr.numChildren > 0) {
		spr.removeChildAt(0);
	    }
	    spr.addChild(maskSpr);
	    spr.blendMode = BlendMode.LAYER;
	    maskSpr.blendMode = BlendMode.ALPHA;
	    maskSpr.graphics.clear();
	    var bd:BitmapData = new BitmapData((localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale, true, 0x00000000);
	    bd.fillRect(new Rectangle(4, 4, (localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale - 8, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale - 8), 0xffffffff);
	    var filter:BlurFilter = new BlurFilter(5, 5, flash.filters.BitmapFilterQuality.HIGH);
	    bd.applyFilter(bd, new Rectangle(0, 0, (localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale), new Point(0, 0), filter);
	    matrix = new Matrix();
	    matrix.translate((localBounds.lowerBound.x - dx) * drawScale, (localBounds.lowerBound.y - dy) * drawScale);
	    maskSpr.graphics.beginBitmapFill(bd, matrix, true);
	    
	    maskSpr.graphics.drawRect((localBounds.lowerBound.x - dx) * drawScale, (localBounds.lowerBound.y - dy) * drawScale, (localBounds.upperBound.x - localBounds.lowerBound.x) * drawScale, (localBounds.upperBound.y - localBounds.lowerBound.y) * drawScale);
	    maskSpr.graphics.endFill();
	    //spr.mask = maskSpr;		
	    //bd.dispose();
	    */ 
        }


    }
	
}