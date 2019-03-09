package com.imagame.game 
{
	import com.greensock.TweenLite;
	import com.imagame.engine.ImaSprite;
	import com.imagame.engine.ImaSpriteAnim;
	import com.imagame.engine.Registry;
	import com.imagame.fx.ImaFx;
	import com.imagame.utils.ImaBitmapSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/** 
	 * Puzzle Piece 
	 * Features: 
	 * - Piece situation (box/puzzle) and position within box or puzzle 
	 * - Graphis: in box graphics, in dragging operation graphic, in puzzle graphic 
	 * - Movement logic (start drag and stop drag handling) 
	 * - Check drop position (communicating with Puzzle to check dst position) 
	 * - Reaction to drop (adjusting to correct dst puzzle position, returning to box original position if failed dst position, communicate with puzzle/box to indicate result) 
	 * - Animation (in-box behaviour guided by type of box, in-puzzle behaviour guided to type of puzzle) 
	 * @author imagame 
	 */ 
	public class Piece extends ImaSpriteAnim 
	{ 
		//categorization variables
		protected var _category: uint;	//piece type
		public static const TYPE_NOPIECE: uint = 0; 	//Type values
		public static const TYPE_COL1: uint = 1; 
		public static const TYPE_COL2: uint = 2;        
		public static const TYPE_COL3: uint = 3;        
		public static const TYPE_COL4: uint = 4;        
		public static const TYPE_COL5: uint = 5;        
		public static const TYPE_COL6: uint = 6;        
		public static const TYPE_COL7: uint = 7;        
		public static const TYPE_COL8: uint = 8;        
       
		
		//state variables 
		protected var _sit: uint;        //Piece situation 

		public static const SIT_BOX_IN: uint = 0; 
		public static const SIT_BOX_OUT: uint = 1; 
		public static const SIT_PUZZLE: uint = 2;        //It correspond to STS_FINISHED (piece positioned in correct dst position) 
				
		//graphic variables 
		protected var _srcPos: Point;         //Original source position in Box (centre reg point?) 
		protected var _dstPos: Point;        //Global Destination point in puzzle (centre reg point?) 		
		protected var _w: uint;			//current width (based on current animation frame width). Piece width in dst pos
		protected var _h: uint;
		
		//behavior variables 
		protected var _bSelected: Boolean = false;        //Selected by touch event 
		protected var _rectDrag: Rectangle; //rectangle limiting sprite dragging area 
       

		//public function Piece(id:uint, category: uint) 		
		public function Piece(id:uint, category: uint) 
		{ 
			super(ImaSprite.TYPE_ENTITY, id);         
			
			_category = category;			
			_srcPos = new Point();
			_dstPos = new Point();	
			_rectDrag = new Rectangle();
		} 
			
		override public function destroy():void { 
			_srcPos = null;
			_dstPos = null;
			_rectDrag = null;
			super.destroy(); 
		} 
		
		override public function init():void {   
			//TODO init actions 
			_sit = SIT_BOX_OUT;
			super.init(); 
		} 
			
		override public function exit():void { 
			//TODO exit actions 
			super.exit(); 
		} 
                
		//****************************************************** Update status 
		
		public function updPutInBox(): void { 
			_sit = SIT_BOX_IN; 
			visible = true;
			
			_w = getWidth();	//get width and height from current Anim
			_h = getHeight(); 
		} 
				
		public function updPutOutBox(): void { 
			_sit = SIT_BOX_OUT; 
			visible = false;
		} 
		
		public function updPutInPuzzle(): void { 
			_sit = SIT_PUZZLE; 
			visible = true;
			alpha = 1;
			scaleX = scaleY = 1;	
			
			_w = getWidth();
			_h = getHeight();
		} 
		
		
		  
		//***************************************************** Getters/Setters 
		
		public function get situation():int {
			return _sit;
		}
		
		public function get category():int {
			return _category;
		}
		
		public function get w():uint {
			return _w;
		}
		public function get h():uint {
			return _h;
		}
		
		/**
		 * Set local source position with centered registraion point
		 * @param	x
		 * @param	y
		 */
		public function setPos(inx: Number, iny: Number):void {
			this.x = (uint)(inx - _w * 0.5);
			this.y = (uint)(iny - _h * 0.5);
			//this.x = inx - _w * 0.5;
			//this.y = iny - _h * 0.5;
			//trace("      piece.setPos: "+x + ","+y);
		}
		
		/** 
		 * Set global source pos, and assigns it to current position applying centered registration point
		 * @param        pos	global up-left point
		 */ 
		public function setSrcPos(pos: Point):void { 
			_srcPos.copyFrom(pos); //DUDA: local pos to sprite group, or global pos?? 
			x = pos.x - _w * 0.5; 
			y = pos.y - _h * 0.5; 
		} 
		
		/**
		 * Set global destination position 
		 * @param	pos	global center point
		 */
		public function setDstPos(pos: Point):void {
			_dstPos.copyFrom(pos);
		}
		
		
		public function setDragArea(rect: Rectangle):void {
			_rectDrag.copyFrom(rect); 
			_rectDrag.width -= _bmp.width; 
			_rectDrag.height -= _bmp.height;
		}
		
		public function getDstPos():Point {
			return _dstPos;
		}
		
		public function isSelected(): Boolean { 
				return _bSelected; 
		}                 
		

		
	
		
/*		
		public function onTweenInitDropOk():void { 
			TweenLite.to(this, 0.4, { x:_dstPos.x - width * 0.5, y:_dstPos.y - height * 0.5, onComplete: onTweenCompleteDropOk, onCompleteParams:[0] } ); 
			//on complete function with params: {onComplete:myFunction, onCompleteParams:[myVar]} 
		} 
		public function onTweenCompleteDropOk(i: uint):void { 
			//TweenLite.to(this, 0.25, { x:_dstPos.x-width*2, y:_dstPos.y-height*2, alpha:0, scaleX:4, scaleY:4, onComplete: function(){_sts = STS_FINISHED; _bSelected = false;}} ); 
		//	TweenLite.to(this, 0.25, { x:_dstPos.x - width * 2, y:_dstPos.y - height * 2, alpha:0, scaleX:4, scaleY:4, onComplete: onTweenCompleteDropOk2} ); 
			_sts = STS_FINISHED; _bSelected = false;
			
			//ImaFx.imaFxZoomIn((Registry.game.getState() as GameState).puzzle, this, 4, 0.4, true, function(){_sts = STS_FINISHED; _bSelected = false;}); 
			
			//Alternativa 1.a: Cambio de estado a STS_DYING, que provoca llamada a exit, function sobrescrita que llamará a puzzle para realizar la transferencia de pieza de box a puzzle. 
			//Alternativa 1.b: Cambio de estado a STS_FINISHED, que provoca una única llamada a puzzle para realizar la transferencia de pieza de box a puzzle. Se encarga Puzzle del cambio de estao a STS_FINISHED 
			//Alternativa 2: disparar señal 
			//signalPieceInPuzzle.dispatch(this); 
		}  
		public function onTweenCompleteDropOk2():void {
			TweenLite.to(this, 0.25, {x:_dstPos.x - width * 0.5, y:_dstPos.y - height * 0.5, alpha:1, scaleX:1, scaleY:1, onComplete: function(){_sts = STS_FINISHED; _bSelected = false;}} ); 
		}
		public function onTweenInitDropKo():void { 
			TweenLite.to(this, 0.25, { x:_srcPos.x-width*0.5, y:_srcPos.y-height*0.5, onComplete: function(){_bSelected = false;}} ); 
		} 
	*/

	
		
		
		
		override public function update():void { 
			// State defined to manage transfer between Box and Puzzle 
		/*
			if (_sts == STS_FINISHED) {         
				if(_sit == SIT_BOX_IN) { 
					(_grp as AbstractBox).removePieceFromBox(this); 
					(Registry.game.getState() as GameState).puzzle.setPieceInPuzzle(this,_dstPos); 
				} 
			} 			
		*/
			
			//llamada a super.update() para tratar cambios estados crear->init y muriendo->muerto			
			super.update(); 
		}                         
			

			
	} 

}