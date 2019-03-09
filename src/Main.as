package 
{
	import com.imagame.engine.ImaEngine;
	import com.imagame.game.MenuState;
	import com.imagame.game.PropManager;

	
	/**
	 * Numbers Toys game
	 * @author imagame
	 */
	
	//[SWF(frameRate = "60", width = "960", height = "640",  backgroundColor = "#000000" )]
	//[SWF(frameRate = "40", width = "480", height = "320",  backgroundColor = "#000000" )]
	[SWF(frameRate = "40", width = "800", height = "400",  backgroundColor = "#000000" )]
	
	public class Main extends ImaEngine 
	{
		public function Main():void 
		{
			super(new PropManager("numbertoys"));
			start(new MenuState(0));
		}
				
	}
	
}