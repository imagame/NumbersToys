package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	/**
	 * ...
	 * @author imagame
	 */
	public class PanelMenuFase3 extends PanelMenuFase 
	{
		
		public function PanelMenuFase3(id:uint) 
		{
			super(id);
			
		}
		
		override protected function createLevels():void { 
			_bmpFaceSheet = new ImaBitmapSheet(Assets.GfxSpriteFace3, Assets.SPRITE_FACE3_WIDTH, Assets.SPRITE_FACE3_HEIGHT);                                                 
			_bmpBkgSheet = new ImaBitmapSheet(Assets.GfxMenuLevel, Assets.LEVEL_MENU_WIDTH, Assets.LEVEL_MENU_HEIGHT);                         
			_bmpBtSheet = new ImaBitmapSheet(Assets.GfxButtonsLevelNumbers, Assets.BT_LEVEL_WIDTH, Assets.BT_LEVEL_HEIGHT);                         
			_bmpFrmSheet = new ImaBitmapSheet(Assets.GfxFxFrmBtn, Assets.FX_FRMBTN_WIDTH, Assets.FX_FRMBTN_HEIGHT); 
			
			var refx:uint = (Registry.gameRect.width - Assets.LEVEL_MENU_WIDTH * 3) / 4; 
			var refy:uint = Registry.appUpOffset + 64; //TODO: hacer 64 dependiente de alto? 
			var phase:uint = 3; 
			
			_level1grp = createFaceLevel(6, phase, refx, refy, onLevel1Selected); 
			_level2grp = createFaceLevel(7, phase, 2 * refx + Assets.LEVEL_MENU_WIDTH, refy, onLevel2Selected); 
			_level3grp = createFaceLevel(8, phase, 3 * refx + 2 * Assets.LEVEL_MENU_WIDTH, refy, onLevel3Selected); 
		} 
		

	}

}