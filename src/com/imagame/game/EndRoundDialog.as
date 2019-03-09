package com.imagame.game 
{
	import com.imagame.engine.ImaDialog;
	import com.imagame.engine.ImaState;
	import com.imagame.utils.ImaBitmapSheet;
	
	/**
	 * ...
	 * @author imagame
	 */
	public class EndRoundDialog extends ImaDialog 
	{
		private var _newRound: uint;
		
		public function EndRoundDialog(id:uint, newRound: uint, parentRef:ImaState) 
		{
			super(id, parentRef, new ImaBitmapSheet(Assets.GfxIconsEndRoundDlg, Assets.IMG_ICONROUNDDLG_WIDTH, Assets.IMG_ICONROUNDDLG_HEIGHT), 
			[false, false, true], [Assets.GfxDlg1, Assets.GfxFxFrmIconEndRoundDlg, null]); 
			_newRound = newRound;
			visible = false;
			
			//Set icon depending on current level-phase, and if it is the first time is completed
			_sprIcon.addAnimation("round1", _tileSheet, null, [3], null, 20);
			_sprIcon.addAnimation("round2", _tileSheet, null, [5], null, 20);
			_sprIcon.addAnimation("round3", _tileSheet, null, [7], null, 20);
			_sprIcon.addAnimation("round4", _tileSheet, null, [9], null, 20);
			_sprIcon.addAnimation("round5", _tileSheet, null, [11], null, 20);
			_sprIcon.addAnimation("round6", _tileSheet, null, [13], null, 20);
			_sprIcon.addAnimation("round7", _tileSheet, null, [15], null, 20);
			_sprIcon.addAnimation("round8", _tileSheet, null, [17], null, 20);
			
		}
		
		
		/**
		 * Opening event where perform init actions, after each time the dialog is shown.
		 */
		override protected function open():void {
			//set the animation depending on the new round
			visible = true;
			_sprIcon.playAnimation(String("round"+_newRound));
		}		
	}
}