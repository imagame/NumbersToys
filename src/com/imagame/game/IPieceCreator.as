package com.imagame.game 
{       
	import flash.display.Bitmap;
	/** 
	 * Puzzle Piece creator (Factory Method) Interface 
	 * @author imagame 
	 */ 
	public interface IPieceCreator 
	{
		function createPuzzle(): AbstractPuzzle;
		function getPieces(): Vector.<Piece>;
		//function setImage(img: Bitmap):void; 
		// function setMask(img: Class); 
		function destroy():void;
	} 
        
} 