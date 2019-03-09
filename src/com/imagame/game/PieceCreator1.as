package com.imagame.game 
{
	import adobe.utils.CustomActions;
	import avmplus.getQualifiedClassName;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.imagame.engine.ImaBackground;
	import com.imagame.engine.ImaSpriteAnim;
	import com.imagame.engine.ImaState;
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import com.imagame.utils.ImaBitmapSheetDirect;
	import com.imagame.utils.ImaCachedBitmap;
	import com.imagame.utils.ImaSubBitmapSheet;
	import com.imagame.utils.ImaSubBitmapSheetDirect;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	/**
	 * Creator of pieces with the following features:
	 * - Square pieces with same width and height and an color attribute 
	 * A puzzle to be created requires:
	 * - Create list of pieces
	 * - Create Destination positions for the pieces (relative positions)
	 * - Map each piece to every posible destination (a Map function for every position accepting a list of pieces --or kind of pieces--)
	 * @author imagame
	 */
	public class PieceCreator1 implements IPieceCreator 
	{		
		private var _pieces: Vector.<Piece>;
		private var _dstPos: Vector.<Point>;	//Destination local positions (local pos within _img puzzle image)
		private var _dstMapPiece: Vector.<uint>;
		
		private var _numPieces: uint;
		
		private var _id: uint;
		private var _img: Bitmap;		//Bmp sheet with four base puzzle images of a number

		//specific piece creator variables
		protected var _pieceWidth: uint; 
		protected var _pieceHeight: uint; 
		protected var _numPiecesWidth: uint; 
		protected var _numPiecesHeight: uint; 		
		
		/**
		 * 
		 * @param	id		Number: 1..9
		 * @param	img		Img sheet of the base puzzle images for the id number
		 * @param	w		Piece width
		 * @param	h		Piece height
		 * @return
		 */
		public function PieceCreator1(id: uint, img: Bitmap, w: uint, h: uint) //TODO: color vector parameter
		{
			trace("IPIECECREATOR >> PieceCreator1()");
			
			_id = id;
			_img = img;
			_pieceWidth = w;
			_pieceHeight = h;			
			_numPiecesWidth = _img.width / _pieceWidth; //TODO 
			_numPiecesHeight = _img.height / _pieceHeight; 
			_numPieces = _numPiecesWidth * _numPiecesHeight;	//6*7
			createPieces();	
			createDstPositions();
			mapPiecesToPositions();
		}
		
		public function destroy():void {
			for (var i:int = 0; i < _pieces.length; i++)
				_pieces[i].destroy();
			_pieces = null;
			for (var i:int = 0; i < _dstPos.length; i++)
				_dstPos[i] = null;
			_dstPos = null;
			_dstMapPiece = null;
			
		}
		
		
		
		/**
		 * Create a list of pieces <_pieces> from an image 
		 */
		protected function createPieces():void
		{			
			var _pieceTypes:Vector.<uint> = new Vector.<uint>(); // [0, 0, 1, 1, 0, 0, 0, 2, 3, 3, 0, 0, 0, 3, 3, 3, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 3, 3, 0, 0, 0, 2, 3, 3, 2, 0, 0, 1, 1, 1, 1, 0]);			
			switch(_id){
					case 1: //_pieceTypes.push(0, 0, 3, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0);
							_pieceTypes.push(0, 0, 3, 3, 0, 0,  0, 3, 3, 3, 0, 0,  0, 3, 3, 3, 0, 0,  0, 0, 3, 3, 0, 0,  0, 0, 3, 3, 0, 0, 0, 3, 3, 3, 3, 0, 0, 3, 3, 3, 3, 0);
						break;
					case 2: _pieceTypes.push(0, 1, 3, 3, 1, 0,  1, 3, 3, 3, 3, 0,  0, 1, 0, 3, 3, 0,  0, 0, 1, 3, 3, 0,  0, 1, 3, 3, 1, 0,  1, 3, 3, 3, 3, 1,  1, 3, 3, 3, 3, 1);							
							break;
					case 3: _pieceTypes.push(0, 2, 3, 3, 2, 0,  2, 3, 3, 3, 3, 4,  0, 0, 0, 3, 3, 4,  0, 0, 2, 3, 4, 0,  0, 0, 0, 3, 3, 4,  2, 3, 3, 3, 3, 4,  0, 2, 3, 3, 2, 0);
							break;	
					case 4: _pieceTypes.push(0,0,0,2,2,0, 0,0,1,7,3,0, 0,1,7,7,3,0, 1,7,3,7,3,0, 1,1,1,7,2,2, 0,0,0,7,3,0, 0,0,0,2,2,0);
							break;								
					case 5: _pieceTypes.push(0,2,2,2,2,0, 0,5,3,3,3,0, 0,5,7,7,0,0, 0,5,3,3,3,0, 0,0,0,1,1,3, 7,7,7,7,3,0, 0,2,2,2,2,0);
							break;								
					case 6: _pieceTypes.push(0, 0, 2, 2, 2, 0, 0, 8, 4, 4, 4, 0, 9, 8, 7, 7, 0, 0, 9, 8, 1, 1, 1, 7, 9, 8, 7, 0, 1, 7, 0, 8, 1, 1, 1, 7, 0, 2, 2, 2, 2, 0);
							break;								
					case 7: _pieceTypes.push(9,2,2,2,2,2, 9,4,4,4,4,2, 0,0,0,8,3,9, 0,0,8,3,5,0, 0,0,8,5,0,0, 0,8,3,5,0,0, 0,2,2,0,0,0);
							break;			
					case 8: _pieceTypes.push(0, 6, 1, 1, 6, 0, 6, 4, 4, 4, 4, 6, 9, 4, 9, 0, 3, 9, 0, 3, 3, 3, 3, 0, 9, 3, 0, 6, 7, 9, 6, 7, 7, 7, 7, 6, 0, 6, 1, 1, 6, 0 );
							break;
					case 9: _pieceTypes.push(0,8,1,1,8,0, 8,4,4,4,4,8, 3,4,0,0,5,3, 8,5,5,5,5,7, 0,8,8,3,7,3, 0,7,7,7,7,0, 0,1,1,1,0,0);
							break;
			}
			_pieces = new Vector.<Piece>(_numPieces);
			for (var i:uint = 0; i < _pieceTypes.length; i++)
				_pieces[i] = new Piece(i, _pieceTypes[i]);
			
			var _bmpSheetBox: ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxSpritePieceBox1, Assets.SPRITE_PIECEBOX1_WIDTH, Assets.SPRITE_PIECEBOX1_HEIGHT); 
			var _bmpSheetPuzzle: ImaSubBitmapSheet = new ImaSubBitmapSheet(Assets.numberImages[_id-1], _pieceWidth, _pieceHeight, new Rectangle(Assets.IMG_NUMBER_WIDTH, 0, Assets.IMG_NUMBER_WIDTH, Assets.IMG_NUMBER_HEIGHT)); //Tomamos solo la segunda imagen del asset
			
			//recorta el fondo sobre el que se pinta el número del puzzle
			var posPuzX: uint = (Registry.gameRect.width - _img.width) * 0.5; 
			var posPuzY: uint = Registry.appUpOffset + 16;					
			//Op1
			var _bmpSheetBkgDir: ImaBitmapSheetDirect = new ImaBitmapSheetDirect((Registry.game.getState() as ImaState).background.getImg(new Rectangle(posPuzX, posPuzY, _img.width, _img.height)), _pieceWidth, _pieceHeight);
			//var _bmpSheetBkgDir: ImaBitmapSheetDirect = new ImaBitmapSheetDirect((Registry.game.getState() as GameState).getBkg().getImg(new Rectangle(posPuzX, posPuzY, _img.width, _img.height)), _pieceWidth, _pieceHeight);
			//Op2	
			//var _bmpSheetBkgDir: ImaSubBitmapSheetDirect = new ImaSubBitmapSheetDirect((Registry.game.getState() as GameState).getBkg()._bmpBkg, _pieceWidth, _pieceHeight, new Rectangle(posPuzX, posPuzY, _img.width, _img.height));			
						
			for (var i:uint = 0; i < _numPieces; i++) {
				_pieces[i].addAnimation("InBox", _bmpSheetBox, null, null, calcFramesInBoxCB);
				_pieces[i].addAnimation("InBoxSelected", _bmpSheetBox, null, null, calcFramesInBoxSelectedCB, 5);
				_pieces[i].addAnimation("InPuzzle", _bmpSheetPuzzle, _bmpSheetBkgDir , null, calcFramesInPuzzleCB, 0, false, null, null); //array null: se calcula el frame de forma dinámica por función XXXX
			}
			//"InPuzzle" frames no son estáticos- Deben ser calculados en tiempo-ejecución en función de 
			//array de frames contenga todos los frames de la img, pero luego se fuerce el setFrame a la hora de realizar playAnim (manipular el _curFrame)			     
		}
		
		/**
		 * Create a list of destination positions for the list of pieces, based in 0,0 local origin.
		 */
		protected function createDstPositions():void {
			_dstPos = new Vector.<Point>(_numPieces);
			
			var dx:uint = _pieceWidth * 0.5;
			var dy:uint = _pieceHeight * 0.5;
			var val:uint = 0;
			for (var y:uint = 0; y < _numPiecesHeight; y++) {
				for (var x:uint = 0; x < _numPiecesWidth; x++) {
					val = y * _numPiecesWidth + x;
					if (val >= _numPieces)
						break;
					_dstPos[val] = new Point(_pieceWidth * x, _pieceHeight * y);
					_dstPos[val].offset(dx, dy);					
				}
				if (val >= _numPieces)
					break;
			}
			
			/*
			_dstPos[0] = new Point(0, 0);
			_dstPos[1] = new Point(_w, 0);
			_dstPos[2] = new Point(_w*2, 0);
			
			//Adjust registration point to center for each position
			var dx:uint = _w * 0.5;
			var dy:uint = _h * 0.5;
			for (var i:uint = 0; i < _dstPos.length; i++) {
				_dstPos[i].offset(dx, dy);
			}
			*/
		}
		
		/**
		 * Creates a list of objects to let check wich piece/s map to each dst position
		 */
		protected function mapPiecesToPositions():void {
			//_dstMapPiece = new Vector.<Object>(_numPieces);
			_dstMapPiece = new Vector.<uint>(_numPieces);
			
			/*
			_dstMapPiece[0] = { color:0, piezas:2 };
			_dstMapPiece[1] = { color:1, piezas:2 };
			_dstMapPiece[2] = { color:1, piezas:2 };
			*/
			
			/*
			_dstMapPiece[0] = 1;	//En la pos 0 va  pieza de tipo 1 (Piece.TYPE_COL1)
			_dstMapPiece[1] = 2;
			_dstMapPiece[2] = 0;
			_dstMapPiece[2] = 0;
			_dstMapPiece[2] = 0;
			_dstMapPiece[2] = 0;
			_dstMapPiece[2] = 0;*/
			
			for (var i:uint = 0; i < _numPieces; i++) {
				_dstMapPiece[i] = _pieces[i].category;
			}
		}
		
		/*----------------------------------------------------------------- Getters/Setters */
		
		public function getPieces():Vector.<Piece> { 
			return _pieces; 
		} 
		
		public function getNumOfPieceCategory(): uint {
			var _pieceCategory: Vector.<uint> = new Vector.<uint>;
			for each (var piece:Piece in _pieces) 
				if (_pieceCategory.indexOf(piece.category) == -1)
					_pieceCategory.push(piece.category);
			return _pieceCategory.length - 1; //we substract NON USE CATEGORY
		}

		public function calcFramesInBoxCB(spr: ImaSpriteAnim, bs: ImaBitmapSheet, idx:uint):int {
			return ((spr as Piece).category-1) * 4;	//4 (number of tiles in width)
		}
		
		public function calcFramesInBoxSelectedCB(spr: ImaSpriteAnim, bs: ImaBitmapSheet, idx:int):int {
			//trace("cat: " + (spr as Piece).category + "  idx: " + idx);
			var lim:uint = ((spr as Piece).category ) * 4;
			if (idx < lim - 4)
				idx = lim - 4;
			else
				idx++;
			if (idx >= lim)
				idx = lim - 4;
			return idx;
		}
		
		/**
		 * Calculate number of frame for the "InPuzzle" Animation 
		 * - Convert from idxPosition within Assets.numberImages[0] to idxFrame in bs
		 * @param	bs
		 * @param	idx	(index in the 6x7 number grid)
		 * @return	global idx in the (6*4 x 7 grid)
		 */
		public function calcFramesInPuzzleCB(spr: ImaSpriteAnim, bs: ImaBitmapSheet, idx:uint):int {
			var x:uint = idx % _numPiecesWidth;
			var y:uint = idx / _numPiecesWidth;
			//return (6 + 24 * y + x);  //Para el caso de que no usemos SubBitmapSheet
			return (_numPiecesWidth * y + x);
		}

		/* INTERFACE com.imagame.game.IPieceCreator */
		
		public function createPuzzle(): AbstractPuzzle {
			return (new Puzzle1(0, _pieces, _dstPos, _dstMapPiece));		
		}		
		
	}

}