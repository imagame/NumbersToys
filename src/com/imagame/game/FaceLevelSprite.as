package com.imagame.game 
{
	import com.greensock.TweenLite;
	import com.imagame.engine.ImaSprite;
	import com.imagame.engine.ImaSpriteGroup;
	import com.imagame.utils.ImaBitmapSheet;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * sprite draggable con condición de grupo sobre la operación de drop 
	 * @author imagame
	 */
	public class FaceLevelSprite extends ImaSprite 
	{
		//graphic variables 
		protected var _srcPos: Point; 	//Original source position 
		protected var _dstPos: Point;	//Destination point 
		
		//behavior variables 
		protected var _bSelected: Boolean = false;        //Selected by touch event 		
		protected var _rectDrag: Rectangle; //rectangle limiting sprite dragging area 
                
                
		public function FaceLevelSprite(id: int, tileSheet: ImaBitmapSheet, idxTile: uint) { 
			trace("FaceLevelSprite: "+id); 

			super(ImaSprite.TYPE_SPRITE_FACE, id); 
			
			_tileSheet = tileSheet;
			_bmp = _tileSheet.getTile(idxTile);
			addChild(_bmp); 									
			
			_rectDrag = new Rectangle();
			
			//mouseChildren = false; 
			//_sts = STS_ACTIVE; 
		} 

        override public function destroy():void { 
			removeChild(_bmp);
			_rectDrag = null;
			_srcPos = null;
			_dstPos = null;
			super.destroy();
		}
		
		override public function init():void {
			//srPos must be set from outside calling setSrcPos
			_dstPos = null;
			alpha = 1;
			scaleX = scaleY = 1;
			visible = true;
			super.init();
		}
		
		//***************************************************** Getters/Setters
		
		/**
		 * Set source pos and initialize graphical status
		 * @param	pos
		 */
		public function setSrcPos(pos: Point):void { 
			_srcPos = pos; //DUDA: local pos to sprite group, or global pos?? 
			x = pos.x-width/2;
			y = pos.y - height / 2;
		} 
		
		public function setDragArea(rect: Rectangle):void{ 
			_rectDrag.copyFrom(rect); 
			_rectDrag.width -= _bmp.width;
		} 
					
		public function isSelected(): Boolean {
			return _bSelected;
		}
                        
                                
		//--------- movement handling logic 
		
		override public function doStartDrag(e:MouseEvent):void {	
			_bSelected = true; 
			startDrag(false, _rectDrag);
		}
		
		/*
		override public function doStartDrag(e:MouseEvent):void {
			if(_sts == STS_ACTIVE) {
			_bSelected = true; 
			startDrag(false, _rectDrag);
			}
			else{
			trace("Spr: " + grp.id + "." + _id + " STS != Active con startDrag " + _sts);
			_sts = STS_DYING;
			}
		}
		*/
		override public function doStopDrag(e:MouseEvent):void {
			stopDrag();
			if (chkDropPosition())        //Check if drop in a valid dst position, if true set it there and kill it. 
				Assets.playSound("Faceok");
			else
				Assets.playSound("Piece2ko");
		}
		
		override public function doTouchBegin(e:TouchEvent):void { 	
			_bSelected = true; 
			startTouchDrag(e.touchPointID, false, _rectDrag);                         
		} 

		override public function doTouchEnd(e:TouchEvent):void { 
			stopTouchDrag(e.touchPointID); 
			if (chkDropPosition())        //Check if drop in a valid dst position, if true set it there and kill it. 
				Assets.playSound("Faceok");
			else
				Assets.playSound("Piece2ko");
		}
		
		private function chkDropPosition():Boolean {
			_dstPos = (_grp as FaceLevelSpriteGroup).chkCorrectDstPos(x + width * 0.5, y + height * 0.5, true);
		
			if(_dstPos != null) {  //If drop position is correct on behalf on group dropping condition 
				//Tween de desplazamiento hasta centro pos dst y fade out 
				//_sts = STS_FINISHED;
				onTweenInitDropOk();	
				return true;
			}else { 
				onTweenInitDropKo(); //Tween from current pos to src pos 
				return false;
			} 	
		
		} 
		
		
		public function onTweenInitDropOk():void {
			TweenLite.to(this, 0.4, { x:_dstPos.x - width * 0.5, y:_dstPos.y - height * 0.5, onComplete: onTweenCompleteDropOk, onCompleteParams:[0] } ); 
			//on complete function with params: {onComplete:myFunction, onCompleteParams:[myVar]}
		}
		public function onTweenCompleteDropOk(i: uint):void {
			TweenLite.to(this, 0.25, { x:_dstPos.x-width*2, y:_dstPos.y-height*2, alpha:0, scaleX:4, scaleY:4, onComplete: function(){_sts = STS_DYING; _bSelected = false;}} ); 
		}
		public function onTweenInitDropKo():void {
			TweenLite.to(this, 0.25, { x:_srcPos.x-width/2, y:_srcPos.y-height/2, onComplete: function(){_bSelected = false;}} );
		}
		
		
		
		override public function update():void { 
			//animation depending on state (and possibly and control variables defined in sprite group) 
			//trace("FaceLevelSprite->update() id:" + _grp.id + "." + id);
			
			//EXample
			//if (id == 2)
			//	_bmp.bitmapData = (_tileSheet.getTile(0) as Bitmap).bitmapData;
			
				
			//llamada a super.update() para tratar cambios estados crear->init y muriendo->muerto
			super.update();
		} 
	}

}