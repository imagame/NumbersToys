package com.imagame.game 
{
	import com.imagame.engine.ImaButton;
	import com.imagame.engine.ImaIcon;
	import com.imagame.engine.ImaTimer;
	import com.imagame.engine.Registry;
	import com.imagame.fx.ImaFx;
	import com.imagame.fx.ImaFxCircularProgressCtrl;
	import com.imagame.utils.ImaUtils;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.osflash.signals.Signal;

	/**
	 * Box with piece categories as In-Box pieces and rest of pieces as Out-Box pieces
	 * Number of inbox Pieces: Same as _pieceCategories values, equal to number o elements in _srcId an _srclist
	 * @author imagame
	 */
	public class Box1 extends AbstractBox 
	{		
		//Piece selection                 
		private var _idxSelected: int;		//idx in _srcId, _srclist and _pieceCategory for the selected piece in InBox
		private var _sprSelectedFx: ImaFxCircularProgressCtrl;        //FX Sprite to show selected piece and selection time progress 
		
		public var signalPieceSelection: Signal;		//Signal to be dispatched when a new piece is selected (automatic selection)

		protected static const STS_NEXTPIECE:uint = STS_001;
		
		
		//public function Box1(id:uint, iniy: uint, pieces:Vector.<Piece>) 
		public function Box1(id:uint, pieces:Vector.<Piece>) 
		{ 
			super(id, pieces); 
			trace("ABSTRACTBOX >> Box1() " + id);
											
			//Adjust _category to remove dummy category (0)
			
			_pieceCategory.splice(_pieceCategory.indexOf(0), 1); //remove category with value = 0
			_numCategories = _pieceCategory.length; 

			setSrcPosList();        //Define src positions (but there is still no assignment to any piece) 	
			
			//FX: Circular progress in selected box 
			// [CONFIG] Game difficulty parametrization
			var freq:Number;		
			switch(Registry.gpMgr['round']){
				case 0:
					if(id <= 2)	//Phases 0,1,2
						freq = 0.07;
					else if (id <= 5) //Phases 3,4,5
						freq = 0.05;
					else	//Phases 6,7,8
						freq = 0.04;
					break;
				case 1:
					freq = 0.04;
					break
				default:
					freq = 0.03;			
			}
			_sprSelectedFx = new ImaFxCircularProgressCtrl(32,0xffffff,8,freq,freq * 72,onEndFxCircularProgress); //De 1.2 a 4.8
			//_sprSelectedFx = new ImaFxCircularProgressCtrl(32,0xffffff,8,0.05,3.6,onEndFxCircularProgress); //De 1.2 a 4.8
			//_sprSelectedFx = new ImaFxCircularProgressCtrl(32,0xffffff,8,0.01,1.2,onEndFxCircularProgress);
			addChild(_sprSelectedFx);
						
			//Signals definition
			signalPieceSelection = new Signal();			
		} 
		
		override public function destroy():void { 
			//TODO delete components
			removeChild(_sprSelectedFx); 
			_sprSelectedFx.destroy(); 
			_sprSelectedFx = null; 
			
			signalPieceSelection.removeAll();
			signalPieceSelection = null;
			super.destroy(); 
		} 
		
		/** 
		* Initializes pieces contained in box (position and visible status) 
		*/ 
		override public function init():void {  
			//Apply default init piece method to all pieces
			for (var i:uint = 0; i < _members.length; i++) { 
				(_members[i] as Piece).init(); 
			} 
			
			_idxSelected = -1;
			
			//select initial pieces to assign to InBox src positions: the first piece of each category
			_srcId = new Vector.<int>(_numCategories); 
			var idx:uint = 0;
			for (var c:uint = 0; c < _numCategories; c++) {
				var piece:Piece = retrieveByCategory(_pieceCategory[c]);  
				setPieceInBoxPos(piece, idx); 
				idx++;
			}
					
			//Select initial piece
			setPieceSelected(getNextPieceSelected());	//starts the imaFxCircularProgressCtrl locating it on the selected piece 
 					
			super.init();        //Move on active state 
		} 
 
		/** 
		 * Exit function called when moving from STS_DYING to STS_DEAD, or directly from gamestate exit func 
		 * Closed and consolidate logic data 
		 */ 
		override public function exit():void { 
			_sprSelectedFx.stopFx(true);	//stops the Fx
		}   		

		
		
		 /** 
		 * Define de initial positions for sprites. Options: 1,2,3,4,5,6 (number of pieces in In-Box)
		 * To be executed once in the creation of the Box 
		 */ 
		private function setSrcPosList():void {   
			_srclist = new Vector.<Point>(_numCategories); 

			var numLe: uint = Math.floor(_numCategories/2); 
			var numRi: uint = _numCategories - numLe; 
				
			var boxAdjW: uint = 16;                        //pixels of w adjustment, to bring the piece (Src pos) close to the puzzle 
			var boxW: uint = (Registry.gameRect.width - Assets.IMG_NUMBER_WIDTH) * 0.5 
			var xle:uint = boxW * 0.5 + boxAdjW; 
			var xri:uint = boxW + Assets.IMG_NUMBER_WIDTH + boxW * 0.5 - boxAdjW; 
				
			var boxAdjH: uint = Registry.appUpOffset+26;                //pixels of h adjustment, to jump over the fixed initial space (16) and the HUD buttons h space (32) 
			var boxH: uint = (Assets.IMG_NUMBER_HEIGHT + 32);        //remove the fixed 32 pixels of HUD buttons 
			//var boxAdjH2: uint = Registry.appUpOffset+16+32;                //pixels of h adjustment, to jump over the fixed initial space (16) and the HUD buttons h space (32) 
			//var boxH2: uint = (Assets.IMG_NUMBER_HEIGHT - 32);        //remove the fixed 32 pixels of HUD buttons 
			
			
			var yle: Vector.<uint> = new Vector.<uint>(numLe); 
			var yri: Vector.<uint> = new Vector.<uint>(numRi); 
				
			var sepleY:uint = (boxH - pieceMaxHeight * numLe) / (numLe + 1);
			var sepriY:uint = (boxH - pieceMaxHeight * numRi) / (numRi + 1); 
				
			for(var i:uint = 0; i< numLe; i++){ 
				_srclist[i] = new Point(); 
				_srclist[i].x = xle; 
				_srclist[i].y = boxAdjH + sepleY * (i+1) + pieceMaxHeight * i + pieceMaxHeight*0.5; 
			} 
			for(var i:uint = 0; i< numRi; i++){ 
				_srclist[i+numLe] = new Point(); 
				_srclist[i+numLe].x = xri; 
				_srclist[i+numLe].y = boxAdjH + sepriY * (i+1) + pieceMaxHeight * i + pieceMaxHeight*0.5; 
			}                         			
		}                 
		
		

		/*-------------------------------------------------------------------------- Getters / Setters */

		public function getCategorySelected():uint {
			return _pieceCategory[_idxSelected];		
		}
		
		/**
		 * Returns a vector indicating the number of pieces in puzzle for each piece category. (-1: cat not in puzzle, 1..N: number of pieces of that category in the box) 
		 * @return	vector of 9 positions, with -1 value, or >0 values.
		 */
		public function getExistCategories():Vector.<int> { 
				var v: Vector.<int> = new Vector.<int>(9); 
				
				v.push(0,0,0,0,0,0,0,0,0); 
				for(var i:uint=0; i < _members.length; i++) { 
					v[(_members[i] as Piece).category]++; 
				} 
				for(var i:uint=0; i < 9; i++) 
					if(v[i] ==0 ) 
						v[i]=-1; 
				
				return v; 
		} 
		
		/**
		 * Obtain a new Piece in box to set it the Selected one. Method to get the next piece is based on level difficulty.
		 * @return
		 */
		protected function getNextPieceSelected():int {
			if (_idxSelected == -1)
				return getSequencePieceSelected();
			else
				return getRandomPieceSelected();
		}
		
		/**
		 * Obtain the next piece in-box to make it the selected piece.
		 * Rules: Has to exist in in-box (_srcId <> -1) and has to be different than the current selected piece (except if there is only one piece category left)
		 * @return	idx of _srcId, -1 if there is no more pieces in in-box
		 */
		protected function getSequencePieceSelected():int { 
			var bFound: Boolean = false;
			var idx:uint; //Start from the next piece after the selected one
			for (idx = (_idxSelected+1)%_numCategories; idx < _numCategories; idx++){
				if (_srcId[idx] != -1) {
					if(idx != _idxSelected) {
						bFound = true;
						break;
					}
				}
			}
			if (bFound) {
				return idx; //next value <> 1 (if sequence rule applied)
			}
			else {
				for (idx = 0; idx < _idxSelected; idx++) {
					if (_srcId[idx] != -1) 
						return idx;
				}
				if (_srcId[_idxSelected] != -1) {//case: there is only one piece category let
					return _idxSelected;
				}else
					return -1; //if all values of _srcId are -1
			}
		} 
		
		/** 
		 * Obtain a random piece in-box to make it the selected piece. (random: not the next in sequence) 
		 * Rules: Has to exist in in-box (_srcId <> -1) and has to be different than the current selected piece (except if there is only one piece category left) 
		 * @return        idx of _srcId, -1 if there is no more pieces in in-box 
		 */ 
		protected function getRandomPieceSelected():int { 
			var bFound: Boolean = false; 
			
			//chk si existe al menos un idx<>-1 distinto a _idxSelected 
			var idx:uint; //Start from the next piece after the selected one 
			for (idx = 0; idx < _numCategories; idx++){ 
				if (_srcId[idx] != -1) { 
					if(idx != _idxSelected) { 
						bFound = true; 
						break; 
					} 
				} 
			} 
			//en caso afirmativo obtener uno al azar <> _idxSelected 
			if(bFound) { 
				do { 
					idx = (uint)(ImaUtils.randomize(0, _numCategories));                         
				//} while (_srcId[_idxSelected] == -1 || idx == _idxSelected) 
				} while(_srcId[idx] == -1 || idx == _idxSelected) 
				return idx; 
			}                                         
			//en caso negativo, si _idxSelected <>-1 devolver este, y sino -1 
			else { 
				if (_srcId[_idxSelected] != -1) //case: there is only one piece category let 
					return _idxSelected; 
				else 
					return -1; //if all values of _srcId are -1 
			}                         
		}		
		
		/*-------------------------------------------------------------------------- Piece operations */

		/**
		 * Add piece to Box, setting in box if there its category is not in box
		 * @param	piece	Piece to put in box
		 */
		override public function setPieceInBox(piece: Piece):void {
			super.setPieceInBox(piece);	//adds to Box if piece comes from outside (puzzle)
			
			//Check if the piece belongs to a category not included In Box. If so, add it to in box
			var idx:uint = _pieceCategory.indexOf(piece.category);
			if (_srcId[idx] == -1) {
				setPieceInBoxPos(piece, idx); 
			}			
		}

		/**
		 * Set a piece in Box in a given position
		 * @param	piece	Piece to put in box
		 * @param	idx		In-Box idx position to put the piece
		 */
		private function setPieceInBoxPos(piece: Piece, idx: uint):void { 
			_srcId[idx] = piece.id; 
			piece.playAnimation((idx==_idxSelected)?"InBoxSelected":"InBox"); 
			piece.updPutInBox(); 
			piece.setSrcPos(_srclist[idx]); 
		}   		
		
		/**
		 * Remove piece from in-box and replace it by one with the same category from out-box (if any exist)
		 * @param	piece
		 */
		override public function removePieceFromBox(piece: Piece): void { 
			super.removePieceFromBox(piece);	//remove the piece from the group
			
			var idx:uint = _srcId.indexOf(piece.id);
			
			if (piece.situation == Piece.SIT_BOX_IN) { //piece in _srcID, has to be reset
				var replacePiece:Piece = retrieveByCategory(piece.category);
				if (replacePiece == null) {
					_srcId[idx] = -1;
					_sprSelectedFx.stopFx();
					_sts = STS_NEXTPIECE; 
				}
				else { //Move from OUT-BOX to IN-BOX
					setPieceInBoxPos(replacePiece, idx);    
				}
			}
			//if piece is OutBox nothing else to do
		} 
		
 
		
		/**
		 * Set the new selected piece, and starts the selection duration timer. 
		 * @param	idxId
		 */
		protected function setPieceSelected(idxId: int):void {
			_idxSelected = idxId;
			if (idxId == -1)
				trace("<< ERROR >> Box1.setPieceSelected IDX -1");
			
			//Fx Selection zoom 
			ImaFx.imaFxZoomOut(this, retrieve(_srcId[idxId]), 8, 0.4, true, null);                         
       		//ImaFx.imaFxZoomOut(this, retrieve(_srcId[idxId]), 8, 2, true, null);                         
                        
			//Fx Piece CircularProgressCtrl 
			_sprSelectedFx.x = _srclist[idxId].x;
			_sprSelectedFx.y = _srclist[idxId].y;
			_sprSelectedFx.startFx();        //False: inits from scratch 

			//Change animation for selected piece in box 
			(retrieve(_srcId[idxId]) as Piece).playAnimation("InBoxSelected"); 
                        
			//Dispatch signal 
			signalPieceSelection.dispatch(_pieceCategory[_idxSelected]);
		}

		
		//------------------------------------------------------------------- Callbacks
		
		/**
		 * Callback called from CircularProgressFX when is completed
		 */
		protected function onEndFxCircularProgress():void { 
			_sprSelectedFx.stopFx(); //pauses and hides the Fx
			addChildAt(_sprSelectedFx, this.numChildren); //take it to the front
			_sts = STS_NEXTPIECE; 
			
			//Change animation to nonselected piece in box 
			(retrieve(_srcId[_idxSelected]) as Piece).playAnimation("InBox"); 			
		} 
                    
	             		
				
		/** 
		 * Update group sprites execution: call each sprite update() method, and chk exit group condition 
		 */                 
		override public function update():void { 
			super.update();  ///std behavior: para cada sprite de _members llama a update() 
				
			//Check if final condition is just met (if all face sprites are positiones in dst positions) 
			if(_sts != STS_FINISHED) { 
				if (_sts == STS_NEXTPIECE) { //final condition: There is no next piece category (all have been put in puzzle)
										
					var idx:int = getNextPieceSelected(); 					
					if(idx == -1) { 
						_sts = STS_FINISHED;																
					} 
					else { //select next piece category and move on active state (keep playing)
						_sts = STS_ACTIVE; 						
						setPieceSelected(idx);	//starts Fx
					} 
				} 
			} 
		} 		
}

}