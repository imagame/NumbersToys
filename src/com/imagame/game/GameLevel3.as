package com.imagame.game 
{
	import com.imagame.engine.ImaSprite;
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import com.imagame.utils.ImaBitmapSheetDirect;
	import com.imagame.utils.ImaCachedBitmap;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author imagame
	 */
	public class GameLevel3 extends GameState 
	{
		/**
		 * 
		 * @param	id 0..numLevels-1
		 * @param	idPhase	1..9
		 * @param	numLevels	Number of levels in each phase
		 */
		public function GameLevel3(id:uint, idPhase:uint, numLevels:uint) 
		{ 
			super(id, idPhase, numLevels); 
			trace("GAMESTATE >> GameLevel3() " + idPhase + "." + id + "(" + numLevels + ")"); 
		} 

		/** 
		* Called once this state has been created, and after the old state has been destroyed 
		* Create gamestate components (hud buttons and background), show puzzle and box graphics, and init them 
		*/ 
		override public function create():void 
		{ 
			trace("GameLevel3->create() " + _idPhase + "." + id);
			
			//Create puzzle and box 
			var _bmpSheet:ImaBitmapSheet = new ImaBitmapSheet(Assets.numberImages[_idPhase-1], Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT); 
			
			var bmp:Bitmap = _bkg.getImg();			
			
			bmp.bitmapData.copyPixels(_bmpSheet.getTile(id+1).bitmapData, 
				new Rectangle(0, 0, Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT), 
				new Point((uint)((Registry.gameRect.width - Assets.IMG_NUMBER_WIDTH) * 0.5), (uint)(Registry.appUpOffset + 16)),
				null,null,true);
			
			_pieceCreator = new PieceCreator3(_idPhase, 
											ImaCachedBitmap.instance.createBitmapFromSheetDirect(bmp, 0, 0, Registry.gameRect.width, Registry.gameRect.height),
											this
											); //Factory method creador de puzzle de piezas 
			
			_puzzle = _pieceCreator.createPuzzle();
			_box = new Box3(0, _pieceCreator.getPieces(), getPlayableRect());    //Sent number of piece categories

			_puzzle.setRefBox(_box); 
			_box.setRefPuzzle(_puzzle); 
  			
			_container.addChild(_puzzle);         
			_container.addChild(_box); 

			super.create();        //create hud buttons, and set STS to STS_PLAY 
		} 
                
		override public function destroy():void 
		{                         
			trace("GameLevel1->destroy() " + _idPhase + "." + id); 
			
			//destroy puzzle components 
			_box.destroy(); 
			_container.removeChild(_box); 
			_box = null; 
			_puzzle.destroy(); 
			_container.removeChild(_puzzle); 
			_puzzle = null; 
			_pieceCreator.destroy(); 
			_pieceCreator = null; 
			
			super.destroy(); 
		}                 
		
		
		override public function update():void 
		{ 
			super.update(); 
			//Chk if final condition is met and update game progress status 
			if (_sts != STS_END && _box.state == ImaSprite.STS_FINISHED){ 
				_sts = STS_END; 
				_sbsts = SBSTS_INIT; 
			} 

			        
		}                		
		
	}

}