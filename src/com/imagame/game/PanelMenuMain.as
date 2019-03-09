package com.imagame.game 
{
	import com.imagame.engine.ImaHUDBar;
	import com.imagame.engine.ImaHUDButton;
	import com.imagame.engine.ImaSprite;
	import com.imagame.utils.ImaCachedBitmap;
	
	import com.imagame.engine.Registry;
	import com.imagame.engine.ImaButton;
	import com.imagame.engine.ImaPanel;
	import com.imagame.utils.ImaBitmapSheet;
	
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent; 
		
	import org.osflash.signals.Signal; 
		
	/**
	 * ...
	 * @author imagame
	 */
	public class PanelMenuMain extends ImaPanel 
	{
		protected var _bthelp: ImaButton;
		protected var _btplay: ImaButton;
		protected var _btcredits: ImaButton;
		protected var _barProgressGame: ImaHUDBar;
		protected var _btconfig: ImaButton;
		protected var _btstore: ImaButton;
		
		public var signalhelp: Signal;
		public var signalplay: Signal;
		public var signalcredits: Signal;
		public var signalconfig: Signal;
		public var signalstore: Signal;
		
		private var _bloqueado: Boolean;

		public function PanelMenuMain(id:uint) 
		{
			super(id, null, false);
			var logo:Bitmap = ImaCachedBitmap.instance.createBitmap(Assets.GfxLogo);
			logo.x = (Registry.gameRect.width - logo.width) * 0.5
			logo.y = Registry.appUpOffset + 8;
			addChild(logo);
			
			var tit:Bitmap = ImaCachedBitmap.instance.createBitmap(Assets.GfxTitle);
			tit.x = (Registry.gameRect.width - tit.width) * 0.5
			tit.y = Registry.appUpOffset + 32;
			addChild(tit);
				
			//buttons creation
			//Create HUD progress bar
			var _bmpSheetBar:ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxBarHUD, Assets.BAR_HUD_WIDTH, Assets.BAR_HUD_HEIGHT); 
			_barProgressGame = new ImaHUDBar(0, 0, 9 * 6, _bmpSheetBar,ImaSprite.POS_DOLE, ImaSprite.POS_CENTREX, 32, 0, Registry.gpMgr, "starsRound","round");			
			_barProgressGame.bForceUpdate = true;
			_barProgressGame.update();	//force paint progress status
			this.addChild(_barProgressGame);
			
			//Create HUD Config button
			var _bmpSheetConfig:ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxButtonsHUD, Assets.BUTTON_HUD_WIDTH, Assets.BUTTON_HUD_HEIGHT); 
			_btconfig = new ImaHUDButton(4, _bmpSheetConfig, 4, 4, ImaSprite.POS_UPLE, 0); 
			this.addChild(_btconfig);
			
			//Create HUD Store button
			var _bmpSheetConfig:ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxButtonsLinkStore, Assets.BUTTON_STORE_WIDTH, Assets.BUTTON_STORE_HEIGHT); 
			_btstore = new ImaHUDButton(5,_bmpSheetConfig, 0, 4, ImaSprite.POS_UPRI, 0, 0, 0, 0, 0,0, Assets.BUTTON_STORE_WIDTH, Assets.BUTTON_STORE_HEIGHT); 
		//	this.addChild(_btstore);
			
			
			
			
			//Option: bitmap sheet
			var bmpSheet: ImaBitmapSheet = new ImaBitmapSheet(Assets.GfxButtonsPanelMenuMain, Assets.BUTTON_MENU_WIDTH, Assets.BUTTON_MENU_HEIGHT);

			_btplay = new ImaButton(1, bmpSheet, 4, 5);
			_btplay.x = (Registry.gameRect.width  -_btplay.width) * 0.5;
			_btplay.y = Registry.gameRect.height * 0.5; 
			this.addChild(_btplay);
			
			_bthelp = new ImaButton(2, bmpSheet, 0, 1);
			_bthelp.x = _btplay.x - _bthelp.width - 32;
			_bthelp.y = Registry.gameRect.height*0.5; // (Registry.gameRect.height - _btplay.height) * 0.5;
			this.addChild(_bthelp);
			
			_btcredits = new ImaButton(3, bmpSheet, 8, 9);
			_btcredits.x = _btplay.x + _btplay.width + 32;
			_btcredits.y = Registry.gameRect.height*0.5; 
			this.addChild(_btcredits);
						
						
			_bloqueado = false;			
			//Buttons lock update
			if (_bloqueado)
				(_btcredits as ImaButton).loadGraphic(10, 11);
			
			
			//click signals
			signalhelp = new Signal();
			_bthelp.signalclick.add(onHelpClick);
			signalplay = new Signal();
			_btplay.signalclick.add(onPlayClick);
			signalcredits = new Signal();
			_btcredits.signalclick.add(onCreditsClick);
			signalconfig = new Signal();
			_btconfig.signalclick.add(onConfigClick);	
			signalstore = new Signal();
			_btstore.signalclick.add(onStoreClick);
							
		}
		
		override public function destroy():void {
			_btplay.destroy();
			removeChild(_btplay);
			_btplay = null;
			signalplay.removeAll();
			signalplay = null;

			
			_bthelp.destroy();
			removeChild(_bthelp);
			_bthelp = null;
			signalhelp.removeAll();
			signalhelp = null;
			
			_btcredits.destroy();
			removeChild(_btcredits);
			_btcredits = null;
			signalcredits.removeAll();
			signalcredits = null;
			
			_btconfig.destroy();
			removeChild(_btconfig);
			_btconfig = null;
			signalconfig.removeAll();
			signalconfig = null;
			
			_btstore.destroy();
			//removeChild(_btstore);
			_btstore = null;
			signalstore.removeAll();
			signalstore = null;
			
			if(_barProgressGame != null) {
				_barProgressGame.destroy();
				removeChild(_barProgressGame);
				_barProgressGame = null;
			}

			
			//TODO remove ImaBitmapSheet used by the above buttons
			
			//DUDA remove anonymous children
			//removeChildren();
			super.destroy();
			
				/*		//Dispose buttons
			var bt: ImaButton;
			for (var i:uint = 0; i < _vPanel[0].numChildren; i++) {
				if (_vPanel[0].getChildAt(i) is ImaButton) {
					bt = _vPanel[0].getChildAt(i) as ImaButton;
					bt.destroy();
					_vPanel[0].removeChild(bt);
					bt = null;
				}
			}
			_btplay = _btback = null;
		*/	

		}

		
		override public function enable(bEnable: Boolean = true):void {
			if (bEnable) {
				_bthelp.enable(onHelpClick);
				_btplay.enable(onPlayClick);
				_btcredits.enable(onCreditsClick);	
				_btconfig.enable(onConfigClick);
				_btstore.enable(onStoreClick);
			}
			else {
				_bthelp.disable();
				_btplay.disable();
				_btcredits.disable();
				_btconfig.disable();
				_btstore.disable();
			}
			super.enable(bEnable);
		}
		
		//--------------------------------------------------- Interaction
		
		
		public function onHelpClick(event:MouseEvent):void { 
			//TODO If button locked dispatch signal with param value to fire In-app purchase connection.			
			/*
			if (_bloqueado) {
				_bloqueado = false;
				//_btcredits.loadGraphic(ImaCachedBitmap.instance.createBitmap(Assets.Gfx789up), ImaCachedBitmap.instance.createBitmap(Assets.Gfx789do));	
				(_btcredits as ImaButtonSheet).loadGraphicSheet(8, 9);
			
			}
			*/
			signalhelp.dispatch();
		}
			
		public function onPlayClick(event:MouseEvent):void { 
			signalplay.dispatch();
		}
		
		public function onCreditsClick(event:MouseEvent):void {
			//(_btplay as ImaButton).loadGraphic(6, 7);
			signalcredits.dispatch();
		}
		
		public function onConfigClick(event:MouseEvent):void { 
			signalconfig.dispatch();
		}
		
		public function onStoreClick(event:MouseEvent):void { 
			signalstore.dispatch();
		}
		
		override public function update():void {
			_barProgressGame.update();
		}
	}

}