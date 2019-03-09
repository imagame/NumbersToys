package com.imagame.game 
{
	import com.greensock.TweenLite;
	import com.imagame.engine.ImaDialog;
	import com.imagame.engine.ImaSprite;
	import com.imagame.engine.ImaSpriteAnim;
	import com.imagame.engine.ImaState;
	import com.imagame.engine.Registry;
	import com.imagame.utils.ImaBitmapSheet;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * End Level Dialog
	 * Dialog shown when a level is complete
	 * @author imagame
	 */
	public class EndLevelDialog extends ImaDialog 
	{
		protected var _idPhase: uint; 	//Phase where the level is included. Values= [1..9]
		protected var _incrementStars:uint;	//Number of stars to increment the game progress (only for first time level complete). Values: 0,1,2,3
		
		protected var _iconStar: ImaSpriteAnim; 
		protected var _srcPos: Vector.<Point>;        //Source stars relative Position within _sprIcon sprite. (for each star in each _spricon frame) 
		protected var _idxPos: uint;	//Index on _srcPos (for the current start tweeening iteration)
		protected var _starIteration: Boolean;
		
		protected static const STS_EXECUTING:uint = 6; //Free state, to use and extend in subclasse   
		protected var _numStar: int;	//Number of iterations to move stars to imaHUDbar
		
		protected var _idTween: TweenLite;
		
		/**
		 * Dialog to manage the end of a number level for each phase
		 * - Shows star icon animation based on level finished and if it is the firs time is completed
		 * - Increments the game progress (when applies)
		 * @param	id	Idlevel for each phase. Values: 0,1,2
		 */
		public function EndLevelDialog(id:uint, phase: uint, parentRef:ImaState) 
		{
			super(id, parentRef, new ImaBitmapSheet(Assets.GfxIconsEndLevelDlg, Assets.IMG_ICONLEVELDLG_WIDTH, Assets.IMG_ICONLEVELDLG_HEIGHT), [false, false, true]); 
			_idPhase = phase;
			_incrementStars = 0;
			visible = false;
			
			
			//Set icon depending on current level-phase, and if it is the first time is completed
			_sprIcon.addAnimation("star1first", _tileSheet, null, [0, 1, 2, 3, 4, 5, 6], null, 20, false, null, onAnimEndCB);
			_sprIcon.addAnimation("star2first", _tileSheet, null, [7,8,9,10,11,12,13], null, 20, false, null, onAnimEndCB);
			_sprIcon.addAnimation("star3first", _tileSheet, null, [14, 15, 16, 17, 18, 19, 20], null, 20, false, null, onAnimEndCB);
			_sprIcon.addAnimation("star1", _tileSheet, null, [0, 1, 2, 3, 4, 5, 21], null, 20);
			_sprIcon.addAnimation("star2", _tileSheet, null, [7,8,9,10,11,12,23], null, 20);
			_sprIcon.addAnimation("star3", _tileSheet, null, [14, 15, 16, 17, 18, 19, 26], null, 20);
			//_sprIcon.addAnimation("starEnd", _tileSheet, null, [21, 22, 23, 24, 25, 26], null, 0, false, onFrameEndCB); //stars off. define anim with framerate=0 to only play one frame 
			_sprIcon.addAnimation("starEnd", _tileSheet, null, [21, 22, 23, 24, 25, 26]);
			
			_iconStar = new ImaSpriteAnim(ImaSprite.TYPE_ICON, 1);
			_iconStar.addAnimation("default", _tileSheet, null, [6]);	
			_iconStar.playAnimation("default");
			_iconStar.x = _sprIcon.x; // (uint)((_bmp.width - _sprIcon.width) * 0.5); 
			_iconStar.y = _sprIcon.y; // (uint)(80 - _sprIcon.height * 0.5); // 24; 
			_iconStar.cacheAsBitmap = true;
			_iconStar.cacheAsBitmapMatrix = new Matrix(); 
			addChild(_iconStar);        //add icon to container 
			_iconStar.visible = false;

			_srcPos = new Vector.<Point>(6);        //3*2*1 = 6 stars, in all 3 star-frames 
			_srcPos[0] = new Point(0,0); 
			_srcPos[1] = new Point(-23,0); 
			_srcPos[2] = new Point(27,0); 
			_srcPos[3] = new Point(3,-22); 
			_srcPos[4] = new Point(-22,22); 
			_srcPos[5] = new Point(28,22); 			
		}
		
		override public function destroy():void {   
			for(var i:uint=0; i< _srcPos.length; i++){ 
					_srcPos[i] = null; 
			} 
			_srcPos = null; 			

			_iconStar.destroy();
			_iconStar = null;
			super.destroy(); 		
		}
		
		 /**
		 * Opening event where perform init actions, after each time the dialog is shown.
		 */
		override protected function open():void {
			Assets.playSound("EndLevel");
			
			//Check if the phase-id level has already been completed or it is the firs time
			_incrementStars = 0;
			var maxLvl:int = (Registry.gpMgr as PropManager).getLevelProgress(_idPhase-1); //Max Level arrived in <phase> (0,1,2 0 3 if has completed all)
			if (id == maxLvl)
				_incrementStars = id + 1;	//Increment level only the first time you win the level
				
			//set the animation depending on the level and if it is completed the first time
			visible = true;
			_iconStar.visible = false;
			switch(id) {
				case 0: _sprIcon.playAnimation(_incrementStars==0?"star1":"star1first", true);
						break;
				case 1: _sprIcon.playAnimation(_incrementStars==0?"star2":"star2first", true);
						break;
				case 2: _sprIcon.playAnimation(_incrementStars==0?"star3":"star3first", true);
						break;
			}
		}
		
		//**************************************************************** Dialog internal actions
		protected function incrementGameProgress(val:uint=1):void {
			(Registry.gpMgr as PropManager).incrementGameProgress(val);
			Registry.gpMgr.save();	//save to shared object
		}
		
		protected function advanceLevel():void {
			(Registry.gpMgr as PropManager).advanceLevel(_idPhase-1);
			Registry.gpMgr.save();	//save to shared object
		}
		
		protected function advanceRound():void {
			(Registry.gpMgr as PropManager).advanceRound();
			Registry.gpMgr.save(); //save to shared object
		}
		
		protected function isEndOfLevel():Boolean {
			return (Registry.gpMgr as PropManager).isEndOfLevel();
			
		}
		
		
		
		
		//**************************************************************** Callbacks

		//Executed only if  the level has been completed for the first time         

		protected function onAnimEndCB(spr: ImaSpriteAnim):void { 
			_sts = STS_EXECUTING;
			_numStar = id+1;        //number of iteratios to tween yellow star to the imaHUDbar 
			_idxPos = (id==0)?0:((id==1)?1:((id==2)?3:3)); 
		} 
                	
		
		override protected function onNextClick(event:MouseEvent):void { 
			if (_idTween != null)
				_idTween.kill();
			if(_numStar > 0) {//exiting dialog before finishing all <_numstar> iterations 
				incrementGameProgress(_numStar); 
				advanceLevel(); //PTE ver si: = id + 1;
			}		
			
			if (isEndOfLevel()) {
				//trace("END OF LEVEL");
				advanceRound();
				onMenuClick(event);	//Retornamos al menú, en lugar de pasar al sig lvl
			}
			else
				super.onNextClick(event);         
		} 
                
		
		protected function endStarIteration():void {
			Assets.playSound("Star");
			
			//Set frame of star depending on the level an the star iteracion <idStar>
			_sprIcon.playAnimation("starEnd", false, _idxPos);
			
			_iconStar.visible = false; 
			incrementGameProgress();
			
			//Prepare vars for the next star iteration (if any) 
			_numStar--; 
			_idxPos++;
			_starIteration = false;
			_idTween = null;
		}
		
		override public function update():void { 
			_iconStar.update(); 
                        
			if(_sts == STS_EXECUTING) {                                 
				if(_numStar <=0) { 
					_sts = STS_ACTIVE;
					_starIteration = false;
					advanceLevel(); 
				}
				else { 
					if (!_starIteration) {
						_starIteration = true;
																					
						//Tween move the moveable star to the imaHUDbar 
						if (Registry.bTween) {         
							_iconStar.x = _sprIcon.x + _srcPos[_idxPos].x;
							_iconStar.y = _sprIcon.y  + _srcPos[_idxPos].y;
							_iconStar.visible = true; 
							_iconStar.alpha = 1; 
					
							_idTween = TweenLite.to(_iconStar, 0.4, { delay:1,  alpha:1,
									x: -x - _sprIcon.width * 0.5 +(_parent as GameState).getGameProgressBar().x , 
									y: -y - _sprIcon.height * 0.5 +(_parent as GameState).getGameProgressBar().y , 
									onComplete: endStarIteration} );                                                                                                                         
						} 
						else { 
							endStarIteration();							
						}
					} 
				} 				
				 
			} 
                        
			//TODO any dialog action not related to default dialog icon animation 
			super.update(); 
		} 
                
                
        
		
	}

}