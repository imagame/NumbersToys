package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.filters.BevelFilter;
	
	/**
	 * ...
	 * @author imagame
	 */
	public class Puzzle3 extends AbstractPuzzle 
	{		
		protected var _bmpPiecesShapes: Bitmap;
		protected var _dstShape: Vector.<uint>;        //Piece Shape Id for each dst positions 
		
		private var _auxRect: Rectangle = new Rectangle(); 
		private var _auxPoint: Point = new Point();
		private var _auxBmdClean: BitmapData;
		
		
		public function Puzzle3(id:uint, pieces:Vector.<Piece>, dstPos: Vector.<Point>, dstMapPiece: Vector.<uint>) 
		{
			super(id, pieces, dstPos, dstMapPiece);	
			createPiecesShapesImage(pieces); 
		}
		
		override public function destroy():void { 			
			removeChild(_bmpPiecesShapes);
			_bmpPiecesShapes = null;
                       
			//aux objects 
			_dstShape = null;
			_auxRect = null; 
			_auxPoint = null; 
			_auxBmdClean.dispose();
			_auxBmdClean = null;
                        			
			super.destroy(); 
		}		
		
		/**
		 * Create puzzle image, composing background + level number image + piece shapes
		 * @param	pieces
		 */
		override protected function createPuzzleImage(pieces: Vector.<Piece>):void {			                        
			var s:GameState = (Registry.game.getState() as GameState); 					
			
			//Copy background 
			_bmp = s.background.getImg();         

//TODO Pegar nº??? o pegar solo bkg?? o no pegar nada: override para no pegar puz number pero no pegar nada dejando detras el bkg			
			//Copy lvl number img 
/*			var ts:ImaBitmapSheet = new ImaBitmapSheet(Assets.numberImages[s.phase-1], Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT); 
			var rect: Rectangle = new Rectangle(); 
			_auxRect.setTo((uint)((Registry.gameRect.width - Assets.IMG_NUMBER_WIDTH) * 0.5), 
						(uint)(Registry.appUpOffset + 16), 
						Assets.IMG_NUMBER_WIDTH, 
						Assets.IMG_NUMBER_HEIGHT);
			_auxPoint.setTo(0, 0);
			_bmp.bitmapData.copyPixels(ts.getTile(s.id).bitmapData, _auxRect, _auxPoint, null, null, true); 	
	*/	
			addChild(_bmp); 			
		}

		/** 
		* Create auxiliar structures required to check correct piece dst position  
		*/           
		override protected function createAuxStructures(pieces: Vector.<Piece>):void { 
			super.createAuxStructures(pieces); 
			
			_dstShape = new Vector.<uint>(_numPieces); 
			//Mark as free all piece positions 
			for (var i:uint = 0; i < _numPieces; i++) { 
					_dstRadio[i] = 16; //TODO: Based in level difficulty set minor radio values        //TODO: also, Depending on piece size 
					_dststslist[i] = DSTSTS_FREE; 
					_dstShape[i] = pieces[i].category; 
			} 
			_auxBmdClean = new BitmapData(_bmp.bitmapData.width, _bmp.bitmapData.height);
		} 
		
		
		
		//TODO: Hacerlo depender de tamaños variables de pieza: 
		//Crear un _tilesheet por cada tamaño de pieza (Ej, pequeñas, medianas y grandes): diferenciar unas y otras por rangos de id de shape 
		//En el rect de copypixels establecer el tamaño de _shapeSize[] 
		/**
		 * Create initial piece shapes on puzzle (by default all pieces are in box, so all piece position shapes are included in the image)
		 * @param	pieces
		 */
		protected function createPiecesShapesImage(pieces: Vector.<Piece>):void {                                 
			_tileSheet = new ImaBitmapSheet(Assets.GfxSpritePieceShape, Assets.SPRITE_PIECESHAPE3_WIDTH, Assets.SPRITE_PIECESHAPE3_HEIGHT);                         
			var _bmdPiecesShapes: BitmapData = new BitmapData(Registry.gameRect.width, Registry.gameRect.height, true, 0); 
			for (var i:uint = 0; i < pieces.length; i++) { 
				_auxRect.setTo(0, 0, Assets.SPRITE_PIECESHAPE3_WIDTH, Assets.SPRITE_PIECESHAPE3_HEIGHT);
				_auxPoint.setTo(pieces[i].x, pieces[i].y);
				_bmdPiecesShapes.copyPixels(_tileSheet.getTile(pieces[i].category).bitmapData, _auxRect, _auxPoint, null, null,true); 
			}     
			//apply filter to all shapes
			_auxPoint.setTo(0, 0);
			_bmdPiecesShapes.applyFilter(_bmdPiecesShapes, Registry.gameRect, _auxPoint, new BevelFilter(2,-135));			
			
			_bmpPiecesShapes = new Bitmap(_bmdPiecesShapes);         
			
			//IOS: Filter applied to BMP does NOT WORK. Has to be applied to BMD
			//Apply bevel filter to all piece groups (whole bitmap)
	//		var f:BevelFilter = new BevelFilter(2, -135); 
	//		_bmpPiecesShapes.filters = [f]; 
			
			addChild(_bmpPiecesShapes); 
		} 
                		
		
		/** 
		* Update the piece positions (shape) layer (paint the free puzzle positions)         
		*/ 
		protected function updatePiecesShapesImage():void {                         
			//Borrar _bmpPiecesShapes 
	//		_auxPoint.setTo(0, 0);
	//		_bmpPiecesShapes.bitmapData.copyPixels(_auxBmdClean,_bmpPiecesShapes.bitmapData.rect, _auxPoint, null,null,true); 
			_bmpPiecesShapes.bitmapData.fillRect(_bmpPiecesShapes.bitmapData.rect,0x000000);
			
			
			//TODO: fixe size, till we make it dependant on idShape 
			var shapeHalfW:uint = Assets.SPRITE_PIECESHAPE3_WIDTH*0.5; 
			var shapeHalfH:uint = Assets.SPRITE_PIECESHAPE3_WIDTH*0.5; 
			
			//recorrer las posiciones de piezas y pintar las que estén libres en _bmpPiecesShapes 
			for(var i:uint=0; i < _numPieces; i++) { 
				//If the dst position is free, paint the shape. Obtain the idShape from the _mapDsts vector 
				if(_dststslist[i] == DSTSTS_FREE) { 
					_auxRect.setTo(0, 0, Assets.SPRITE_PIECESHAPE3_WIDTH, Assets.SPRITE_PIECESHAPE3_HEIGHT); //TODO: change to do it shape size dependant 
					_auxPoint.setTo(_dstGlobalPos[i].x - shapeHalfW, _dstGlobalPos[i].y - shapeHalfH); //Pos: obtener la pos up-le de la pieza 
					_bmpPiecesShapes.bitmapData.copyPixels(_tileSheet.getTile(_dstShape[i]).bitmapData, _auxRect, _auxPoint, null, null, true); //TODO: Variable shape size. Hacerlo depender de _shapeSize[idShape] 
				} 
			} 
			//apply filter to all shapes
			_auxPoint.setTo(0, 0);
			_bmpPiecesShapes.bitmapData.applyFilter(_bmpPiecesShapes.bitmapData, Registry.gameRect, _auxPoint, new BevelFilter(2,-135)); //DUDA: Necesario aplicar de nuevo el filtro (entiendo que sí ya que al limpiar el bmd se habrá perdido) 
		} 
		
		

		
		override public function setPieceInPuzzle(piece: Piece, dstPos: Point):void { 
			super.setPieceInPuzzle(piece, dstPos);
			updatePiecesShapesImage();	//update shape pieces		
		}
		
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

	}

}