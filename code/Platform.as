/*
 * @authors: Nick Tucker
 *           Zac Alling
 *
 */
package code { 

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.*;


	public class Platform extends MovieClip {
		
		private var startX;
		private var startY;
		
		public function Platform() {

		}
		public function rotatePlatform(angle:Number) {
			this.rotation = angle;
		}
		public function changeCoords(myX:Number, myY:Number) {
			this.x = myX;
			this.y = myY;
		}
	}
}