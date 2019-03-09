
package com.imagame.engine 
{
	import com.adcolony.airadc.AdColonyInterstitial;
	import com.adcolony.airadc.AdColonyInterstitialEvent;
	import com.adcolony.airadc.AdColonyZone;
	import com.adcolony.airadc.AirAdColony;
	import com.adcolony.airadc.AirAdColonyDefines;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	//Ane Extension Imports (ADMOB option 0: admob_android.ane)
	/*
	import so.cuo.anes.admob.Admob;	
	import so.cuo.anes.admob.AdSize;
	import so.cuo.anes.admob.AdEvent;
	*/
	
	// Ane Extension Imports (ADMOB option 1: AdMob for Flash)
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobSize;	
	import so.cuo.platform.admob.AdmobPosition;
	import so.cuo.platform.admob.AdmobEvent;
	
	// Ane Extension Imports (ADMOB option 3: AdMobANE)
	/*
	import com.codealchemy.ane.admobane.AdMobManager;
	import com.codealchemy.ane.admobane.AdMobPosition;
	import com.codealchemy.ane.admobane.AdMobSize;
	import com.codealchemy.ane.admobane.AdMobEvent;
	*/
	
	/**
	 * Advertisement Manager
	 * @author imagame
	 */
	public class ImaAdManagerAdColony extends Sprite
	{
		public var bAdProvider: Boolean = false;	//if AdProvider is supported
		//public var admob: Admob;	//Option-1
		public static var adColony: AirAdColony;
		public var bPlayVideo: Boolean;
		public var bClosedVideo: Boolean;
		 
		
		//private var id:String;
		//private var id_ban:String;	
		//private var id_int:String;	
		private var currAppId: String;
		private var currVideoZone: String;
		private const IOS_APP_ID: String = "appbdee68ae27024084bb334a"; //pte
		private const IOS_VIDEO_ZONE: String = "vzf8fb4670a60e4a139d01b5"; //Pte
		private const ANDROID_APP_ID: String = "appebfd02d51ff14dffa7";
		private const ANDROID_VIDEO_ZONE: String = "vze70128ae7fe04290b4";
		
		private var bVisible: Boolean;
		
		private var currInterstitialAd:AdColonyInterstitial;

		
		public function ImaAdManagerAdColony() 
		{						
			//AdMob id
			//id = "a1517f033bb0ea5"; //IOS Admon Id
			//id = "a151f1ae2e40e53"; //ANDROID NT Admob Id	
			//id = "a153ccd28d15e50" //ANDROID VT Admob Id	
			
			//AdMob id - Nuevos bloques de anuncions: New banner & intersticial
			//id_ban = "ca-app-pub-3497215250736989/8915250129";	//id del bloque de anuncios banner VT-And
			//id_int = "ca-app-pub-3497215250736989/3309368526";  //id del bloque de anuncios intersticial VT-And			
			//id_ban = "ca-app-pub-3497215250736989/4092183722";	//id del bloque de anuncios banner NT-And
			//id_int = "ca-app-pub-3497215250736989/1138717322";  //id del bloque de anuncios intersticial NT-And
			//id_ban = "ca-app-pub-3497215250736989/8382782527";	//id del bloque de anuncios banner NT-iOS
			//id_int = "ca-app-pub-3497215250736989/6906049321";  //id del bloque de anuncios intersticial NT-iOS
			
			
			
			//admob = Admob.getInstance();	//Option-0
			adColony = new AirAdColony();
			
			//if (admob.isSupported) { Option-0, Option-3
			//if (admob.supportDevice) { //Option-1
			if (adColony.isSupported()){
				trace("AdColony supported!!");
				bAdProvider = true;
				bVisible = false;
				
				//option 1
				//admob.setKeys(id_ban, id_int);
				//admob.enableTrace = false;
				
				//option 3
				/*
				admob.verbose = true;
				admob.operationMode = AdMobManager.TEST_MODE;
				admob.bannersAdMobId = id_ban;
				admob.interstitialAdMobId = id_int;
				*/
				currAppId = ANDROID_APP_ID;
				currVideoZone = ANDROID_VIDEO_ZONE;
				
				adColony.addEventListener(AdColonyInterstitialEvent.EVENT_TYPE, handleInterstitialEvent);
				adColony.configure(null, currAppId, currVideoZone);
			
				requestVideo();

			}
			else
				Registry.bAd = false;
		}
		

		
		public function handleInterstitialEvent(event:AdColonyInterstitialEvent):void {
			var interstitialAd:AdColonyInterstitial = event.getInterstitialAd();
			var zone:AdColonyZone = event.getZone();

			var zoneStr:String = "";
			if (interstitialAd != null) {
				zoneStr = interstitialAd.getZoneId();
				
			} else if (zone != null) {
				zoneStr = zone.getZoneId();
			}

			if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_CLICK) {
				updateInterstitialAd(interstitialAd);
				trace("Ad Clicked: " + zoneStr);
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_CLOSE) {
				updateInterstitialAd(interstitialAd);
				trace("Ad Closing: " + zoneStr);
				//TODO: Invocara a CB de fin de interstitial
				bPlayVideo = false;
				bClosedVideo = true;
				
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_EXPIRING) {
				updateInterstitialAd(interstitialAd);
				trace("Ad Expiring: " + zoneStr);
				//TODO: Invocar a requestVideo
				requestVideo();
				
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_IAP) {
				updateInterstitialAd(interstitialAd);
				trace("On IAP: " + zoneStr);
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_LEFT_APP) {
				updateInterstitialAd(interstitialAd);
				trace("Left App: " + zoneStr);
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_OPEN) {
				updateInterstitialAd(interstitialAd);
				trace("Ad Opened: " + zoneStr);
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_REQUEST_FILLED) {
				updateInterstitialAd(interstitialAd);
				trace("Request Filled: "+zoneStr);
			} else if (event.getInterstitialEventType() == AirAdColonyDefines.INTERSTITIAL_EVENT_ON_REQUEST_NOT_FILLED) {
				updateInterstitialAd(interstitialAd);
				trace("Request Not Filled: "+zoneStr);
			}
		}

		//private function updateInterstitialAd(interstitialAd:AdColonyInterstitial, zoneStr:String):void {
		private function updateInterstitialAd(interstitialAd:AdColonyInterstitial):void {
			  if (interstitialAd != null) {
				  if (currVideoZone == interstitialAd.getZoneId()) {
					  currInterstitialAd = interstitialAd;
				  }
			  }
		}
			
		
		
		
		public function initAds():void {
			requestVideo();
			//_funcCBCloseVideo = funcIntEndCB;

		}
		


		
		public function requestVideo():void {
			bPlayVideo = false;
			bClosedVideo = false;
			var zoneID: String = currVideoZone;
			var isSuccess:Boolean = adColony.requestInterstitial(
				zoneID,   // the zone the interstitial is being requested from
				null);              // The ad-options for the request (optional)
			trace("Ad request for "+zoneID+" is "+isSuccess);
		}

		public function playVideo():void {
			bPlayVideo = true;
			bClosedVideo = false;
			
			var zoneID: String = currVideoZone;
			if (currInterstitialAd != null) {
				var isSuccess:Boolean = adColony.showInterstitial(currInterstitialAd);
				trace("Showing ad for "+zoneID+" is "+isSuccess);		
			}
		}
		
		
		//Option-1
		/*
		public function showBanner():void {
			var adsize:AdmobSize;
			//toDo: Select adsize dependint on screen size (admob.getScreenSize())
            //adsize = Admob.BANNER;//No compatible con ultima v Admob
			adsize = AdmobSize.BANNER_STANDARD;
			//admob.showBanner(adsize, AdmobPosition.BOTTOM_CENTER);
			bVisible = true;
		}
		public function hideBanner():void {
			admob.hideBanner();	
			bVisible = false;
		}
		public function showInterstitial():void {
			if(admob.isInterstitialReady()){
				admob.showInterstitial();
			}else{
				admob.cacheInterstitial();
			}			
		}
		public function hideInterstitial():void {
			
		}
		*/

	}

}