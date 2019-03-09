package com.imagame.game 
{
	import com.imagame.engine.Registry;
	import flash.display.Bitmap;
	import flash.media.Sound; 
    import flash.utils.Dictionary; 
	
	/**
	 * ...
	 * @author imagame
	 */
	public class Assets 
	{
		private static var sSounds:Dictionary = new Dictionary(); 

		// sounds         
		[Embed(source = "../../../../assets/sfx/btHud.mp3")]  private static const sndBtHud:Class;
		[Embed(source = "../../../../assets/sfx/btLevel.mp3")]  private static const sndBtGroupLevel:Class;
		[Embed(source = "../../../../assets/sfx/btLevel.mp3")]  private static const sndBtLevel:Class;
		[Embed(source = "../../../../assets/sfx/face_ok.mp3")]  private static const sndFaceok:Class;
		[Embed(source = "../../../../assets/sfx/facegroup_ok.mp3")]  private static const sndFaceGroupok:Class;
		[Embed(source = "../../../../assets/sfx/piece1_ok.mp3")]  private static const sndPiece1ok:Class;
		[Embed(source = "../../../../assets/sfx/piece1_ko.mp3")]  private static const sndPiece1ko:Class;
		[Embed(source = "../../../../assets/sfx/piece2_ok.mp3")]  private static const sndPiece2ok:Class;
		[Embed(source = "../../../../assets/sfx/piece2_ko.mp3")]  private static const sndPiece2ko:Class;
		[Embed(source = "../../../../assets/sfx/piece3_ok.mp3")]  private static const sndPiece3ok:Class;
		[Embed(source = "../../../../assets/sfx/EndLevel.mp3")]  private static const sndEndLevel:Class;
		[Embed(source = "../../../../assets/sfx/EndRound.mp3")]  private static const sndEndRound:Class;
		[Embed(source = "../../../../assets/sfx/star.mp3")]  private static const sndStar:Class;
		
		[Embed(source = "../../../../assets/sfx/no1.mp3")]  private static const sndNo1:Class;
		[Embed(source = "../../../../assets/sfx/no2.mp3")]  private static const sndNo2:Class;
		[Embed(source = "../../../../assets/sfx/no3.mp3")]  private static const sndNo3:Class;
		[Embed(source = "../../../../assets/sfx/no4.mp3")]  private static const sndNo4:Class;
		[Embed(source = "../../../../assets/sfx/no5.mp3")]  private static const sndNo5:Class;
		[Embed(source = "../../../../assets/sfx/no6.mp3")]  private static const sndNo6:Class;
		[Embed(source = "../../../../assets/sfx/no7.mp3")]  private static const sndNo7:Class;
		[Embed(source = "../../../../assets/sfx/no8.mp3")]  private static const sndNo8:Class;
		[Embed(source = "../../../../assets/sfx/no9.mp3")]  private static const sndNo9:Class;
		
		
		//[Embed(source = "../../../../assets/sfx/fart-01.mp3")]  private static const sndFart01:Class;
		
        
		
		//Dialogs		
		[Embed(source = "../../../../assets/gfx/dlg0.png")] public static var GfxDlg0: Class; 
		[Embed(source = "../../../../assets/gfx/fx_frm128_0.png")] public static var GfxFxFrmIconDlg:Class;	//fx
		[Embed(source = "../../../../assets/gfx/dlg1.png")] public static var GfxDlg1: Class; 
		[Embed(source="../../../../assets/gfx/fx_frm128_1.png")] public static var GfxFxFrmIconEndRoundDlg:Class;	//fx
		[Embed(source = "../../../../assets/gfx/dlgConfig.png")] public static var GfxDlgConfigv: Class; 
		[Embed(source = "../../../../assets/gfx/dlgParentalGate.png")] public static var GfxDlgParentalGate: Class; 
		
		//Background images
		[Embed(source = "../../../../assets/gfx/bkg480x320_main.png")] public static var GfxBkgImg0: Class;
		[Embed(source = "../../../../assets/gfx/bkg480x320_mainext.png")] public static var GfxBkgImg1: Class;
		[Embed(source = "../../../../assets/gfx/bkg480x320_mainextv.jpg")] public static var GfxBkgImg2: Class;
		[Embed(source = "../../../../assets/gfx/bkg480x320_1.jpg")] public static var GfxBkgImg3: Class;	//1-Azul Metal (palillos)	
		[Embed(source = "../../../../assets/gfx/bkg480x320_2.jpg")] public static var GfxBkgImg4: Class;	//2-Gris Rosado (figuras)
		[Embed(source = "../../../../assets/gfx/bkg480x320_3.jpg")] public static var GfxBkgImg5: Class;	//3-Verde Metal (cajas) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_4.jpg")] public static var GfxBkgImg6: Class;	//4-Azul (círculos lentes) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_5.jpg")] public static var GfxBkgImg7: Class;	//5-gris (baldosa) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_6.jpg")] public static var GfxBkgImg8: Class;	//6-amarillo (abanico) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_7.jpg")] public static var GfxBkgImg9: Class;	//7-naranja (rombos pequeños) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_8.jpg")] public static var GfxBkgImg10: Class;	//8-morado (rombos grandes) 
		[Embed(source = "../../../../assets/gfx/bkg480x320_9.jpg")] public static var GfxBkgImg11: Class;	//9-gris (jap flag) 

		
 		public static var bkgImages: Array = [GfxBkgImg0, GfxBkgImg1, GfxBkgImg2, GfxBkgImg3, GfxBkgImg4, GfxBkgImg5, GfxBkgImg6, GfxBkgImg7, GfxBkgImg8, GfxBkgImg9, GfxBkgImg10, GfxBkgImg11];		//this definition must be after embedded classes

		//Text and titles
		[Embed(source = "../../../../assets/gfx/logoimagame.png")] public static var GfxLogo: Class; //176x24
		[Embed(source = "../../../../assets/gfx/title.png")] public static var GfxTitle: Class;	//352x96
		[Embed(source = "../../../../assets/gfx/titFase.png")] public static var GfxTitFase: Class; //200x56
		
		//Menu images
		[Embed(source = "../../../../assets/gfx/menuarealevel.png")] public static var GfxMenuLevel: Class;
		public static const LEVEL_MENU_WIDTH:uint = 132;
		public static const LEVEL_MENU_HEIGHT:uint = 180; //Old: 196 
		
		//Tilesheet Number images
		[Embed(source = "../../../../assets/gfx/ImgNumber1.png")] public static var GfxNumber1Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber2.png")] public static var GfxNumber2Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber3.png")] public static var GfxNumber3Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber4.png")] public static var GfxNumber4Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber5.png")] public static var GfxNumber5Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber6.png")] public static var GfxNumber6Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber7.png")] public static var GfxNumber7Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber8.png")] public static var GfxNumber8Img: Class;
		[Embed(source = "../../../../assets/gfx/ImgNumber9.png")] public static var GfxNumber9Img: Class;
		public static const IMG_NUMBER_WIDTH:uint = 192;
		public static const IMG_NUMBER_HEIGHT: uint = 224
		public static var numberImages: Array = [GfxNumber1Img, GfxNumber2Img, GfxNumber3Img, GfxNumber4Img, GfxNumber5Img, GfxNumber6Img, GfxNumber7Img, GfxNumber8Img, GfxNumber9Img];		//this definition must be after embedded classes
		
		//Tilesheet icon Config dialog
		[Embed(source = "../../../../assets/gfx/IconSheetConfigDlg.png")] public static var GfxIconsConfigDlg: Class; 
		public static const IMG_ICONCONFIGDLG_WIDTH:uint = 44; 
		public static const IMG_ICONCONFIGDLG_HEIGHT: uint = 44; 
		
		//Tilesheet icon Parental Gate dialog
		[Embed(source = "../../../../assets/gfx/ts_shapeParentalGateDlg.png")] public static var GfxShapesParentalGateDlg: Class;
		public static const IMG_SHAPEPARENTALDLG_WIDTH:uint = 54; 
		public static const IMG_SHAPEPARENTALDLG_HEIGHT: uint = 18; 
		public static const NUM_SHAPEPARENTALDLG: uint = 8; 
		[Embed(source = "../../../../assets/gfx/IconSheetParentalGateDlg.png")] public static var GfxIconsParentalGateDlg: Class; 
		public static const IMG_ICONPARENTALDLG_WIDTH:uint = 44; 
		public static const IMG_ICONPARENTALDLG_HEIGHT: uint = 44; 		
	
		//Tilesheet icon End Level dialog
		[Embed(source = "../../../../assets/gfx/ImgStar.png")] public static var GfxIconsEndLevelDlg: Class; 
		public static const IMG_ICONLEVELDLG_WIDTH:uint = 112; 
		public static const IMG_ICONLEVELDLG_HEIGHT: uint = 112; 
		
		//Tilesheet icon End Round dialog
		[Embed(source = "../../../../assets/gfx/ImgRound.png")] public static var GfxIconsEndRoundDlg: Class; 
		public static const IMG_ICONROUNDDLG_WIDTH:uint = 80; 
		public static const IMG_ICONROUNDDLG_HEIGHT: uint = 80; 
		
		
	/*	
		[Embed(source = "../../../../assets/gfx/icon_up_32x32.png")] public static var GfxIcon1: Class;
		[Embed(source = "../../../../assets/gfx/icon_down_32x32.png")] public static var GfxIcon2: Class;
		[Embed(source = "../../../../assets/gfx/icon_over_32x32.png")] public static var GfxIcon3: Class;
		[Embed(source="../../../../assets/gfx/icon_lock.png")]  public static var GfxLock: Class;
		*/
		
		//Tilesheet buttons
		[Embed(source = "../../../../assets/gfx/btHUD.png")] public static var GfxButtonsHUD: Class;
		public static const BUTTON_HUD_WIDTH:uint = 36;
		public static const BUTTON_HUD_HEIGHT: uint = 36;
		[Embed(source = "../../../../assets/gfx/btDlg.png")] public static var GfxButtonsDlg: Class; 
		public static const BUTTON_DLG_WIDTH:uint = 36; 
		public static const BUTTON_DLG_HEIGHT: uint = 36;              
		[Embed(source="../../../../assets/gfx/btLinkStore.png")] public static var GfxButtonsLinkStore: Class;
		public static const BUTTON_STORE_WIDTH:uint = 96;
		public static const BUTTON_STORE_HEIGHT:uint = 96;
		[Embed(source="../../../../assets/gfx/btPanelMenuMain.png")] public static var GfxButtonsPanelMenuMain: Class;
		public static const BUTTON_MENU_WIDTH:uint = 96;
		public static const BUTTON_MENU_HEIGHT:uint = 96;
		[Embed(source = "../../../../assets/gfx/btLevelNumbers.png")] public static var GfxButtonsLevelNumbers: Class;
		public static const BT_LEVEL_WIDTH:uint = 100;
		public static const BT_LEVEL_HEIGHT:uint = 100;
		
		[Embed(source = "../../../../assets/gfx/barHUD.png")] public static var GfxBarHUD: Class;
		public static const BAR_HUD_WIDTH:uint = 388;
		public static const BAR_HUD_HEIGHT:uint = 14;
		public static const BAR_ICON_HUD_WIDTH:uint = 28;
		public static const BAR_ICON_HUD_HEIGHT:uint = 28;
		

		//fx
		//[Embed(source = "../../../../assets/gfx/fx_frameLevelButton.png")] public static var GfxFxFrmBtn:Class;
		[Embed(source = "../../../../assets/gfx/fx_frm116.png")] public static var GfxFxFrmBtn:Class;
		public static const FX_FRMBTN_WIDTH:uint = 116;
		public static const FX_FRMBTN_HEIGHT:uint = 116;		
		[Embed(source = "../../../../assets/gfx/fx_tapIndicator.png")] public static var GfxFxTapIndicator: Class;
		public static const FX_TAPIND_WIDTH:uint = 32;
		public static const FX_TAPIND_HEIGHT:uint = 32;
		[Embed(source = "../../../../assets/gfx/fx_piece3PreInBox.png")] public static var GfxFxPiecePreInBox: Class;
		public static const FX_PIECE3_WIDTH:uint = 48;
		public static const FX_PIECE3_HEIGHT:uint = 48;
		
		//Sprites
		[Embed(source = "../../../../assets/gfx/SpriteFace1.png")] public static var GfxSpriteFace1: Class;
		public static const SPRITE_FACE1_WIDTH:uint = 44;
		public static const SPRITE_FACE1_HEIGHT:uint = 44;
		[Embed(source = "../../../../assets/gfx/SpriteFace2.png")] public static var GfxSpriteFace2: Class;
		public static const SPRITE_FACE2_WIDTH:uint = 32;
		public static const SPRITE_FACE2_HEIGHT:uint = 32;
		[Embed(source = "../../../../assets/gfx/SpriteFace3.png")] public static var GfxSpriteFace3: Class;
		public static const SPRITE_FACE3_WIDTH:uint = 24;
		public static const SPRITE_FACE3_HEIGHT:uint = 24;		
		[Embed(source = "../../../../assets/gfx/SpriteFace1Dst.png")] public static var GfxSpriteFace1Dst: Class;
		public static const SPRITE_FACEDST1_WIDTH:uint = 32;
		public static const SPRITE_FACEDST1_HEIGHT:uint = 32;
		[Embed(source = "../../../../assets/gfx/SpriteFace2Dst.png")] public static var GfxSpriteFace2Dst: Class;
		public static const SPRITE_FACEDST2_WIDTH:uint = 24;
		public static const SPRITE_FACEDST2_HEIGHT:uint = 24;
		[Embed(source = "../../../../assets/gfx/SpriteFace3Dst.png")] public static var GfxSpriteFace3Dst: Class;
		public static const SPRITE_FACEDST3_WIDTH:uint = 20;
		public static const SPRITE_FACEDST3_HEIGHT:uint = 20;
		//Sprites Puzzle 1
		[Embed(source = "../../../../assets/gfx/pieceBox1.png")] public static var GfxSpritePieceBox1: Class;
		public static const SPRITE_PIECEBOX1_WIDTH:uint = 44;
		public static const SPRITE_PIECEBOX1_HEIGHT:uint = 44;
		//Sprites Puzzle 3
		[Embed(source = "../../../../assets/gfx/mskFigures.png")] public static var GfxSpritePieceShape: Class;
		public static const SPRITE_PIECESHAPE3_WIDTH: uint = 48;
		public static const SPRITE_PIECESHAPE3_HEIGHT: uint = 48;
		//From 0..8: numbers
		//From 9..15 alone pieces
		//From 15..xx simple connectable pieces
		//From xx..xxcomplex connectable pieces
		

		
		//Constantes colores
		public static const COL_BUT:uint = 0xffffaa66; // 0xffA1A7B7;
		public static const COL_TITBUT:uint = 0xffffeeee;

		//Game configuration definitions 
		//-- GameState subclass for each game level 
		public static var gameStates: Array = 
			[GameLevel1, GameLevel2, GameLevel3, 
			GameLevel1, GameLevel2, GameLevel3, 
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3,
			GameLevel1, GameLevel2, GameLevel3]; 
		//-- Background image and extension img (W and H) for each game level 
		public static var gameIdBkg: Array = 
			[3,0,0,3,0,0,3,0,0, 4,0,0,4,0,0,4,0,0, 5,0,0,5,0,0,5,0,0, 
			6,0,0,6,0,0,6,0,0, 7,0,0,7,0,0,7,0,0, 8,0,0,8,0,0,8,0,0,
			9,0,0,9,0,0,9,0,0, 10,0,0,10,0,0,10,0,0, 11,0,0,11,0,0,11,0,0 ]; 
                			  
		
		public function Assets() 
		{	
			
		}
		
		
		////////////////////////////////////////////////////////////////////////// Sound
		
		
		public static function playSound(name:String,t:Number=0):void {
			if(Registry.bSnd)
				(sSounds[name] as Sound).play(t);
		}
		
		public static function getSound(name:String):Sound 
        { 
            var sound:Sound = sSounds[name] as Sound; 
            if (sound) return sound; 
            else throw new ArgumentError("Sound not found: " + name); 
        } 


		public static function prepareSounds():void 
        { 
            sSounds["BtHud"] = new sndBtHud();
			sSounds["BtGroupLevel"] = new sndBtGroupLevel();
			sSounds["BtLevel"] = new sndBtLevel();
			sSounds["Faceok"] = new sndFaceok();
			sSounds["FaceGroupok"] = new sndFaceGroupok();
			sSounds["Piece1ok"] = new sndPiece1ok(); 
			sSounds["Piece1ko"] = new sndPiece1ko(); 
			sSounds["Piece2ok"] = new sndPiece2ok();
			sSounds["Piece2ko"] = new sndPiece2ko();
			sSounds["Piece3ok"] = new sndPiece3ok();
			sSounds["EndLevel"] = new sndEndLevel();
			sSounds["EndRound"] = new sndEndRound();
			sSounds["Star"] = new sndStar();
			sSounds["No1"] = new sndNo1();
			sSounds["No2"] = new sndNo2();
			sSounds["No3"] = new sndNo3();
			sSounds["No4"] = new sndNo4();
			sSounds["No5"] = new sndNo5();
			sSounds["No6"] = new sndNo6();
			sSounds["No7"] = new sndNo7();
			sSounds["No8"] = new sndNo8();
			sSounds["No9"] = new sndNo9();
			
        } 
		
		
		////////////////////////////////////////////////////////////////////////// Assets ImaEngine
		//Icons
		[Embed(source = "../../../../assets/gfx/icon_back_32x32.png")] public static var GfxIcon0: Class;
				
	}
	
	//AREA (vertical disposition DST 1)
	//sep: 16 (4 border)
	//number: 100
	//sep: 16
	//dst1: 32
	//sep: 16 (4 border)
	//h-area: 180
	
	//DOWNAREA: 76 
	//        16 
	//        44 
	//        16 
	
	
	//AREA (vertical disposition DST2)
	//sep: 16 (4 border)
	//number: 100
	//sep: 4
	//dst2: 24
	//sep: 4
	//dst2: 24
	//sep:8 (4 border)
	//h-area: 180
	
	//DOWNAREA: 76 
	//        4 
	//        32 
	//        4 
	//        32 
	//        4 
		
	//AREA (vertical disposition DST 3)
	//sep: 16 (4 border)
	//number: 100
	//sep: 8
	//dst2: 20
	//sep: 8
	//dst2: 20
	//sep:8 (4 border)
	//h-area: 180
 
	//DOWNAREA: 76 
	//        8 
	//        24 
	//        12 
	//        24 
	//        8 
	
}

