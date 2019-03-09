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
	import flash.display.BitmapData;
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
	public class PieceCreator2 implements IPieceCreator 
	{		
		private var _pieces: Vector.<Piece>;
		private var _dstPos: Vector.<Point>;	//Destination local positions (local pos within _img puzzle image)
		private var _dstMapPiece: Vector.<uint>;
		
		private var _numPieces: uint;
		
		private var _id: uint;
		private var _img: Bitmap;		//Bmp sheet with four base puzzle images of a number
		
		/**
		 * Creator of Puzzle-2
		 * @param	id		Number: 1..9
		 * @param	img		Img sheet of the base puzzle images for the id number
		 * @param	w		Piece width
		 * @param	h		Piece height
		 * @return
		 */
		public function PieceCreator2(id: uint, img: Bitmap) 
		{
			trace("IPIECECREATOR >> PieceCreator2()");
			
			_id = id;
			_img = img;
			
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
			//Define pieces
			//[CONFIG] Game Difficulty parametrization			
			var _piecesPos: Vector.<uint> = new Vector.<uint>;
			
			switch(Registry.gpMgr['round']) {
				case 0: 
					switch(_id){
						case 1:	_piecesPos.push(32, 0, 96, 96,  64, 96, 64, 64,  32, 160, 128, 64);	//x,y, dstw, dsth
								//_piecesPos.push(32, 8, 96, 88,  64, 96, 64, 64,  32, 160, 128, 64);	//x,y, dstw, dsth
								break;
						case 2:	_piecesPos.push(16, 8, 80, 72,  96, 8, 72, 72,  32, 80, 128, 64,  16,144,160,72);	//4 pieces
								break;
						case 3:	_piecesPos.push(16, 8, 160, 64,  102, 72, 80, 72,  56, 80, 48, 56,  16, 152, 88, 64,  104, 144, 80, 72);	//5 pieces
								//_piecesPos.push(16,8,192,64,  102,72,80,72,  56,80,48,56,  16,152,88,64, 104,144,80,72);	//x,y, dstw, dsth
								break;
						case 4:	_piecesPos.push(16,16,80,96,  96,8,64,72,  96,80,64,40,  8,112,64,56,  72,120,112,48,  96, 168, 64,48);	//6 pieces
								break;
						case 5:	_piecesPos.push(24,8,72,56,  96,8,72,56,  24,64,64,64,  88,72,88,80,  16,152,88,64,  104,152,72,64); //6 pieces
								break;
						case 6: _piecesPos.push(88,8,80,56,  16,8,72,72,  16,80,72,72,  88,72,96,64,  16,152,96,64,  112,136,72,80); //6 pieces
								break;
						case 7: _piecesPos.push(16,8,48,56,  64,8,40,56,  104,8,72,64,  72,72,48,48,  120,72,48,80,  40,120,48,56,  88,120,32,56,  24,176,88,40); //8 pieces
								break;	
						case 8: _piecesPos.push(56,8,56,48,  16,16,40,96,  112,8,64,80,  56,56,56,56,  8,112,104,48,  112,88,72,72,  8,160,80,56,  88,160,96,56); //8 pieces
								break;	
						case 9: _piecesPos.push(16, 8, 64, 56,  80, 8, 96, 48,  8, 64, 80, 40,  104, 56, 72, 48,  16, 104, 80, 48,  96, 104, 80, 48,  96, 152, 72, 64,  24, 160, 72, 56); //8 pieces						
								break;						
					}		
					break;
				
				default: //Case >= 2
					switch(_id){
						case 1:	_piecesPos.push(64,8, 72,32,  24,40, 40,40,  64,40, 72,40,  64,80, 72,40,  64,120, 72,40,  24,168, 40,48,  64,160, 64,56,  128,168, 40,48 );	//8 pieces
								break;
						case 2:	_piecesPos.push(16,8, 72,72,  88,8, 80,40,  88,48, 80,40,  40,88, 64, 56,  104,88, 64, 56,  16,144, 40, 72,  56,144, 64,72,  120,160, 56, 56 );	//8 pieces
								break;
						case 3:	_piecesPos.push(16,8, 72,64,  88,8, 80,56,  112,64, 56,48,  56,80, 56,56,  112,112, 64,56,  16,152, 40,64,  56,160, 56,56,  112,168, 64,48);	//8 pieces
								break;
								
						case 4:	_piecesPos.push(16, 16, 80, 64,  16, 80, 48, 32,  64, 80, 32, 32,  96, 8, 64, 40,  96, 48, 64, 32, 
								96,80,64,40,  8,112,64,56,  72,120,56,48,  128,120,56,48,  96, 168, 64,48);	//10 pieces
								break;
						case 5:	_piecesPos.push(24, 8, 72, 56,  96, 8, 72, 56,  24, 64, 64, 32,  24, 96, 64, 32,  88, 72, 40, 80,  
								128,72,48,80,  16,152,48,64,  64,152,40,64,  104,152,72,32,  104,184,72,32); //10 pieces
								break;
						case 6: _piecesPos.push(88, 8, 80, 56,  16, 8, 72, 72,  16, 80, 72, 40,  16, 120, 72, 32,  88, 72, 48, 64,
								136,72,48,64,  16,152,56,64,  72,152,40,64,  112,136,72,32,  112, 168,72,48); //10 pieces
								break;
								
						case 7: _piecesPos.push(16, 8, 48, 56,  64, 8, 40, 56,  104, 8, 40, 64,  144, 8, 32, 64,  72, 72, 48, 48,  120, 72, 48, 32,
								120,104,48,48,  40,120,48,32,  40,152,48,24,  88,120,32,56,  24,176,40,40,  64,176,48,40); //12 pieces
								break;	
						case 8: _piecesPos.push(56, 8, 56, 48,  16, 16, 40, 48,  16, 64, 40, 48,  112, 8, 64, 40,  112, 48, 64, 40, 56, 56, 56, 56,
								8,112,64,48,  72,112,40,48,  112,88,72,72,  8,160,80,56,  88,160,48,56,   136,160,48,56); //12 pieces
								break;	
						case 9: _piecesPos.push(16, 8, 64, 56,  80, 8, 48, 48,  128, 8, 48, 48,   8, 64, 80, 40,  104, 56, 72, 48,  16, 104, 48, 48,  
								64, 104, 32, 48,  96,104,48,48,  144,104,32,48,  24,160,72,56,  96,152,72,32,  96,184,72,32); //12 pieces
								break;						
					}		
							
			}
			
			
			
			//Create the defined pieces
			_numPieces = _piecesPos.length / 4;
			_pieces = new Vector.<Piece>(_numPieces);
			for (var i:uint = 0; i < _numPieces; i++) {
				var pos:uint = i * 4;
				_pieces[i] = new Piece2(i, _piecesPos[pos + 2], _piecesPos[pos + 3]);	//create piece setting dst w and dst h
				_pieces[i].x = _piecesPos[pos];		//Set x local position in puzzle, require to calculate dst position
				_pieces[i].y = _piecesPos[pos + 1];	//Set x local position in puzzle, require to calculate dst position
				
				//Op 1: crear bitmapsheet con un solo frame que coincide justamente con el recorte del número que se corresponde con la pieza en curso
				var bmpSheetPiece: ImaSubBitmapSheet = new ImaSubBitmapSheet(Assets.numberImages[_id-1], _piecesPos[pos + 2], _piecesPos[pos + 3], new Rectangle(Assets.IMG_NUMBER_WIDTH*2+_piecesPos[pos], _piecesPos[pos + 1], _piecesPos[pos + 2], _piecesPos[pos + 3])); //Tomamos solo el trozo de img (la pieza), como imagen única de todo el bitmpasheet
			
				//Op 2: recorta dinamicamente la subimagen de _img, según pos y ancho,alto
				//var bmd:BitmapData = getSubImg(_piecesPos[pos], _piecesPos[pos + 1], _piecesPos[pos + 2], _piecesPos[pos + 3]); 
				
				//create anim with only 1 image
				_pieces[i].addAnimation("InBox", bmpSheetPiece, null, [0]); //necesario null y [0] ??
				_pieces[i].addAnimation("InPuzzle", bmpSheetPiece, null, [0]);
			}
		}
		
		/**
		 * Create a list of destination positions for the list of pieces, based in 0,0 local origin.
		 */
		protected function createDstPositions():void {
			_dstPos = new Vector.<Point>(_numPieces);			
					
			for (var i:uint = 0; i < _numPieces; i++) {
				_dstPos[i] = new Point(_pieces[i].x + _pieces[i].w * 0.5, _pieces[i].y + _pieces[i].h* 0.5);	//Adjust registration point to center for each position
			}			
		}
		
		/**
		 * Creates a list of objects to let check wich piece/s map to each dst position
		 */
		protected function mapPiecesToPositions():void {
			_dstMapPiece = new Vector.<uint>(_numPieces);
			for (var i:uint = 0; i < _numPieces; i++) {
				_dstMapPiece[i] = i;
			}
		}
		
		/*----------------------------------------------------------------- Getters/Setters */
		
		
		public function getPieces():Vector.<Piece> { 
			return _pieces; 
		} 
		
		
		/* INTERFACE com.imagame.game.IPieceCreator */
		
		public function createPuzzle(): AbstractPuzzle {
			return (new Puzzle2(0, _pieces, _dstPos, _dstMapPiece));		
		}
		

		
	}

}