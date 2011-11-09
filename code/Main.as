/*
 * @authors: Nick Tucker
 *           Zac Alling
 *
 */
package code { 

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.*;


	public class Main extends MovieClip {
		
		private var host:String = "localhost";
		private var client:SoldierClient;
		private var clientPort:int = 11300;
		private var tempStr:String = "";
		
		//declare and instantiate the multiplayer array
		private var soldierArray:Array = new Array();
		private var spawnPointX:Number;
		private var spawnPointY:Number;
		private var newGroundX:Number = 0;
		private var newGroundY:Number = 0;
		private var groundX:Number;
		private var groundY:Number;
		private var myGroundX:Number;
		private var myGroundY:Number;
		private var shieldFlag:Number;
		private var rotationAngle:int;
		
		private var resizer:code.Resizer;
		private var ground:code.Ground;
		private var sm:code.SoldierMovie;
		private var platform:code.Platform;
		private var environment:code.Environment;
		
		public function Main() {
			
		}
		
		public function initializeObjects() {		
			
			rotationAngle = 0;
			shieldFlag = 0;
			
			
			
			spawnPointX = (MovieClip(root).stage.stageWidth / 2) + 10;
			spawnPointY = (MovieClip(root).stage.stageHeight / 2) + 5;
			
			//create resizer - resizes objects
			resizer = new code.Resizer();		

			//Create soldier's deployable platform
			ground = new code.Ground();
			
			resizer.resizeMe(ground, 4000);
			ground.x = (MovieClip(root).stage.stageWidth / 2);
			ground.y = (MovieClip(root).stage.stageHeight / 2);
			ground.visible = true;
			MovieClip(root).addChild(ground);
			
			//Create soldier's deployable platform
			platform = new Platform();
			resizer.resizeMe(platform, 450);
			platform.x = (MovieClip(root).stage.stageWidth / 2) - 5;
			platform.y = (MovieClip(root).stage.stageHeight/ 2) - 5;
			platform.visible = false;
			MovieClip(root).addChild(platform);
						
			//Create soldier
			sm = new SoldierMovie();
			resizer.resizeMe(sm, 250);
			sm.x = (MovieClip(root).stage.stageWidth / 2);
			sm.y = (MovieClip(root).stage.stageHeight/ 2);
			MovieClip(root).addChild(sm);

			//add environment
			environment = new Environment();
			environment.pushVar(platform);
			environment.pushVar(ground);
			
			MovieClip(root).stage.addEventListener(Event.ENTER_FRAME, sm.rotate);
			MovieClip(root).stage.addEventListener(Event.ENTER_FRAME, everyFrame);
			
			sendSpawnPosition();
		}
		
		public function sendSpawnPosition() {
			
			//create the object that communicates with the server
			client = new SoldierClient(host, clientPort);
			client.connect();
			//MovieClip(root).Mouse.hide();
			
			groundX = (MovieClip(root).stage.stageWidth / 2);
			groundY = (MovieClip(root).stage.stageHeight/ 2);
			myGroundX = (MovieClip(root).stage.stageWidth / 2);
			myGroundY = (MovieClip(root).stage.stageHeight/ 2);
			
			tempStr = " 3" + (MovieClip(root).stage.stageWidth / 2) + " " + (MovieClip(root).stage.stageHeight/ 2);
			client.sendInitialPosition(tempStr);
		}
		
		public function everyFrame(event:Event) {
			MovieClip(root).stage.addEventListener(Event.ENTER_FRAME, sm.adjustEnvironment);
			MovieClip(root).stage.addEventListener(MouseEvent.MOUSE_MOVE,sm.follow);
			MovieClip(root).stage.addEventListener(KeyboardEvent.KEY_DOWN, sm.keyPressed); 
			MovieClip(root).stage.addEventListener(KeyboardEvent.KEY_UP, sm.keyReleased);
			
			//update shieldFlag
			if(sm.runningSoldier1.shield.visible == false) {
				shieldFlag = 0;
			}
			else {
				shieldFlag = 1;
			} 
			
			var frameString:String = "";
			//truncate rotation angle
			rotationAngle = sm.getAngle()*-1;
			frameString = " 2" + ground.x + " " + ground.y + " " + rotationAngle.toFixed(1) + " " + shieldFlag;
			sendFrame(frameString);
			updateOtherClients();
		}
		
		public function sendFrame(frameString:String) {
			client.sendFrame(frameString);
		}
		
		public function getSoldierMovie():SoldierMovie {
			return sm;		
		}
		
		public function getGround():Ground {
			return ground;
		}
		
		public function getPlatform():Platform {
			return platform;
		}
		
	    public function getEnvironment():Environment {
			return environment;
		}
		
		public function updateOtherClients():void {
		
			var angle:Number = 0;
			var j:int = 1;
			
			while(j < client.getSenderArray().length) {
				if(client.getPositionArray()[j] == null) {
					trace("client pos arr was null holler");
				}
				else {
					var posStr = client.getPositionArray()[j];
					myGroundX = parseInt(posStr.substring(0, posStr.indexOf(" ")));
					posStr = posStr.substring(posStr.indexOf(" ")+1, posStr.length);
					myGroundY = parseInt(posStr.substring(0, posStr.indexOf(" ")));
					posStr = posStr.substring(posStr.indexOf(" ")+1, posStr.length);
					angle = parseInt(posStr.substring(0, posStr.indexOf(" "))); //setting angle to single digit num
					posStr = posStr.substring(posStr.indexOf(" ")+1, posStr.length);
					var shieldFlag = parseInt(posStr.substring(0, posStr.length));
			
					//new soldier
					if(j >= soldierArray.length) {
						var tempSoldierMovie_mc:RemoteSoldierMovie = new RemoteSoldierMovie();
						resizer.resizeMe(tempSoldierMovie_mc, 75);
						tempSoldierMovie_mc.x =  spawnPointX; 
						tempSoldierMovie_mc.y =  spawnPointY;
						tempSoldierMovie_mc.visible = true;
						soldierArray[j] = tempSoldierMovie_mc;
						environment.pushVar(soldierArray[j]);
						MovieClip(root).addChild(soldierArray[j]);
					}
					//update existing soldier
					else if(j < soldierArray.length)  {
							
						soldierArray[j].x =  spawnPointX + (spawnPointX - myGroundX) + (ground.x - groundX);
						soldierArray[j].y =  spawnPointY + (spawnPointY - myGroundY)+ (ground.y - groundY);  
						
						if(shieldFlag == 0) {
							soldierArray[j].stillSoldier1.shield.visible = false;
							soldierArray[j].runningSoldier1.shield.visible = false;
							soldierArray[j].stillSoldier1.rifle.visible = true;
							soldierArray[j].runningSoldier1.rifle.visible = true;
						}
						else {
							soldierArray[j].stillSoldier1.shield.visible = true;
							soldierArray[j].runningSoldier1.shield.visible = true;
							soldierArray[j].stillSoldier1.rifle.visible = false;
							soldierArray[j].runningSoldier1.rifle.visible = false;
						}
						
						soldierArray[j].rotation = angle;
					}	else {
						//do nothing
						trace("j was neither greater than sender array nor less than or equal to it");
					}
				}
				j++;
			}
		}
		
	}
}