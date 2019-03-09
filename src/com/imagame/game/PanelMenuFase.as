package com.imagame.game 
{
	import com.imagame.engine.ImaButton;
	import com.imagame.engine.ImaIcon;
	import com.imagame.engine.ImaPanel;
	import com.imagame.engine.ImaSpriteGroup;
	import com.imagame.engine.ImaTimer;
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import org.osflash.signals.Signal;
	
	/**
	 * Menu Panel template class. A subclass must implement the abstract method createLevels()
	 * @author imagame
	 */
	public class PanelMenuFase extends ImaPanel 
	{
		public var signal1: Signal; 
        public var signal2: Signal; 
        public var signal3: Signal; 
                
		//protected variables
        protected var _level1grp: ImaSpriteGroup; 
        protected var _level2grp: ImaSpriteGroup; 
        protected var _level3grp: ImaSpriteGroup; 
		protected var _touching: Array;
		
		protected var _imgNumberArea = new Vector.<Sprite>;        //Background areas with numbers and dst face positions 
		protected var _btLevelContainer: Vector.<Sprite>; 
		protected var _btFrmLevel: Vector.<ImaIcon>;        //Icon to show a frame on the button level 
		protected var _btLevel: Vector.<ImaButton>;        //Button to select level number once is activated by positioning face sprite in dst positions               
		protected var _btLevelOn: Vector.<Boolean>;         //True is bt level enabled (enabled the first time all level sprites are located in dst pos) 
		protected var _btFrmLevelTimer: Vector.<ImaTimer>;        //Timer to control _btLevel1 animation 
		
		protected var _bmpFaceSheet: ImaBitmapSheet; 
		protected var _bmpBkgSheet: ImaBitmapSheet;                         
		protected var _bmpBtSheet: ImaBitmapSheet; 
		protected var _bmpFrmSheet: ImaBitmapSheet; 
    
		
		
		public function PanelMenuFase(id:uint) 
		{			
			super(id, Assets.GfxTitFase, true); 
			_imgNumberArea = new Vector.<Sprite>(3); 
			_btLevelContainer = new Vector.<Sprite>(3); 
			_btFrmLevel = new Vector.<ImaIcon>(3); 
			_btLevel = new Vector.<ImaButton>(3); 
			_btLevelOn = new Vector.<Boolean>(3); 
			_btFrmLevelTimer = new Vector.<ImaTimer>(3); 

			createLevels();
			
			//click signals 
			signal1 = new Signal(); 
			signal2 = new Signal(); 
			signal3 = new Signal(); 
			
			_touching = [];			
		}
		
		/**
		 * To be overriden
		 */
		protected function createLevels():void { }

		override public function destroy():void { 
			for (var i:int = 0; i < 3; i++) { 
				_btLevel[i].destroy();                                 
				_btLevel[i] = null; 
				_btLevelContainer[i].removeChild(_btFrmLevel[i]); 
				_btFrmLevel[i].destroy(); 
				_btFrmLevel[i] = null; 
				_btLevelContainer[i] = null;                                 
				_btFrmLevelTimer[i].destroy(); 
				_btFrmLevelTimer[i] = null; 
				_imgNumberArea[i] = null; 
			}                 
			_btLevelOn = null; 			
			_touching = null;
			signal1.removeAll();
			signal1 = null;			
			signal2.removeAll();
			signal2 = null;
			signal3.removeAll();
			signal3 = null;
		}
		
		/**
		 * calling each levelSpriteGroup init() function. 
		 * ¿Update stars display foreach level group?? not necessary if number of active stars cannot change outside playable level
		 */
		override public function init():void {
			_level1grp.init();
			_level2grp.init();
			_level3grp.init();
		}
		
		/**
		 * Any operation when going back to main menu panel??
		 */
		override public function exit(): void {
			_level1grp.exit();
			_level2grp.exit();
			_level3grp.exit();			
		}

		//----------------------------------------------------------
		
		                
		/**
		 * 
		 * @param	numLvl	Number level [0..8]
		 * @param	phase	Number phase [1..3]
		 * @param	px
		 * @param	py
		 * @param	onLevelSelectedCB	Callback function for level selection
		 * @return
		 */
		protected function createFaceLevel(numLvl: uint, phase:uint, px:uint, py: uint, onLevelSelectedCB: Function):FaceLevelSpriteGroup { 
			var idx:uint = numLvl - (phase-1) * 3;
			//create number bkg area 
			_imgNumberArea[idx] = new Sprite(); 
			_imgNumberArea[idx].x = px; 
			_imgNumberArea[idx].y = py; 
			_imgNumberArea[idx].cacheAsBitmap = true; 
			_imgNumberArea[idx].cacheAsBitmapMatrix = new Matrix(); 
			_imgNumberArea[idx].addChild(_bmpBkgSheet.getTile(numLvl)); 
			addChild(_imgNumberArea[idx]); 
									
			//create Level 1 button 
			_btLevelContainer[idx] = new Sprite(); //adopt same x,y coords as bmp                         
			_btLevelContainer[idx].x = (int)(_imgNumberArea[idx].x  + Assets.LEVEL_MENU_WIDTH * 0.5 -2); // _bmp.width * 0.5; 
			_btLevelContainer[idx].y =  (int)(_imgNumberArea[idx].y + Assets.LEVEL_MENU_HEIGHT * 0.5 -24); 
			_btLevelContainer[idx].cacheAsBitmap = true; 
			_btLevelContainer[idx].cacheAsBitmapMatrix = new Matrix(); 
			addChild(_btLevelContainer[idx]); 
			
			_btFrmLevel[idx] = new ImaIcon(numLvl, _bmpFrmSheet, [0]); 
			_btLevelContainer[idx].addChild(_btFrmLevel[idx]); 
			_btFrmLevel[idx].x = -_btLevelContainer[idx].width / 2; 
			_btFrmLevel[idx].y = -_btLevelContainer[idx].height / 2; 
							
			_btLevel[idx] = new ImaButton(numLvl, _bmpBtSheet); 
			_btLevel[idx].x = _imgNumberArea[idx].x + 14;        //to exactly adjust image button to background area graphic 
			_btLevel[idx].y = _imgNumberArea[idx].y + 16; 
			_btLevelOn[idx] = false; 
			addChild(_btLevel[idx]); 

			//Create face level sprites 
			var levelgrp: FaceLevelSpriteGroup = new FaceLevelSpriteGroup(numLvl+1, phase, _imgNumberArea[idx].x, _imgNumberArea[idx].y); 
			for(var i:uint=0; i<=numLvl; i++) { 
					levelgrp.add(new FaceLevelSprite(i, _bmpFaceSheet, idx)); 
			} 
			addChild(levelgrp);     
			(levelgrp as FaceLevelSpriteGroup).signalComplete.add(onLevelComplete);                         

			//create level 1 behaviour                                                         
			_btLevel[idx].signalclick.add(onLevelSelectedCB);                                                 
			_btFrmLevelTimer[idx] = new ImaTimer(); 
			if((Registry.gpMgr as PropManager).isLevelEnabled(numLvl)) 
				enableBtLevel(numLvl,true); 
			else 
				enableBtLevel(numLvl,false);     
					
			return levelgrp; 
		} 
                
                
                
  
		/** 
		Enable button for the level <numLvl> 
		@param numLvl 0..8 
		*/ 
		protected function enableBtLevel(numLvl: uint, bEnable: Boolean = true):void { 
			var idx: uint = numLvl % 3;
			if(bEnable) { 
				//Enable level (for ever) 
				_btLevelOn[idx] = true; 
				(Registry.gpMgr as PropManager).openLevelNumber(numLvl); 
				Registry.gpMgr.save();         
				
				_btLevel[idx].visible = true; //Activate Level selection button   
				_btLevel[idx].loadGraphic(numLvl*2+1,numLvl*2);  //Set highlighted status 
				_btFrmLevel[idx].visible = true; 
				_btFrmLevelTimer[idx].start(0.05, 0, OnBtFrmLevelTimer); //set timer for button animation         
     
			} 
			else { 
				_btLevel[idx].visible = false;         
				_btFrmLevel[idx].visible = false; 
			}                 
		} 
                
		public function OnBtFrmLevelTimer(timer: ImaTimer):void { 
			for (var i:uint = 0; i < 3; i++) { 
				if (_btFrmLevelTimer[i] == timer) { 
					_btLevelContainer[i].rotation += 5; 
					break; 
				} 
			}                 
		} 
                
                
		/** 
		Callback to be called when a number faces are all located in dst pos 
		*/ 
		public function onLevelComplete(numLvl: uint):void { 
			var idx: uint = numLvl % 3;
			//NO => FIX-V1.1.0 - Sometimes framelvltimer not visible and button not active, thought it is open
			if(!_btLevelOn[idx]) {
				enableBtLevel(numLvl); //Activate <num> button level 
				Assets.playSound("FaceGroupok");
			}
		} 
		
		
		//--------------------------------------------------------- Interaction
		
		override public function doMouseDown(e:MouseEvent):void {
			var spr: FaceLevelSprite = e.target as FaceLevelSprite; 
			if (spr != null && !spr.isSelected()) {
				trace("MouseDown FaceLevelSprite Id: " + spr.grp.id + "." + spr.id+" => "+spr.isSelected()+"  TYPEOF: "+typeof(e.target));
				_touching[0] = spr; 
				spr.doStartDrag(e);  
			}
		}
				
		/**
		 * Versión simplificada: Sólo hay un tipo de Sprite sobre el que se puede hacer drag&drop
		 * @param	e
		 */
		override public function doMouseUp(e:MouseEvent):void {
			if (_touching[0] != null) {
				(_touching[0] as FaceLevelSprite).doStopDrag(e);
				_touching[0] = null;
			}
		}
		
		override public function doTouchBegin(e:TouchEvent):void { 
			var spr: FaceLevelSprite = e.target as FaceLevelSprite; 
			if (spr != null && !spr.isSelected()) {
				trace("Touch FaceLevelSprite Id: " + spr.id);
				_touching[e.touchPointID] = spr;
				spr.doTouchBegin(e);
			}
		} 
		
		override public function doTouchEnd(e:TouchEvent):void {
			var spr: FaceLevelSprite = _touching[e.touchPointID]; 			
			if (spr != null) {
				//TODO asegurar que _touching[e.touchPointID] == spr (debería, pero vamos..¨)
				delete _touching[e.touchPointID];
				_touching[e.touchPointID] = null;
				spr.doTouchEnd(e);
			}			
		}
		
		//--------------------------------------------------------- Signal handling and update control
			
		//Dispatch signal to Menustate to perfomr state change from the menu state, and not from child classes
		public function onLevel1Selected(event:MouseEvent):void { 
			signal1.dispatch();
		} 

		public function onLevel2Selected(event:MouseEvent):void { 
			signal2.dispatch();
		} 
		
		public function onLevel3Selected(event:MouseEvent):void { 
			signal3.dispatch();
		} 
		
		override public function update():void {
			//trace("PanelMenuFase2 id:" + _id);			
			_level1grp.update();
			_level2grp.update();
			_level3grp.update();		
						
		} 
				
	}

}