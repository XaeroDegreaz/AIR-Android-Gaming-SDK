package net.smartsocket.gaming.controlers {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class GenericControler {
		
		private var _interactiveObject:InteractiveObject;
		
		public function GenericControler(pInteractiveObject:InteractiveObject) {
			_interactiveObject = pInteractiveObject;
		}
		
		public function moveInverted(angle:Number, speed:Number):void {
			var s:Object = getSpeeds(angle, speed);
			
			_interactiveObject.x -= s.speedX * speed;
			_interactiveObject.y -= s.speedY * speed;			
		}
		
		public function move(angle:Number, speed:Number):void {
			var s:Object = getSpeeds(angle, speed);
			
			_interactiveObject.x += s.speedX * speed;
			_interactiveObject.y += s.speedY * speed;
		}
		
		private function getSpeeds(angle:Number, speed:Number):Object {
			var speedX:Number = Math.sin( angle * (Math.PI / 180) ) * 2;
			var speedY:Number = Math.cos( angle * (Math.PI / 180) ) * 2 * -1;
			
			return {speedX: speedX, speedY:speedY};
		}
		
//		public function moveInteractiveObject(angle:Number, speed:Number):void {
//			var speedX:Number = Math.sin( angle * (Math.PI / 180) ) * 2;
//			var speedY:Number = Math.cos( angle * (Math.PI / 180) ) * 2 * -1;
//			
//			if(isControlInverted) {
//				interactiveObject.x -= speedX * speed;
//				interactiveObject.y -= speedY * speed;
//			}else {
//				interactiveObject.x += speedX * speed;
//				interactiveObject.y += speedY * speed;
//			}
//		}
		
	}
}