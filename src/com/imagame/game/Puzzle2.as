package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author imagame
	 */
	public class Puzzle2 extends AbstractPuzzle 
	{		
		public function Puzzle2(id:uint, pieces:Vector.<Piece>, dstPos: Vector.<Point>, dstMapPiece: Vector.<uint>) 
		{
			super(id, pieces, dstPos, dstMapPiece);				
		}
		
		
		/** 
		* Create auxiliar structures required to check correct piece dst position  
		*/           
		override protected function createAuxStructures(pieces: Vector.<Piece>):void { 
			super.createAuxStructures(pieces); 
			
			// [CONFIG] Game difficulty parametrization 
			var radio:uint;                 
			switch(Registry.gpMgr['round']){ 
				case 0: 
					radio = 32; 
					break; 
				case 1: 
					radio = 24; 
					break; 
				default: 
					radio = 16;                         
			} 			
			
			//override radio and state positions
			//Mark as free all piece positions 
			for (var i:uint = 0; i < _numPieces; i++) {
				_dstRadio[i] = radio; 
				_dststslist[i] = DSTSTS_FREE;
			}
			
			
		} 
		

		/*
		override protected function createDstPositions(pieces: Vector.<Piece>):void { 
			_dstlist = new Vector.<Point>(_numPieces); 
			_dstRadio = new Vector.<uint>(_numPieces);
			_dststslist = new Vector.<uint>(_numPieces);
			
			for(var i:uint; i<_numPieces; i++){ 
				_dstlist[i] = new Point(); 
				//local pos to _bmp
				_dstlist[i].x = Registry.appLeftOffset + i * 44 + i * 8;	//Principio pantalla
				_dstlist[i].x = x + i * 44 + i  * 8;	//Principio Number area
				_dstlist[i].y = y; // Registry.appUpOffset + 32;
				_dstRadio[i] = 16;	//TODO
				_dststslist[i] = 0; //libre
			} 
		} */	
		
		
/*		
		override public function doClick(localX:Number, localY:Number):void { 
			var posX:uint = localX / _pieceWidth; 
			var posY:uint = localY / _pieceHeight; 
			var idx:uint = posY * _numPiecesWidth + posX; 
			if (_dststslist[idx] == DSTSTS_FREE) { //Si vacío
				var colPos = _dstMapPiece[idx]; 
				//var colPos = _dstMapPiece[idx].color; _dstMapPiece[idx].pieces[i] 
				if(colPos == (_box as Box1).getCategorySelected()) { 
					var piece: Piece = _box.retrieveByCategory(colPos); 
					_box.removePieceFromBox(piece); 
					setPieceInPuzzle(piece,_dstGlobalPos[idx]); //o sobreargar setPieceInPuzzle para que acepte param idx 
				} 
				else { 
					//removeAllPiecesFromPuzzle(); 
					for(var i:uint=0; i<_numPieces; i++) { 
						if(_dststslist[i] == 1) { //TYPE OCCUPIED 
							var piece: Piece = removePieceFromPuzzlePos(i); 
							_box.setPieceInBox(piece); 
						} 
					} 
				} 
			} 
		} 		
	*/
		
		
		/** 
		 * Check if drop position is valid, based on group dropping conditions 
		 * Condition 1:(distance < _radio) -> identificar la dst más próxima a x,y. Chequear que se cumple distance rule. 
		 * Condition 2: chk if piece matches position (for 1:1 mapping or 1:N mapping) 
		 * Assumption: only one position must be valid at the same time 
		 * @param        x 
		 * @param          y 
		 * @return  True if pos (x,y) is a valid destination position 
		 */ 
        override public function chkCorrectDstPos(x: Number, y: Number, piece: Piece, updSts: Boolean=false): Point { 
			//return _dstGlobalPos[piece.id]; 
			
			//[TODO] Implement puzzle rounds 
			//r: a que round pertenece la pieza: 
			//idx: indice secuencia relativa dentro del round r 
			//To check in _dstPos[_round[_roundAct] + idx] 
			for(var i:uint=0; i < _numPieces; i++){                         
				//Chk cond 1 
				if(_dststslist[i]==DSTSTS_FREE && distance(x, y, _dstGlobalPos[i].x, _dstGlobalPos[i].y) < _dstRadio[i]) {        //_radio: valor en pixels                                         
					//Chk cond 2 
					if(chkCorrectPuzzleCondition(piece.id,i)) {                                         
						if (updSts) { 
							setDstPosStatus(i, false); //Update dst bmp (set occupied graphic) 
						} 
						return _dstGlobalPos[i]; 
					} 
				}                                                         
			}                         
			return null;                                             
		} 

		/** 
		*        Checks if a piece matches the puzzle <idxPos> position 
		*/ 
		private function chkCorrectPuzzleCondition(idPiece: uint, idxPos: uint): Boolean { 
				//if 1-piece:1-position mapping 
				return (_dstMapPiece[idxPos] == idPiece); 
		} 

		//TODO
		/*
		private function chkMatchPieceInPosition(idPiece: uint, idxPos: uint): Boolean { 
				//if 1-piece:N-positions mapping 
				for(var i:uint=0; i < _dstMapPiece[idxPos].length; i++) { 
						//TODO if (_dstMapPiece[idxPos][i] == idPiece) 
						if (_dstMapPiece[idxPos] == idPiece) 
								return true; 
				} 
				return false; 
		} 	
		*/
		
	}

}