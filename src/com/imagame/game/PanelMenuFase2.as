package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	
	/**
	 * Menu Panel for the second phase, containing levels 4, 5 and 6. A signal is dispatched for each level if selected.
	 * @author imagame
	 */
	public class PanelMenuFase2 extends PanelMenuFase 
	{
		
		public function PanelMenuFase2(id:uint) 
		{	
			super(id);
		}
		
		override protected function createLevels():void { 
			_bmpFaceSheet = new ImaBitmapSheet(Assets.GfxSpriteFace2, Assets.SPRITE_FACE2_WIDTH, Assets.SPRITE_FACE2_HEIGHT);                                                 
			_bmpBkgSheet = new ImaBitmapSheet(Assets.GfxMenuLevel, Assets.LEVEL_MENU_WIDTH, Assets.LEVEL_MENU_HEIGHT);                         
			_bmpBtSheet = new ImaBitmapSheet(Assets.GfxButtonsLevelNumbers, Assets.BT_LEVEL_WIDTH, Assets.BT_LEVEL_HEIGHT);                         
			_bmpFrmSheet = new ImaBitmapSheet(Assets.GfxFxFrmBtn, Assets.FX_FRMBTN_WIDTH, Assets.FX_FRMBTN_HEIGHT); 
			
			var refx:uint = (Registry.gameRect.width - Assets.LEVEL_MENU_WIDTH * 3) / 4; 
			var refy:uint = Registry.appUpOffset + 64; //TODO: hacer 64 dependiente de alto? 
			var phase:uint = 2; 
			
			_level1grp = createFaceLevel(3, phase, refx, refy, onLevel1Selected); 
			_level2grp = createFaceLevel(4, phase, 2 * refx + Assets.LEVEL_MENU_WIDTH, refy, onLevel2Selected); 
			_level3grp = createFaceLevel(5, phase, 3 * refx + 2 * Assets.LEVEL_MENU_WIDTH, refy, onLevel3Selected); 
		} 
		
	/*	
		override protected function createLevels():void {
			var bmpFaceSheet: ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxSpriteFace2, Assets.SPRITE_FACE2_WIDTH, Assets.SPRITE_FACE2_HEIGHT);                                                 
			var sepx:uint = (Registry.gameRect.width - Assets.LEVEL_MENU_WIDTH * 3) / 4; 
			var sepy:uint = Registry.appUpOffset + 64; //TODO: hacer 64 dependiente de alto?
			
			_level1grp = new FaceLevelSpriteGroup(4, 2, sepx, sepy); 
			_level1grp.add(new FaceLevelSprite(0, bmpFaceSheet, 0)); 
			_level1grp.add(new FaceLevelSprite(1, bmpFaceSheet, 0)); 
			_level1grp.add(new FaceLevelSprite(2, bmpFaceSheet, 0)); 
			_level1grp.add(new FaceLevelSprite(3, bmpFaceSheet, 0)); 
			addChild(_level1grp); 				
			
			_level2grp = new FaceLevelSpriteGroup(5, 2, 2*sepx+Assets.LEVEL_MENU_WIDTH, sepy); 
			_level2grp.add(new FaceLevelSprite(0, bmpFaceSheet, 1)); 
			_level2grp.add(new FaceLevelSprite(1, bmpFaceSheet, 1)); 
			_level2grp.add(new FaceLevelSprite(2, bmpFaceSheet, 1)); 
			_level2grp.add(new FaceLevelSprite(3, bmpFaceSheet, 1)); 
			_level2grp.add(new FaceLevelSprite(4, bmpFaceSheet, 1)); 
			addChild(_level2grp); 
                       
			_level3grp = new FaceLevelSpriteGroup(6, 2, 3 * sepx + 2 * Assets.LEVEL_MENU_WIDTH, sepy); 
			_level3grp.add(new FaceLevelSprite(0, bmpFaceSheet, 2)); 
			_level3grp.add(new FaceLevelSprite(1, bmpFaceSheet, 2)); 
			_level3grp.add(new FaceLevelSprite(2, bmpFaceSheet, 2)); 
			_level3grp.add(new FaceLevelSprite(3, bmpFaceSheet, 2)); 
			_level3grp.add(new FaceLevelSprite(4, bmpFaceSheet, 2)); 
			_level3grp.add(new FaceLevelSprite(5, bmpFaceSheet, 2)); 
			addChild(_level3grp);			
		}
	*/
	}

}