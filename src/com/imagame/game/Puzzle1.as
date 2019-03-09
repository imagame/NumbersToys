package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import com.imagame.fx.ImaFx;
	import com.imagame.fx.ImaFxGroupTapIndicator;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author imagame
	 */
	public class Puzzle1 extends AbstractPuzzle 
	{		
		protected var _pieceWidth: uint; 
		protected var _pieceHeight: uint; 
		protected var _numPiecesWidth: uint; 
		protected var _numPiecesHeight: uint; 
		
		protected var _numFreePiecesCategory: Vector.<int>; //Vector that indicates if there are any free piece position in puzzle for each category 
                        //Values: -1: category does not exist in this puzzle, 0: no free positions in puzzle, 1: free positions in puzzle 
		protected var _sprGroupTapIndicatorFx: ImaFxGroupTapIndicator;        //FX Sprite to show selected piece and selection time progress 
		protected var _selectedCategoryList: Vector.<int>;	//Vector of piece positions with the selected categories where to activate the tap fx
		private var _bTapFx: Boolean;        //True to manage ImaFxGroupTapIndicator 
		
		public function Puzzle1(id:uint, pieces:Vector.<Piece>, dstPos: Vector.<Point>, dstMapPiece: Vector.<uint>) 
		{
			//if (CONFIG::mobile) //faltaria detectar que es Android 
			if(Registry.bLowRange)
				_bTapFx = false; 
			else 
				_bTapFx = true;
			super(id, pieces, dstPos, dstMapPiece);		
			
			
		}
				
		/** 
		* Create auxiliar structures required to check correct piece dst position  
		*/           
		override protected function createAuxStructures(pieces: Vector.<Piece>):void { 
			super.createAuxStructures(pieces); 
			
			//Mark as free positions those ones where a piece of any category is able to be put	
			for (var i:uint = 0; i < pieces.length; i++)
				if (pieces[i].category != Piece.TYPE_NOPIECE)
					_dststslist[i] = DSTSTS_FREE;
				
			
			_pieceWidth = 32; // pieces[0].width;  //TODO: tomarlo de piece.anim, creando getter en ImaAnim
			_pieceHeight = 32; // pieces[0].height; 
			_numPiecesWidth = _bmp.width / _pieceWidth; 
			_numPiecesHeight = _bmp.height / _pieceHeight; 
			
			if(_bTapFx){ 
				_selectedCategoryList = new Vector.<int>(_numPieces);
				for (var i:uint = 0; i < _numPieces; i++) { 				
					_selectedCategoryList[i] = (_dststslist[i] == DSTSTS_FREE)?1:-1; 	//set -1 if pos unused, and 1 if pos is usable for any category                                 
				}
				var numLoopsFx:uint = 0;
				if ( Registry.gpMgr['round'] >= 3)
					numLoopsFx = 1;
				_sprGroupTapIndicatorFx = new ImaFxGroupTapIndicator(_selectedCategoryList,6,7,numLoopsFx);	//TODO: number of loops depending on number of puzzle ¿?
				addChild(_sprGroupTapIndicatorFx);
			}
		} 
			
		
		override public function destroy():void { 
			if(_bTapFx){
				_selectedCategoryList = null;
				removeChild(_sprGroupTapIndicatorFx);
				_sprGroupTapIndicatorFx.destroy();
				_sprGroupTapIndicatorFx = null;
			}			
			super.destroy(); 
		}
		
		
		override public function init():void {  
			(_box as Box1).signalPieceSelection.add(onBoxPieceSelected);
			 _numFreePiecesCategory = (_box as Box1).getExistCategories(); //initFreePiecesCategory(); 
			super.init()
		} 
		
		
		override public function setPieceInPuzzle(piece: Piece, dstPos: Point):void { 
			_numFreePiecesCategory[piece.category]--;        //decrements the number of free pos for the piece category 
			super.setPieceInPuzzle(piece,dstPos); 
		} 
                
		override public function removePieceFromPuzzle(piece: Piece):int {   
			_numFreePiecesCategory[piece.category]++;        //increments the number of free pos for the piece category 
			return super.removePieceFromPuzzle(piece); 
		} 
		
		override public function doClick(localX:Number, localY:Number):void { 
			var posX:uint = localX / _pieceWidth; 
			var posY:uint = localY / _pieceHeight; 
			var idx:uint = posY * _numPiecesWidth + posX; 
			if (_dststslist[idx] == DSTSTS_FREE) { //Si vacío								
				var colPos = _dstMapPiece[idx]; 
				var colSel = (_box as Box1).getCategorySelected();
				if(colPos == colSel) { 
					var piece: Piece = _box.retrieveByCategory(colPos); 
					
					
				//	if (ImaFx.getIdTween(_box) != null) {	//If there is an active tween on box (piece selection is the only one that can be)
				//		trace("<< ERROR >> ### Puzzle1.doClick() ##################################################### "+ localX+","+localY);
				//	}
				//	else {
					if (ImaFx.getIdTween(_box) == null) {
						//Assets.getSound("Click").play(); //SOUND
						Assets.playSound("Piece1ok");
						
						_box.removePieceFromBox(piece); 
						setPieceInPuzzle(piece, _dstGlobalPos[idx]); //o sobrecargar setPieceInPuzzle para que acepte param idx 
						
						if(_bTapFx)
							_sprGroupTapIndicatorFx.disableMemberFx(idx);	//Fx: disable member fx 
					}
				} 
				else { 
					Assets.playSound("Piece1ko");
					//Option-1 
					//Remove pieces of the current color (not the active one, but the one thar erroneously has been tapped )  
	/*				for(var i:uint=0; i<_numPieces; i++) {                                                 
						if (_dststslist[i] == DSTSTS_OCCUPIED) { //1st cond: POS OCCUPIED 
							var piece: Piece = retrieveByDstPos(_dstGlobalPos[i]);
							//var piece: Piece = _box.retrieveByIdx(i);
							if (piece == null) {
								trace("<< ERROR >> _box.retrieveByIdx " + i);
								continue;
							}
							if(piece.category == colPos) { //2n cond: PIECE IN POS WITH SAME COLOR AS COLPOS 
								removePieceFromPuzzlePos(i); 
								_box.setPieceInBox(piece); //no need to show fx on piece since 
							} 
						} 
					} 
		*/
					if( Registry.gpMgr['round'] <= 1) { 
						//Option-2: 
						//Remove pieces of the current color, and pieces of colors not finalized (not totally cleaned) 
						//Remove pieces of the tapped color (piece.category = colPos <> colSel) 
						//Remove pices of other colors for those ones that there is still any piece not set 
						for(var i:uint=0; i<_numPieces; i++) {                                                 
							if(_dststslist[i] == DSTSTS_OCCUPIED){ //1st cond: POS OCCUPIED 
								var piece: Piece = retrieveByDstPos(_dstGlobalPos[i]);       
								if(_numFreePiecesCategory[piece.category] > 0) {//2n cond: NOT ALL THE PIECES ARE SET FOR THAT COLOR
									removePieceFromPuzzlePos(i); //¿¿debe actualizar _numFreePiecesCategory[] incrementando nº de free pieces ?? SI 
									_box.setPieceInBox(piece); //no need to show fx on piece since 
								
									//Mostrar fx solo si estamos en pos cuyo color coincida con el seleccionado 
									if (piece.category == colSel)  
										if(_bTapFx)
											_sprGroupTapIndicatorFx.enableMemberFx(i);	//Fx: enable member fx 	
								} 
							} 
						} 
					}
					else {
						//Option-3: For Complex levels
						//remove all Pieces from Puzzle; 
						for(var i:uint=0; i<_numPieces; i++) { 
							if(_dststslist[i] == DSTSTS_OCCUPIED) { //TYPE OCCUPIED 
								var piece: Piece = removePieceFromPuzzlePos(i); 
								_box.setPieceInBox(piece); 
								
								//Mostrar fx solo si estamos en pos cuyo color coincida con el seleccionado 
								if (piece.category == colSel)   
									if(_bTapFx)
										_sprGroupTapIndicatorFx.enableMemberFx(i);	//Fx: enable member fx 
							} 
						} 

					}
				
				} 
			} 
		} 		
		
		private function onBoxPieceSelected(idCategory: uint):void {
			trace("Piece SELECTED " + idCategory);
			//construct an array (length all pieces) mixing map and dststslist: 
			//Set -1 for unused positions or positions where a piece with a category <> idCategory could be located (<>map or sts=unusable)
			//Set  0 for positions where a idCategory piece is located (=map and sts= Occupied)
			//Set  1 for positions where a idCategory piece could be located (=map and sts= free)
			
			//Play Sound change of color
			Assets.playSound("Faceok");
                        
			if(_bTapFx){ 
				_sprGroupTapIndicatorFx.stopFx(); //pause current tap FX (if exist)
				
				//Update array with free selCat positions (all except unused, other category pieces, and selected category occupied)					
				for (var i:uint = 0; i < _numPieces; i++) {
					if(_selectedCategoryList[i] != -1)         
						_selectedCategoryList[i] = _dstMapPiece[i] == idCategory?1:0;
				}
				_sprGroupTapIndicatorFx.setMembersFx(_selectedCategoryList); //Change the piece positions 
				_sprGroupTapIndicatorFx.startFx();
			}
		}

		
		/** 
		 * Update group sprites execution. To be overriden 
		 */ 
		override public function update():void { 
			super.update();	//Call update method of sprite members
		
			if(_bTapFx) {
				if (_sprGroupTapIndicatorFx)
					_sprGroupTapIndicatorFx.update();
			}
		} 
            
	}

}