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
	public class GameLevel1 extends GameState 
	{
		
		public function GameLevel1(id:uint, idPhase:uint, numLevels:uint) 
		{ 
			super(id, idPhase, numLevels); 
			trace("GAMESTATE >> GameLevel1() " + idPhase + "." + id + "(" + numLevels + ")"); 
		} 

		/** 
		* Called once this state has been created, and after the old state has been destroyed 
		* Create gamestate components (hud buttons and background), show puzzle and box graphics, and init them 
		*/ 
		override public function create():void 
		{ 
			trace("GameLevel1->create() " + _idPhase + "." + id);
			
			//Create puzzle and box 
			var _bmpSheet:ImaBitmapSheet = new ImaBitmapSheet(Assets.numberImages[_idPhase-1], Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT); 
			var bmp:Bitmap = _bmpSheet.getTile(id);
			_pieceCreator = new PieceCreator1(_idPhase, bmp, 32, 32); //Factory method creador de puzzle de piezas 
			
			_puzzle = _pieceCreator.createPuzzle();
			_box = new Box1(_idPhase, _pieceCreator.getPieces());    //Sent number of piece categories

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
			
			//If we are not in end state 
			if (_sts != STS_END) { 
				//Chk if final condition is met and update game progress status 
				if(_box.state == ImaSprite.STS_FINISHED){ 
					_sts = STS_END; 
					_sbsts = SBSTS_INIT; 
				}
			} 	
			
		}                		
		
	}

}