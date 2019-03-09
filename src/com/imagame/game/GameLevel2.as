package com.imagame.game 
{
	import com.imagame.engine.ImaSprite;
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import com.imagame.utils.ImaCachedBitmap;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author imagame
	 */
	public class GameLevel2 extends GameState 
	{
		/**
		 * 
		 * @param	id			Graphics Number id. Must be 1
		 * @param	idPhase
		 * @param	numLevels
		 */
		public function GameLevel2(id:uint, idPhase:uint, numLevels:uint) 
		{ 
			super(id, idPhase, numLevels); 
			trace("GAMESTATE >> GameLevel2() " + idPhase + "." + id + "(" + numLevels + ")"); 
		} 

		/** 
		* Called once this state has been created, and after the old state has been destroyed 
		* Create gamestate components (hud buttons and background), show puzzle and box graphics, and init them 
		*/ 
		override public function create():void 
		{ 
			trace("GameLevel2->create() " + _idPhase + "." + id);
			
			//Create puzzle and box 
			var _bmpSheet:ImaBitmapSheet = new ImaBitmapSheet(Assets.numberImages[_idPhase-1], Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT); 
			var bmp:Bitmap = _bmpSheet.getTile(id);
			_pieceCreator = new PieceCreator2(_idPhase, bmp); //Factory method creador de puzzle de piezas 
			
			_puzzle = _pieceCreator.createPuzzle();
			_box = new Box2(0, _pieceCreator.getPieces(), getPlayableRect());    //Sent number of piece categories

			_puzzle.setRefBox(_box); 
			_box.setRefPuzzle(_puzzle); 
  			
			_container.addChild(_puzzle);         
			_container.addChild(_box); 

			super.create();        //create hud buttons, and set STS to STS_PLAY 
		} 
                
		override public function destroy():void 
		{                         
			trace("GameLevel2->destroy() " + _idPhase + "." + id); 
			
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
			if (_sts != STS_END && _box.state == ImaSprite.STS_FINISHED ){ 
				_sts = STS_END; 
				_sbsts = SBSTS_INIT; 
			} 

			        
		}                		
		
	}

}