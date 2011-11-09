/*
 * @authors: Nick Tucker
 *           Zac Alling
 *
 * The runningSoldier1(running animation instance) is invisible as long as the
 * character is stationary.  If a movement key is pressed, then runningSoldier1
 * becomes visible.  At the same time, when ever runningSoldier1 is invisible,
 * stillSoldier1 is visible and vis versa.  They are both kep in the same 
 * position.  In this way the charater appears to move when moving and stop
 * when stopped.
 */
package code { 

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.*;
	import code.Platform;
	
	//These boolean(true/false) values keep track of whether or not
	//a key is being held down
	//var rightArrow,leftArrow,upArrow,downArrow,spaceBar:Boolean;
	//var speed:int = 4; //scalar variable that determines how fast object moves
	
	//Rotate the character with the mouse
	//stage.addEventListener(Event.ENTER_FRAME, rotate);
	
	//var rightArrow,leftArrow,upArrow,downArrow,spaceBar:Boolean;
	//var speed:int;
	//var quadrant:int;

	public class SoldierMovie extends MovieClip {
			
		private var rightArrow:Boolean;
		private var leftArrow:Boolean;
		private var upArrow:Boolean;
		private var downArrow:Boolean;
		private var spaceBar:Boolean;
		
		private var speed:int;
	    private var quadrant:int;
		
		private var angle:int;
		//MovieClip(root).Mouse.hide();
		public function SoldierMovie() {
			
			this.runningSoldier1.visible = false;
			this.forward.visible = false;
			this.strafe.visible = false;
			this.forwardStrafeRight.visible = false;
			this.forwardStrafeLeft.visible = false;
			this.stillSoldier1.visible = true;
			
			this.stillSoldier1.shield.visible = false;
			this.runningSoldier1.shield.visible = false;
			//These boolean(true/false) values keep track of whether or not
			//a key is being held down
			//rightArrow,leftArrow,upArrow,downArrow,spaceBar:Boolean;
			
			this.speed = 4; //scalar variable that determines how fast object moves
			
			this.quadrant = 0;
			this.rightArrow = false;
			this.leftArrow = false;
			this.upArrow = false;
			this.downArrow = false;
			this.spaceBar = false;
		}
			
		/*
		* rotate 
		*
		*/
		public function rotate(e:Event) {
			
			var quadrant:int = 0;
			
			var theX:int = mouseX - stillSoldier1.x;
			var theY:int = (mouseY - stillSoldier1.y) * -1;
			
			this.angle = Math.atan(theY/theX)/(Math.PI/180);
			
			if (theX<0) {
				this.angle += 180;
			}
			
			if (theX>=0 && theY<0) {
				this.angle += 360;
			}
				
			//determine quadrant
			if(angle > 337.5 || angle < 22.5) {
				quadrant = 0;
			}
			else if(angle >= 22.5  && angle < 67.5) {
				quadrant = 1;
			}
			else if(angle >= 67.5  && angle < 112.5) {
				quadrant = 2;
			}
			else if(angle >= 112.5  && angle < 157.5) {
				quadrant = 3;
			}
			else if(angle >= 157.5  && angle < 202.5) {
				quadrant = 4;
			}
			else if(angle >= 202.5  && angle < 247.5) {
				quadrant = 5;
			}
			else if(angle >= 247.5  && angle < 292.5) {
				quadrant = 6;
			}
			else if(angle >= 292.5  && angle <= 337.5) {
				quadrant = 7;
			}
			
			stillSoldier1.rotation = (angle*-1);
			runningSoldier1.rotation = (angle*-1);
		
			forward.rotation = (angle*-1);
			strafe.rotation = (angle*-1);
			forwardStrafeRight.rotation = (angle*-1);
			forwardStrafeLeft.rotation = (angle*-1);
			
			//visual effects (solar glare and helmet shadow)
			stillSoldier1.helmet.helmetGlare.rotation = (angle*1);
			runningSoldier1.helmet.helmetGlare.rotation = (angle*1);
			runningSoldier1.leftShoulder.leftShoulderGlare.rotation = (angle*1);
			stillSoldier1.leftShoulder.leftShoulderGlare.rotation = (angle*1);
			runningSoldier1.rightShoulder.rightShoulderGlare.rotation = (angle*1);
			stillSoldier1.rightShoulder.rightShoulderGlare.rotation = (angle*1);
			runningSoldier1.helmetShadow.rotation = (angle*1);
			stillSoldier1.helmetShadow.rotation = (angle*1);
			
			//MovieClip(root).rotationAngle = (angle*-1);
		}
		
		public function getAngle():int {
			return angle;
		}

		public function keyPressed(e:KeyboardEvent):void {
			
			if (e.keyCode == 39 || e.keyCode == 68) {
				this.rightArrow = true;
			}
			if (e.keyCode == 37 || e.keyCode == 65) {
				this.leftArrow = true;
			}
			if (e.keyCode == 38 || e.keyCode == 87) {
				this.upArrow = true;
			}
			if (e.keyCode == 40 || e.keyCode == 83) {
				this.downArrow = true;
			}
			if(e.keyCode == 32) {
				//deploy platform
				MovieClip(root).main.getPlatform().rotatePlatform(this.angle*-1);
				
				var platformX = 300 * Math.cos(this.angle*-1 * Math.PI / 180);
				var platformY = 300 * Math.sin(this.angle*-1 * Math.PI / 180);
				
				
				MovieClip(root).main.sendFrame(" 1 " + (MovieClip(root).main.getSoldierMovie().x + platformX) + " " +
												       (MovieClip(root).main.getSoldierMovie().y + platformY) + " " +
														  this.angle*-1);
				MovieClip(root).main.getPlatform().changeCoords(
								MovieClip(root).main.getSoldierMovie().x + platformX,
								MovieClip(root).main.getSoldierMovie().y + platformY);
				MovieClip(root).main.getPlatform().visible = true;
			}
			if (e.keyCode == 32) {
				stillSoldier1.rifle.visible = false;
				runningSoldier1.rifle.visible = false;
				stillSoldier1.shield.visible = true;
				runningSoldier1.shield.visible = true;
			}
		}

		public function keyReleased(e:KeyboardEvent):void {
	
			if (e.keyCode == 39 || e.keyCode == 68) {
				this.rightArrow = false;
			}
			if (e.keyCode == 37 || e.keyCode == 65) {
				this.leftArrow = false;
			}
			if (e.keyCode == 38 || e.keyCode == 87) {
				this.upArrow = false;
			}
			if (e.keyCode == 40 || e.keyCode == 83) {
				this.downArrow = false;
			}
			if (e.keyCode == 32) {
				stillSoldier1.shield.visible = false;
				runningSoldier1.shield.visible = false;
				stillSoldier1.rifle.visible = true;
				runningSoldier1.rifle.visible = true;
			}
		}

		public function adjustEnvironment(e:Event):void {
		
			var num1:Number;
			var num2:Number;
			
			if(this.rightArrow && this.upArrow) {
				num1 = speed * .8 * -1;
				num2 = speed * .8;
				
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, num2);
				
				//MovieClip(root).ground.x -= (speed * .8);
				//MovieClip(root).ground.y -= (speed * .8);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
				
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 1) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 5) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;;
				}
				else if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
			}
			else if(this.rightArrow && this.downArrow) {
				num1 = speed * .8 * -1;
				num2 = speed * .8 * -1;
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, num2);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
					
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 3) {;
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 7) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
			}
			else if(this.upArrow && this.leftArrow) {
				num1 = speed * .8;
				num2 = speed * .8;
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, num2);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
					
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 3) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
		
				}
				else if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 7) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
			}
			else if(this.leftArrow && this.downArrow) {
				num1 = speed * .8;
				num2 = speed * .8 * -1;
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, num2);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
				
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 1) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 5) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
			}
			else if (this.rightArrow) {
				num1 = speed * .8 * -1;
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, 0);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
				
				if(this.quadrant == 0) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 4) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				else if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				else if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
			}
			else if (this.leftArrow) {
				num1 = speed * .8;
				MovieClip(root).main.getEnvironment().adjustEnvironment(num1, 0);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
	
				if(this.quadrant == 0) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				if(this.quadrant == 2) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 4) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
			}
			else if (this.upArrow) {
				num2 = speed * .8;
				MovieClip(root).main.getEnvironment().adjustEnvironment(0, num2);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
					
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 2) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 6) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
			}
			else if (this.downArrow) {
				num2 = speed * .8 * -1;
				MovieClip(root).main.getEnvironment().adjustEnvironment(0, num2);
				runningSoldier1.visible = true;
				stillSoldier1.visible = false;
						
				if(this.quadrant == 0) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 1) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 2) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 3) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
				if(this.quadrant == 4) {
					forward.visible = false;
					strafe.visible = true;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 5) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = true;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 6) {
					forward.visible = true;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = false;
				}
				if(this.quadrant == 7) {
					forward.visible = false;
					strafe.visible = false;
					forwardStrafeRight.visible = false;
					forwardStrafeLeft.visible = true;
				}
			}
			else {
				runningSoldier1.visible = false;
				forward.visible = false;
				strafe.visible = false;
				forwardStrafeRight.visible = false;
				forwardStrafeLeft.visible = false;
				stillSoldier1.visible = true;
			}
		}

		//Hide the mouse and replace it with movieclip instance "cursor"
		
		//stage.addEventListener(MouseEvent.MOUSE_MOVE,follow);
		public function follow(event:MouseEvent):void {
		
			cursor.x = mouseX;
			cursor.y = mouseY;
		}

	}
}