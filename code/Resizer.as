/*
 * @authors: Nick Tucker
 *           Zac Alling
 *
 */
package code { 

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.*;


	public class Resizer {
		
		public function Resizer() {

		}
	
		//The resizing function
		// parameters
		// required: mc = the movieClip to resize
		// required: maxW = either the size of the box to resize to, or just the maximum desired width
		// optional: maxH = if desired resize area is not a square, the maximum desired height. default is to match to maxW (so if you want to resize to 200x200, just send 200 once)
		// optional: constrainProportions = boolean to determine if you want to constrain proportions or skew image. default true.
		public function resizeMe(mc:MovieClip, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void {
			
			maxH = maxH == 0 ? maxW : maxH;
			mc.width = maxW;
			mc.height = maxH;
			if (constrainProportions) {
				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;
			}
		}
	}


}