package com.imagame.game 
{ 
	import com.imagame.engine.ImaButton; 
	import com.imagame.engine.ImaIcon; 
	import com.imagame.engine.ImaTimer; 
	import com.imagame.engine.Registry; 
	import com.imagame.utils.ImaBitmapSheet; 
	import flash.display.Sprite; 
	import flash.geom.Matrix; 
	
	/** 
	 * Menu Panel for the first phase, containing levels 1, 2 and 3 
	 * @author imagame 
	 */ 
	public class PanelMenuFase1 extends PanelMenuFase 
	{ 
		
		public function PanelMenuFase1(id:uint) 
		{                                                           
			super(id); 
		} 
                                                
		override protected function createLevels():void { 
			_bmpFaceSheet = new ImaBitmapSheet(Assets.GfxSpriteFace1, Assets.SPRITE_FACE1_WIDTH, Assets.SPRITE_FACE1_HEIGHT);                                                 
			_bmpBkgSheet = new ImaBitmapSheet(Assets.GfxMenuLevel, Assets.LEVEL_MENU_WIDTH, Assets.LEVEL_MENU_HEIGHT);                         
			_bmpBtSheet = new ImaBitmapSheet(Assets.GfxButtonsLevelNumbers, Assets.BT_LEVEL_WIDTH, Assets.BT_LEVEL_HEIGHT);                         
			_bmpFrmSheet = new ImaBitmapSheet(Assets.GfxFxFrmBtn, Assets.FX_FRMBTN_WIDTH, Assets.FX_FRMBTN_HEIGHT); 
			
			var refx:uint = (Registry.gameRect.width - Assets.LEVEL_MENU_WIDTH * 3) / 4; 
			var refy:uint = Registry.appUpOffset + 64; //TODO: hacer 64 dependiente de alto? 
			var phase:uint = 1; 
			
			_level1grp = createFaceLevel(0, phase, refx, refy, onLevel1Selected); 
			_level2grp = createFaceLevel(1, phase, 2 * refx + Assets.LEVEL_MENU_WIDTH, refy, onLevel2Selected); 
			_level3grp = createFaceLevel(2, phase, 3 * refx + 2 * Assets.LEVEL_MENU_WIDTH, refy, onLevel3Selected); 
		} 
                  

	} 

} 