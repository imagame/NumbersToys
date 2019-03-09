package com.imagame.game 
{
	import com.imagame.engine.ImaBackground;
	import com.imagame.engine.ImaDialog;
	import com.imagame.engine.ImaPanel;
	import com.imagame.engine.ImaState;
	import com.imagame.engine.Registry;
	import com.imagame.game.Assets;
	import com.imagame.game.FaceLevelSprite;
	import com.imagame.game.PanelMenuFase1;
	import com.imagame.game.PanelMenuMain;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal; 
	

	/**
	 * ...
	 * @author imagame
	 */
	public class MenuState extends ImaState 
	{
		//private var _bkg:Sprite;
		//private var _vPanel: Vector.<Sprite>;
		protected var _arraypanel: Array = new Array(); 
		protected var _currentPanel: int;	//0..NUM_PANELS
				
		protected var _dlgConfig: ImaDialog;
		protected var _dlgParentalGate: ImaDialog;

//[ANE]		private var admob:Admob = Admob.getInstance();
		
		//GUI objects
		//private var _btplay: ImaButton; 
		//private var _bthelp: ImaButton;
		//private var _btback: ImaButton;
		

		//signals
		//public var signalplay: Signal;
		//public var signalcredits: Signal;
		
		public function MenuState(id: uint) 
		{
			super(id);
			trace("MENUSTATE >> MenuState()");
			
		}
		
		override public function create():void {
			trace("MenuState->create()");
		
			
			//Dibujar fondo que ocupe toda la pantalla
			_bkg = new ImaBackground(0,1,2); 
			_container.addChild(_bkg);

			//Panels creation
			//Panel 0: Main
			var panel:ImaPanel;
			panel = new PanelMenuMain(0);
			(panel as PanelMenuMain).signalplay.add(onPlayButton); 
			(panel as PanelMenuMain).signalhelp.add(onHelpButton); 
			(panel as PanelMenuMain).signalcredits.add(onCreditsButton); 
			(panel as PanelMenuMain).signalconfig.add(onConfigButton);
			(panel as PanelMenuMain).signalstore.add(onStoreButton);
			_arraypanel.push(panel);
			
			//Panel 1: Menu Phase 1 (Levels 1,2,3)
			panel = new PanelMenuFase1(1);
			panel.signalback.add(onBackButton); 
			_arraypanel.push(panel);
			(panel as PanelMenuFase1).signal1.add(onLevel1);
			(panel as PanelMenuFase1).signal2.add(onLevel2);
			(panel as PanelMenuFase1).signal3.add(onLevel3);
			
			//Panel 2: Menu Phase 2 (Levels 4,5,6)
			panel = new PanelMenuFase2(2);
			panel.signalback.add(onBackButton); 
			_arraypanel.push(panel);
			(panel as PanelMenuFase2).signal1.add(onLevel4);
			(panel as PanelMenuFase2).signal2.add(onLevel5);
			(panel as PanelMenuFase2).signal3.add(onLevel6);
			
			//Panel 3: Menu Phase 3 (Levels 7,8,9)
			panel = new PanelMenuFase3(3);
			panel.signalback.add(onBackButton); 
			_arraypanel.push(panel);
			(panel as PanelMenuFase3).signal1.add(onLevel7);
			(panel as PanelMenuFase3).signal2.add(onLevel8);
			(panel as PanelMenuFase3).signal3.add(onLevel9);
			
			//Panel 2: Help
			/*
			panel = new ImaPanel(2, Assets.GfxTitle, true);
			panel.signalback.add(onBackButton); 
			_arraypanel.push(panel);
			*/			
			
			
			//Panels activation
			for each (var i:ImaPanel in _arraypanel){
				_container.addChild(i);
				i.visible = false;
			}
			
			
			//buttons
			/*
			_btplay = new ImaButton(0, Assets.instance.GfxIcon0Bmp);
			_btplay.x = (Registry.gameRect.width  -_btplay.width)*0.5;
			_btplay.y = (Registry.gameRect.height - _btplay.height)* 0.5;
			_btplay.signalclick.add(onPlayClick);
			*/
			//(_vPanel[0] as Sprite).addChild(_btplay);
			//_panelMain.addChild(_btplay);
			
		/*
			_btback = new ImaButton(0, Assets.instance.GfxIcon3Bmp);
			_btback.x = 12;
			_btback.y = Registry.gameRect.height - _btback.height - 12;
			_btback.signalclick.add(onBackClick);
			//(_vPanel[0] as Sprite).addChild(_btplay);
			_panelPlay.addChild(_btback);
*/
			
		
		//	signalplay = new Signal(); 
		//	signalplay.add(doPlay);
		
			_currentPanel = -1; 
			switchPanel(0);
		
/*			
			if (admob.isSupported)
			{
				trace("AdMob supported!!");
				admob.dispatcher.addEventListener(AdEvent.onReceiveAd,onAdEvent);
				admob.setIsLandscape(true);
				//admob.createADView(AdSize.BANNER, "nhrlqd6g2f6qmbbq"); //you must replace this id with your admob app id. create a banner ad view.this init the view .you must replace this id with your.
		//		admob.createADView(AdSize.BANNER, "a151f1ae2e40e53"); //ANDROID: a151f1ae2e40e53
				admob.createADView(AdSize.BANNER, "a1517f033bb0ea5"); //IOS: a1517f033bb0ea5
				admob.addToStage(0, 0); // ad to displaylist position 0,0
				admob.load(true); // send a ad request.  
			}
	*/
			
		
			super.create(); //activa el estado Play
			
		}
	
		/*
		protected function onAdEvent(event:AdEvent):void
		{
			var screen:Rectangle=admob.getScreenSize();
			var adsize:AdSize = admob.getAdSize();
			var x:uint = (uint)((Registry.gameRect.width - adsize.width) * 0.5);
			var y:uint = (uint)(screen.height - adsize.height);
			admob.addToStage(0,x);	//Y,X: bottom-left corner = 0,0
		}
		*/
		
		
		/**
		 * Destroy de objects created in create() and other methods
		 */
		override public function destroy():void {
			trace("MenuState->destroy()");
			
			//Dispose background 
			_container.removeChild(_bkg);
	
			//Dispose panels
			for (var i:int = 0; i < _arraypanel.length; i++) {
				_arraypanel[i].destroy();
				_container.removeChild(_arraypanel[i]);	
				_arraypanel[i] = null;
			}
			_arraypanel = null;
				
			super.destroy();
		}
		
		
		public function switchPanel(panel: int):void {
			if (_currentPanel >= 0) {
				_arraypanel[_currentPanel].exit();
				_arraypanel[_currentPanel].visible = false;
			}
			_currentPanel = panel;
			_arraypanel[_currentPanel].visible = true;
			_arraypanel[_currentPanel].init(); 
		}
	
		override public function backState():void 
		{ 
			if (_currentPanel == 0)
				Registry.game.exitGame();
			else
				switchPanel(0);
		
		}
		
		//---------------------------------------------------------  Signal button callbacks
				
		private function onHelpButton():void {
			//TODO receive param indicating level locked. Manage connection to in-app purchase
			Assets.playSound("BtLevel");
			switchPanel(1);
		}
		
		private function onPlayButton():void {
			Assets.playSound("BtLevel");
			switchPanel(2);
		}
		
		private function onCreditsButton():void {
			//TODO receive param indicating level locked. Manage connection to in-app purchase
			Assets.playSound("BtLevel");
			switchPanel(3);			
		}

		private function onBackButton():void {
			switchPanel(0);
		}

		private function onConfigButton():void {		
			Assets.playSound("BtHud");
			
			//Create ImaDialog with starts win 
			_dlgConfig = new ConfigDialog(id, this);
			_container.addChild(_dlgConfig);
			_dlgConfig.signalClick.add(onDlgConfigClick); 
			_dlgConfig.show();
			
			
			//Disable rest of buttons in screen
			_arraypanel[_currentPanel].enable(false);

		}

		private function onStoreButton():void {
		
			//iOS
			//Requires Parental Gate
			//navigateToURL(new URLRequest("http://itunes.apple.com/app/id898456151"));
			//navigateToURL(new URLRequest("itms-apps://itunes.apple.com/app/id898456151"));	//[iOS]
			Assets.playSound("BtHud");
			
			//Create Parental Gate Dialog
			_dlgParentalGate = new ParentalGateDialog(id, this);
			_container.addChild(_dlgParentalGate);
			_dlgParentalGate.signalClick.add(onDlgParentalGateClick); 
			_dlgParentalGate.show();
			//Disable rest of buttons in screen
			_arraypanel[_currentPanel].enable(false);
		
			
		
		/*
			//Android
			navigateToURL(new URLRequest("market://details?id=air.com.imagame.vowelstoys"));	//[Android]
		*/
		}
		
		
		private function onLevel1():void {		
			Assets.playSound("No1");
			Registry.game.switchState(new GameLevel1(0, 1, 3));   //TEST
			//Registry.game.switchState(new GameLevel2(1,1,3));   
		}
		private function onLevel2():void {
			Assets.playSound("No2");
			Registry.game.switchState(new GameLevel1(0, 2, 3));  //TEST
			//Registry.game.switchState(new GameLevel2(1,2,3)); 
		}
		private function onLevel3():void {
			Assets.playSound("No3");
			Registry.game.switchState(new GameLevel1(0, 3, 3)); //TEST
			//Registry.game.switchState(new GameLevel2(1,3,3));
		}
		
		private function onLevel4():void {		
			Assets.playSound("No4");
			Registry.game.switchState(new GameLevel1(0,4,3));    //TEST
			//Registry.game.switchState(new GameLevel2(1,4,3));   
		}
		private function onLevel5():void {	
			Assets.playSound("No5");
			Registry.game.switchState(new GameLevel1(0,5,3));   //TEST
			//Registry.game.switchState(new GameLevel2(1,5,3));   
		}
		private function onLevel6():void {
			Assets.playSound("No6");
			Registry.game.switchState(new GameLevel1(0,6,3)); 
			//Registry.game.switchState(new GameLevel2(1,6,3));   
		}
		private function onLevel7():void {
			Assets.playSound("No7");
			Registry.game.switchState(new GameLevel1(0,7,3));
			//Registry.game.switchState(new GameLevel2(1,7,3));  
		}
		private function onLevel8():void {
			Assets.playSound("No8");
			Registry.game.switchState(new GameLevel1(0, 8, 3));   
			//Registry.game.switchState(new GameLevel2(1,8,3));  
		}
		private function onLevel9():void {		
			Assets.playSound("No9");
			Registry.game.switchState(new GameLevel1(0, 9, 3));   
			//Registry.game.switchState(new GameLevel3(1,9,3));  
		}

		/**
		 * Click Callback on EndLevelDialog
		 * @param	idBt	Button id in the dialog 0:Menu, 1:Repeat, 2: Menu 
		 */
		private function onDlgConfigClick(idBt: uint):void { 
			//Continue to the next level of the current Number of return to the menu if it is the last level
			if (idBt == 2) { //"NEXT" Button			
				
				//TODO: consequences in MenuState (if any)
				for (var i:int = 0; i < _arraypanel.length; i++) 
					_arraypanel[i].update() //update panels (eg hud progress bar in main panel)
				_arraypanel[_currentPanel].enable();
				
				//Enable buttons 
				_container.removeChild(_dlgConfig);
				_dlgConfig.destroy();
				_dlgConfig = null;
			}		
		} 
		
		/**
		 * Click Callback on ParentalGateDialog
		 * @param	idBt	Button id in the dialog 0:Menu, 2: Next 
		 */
		private function onDlgParentalGateClick(idBt: uint):void { 
			
			//Enable buttons and destroy dialog 
			_arraypanel[_currentPanel].enable();
			_container.removeChild(_dlgParentalGate);
			_dlgParentalGate.destroy();
			_dlgParentalGate = null;
			
			//Navigate to store if the dialog has been left with the correct answer
			if (idBt == 2) { //"NEXT" Button			
				//navigateToURL(new URLRequest("http://itunes.apple.com/app/id898456151"));	//PC VT =>Not valid, removed from AppStore. 	
				//navigateToURL(new URLRequest("http://itunes.apple.com/app/id979053313"));	//PC VT
				//navigateToURL(new URLRequest("itms-apps://itunes.apple.com/app/id898456151"));	//iOS-VT	=>Not valid, removed from AppStore. 	
				navigateToURL(new URLRequest("itms-apps://itunes.apple.com/app/id979053313"));	
			}		
		} 		
		
		//-------------------------------------------------------- Touch handles 
		
		override protected function doTouchBegin(e:TouchEvent):void { 
			if (_dlgConfig != null)
				_dlgConfig.doTouchBegin(e);
			else if (_dlgParentalGate != null)
				_dlgParentalGate.doTouchBegin(e);		
			else
				_arraypanel[_currentPanel].doTouchBegin(e); 
		} 
        
		override protected function doTouchEnd(e:TouchEvent):void { 
			if (_dlgConfig != null)
				_dlgConfig.doTouchEnd(e);
			else if (_dlgParentalGate != null)
				_dlgParentalGate.doTouchEnd(e);	
			else
				_arraypanel[_currentPanel].doTouchEnd(e);
		}
  
/* QUITAMOS para versión móvil*/
		
		override protected function doMouseDown(e:MouseEvent):void {
			if (_dlgConfig != null)
				_dlgConfig.doMouseDown(e);
			else if (_dlgParentalGate != null)
				_dlgParentalGate.doMouseDown(e);	
			else
				_arraypanel[_currentPanel].doMouseDown(e); 			
		}

		override protected function doMouseUp(e:MouseEvent):void {
			if (_dlgConfig != null)
				_dlgConfig.doMouseUp(e);
			else if (_dlgParentalGate != null)
				_dlgParentalGate.doMouseUp(e);
			else
				_arraypanel[_currentPanel].doMouseUp(e); 			
		}


		
		//--------------------------------------------------------- State logic

		override public function update():void {
			super.update(); 
			
			if(_sts == STS_INIT) {
				if (_sbsts == SBSTS_CONT) //&& la condicion de fin de init se cumple
					_sbsts = SBSTS_END;
			}
			else {				
				if (_dlgConfig != null)
					_dlgConfig.update();
				if (_dlgParentalGate != null) {
					_dlgParentalGate.update();
				}
				(_arraypanel[_currentPanel] as ImaPanel).update();
			}
		}		
				
	/*	override public function update():void {
			if (_dlgConfig != null)
				_dlgConfig.update();
			(_arraypanel[_currentPanel] as ImaPanel).update();
		}*/
	}

}