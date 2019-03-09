package com.imagame.game 
{
	import com.imagame.engine.ImaButton;
	import com.imagame.engine.ImaIcon;
	import com.imagame.engine.ImaTimer;
	import com.imagame.engine.Registry;
	import com.imagame.fx.ImaFx;
	import com.imagame.fx.ImaFxCircularProgressCtrl;
	import com.imagame.utils.ImaUtils;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;

	/**
	 * Box with pieces around the board (all are inbox pieces)
	 * @author imagame
	 */
	public class Box3 extends AbstractBox 
	{		
		private var _numPieces: uint;
		private var _boxRect: Rectangle = new Rectangle(); //Rectangle that defines the box area
		private var _auxPoint: Point = new Point();
		
		public function Box3(id:uint, pieces:Vector.<Piece>, boxRect:Rectangle) 
		{ 
			super(id, pieces); 
			trace("ABSTRACTBOX >> Box3() " + id);
			cacheAsBitmap = false;	//avoid cache to keep pices in in-box correctly painted in its group position
								
			_numPieces = pieces.length;
			_boxRect.copyFrom(boxRect);
		} 
		
		override public function destroy():void { 
			//TODO delete components
			_auxPoint = null;
			_boxRect = null;
			super.destroy(); 
		} 
		
		/** 
		* Initializes pieces contained in box (position and visible status) 
		*/ 
		override public function init():void {  
			//Apply default init piece method to all pieces
			for (var i:uint = 0; i < _members.length; i++) { 
				(_members[i] as Piece).init(); 
			} 
			
			//Assign all pieces to inbox
			var xoffset:uint = 16;
			var yoffset:uint = 0;
			for (var p:uint = 0; p < _numPieces; p++) {
				var piece:Piece = retrieve(p) as Piece;
				
				//Set a random position inside the board			
				//TODO: If necessary, Ads.size.y can be substracted from _boxRect.height, to avoid locate a piece inside the ad area (in practice is very difficult)
				_auxPoint.x = (uint)(ImaUtils.randomize(_boxRect.x + xoffset + piece.w , _boxRect.width - piece.w - xoffset)); 
				_auxPoint.y = (uint)(ImaUtils.randomize(_boxRect.y + yoffset + piece.h , _boxRect.height - piece.h - yoffset)); 
				
				piece.setSrcPos(_auxPoint);						//TODO: Set src point randomly in board, ensurign piece completelly fits in board dimensions
				piece.playAnimation("PreInBox",true); 
				piece.updPutInBox(); 
				
				piece.setDragArea(_boxRect);
			}
					 					
			super.init();        //Move on active state 
		} 
 
		/** 
		 * Exit function called when moving from STS_DYING to STS_DEAD, or directly from gamestate exit func 
		 * Closed and consolidate logic data 
		 */ 
		override public function exit():void { 
			//TODO any actions on exit?? Any fx to stop??
		}   		

		
		
             
		
		

		/*-------------------------------------------------------------------------- Getters / Setters */
		
		
		

 

		
		//------------------------------------------------------------------- Callbacks

		
	             		
				
		/** 
		 * Update group sprites execution: call each sprite update() method, and chk exit group condition 
		 */                 
		override public function update():void { 
			super.update();  ///std behavior: para cada sprite de _members llama a update() 
				
			//Check if final condition is just met (if all piece sprites are positiones in dst positions) 
			if(_sts != STS_FINISHED) { 
				if (_members.length == 0){ //final condition: TODO (all have been put in puzzle)
					trace("BOX3 End condition met!!");
					_sts = STS_FINISHED;																
				} 
			} 
		} 		
}

}