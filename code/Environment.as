/*
 * @authors: Nick Tucker
 *           Zac Alling
 *
 */
package code { 

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.*;


	public class Environment {
		
		private var environmentArray:Array = new Array();
		
		public function Environment() {
			
		}
		public function adjustEnvironment(numX:Number, numY:Number) {
			
			for(var i:int = 0; i < environmentArray.length; i++) {
				environmentArray[i].x += numX;
				environmentArray[i].y += numY;
			}
		}
		public function pushVar(obj:Object) {
			environmentArray.push(obj);
		}
		
	}
}