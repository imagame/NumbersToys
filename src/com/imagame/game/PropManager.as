package com.imagame.game 
{
	import com.imagame.engine.ImaPropManager;
	import com.imagame.engine.Registry;
	
	/**
	 * ...
	 * @author imagame
	 */
	public class PropManager extends ImaPropManager 
	{
		
		private var levelProgress:Vector.<uint>;	//Max Level arrived in <phase> (0,1,2 or 3 if has completed all)
        private var levelNumberSts:Vector.<uint>; //Level number state, open/close. Open when face sprites have been located correctly once. 

		
		public var round:uint;		//game rounds: 0..N
		public var starsTotal:uint;	//number of total stars in all rounds
		public var starsRound:uint;	//number of gained stars in current round (0..9*6=54)
		private var _starsRoundMax: uint; 

		public function PropManager(soName:String) 
		{ 
			super(soName); 
			levelProgress = new Vector.<uint>(9);        //9 phases (numbers) 
			levelNumberSts = new Vector.<uint>(9); //9 level buttons 
			initData();                         
			_starsRoundMax = 9 * 6;                         
		} 
		
		
		/**
		 * Incremente the number of stars (game progress)
		 * @param	val
		 * @return	True, if end or round achieved
		 */
		public function incrementGameProgress(val: uint):Boolean { 
			starsRound += val; 			
			starsTotal += val; 
			if (starsRound >= _starsRoundMax) 
				return true;
			else
				return false;
		} 
		
		public function advanceRound(newRound:int = -1):void {
			starsRound = 0;
			if(newRound == -1)
				round++;
			else 
				round = newRound;
			
			//reset level progress for new round
			resetLevelProgress();
		}
		
		public function advanceLevel(idPhase:uint, idLvl:int = -1):void {
			levelProgress[idPhase] = (idLvl == -1)?levelProgress[idPhase]+1:idLvl + 1;
		}
		
			
		public function isEndOfLevel():Boolean {
			return (starsRound == _starsRoundMax);
		}
		
		protected function resetLevelProgress():void {
			for (var i:uint = 0; i < 9; i++) {
				levelProgress[i] = 0;	//By default the first level (lvl 0) is the max level we have arrived
			}		
		}

        public function getLevelProgress(idLvl: uint): uint { 
			return levelProgress[idLvl]; 
		} 
	
        
		/**
		 * Level number
		 */
		protected function resetLevelNumbers():void { 
			for (var i:uint = 0; i < 9; i++) { 
				levelNumberSts[i] = 0;        //0: closed 
			}                 
		} 

		public function openLevelNumber(idLvl: uint):void { 
			levelNumberSts[idLvl] = 1; 
		} 
		
		public function isLevelEnabled(idLvl: uint):Boolean { 
			return (levelNumberSts[idLvl] == 1); 
		} 
	
		
		//*************************************** Set operations
		
		public function setGameProgress(r:uint, sr:uint, st:uint, lvlPrg: Array):void {		
			round = r;
			starsRound = sr;
			starsTotal = st;
			for (var i:uint = 0; i < 9; i++) {
				levelProgress[i] = lvlPrg[i];
				if (lvlPrg[i] > 0)
					openLevelNumber(i);
			}
			round = (int)(starsTotal / _starsRoundMax);
		}
		
		
		
		//*********************
		
		/** 
		* Initialize game progress (for 1st game session) 
		*/ 
		override protected function initData():void {                         
			round = 0;        //no round at the beginning of the game                         
			starsRound = 0; 
			starsTotal = 0; 
			resetLevelProgress(); 
			resetLevelNumbers();                          
		} 
			
		/** 
		 * Set "game" properties from a data Object, which has been obtained from saved data in a local store, or initialized data by the game 
		 * @param        data 
		 */ 
		override protected function setData(data: Object):void { 
			super.setData(data);
			//Preprocess data based in engine o game versions 
			if(data.imaEngineVersion != Registry.IMAENGINE_VERSION){ 
					trace("Data saved with old Engine version saved:"+data.ImaEngineVersion+" Reg: "+Registry.IMAENGINE_VERSION); 
					//TODO Conversion required 
			}
			if(data.gameVersion != Registry.GAME_VERSION) {
					trace("Data saved with old Game version"); 
					//TODO Conversion required 
					//iOS: No hacemos ningun tratamiento si pasamos de versión de pago (1.0) a versión gratis con ads (1.1)
			}
					
			round = data.round; 
			starsRound = data.starsRound; 
			starsTotal = data.starsTotal;         
			levelProgress = data.levelProgress; 
			levelNumberSts = data.levelNumberSts; 
		} 


		/** 
		 * Get "game" properties in data Object, to be saved in a local store. 
		 * @param        data 
		 */ 
		override protected function getData(data:Object):void { 
			super.getData(data); 
			data.round = round; 
			data.starsRound = starsRound; 
			data.starsTotal = starsTotal;         
			data.levelProgress = levelProgress; 
			data.levelNumberSts = levelNumberSts;
		}		
	}

}