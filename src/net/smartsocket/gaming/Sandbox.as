package net.smartsocket.gaming {
	import net.smartsocket.gaming.events.JoystickEvent;
	
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import net.smartsocket.gaming.ui.Joystick;
	import net.smartsocket.gaming.ammo.*;
	
	
	
	public class Sandbox extends MovieClip {
		var test:MovieClip;
		
		var left_je:JoystickEvent;
		var right_je:JoystickEvent;
		
		public var shootTimer:Timer = new Timer(250);
		public var shooting:Boolean = false;
		public var moving:Boolean = false;
		
		public function Sandbox() {
			super();
			test = this["test_mc"];
			test.feet_mc.stop();
			
			Joystick(this["left_mc"]).interactiveObject = test;
			Joystick(this["right_mc"]).interactiveObject = test;
			
			test.addEventListener(JoystickEvent.JOYSTICK_MOVE, onMove);
			test.addEventListener(JoystickEvent.JOYSTICK_RELEASE, onRelease);
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
		}

		private function shoot(event:TimerEvent):void {
			
			var b:Bullet = new Bullet(test.rotation);
			
			var p:Point = new Point(test.gun_mc.x, test.gun_mc.y);
			var ltg:Point = test.localToGlobal(p);
			
			b.x = ltg.x;
			b.y = ltg.y;
			
			stage.addChild(b);
		}		

		private function onRelease(event:JoystickEvent):void {
			
			if(event.joystick.name == "left_mc") {
				moving = false;
				test.removeEventListener(Event.ENTER_FRAME, movePlayer);
				test.feet_mc.stop();
			}else if(event.joystick.name == "right_mc") {
				
				if(moving) {
					test.rotation = left_je.degrees;
				}
				
				shooting = false;
				shootTimer.stop();
				shootTimer.reset();
			}
		}

		private function onMove(event:JoystickEvent):void {
			trace(event.debugString);
			
			if(event.joystick.name == "left_mc") {
				left_je = event;
				moving = true;
				test.feet_mc.play();
				
				if(!shooting) {
					test.rotation = event.degrees;
				}
			
				test.addEventListener(Event.ENTER_FRAME, movePlayer);
			}else if(event.joystick.name == "right_mc") {
				
				//# Only start shooting if not already shooting
				if(!shooting) {
					shootTimer.start();
				}
				
				shooting = true;
				test.rotation = event.degrees;
				
			}
		}

		private function movePlayer(event:Event):void	{
			var angle:Number;
			if(!shooting) {
				angle = test.rotation;
			}else {
				angle = left_je.degrees;
			}
			
			var speed:Number = 1;
			var speedX:Number = Math.sin( angle * (Math.PI / 180) ) * 2;
			var speedY:Number = Math.cos( angle * (Math.PI / 180) ) * 2 * -1;
			
			map_mc.bg_mc.x -= speedX * speed;
			map_mc.bg_mc.y -= speedY * speed;			
		}
		
	}
}