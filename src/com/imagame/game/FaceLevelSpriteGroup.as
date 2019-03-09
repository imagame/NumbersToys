package com.imagame.game 
{ 
	import com.greensock.TweenLite; 
	import com.imagame.engine.ImaIcon; 
	import com.imagame.engine.ImaTimer; 
	import com.imagame.engine.Registry; 
	import flash.display.Sprite; 
	import flash.geom.Matrix; 
	import org.osflash.signals.Signal;
	
	import com.imagame.engine.ImaButton; 
	import com.imagame.engine.ImaSprite; 
	import com.imagame.engine.ImaSpriteGroup; 
	import com.imagame.utils.ImaBitmapSheet; 
	import com.imagame.utils.ImaCachedBitmap; 
	import flash.display.Bitmap; 
	import flash.geom.Point; 
	import flash.geom.Rectangle; 
	import flash.utils.getTimer; 
	
	/** 
	 * Group of FaceLevelSprite objects with source postions and destination goal positions 
	 * Goal: Container of moveable sprites that have to be manually dragged from initial source positions to valid unsorted destination positions. 
	 * Functionality added to ImaSpriteGroup: 
	 * - Define source and destination positions for a different range of number of members (from 1 to 9) 
	 * - Add operation extension to assign source position to new member in group 
	 * - Add check controls to detect drop correct position and update dst position status 
	 * - Control final group condition, and set a timer to execute level button open status when final condition is met 
	 * Consequences: 
	 * - FaceLevelSprites must be added to group to start group functionality 
	 * - Dragging behaviour and touch events are included in FaceLevelSprite 
	 * - Reaction methods to drop (fix to its dst -success drop- or return to its source -fail drop-) are included in FaceLevelSprite 
	 * @author imagame 
	 */         
	public class FaceLevelSpriteGroup extends ImaSpriteGroup 
	{                 
			private var _num: uint;        //Total number of final members                 
			private var _idx: uint;        //Current number of members (0.._num) (since members are added individually, not at once) 
			private var _phase: uint;        //Phase of numbers [1..3] 
			
			private var _dragArea: Rectangle;        //dragging area for the sprite members (graphic area + le_ri borders + bottom border for src pos) 
			private var _srclist: Vector.<Point>;         //List of source positions, with centered registration point 
			private var _dstlist: Vector.<Point>; 
			private var _dststslist: Vector.<uint>; 
			private var _bmplist: Vector.<Bitmap>; 
			private var _radio:Number; // distance to check dst correct position 

			private var _srcw: uint; 
			private var _srch: uint;                 
			private var _dstw: uint; 
			private var _dsth: uint; 
			
			private var _bmpPosSheet: ImaBitmapSheet; //graphics tilesheet 
			
			public var signalComplete: Signal; //To notify once all faces are located in dst pos 
			
			/** 
			 * Faces Level Sprite group constructor 
			 * @param        num        Number that is included in the group (1..9) 
			 * @param          phase        Number of game phase [1..3]. Size of face sprites depends on this value. 
			 * @param        x        x initial position in screen 
			 * @param        y        y initial position in screen 
			 */ 
			public function FaceLevelSpriteGroup(num: uint, phase: uint, x: int, y: int) 
			{ 
					_num = num;               
					_phase = phase;                         
					
					//Create level area graphic 
					_tileSheet = new ImaBitmapSheet(Assets.GfxMenuLevel, Assets.LEVEL_MENU_WIDTH, Assets.LEVEL_MENU_HEIGHT); 
					_bmp = _tileSheet.getTile(num -1); 
					addChild(_bmp); 
					_bmp.visible = false;
					
					width = Assets.LEVEL_MENU_WIDTH; 
					height = Assets.LEVEL_MENU_HEIGHT; 
					

					//Set source and destination size position and Get bitmaps for each dst pos 
					switch(_phase) { 
							case 1: 
									_srcw = Assets.SPRITE_FACE1_WIDTH; 
									_srch = Assets.SPRITE_FACE1_HEIGHT; 
									_dstw = Assets.SPRITE_FACEDST1_WIDTH; 
									_dsth = Assets.SPRITE_FACEDST1_HEIGHT; 
									_bmpPosSheet = new ImaBitmapSheet(Assets.GfxSpriteFace1Dst, _dstw, _dsth); 
									break; 
							case 2: 
									_srcw = Assets.SPRITE_FACE2_WIDTH; 
									_srch = Assets.SPRITE_FACE2_HEIGHT;                                 
									_dstw = Assets.SPRITE_FACEDST2_WIDTH; 
									_dsth = Assets.SPRITE_FACEDST2_HEIGHT; 
									_bmpPosSheet = new ImaBitmapSheet(Assets.GfxSpriteFace2Dst, _dstw, _dsth); 
									break;                                                                         
							case 3: 
									_srcw = Assets.SPRITE_FACE3_WIDTH; 
									_srch = Assets.SPRITE_FACE3_HEIGHT;                                 
									_dstw = Assets.SPRITE_FACEDST3_WIDTH; 
									_dsth = Assets.SPRITE_FACEDST3_HEIGHT; 
									_bmpPosSheet = new ImaBitmapSheet(Assets.GfxSpriteFace3Dst, _dstw, _dsth); 
									break;                                         
					} 
											
					//init src, dst positions and dragging area 
					initDragArea(); 
					initSrcPos(); 
					initDstPos(); 


					//Displays bitmaps in dsto positions 
					_bmplist = new Vector.<Bitmap>(_num); 
					for (var i:int = 0; i < num; i++) { 
							_bmplist[i] = _bmpPosSheet.getTile((_num -(_phase-1)*3 - 1) * 2 + _dststslist[i]); //status 0: 1er png, status 1: 2ºpng 
							_bmplist[i].x = _dstlist[i].x - _dstw * 0.5; 
							_bmplist[i].y = _dstlist[i].y - _dsth * 0.5; 
							addChild(_bmplist[i]);                                                                 
					} 
			
							
					this.x = x; 
					this.y = y; 
					_radio = _dstw; 
					
					signalComplete = new Signal(); 
					
					super(num - 1); 
					cacheAsBitmap = false;	//avoid cache to keep pices in in-box correctly painted in its group position
			} 
			
			override public function destroy():void { 
					//TODO destroy all except sprite children 
					_dragArea = null; 
					for (var i:int = 0; i < _num; i++){ 
							_srclist[i] = null; 
							_dstlist[i] = null; 
							_bmplist[i] = null; 
					} 
					_srclist = null; 
					_dstlist = null; 
					_dststslist = null; 
					_bmplist = null; 
					
					_bmpPosSheet = null; 
					signalComplete.removeAll(); 
					signalComplete = null; 

					super.destroy(); //perform remove of _members 
			} 
			
			/** 
			 * Init function called when panelMenuFase1 is getting visible (no effect when is first time called) 
			 * Actions: put visible sprites in source positions, dst status set to free (0), set level button inactive (hidden). 
			 */ 
			override public function init():void {   
				super.init(); 
				//trace("LevelSpriteGroup->init() : " + id + "(sts: "+_sts+")"); 
				for (var i:int = 0; i < _num; i++) { 
					(_members[i] as FaceLevelSprite).init(); 
					(_members[i] as FaceLevelSprite).setSrcPos(_srclist[i]); //put sprite in source position 
					setDstPosStatus(i, true);        //Set i pos to free pos 
				} 
			} 
			  
			/** 
			 * Exit function called when exiting the panel and returning to the main menu panel 
			 */ 
			override public function exit():void { 
					trace("LevelSpriteGroup->exit() : " + id);                 
			  //      _btFrmLevelTimer.stop(); //Stop the timer, though it is not started 
			} 
			 
			
			 //------------------------------------------------------- standar group operations 
			
			override public function add(spr: ImaSprite):void { 
					_idx++; 
					/* 
					if(_idx > _num){ 
									//throw argument exception 
					} 
					*/ 
					var facespr:FaceLevelSprite = (spr as FaceLevelSprite);                         
					
					facespr.setGroup(this); //Indicate group to member                                 
					facespr.setSrcPos(_srclist[_idx - 1]); //assign src pos based in total numbers of members and idx of current membe 
					facespr.setDragArea(_dragArea); 
					
					super.add(spr);                         
			} 
			
			//Avoid removing individual sprites   
			override public function remove(spr: ImaSprite):Boolean { 
					return false; 
			} 
  
			//-------------------------------------------------------- group initialization 
			private function initDragArea():void { 
					switch(_phase){ 
							case 1: 
									_dragArea = new Rectangle(x - 8, y, width + 16, height + 16); //44: sprite max height                         
									break; 
							case 2: 
									_dragArea = new Rectangle(x - 8, y, width + 16, height + 8 + _srch); //4+4                         
									break; 
							case 3: 
									_dragArea = new Rectangle(x - 8, y, width + 16, height + 20 + _srch); //8+12                         
									break; 
					} 
			} 
		   /** 
			 * Define de initial positions for _num sprites within the area delimited by init pos x,y, with _bmp.w , _bmp.h area (inferior area of 3x3 quadrants) 
			 */ 
			private function initSrcPos():void {                         
					_srclist = new Vector.<Point>(_num);        //list of source positions (mid reg points) 
													
					switch(_phase){ 
							case 1: 
									//Sprites located in one single line 
									var sepx = (width + 16 - _srcw * _num) / (_num + 1);        //16: 8 pixels extended in each area side 
									for (var i:int = 0; i < _num; i++) { 
													_srclist[i] = new Point(); 
													_srclist[i].x = -8 + (i + 1) * sepx + i * _srcw + _srcw * 0.5;         //Src: x-center reg point 
													//_srclist[i].y = height + 8 + _srch * 0.5; //Src: y-center reg point 
													_srclist[i].y = height + 16 + _srch * 0.5; //Src: y-center reg point 
									} 
									break; 
									
							case 2:         
									var numUp: uint = _num%2 + _num/2;        //4:2, 5:3, 6:3, 7:4, 8:4, 9:5 (Number of sprites in the upper line) 
									var sepx1 = (width + 16 - _srcw * numUp) / (numUp + 1);        //sprite horz separation in the upper line 
									var sepx2 = (width + 16 - _srcw * (_num-numUp)) / (_num - numUp + 1);        //sprite horz separation in the bottom line 
									var sepy = _srch + 4;         
									for (var i:int = 0; i < numUp; i++) { 
											_srclist[i] = new Point(); 
											_srclist[i].x = -8 + (i + 1) * sepx1 + i * _srcw + _srcw * 0.5; 
											//_srclist[i].y = height + 8 + _srch * 0.5; 
											_srclist[i].y = height + 4 + _srch * 0.5; 
									} 
									for (var i:int = 0; i < (_num - numUp); i++) { 
											_srclist[numUp + i] = new Point(); 
											_srclist[numUp + i].x = -8 + (i + 1) * sepx2 + i * _srcw + _srcw * 0.5; 
											_srclist[numUp + i].y = _srclist[0].y + sepy; 
									} 
									break;                                 
									
							case 3: //definition of 2 lines of sprites         
									var numUp: uint = _num%2 + _num/2;        //7:4, 8:4, 9:5 (Number of sprites in the upper line) 
									var sepx1 = (width + 16 - _srcw * numUp) / (numUp + 1);        //sprite horz separation in the upper line 
									var sepx2 = (width + 16 - _srcw * (_num-numUp)) / (_num - numUp + 1);        //sprite horz separation in the bottom line 
									var sepy = _srch + 12;         
									for (var i:int = 0; i < numUp; i++) { 
											_srclist[i] = new Point(); 
											_srclist[i].x = -8 + (i + 1) * sepx1 + i * _srcw + _srcw * 0.5; 
											_srclist[i].y = height + 8 + _srch * 0.5; 
									} 
									for (var i:int = 0; i < (_num - numUp); i++) { 
											_srclist[numUp + i] = new Point(); 
											_srclist[numUp + i].x = -8 + (i + 1) * sepx2 + i * _srcw + _srcw * 0.5; 
											_srclist[numUp + i].y = _srclist[0].y + sepy; 
									} 
									break; 
					} 
			} 
							
	/* 
			private function initSrcPos2():void { 
					//Define de initial positions for _num sprites within the area delimited by init pos x,y, with _bmp.w , _bmp.h area (inferior area of 3x3 quadrants) 
					_srclist = new Vector.<Point>(_num);         
					
					var w = Assets.SPRITE_FACE1_WIDTH; 
					var h = Assets.SPRITE_FACE1_HEIGHT; 
					var sepx = (width + 16 - w * _num) / (_num + 1);        //16: 8 pixels extended in each area side 
					for (var i:int = 0; i < _num; i++) { 
							_srclist[i] = new Point(); 
							_srclist[i].x = -8 + (i + 1) * sepx + i * w + w * 0.5; 
							_srclist[i].y = height + 8 + h * 0.5; 
					} 
			} 
*/ 
			
			/** 
			* Define de initial positions for _num sprites within the area delimited by init pos x,y, with _bmp.w , _bmp.h area 
			*/ 
			private function initDstPos():void {                         
					_dstlist = new Vector.<Point>(_num);         
					_dststslist = new Vector.<uint>(_num); 

					switch(_phase){ 
							case 1: 
									//Definition for dst pos in one unique line 
									var sepx:uint = (width - _dstw * _num) / (_num + 1); 
									for (var i:int = 0; i < _num; i++) { 
											_dstlist[i] = new Point(); 
											_dstlist[i].x = (i+1) * sepx + i * _dstw + _dstw*0.5; 
											_dstlist[i].y = height - 16 - _dsth*0.5;  //height - 16 - h * 0.5; 
											_dststslist[i] = 0;        //free dst pos 
									} 
									break; 
									
							case 2: 
									var numUp: uint = _num%2 + _num/2;        //4:2, 5:3, 6:3, 7:4, 8:4, 9:5 (Number of sprites in the upper line) 
									var sepx1:uint = (width - _dstw * numUp) / (numUp + 1);        //sprite horz separation in the upper line 
									var sepx2:uint = (width - _dstw * (_num-numUp)) / (_num - numUp + 1);        //sprite horz separation in the bottom line 
									var sepy:uint = _dsth + 4; //4 + _dsth + 4 
									for (var i:int = 0; i < numUp; i++) { 
											_dstlist[i] = new Point(); 
											_dstlist[i].x = (i+1) * sepx1 + i * _dstw + _dstw * 0.5;                                                 
											_dstlist[i].y = height - 12 - _dsth - _dsth * 0.5; // -8 - dsth - 4 - dsth + ajuste_centre 
											_dststslist[i] = 0;        //free dst pos 
									} 
									for (var i:int = 0; i < (_num - numUp); i++) { 
											_dstlist[numUp + i] = new Point(); 
											_dstlist[numUp + i].x = (i + 1) * sepx2 + i * _dstw + _dstw * 0.5; 
											_dstlist[numUp + i].y = _dstlist[0].y + sepy; 
											_dststslist[numUp + i] = 0;        //free dst pos 
									} 
									break;                                 

							case 3: 
									var numUp: uint = _num%2 + _num/2;        //7:4, 8:4, 9:5 (Number of sprites in the upper line) 
									var sepx1:uint = (width - _dstw * numUp) / (numUp + 1);        //sprite horz separation in the upper line 
									var sepx2:uint = (width - _dstw * (_num-numUp)) / (_num - numUp + 1);        //sprite horz separation in the bottom line 
									var sepy:uint = _dsth + 8; //8 + _dsth + 8         
									for (var i:int = 0; i < numUp; i++) { 
											_dstlist[i] = new Point(); 
											_dstlist[i].x = (i + 1) * sepx1 + i * _dstw + _dstw * 0.5; 
											_dstlist[i].y = height - 16 - _dsth - _dsth * 0.5; // -8 - dsth - 8 - dsth + ajuste_centre 
											_dststslist[i] = 0;        //free dst pos 
									} 
									for (var i:int = 0; i < (_num - numUp); i++) { 
											_dstlist[numUp + i] = new Point(); 
											_dstlist[numUp + i].x = (i + 1) * sepx2 + i * _dstw + _dstw * 0.5; 
											_dstlist[numUp + i].y = _dstlist[0].y + sepy; 
											_dststslist[numUp + i] = 0;        //free dst pos 
									}                                 
									break; 
							} 
			}                 
	
/*         
			private function initDstPos2():void { 
					//Define de initial positions for _num sprites within the area delimited by init pos x,y, with _bmp.w , _bmp.h area (superior area of 3x3 quadrants) 
					_dstlist = new Vector.<Point>(_num);         
					_dststslist = new Vector.<uint>(_num); 
					
					//Definition for dst pos in one unique line 
					var sepx = (width - _dstw * _num) / (_num + 1); 
					for (var i:int = 0; i < _num; i++) { 
							_dstlist[i] = new Point(); 
							_dstlist[i].x = (i+1) * sepx + i * _dstw + _dstw*0.5; 
							//_dstlist[i].y = height - 16 - _dsth*0.5; 
							_dstlist[i].y = height - 16 - _dsth*0.5;  //height - 16 - h * 0.5; 
							_dststslist[i] = 0;        //free dst pos 
					} 
					
					//TODO Definition for 2 lines 
					//4: 2+2, 5: 3+2, 6: 3+3, 7:4+3, 8:4+4, 9:5+4 => Formula 
					//upline: resto de num/2 + cociente de num/2 
					//boline: cociente de num/2 
					//Aplicar el mismo algoritmo anterior con variable _num=xxline, asign y correcta, y w set con tamaño ok 
					
			} 
	*/ 

	
			/** 
			 * Set dst position status (to free/to occupied), and paint dst box accordingly         
			 * @param        idx        Position index [0..N-1] 
			 * @param        free        Boolean indicating free or occupied status 
			 */ 
			private function setDstPosStatus(idx: uint, free: Boolean):void { 
					if (free) { 
							_dststslist[idx] = 0;        //set dst status to free, and paint dst box accordingly                                 
					} else { 
							_dststslist[idx] = 1;        //set dst status to free, and paint dst box accordingly 
					} 
					_bmplist[idx].bitmapData = (_bmpPosSheet.getTile((_num -(_phase-1)*3 - 1) * 2 + _dststslist[idx])).bitmapData; //status 0: 1er png, status 1: 2ºpng                 
			} 
			
			
			//----------------------------------- group status 
			/** 
			 * Check if group final condition is met 
			 * @return        true if all sprites are positiones in correct destination positions 
			 */ 
			public function isFinished():Boolean { 
					for (var i:int = 0; i < _num; i++) { 
							if (_dststslist[i] == 0) 
									return false; 
					} 
					return true; 
			} 
			
			//----------------------------------- Specific group behavior (moveable imasprites that have to be positioned in free dst positions) 
			
			  
			//----------------------------------- public methods to be called from sprite members 
	
			/** 
			 * Check if drop position is valid, based on group dropping condition (distance < _radio) 
			 * Assumption: only one position must be valid at the same time 
			 * @param        x 
			 * @param          y 
			 * @return  True if pos (x,y) is a valid destination position 
			 */ 
	public function chkCorrectDstPos(x: Number, y: Number, updSts: Boolean): Point { 
					for(var i:uint; i < _num; i++){ 
							//Option 1 
							if(distance(x, y, _dstlist[i].x, _dstlist[i].y) < _radio && _dststslist[i]==0) {        //_radio: valor en pixels 
									if (updSts) { 
											setDstPosStatus(i, false); //Update dst bmp (set occupied graphic) 
									} 
									return _dstlist[i]; 
							} 
							
							//Option 2 
							/* 
							if(distancePct(x, y, _dstlist[i].x, _dstlist[i].y) < _radio  && _dststslist[i]==0)  {// _radio: valor % entre 0 y 1 
											if(updSts) 
															_dststslist[i] = 1; 
											return _dstlist[i]; 
							} 
							*/ 
					}                         
					return null; 
			} 
			
			private function distance(x1: Number, y1: Number, x2: Number, y2: Number): Number { 
					var dx: Number = x1 - x2; 
					var dy: Number = y1 -  y2; 
					return Math.sqrt(dx * dx + dy * dy); 
			} 
	  
			/* 
			private function distancePct(x1: Number, y1: Number, x2: Number, y2: Number): Number { 
					var _radiowDst: Number = Assets.DST1_FACE_WIDTH * 0.5; 
					var _radiohDst: Number = Assets.DST1_FACE_HEIGHT * 0.5; 
					var dx: Number = x1 - x2; 
					var dy: Number = y1 -  y2; 
					var pctx:Number = (Math.abs(dx) - _radiowDst / _radiowDst)  //% relativa distancia 
					var pcty:Number = (Math.abs(dy) - _radiohDst / _radiohDst)  //% relativa distancia 
					return Math.sqrt(pctx * pctx + pcty * pcty);        //Valor entre 0..1 => collide, >1 no collides 
			} 
	 */       
			
			
			/** 
			 * Find the nearest destination position and set it status to occupied 
			 * @param        x 
			 * @param        y 
			 * @return        The destination position nearest to the pos (x,y) 
			 */ 
			public function setNearestDstPos(x: Number, y: Number): Point { 
					//TODO find nearest post, change its status and return it 
					return new Point(); 
			} 
			
			/** 
			 * Compute src pos based in total numbers of members and idx of current member 
			 * @param        idx        Index of member in group [0.._num] 
			 * @return        Source position 
			 */ 
			public function getNextFreeScrPos(idx: uint): Point { 
					//TODO ite 
					var p:Point = new Point(width/2, height+32);        //Src area: y: height+24+facelevelsprite.height 
					return _srclist[idx-1];         
			} 
					

			
		/** 
		 * Update group sprites execution: call each sprite update() method, and chk exit group condition 
		 */                 
		override public function update():void { 
			super.update();  ///std behavior: para cada sprite de _members llama a update() 
			
			//Check if final condition is just met (if all face sprites are positiones in dst positions) 
			if(_sts != STS_FINISHED && isFinished()) { 
				_sts = STS_FINISHED; 
				
				signalComplete.dispatch(_num-1);                                                         
			} 
		} 
									
	} 

}