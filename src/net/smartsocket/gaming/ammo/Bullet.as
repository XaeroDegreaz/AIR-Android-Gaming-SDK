package net.smartsocket.gaming.ammo {
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	public class Bullet extends MovieClip {
		
		var speed:Number = 3;
		var angle:Number;
		var timer:Timer = new Timer(1000);
		
		public function Bullet(angle:Number) {
			super();
			this.angle = angle;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.cacheAsBitmap = true;
		}

		private function onTimer(event:TimerEvent):void
		{
			timer.stop();
			timer = null;
			trace("Removing");
			parent.removeChild(this);
		}

		private function onAddedToStage(event:Event):void
		{
			timer.start();
		}

		private function onEnterFrame(event:Event):void	{
			var speedX:Number = Math.sin( angle * (Math.PI / 180) ) * 2;
			var speedY:Number = Math.cos( angle * (Math.PI / 180) ) * 2 * -1;
			
			this.x += speedX * speed;
			this.y += speedY * speed;	
		}
		
	}
}