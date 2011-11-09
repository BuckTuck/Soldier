package code{ 
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	public class SoldierClient extends Sprite {
		private var host:String;
		private var port:int;
		private var socket:Socket;
		private var chatLimit:Number = 0;
		private var senderArray:Array;
		private var positionArray:Array;
		private var nonce:Number = 0;
		
		public function SoldierClient(h:String, p:int) {
			this.host = h;
			this.port = p;
			this.senderArray = new Array();
			this.positionArray = new Array();
		}
		
		public function sendMessage(msg:String):void {
			msg += "\n";
			
			try {
				this.socket.writeUTFBytes(msg);
				this.socket.flush();
				//trace("Message sent: " + msg);
			}
			catch(e:Error) {
				trace("Error sending data: " + e);
			}
		}
		
		public function sendFrame(msg:String):void {
			msg += "\n";
			
			try {
				this.socket.writeUTFBytes(msg);
				this.socket.flush();
				//trace("Message sent: " + msg);
			}
			catch(e:Error) {
				trace("Error sending data: " + e);
			}
		}
		
		public function sendInitialPosition(msg:String):void {

			msg += "\n";
			
			try {
				this.socket.writeUTFBytes(msg);
				this.socket.flush();
				//trace("initial position: " + msg);
			}
			catch(e:Error) {
				trace("Error sending data: " + e);
			}
		}
		
		private function receiveData(msg:String):void {
			
			var soldierMessage:String = "";
			var sender:String = msg.substring(0, msg.indexOf(" "));
			soldierMessage = msg.substring(msg.indexOf(" ")+1 ,msg.length);
			
			var foundFlag:Boolean = false;
			
			//test to see if the sender is already in the system
			var i:int = 0;
			while(i < sender.length) {
				if(senderArray[i] == sender) {
					handleMessage(i, soldierMessage);
					foundFlag = true;
				}
				i++;
			}
			if(!foundFlag) {
				senderArray.push(sender);
				handleMessage(senderArray.indexOf(sender), soldierMessage);
				foundFlag = false;
			}
		}
		
		public function handleMessage(index:Number, soldierMessage:String) {
			if(soldierMessage.charAt(0) == "1") {

			} 
			else if(soldierMessage.charAt(0) == "2") {
				var strX:String = soldierMessage.substring(1, soldierMessage.indexOf(" "));
				var strY:String = soldierMessage.substring(soldierMessage.indexOf(" "), soldierMessage.length);
				positionArray[index] = "" + strX + strY;
			} 
			else {
				trace("did nothing");
			}
			//trace("&&&&&&&&&&&&&&&&&&& senderArray: " + senderArray);
			//trace("******************* positionArray: " + positionArray);
		}
		
		public function getSenderArray():Array {
			return senderArray;
		}
		
		public function getPositionArray():Array {
			return positionArray;
		}
		
		public function connect():Boolean {
			this.socket = new Socket(this.host, this.port);
			this.socket.addEventListener(Event.CONNECT, socketConnect);
			this.socket.addEventListener(Event.CLOSE, socketClose);
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, socketError);
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, socketData);
				
			try {
				this.socket.connect(this.host, this.port);
			}
			catch (e:Error) {
				trace("Error on connect: " + e);
				return false;
			}
			return true;
		}
		
		private function socketConnect(event:Event):void {
			trace("Connected: " + event);
		}

		private function socketData(event:ProgressEvent):void {
			//trace("Receiving data: " + event);
			receiveData(this.socket.readUTFBytes(this.socket.bytesAvailable));
		}
		
		private function socketClose(event:Event):void {
			trace("Connection closed: " + event);
			//this.chatArea.appendText("Connection lost." + "\n");
		}
		
		private function socketError(event:IOErrorEvent):void {
			trace("Socket error: " + event);
		}
		
		private function securityError(event:SecurityErrorEvent):void {
			trace("Security error: " + event);
		}
	}
}