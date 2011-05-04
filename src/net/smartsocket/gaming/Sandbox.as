package net.smartsocket.gaming {
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import net.smartsocket.gaming.ammo.*;
	import net.smartsocket.gaming.controlers.GenericControler;
	import net.smartsocket.gaming.events.JoystickEvent;
	import net.smartsocket.gaming.ui.Joystick;
	import net.smartsocket.gaming.ui.JoystickControlledObject;
	
	public class Sandbox extends MovieClip {
		
		
		var left_je:JoystickEvent;
		var right_je:JoystickEvent;
		
		public var leftJoystick:Joystick;
		public var rightJoystick:Joystick;
		
		public var shootTimer:Timer = new Timer(250);
		public var shooting:Boolean = false;
		public var moving:Boolean = false;
		
		public var test:JoystickControlledObject;
		public var movementController:JoystickControlledObject;
		
		public function Sandbox() {
			super();
			
			movementController = new JoystickControlledObject(
				map_mc.bg_mc, left_mc, new GenericControler(map_mc.bg_mc), true
			);
			
			test = new JoystickControlledObject(
				test_mc, right_mc, new GenericControler(test_mc)
			);
			
			movementController.setMoveListeners( [ movementController.movementGeneric, test.rotateGeneric, animateStart ]);
			movementController.setReleaseListeners( [ animateStop ]);
			
			test.setMoveListeners( [ test.rotateGeneric, startShootTimer ] );
			test.setReleaseListeners( [ stopShootTimer ] );			
			
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
		}
		
		private function animateStart(event:JoystickEvent = null):void {
			test.interactiveObject.feet_mc.play();
		}
		
		private function animateStop(event:JoystickEvent = null):void {
			test.interactiveObject.feet_mc.stop();
		}
		
		private function startShootTimer(event:JoystickEvent):void {
			shootTimer.start();
		}
		private function stopShootTimer(event:JoystickEvent):void {
			shootTimer.stop();
		}
		
		private function shoot(event:TimerEvent):void {
			
			var b:Bullet = new Bullet(test.interactiveObject.rotation);
			
			var p:Point = new Point(test.interactiveObject.gun_mc.x, test.interactiveObject.gun_mc.y);
			var ltg:Point = test.interactiveObject.localToGlobal(p);
			
			b.x = ltg.x;
			b.y = ltg.y;
			
			stage.addChild(b);
		}		

		private function onRelease(event:JoystickEvent):void {
			
			if(event.joystick.name == "left_mc") {
				moving = false;
				movementController.interactiveObject.removeEventListener(Event.ENTER_FRAME, scrollMap);
				test.interactiveObject.feet_mc.stop();
			}else if(event.joystick.name == "right_mc") {
				
				if(moving) {
					test.interactiveObject.rotation = left_je.degrees;
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
				test.interactiveObject.feet_mc.play();
				
				if(!shooting) {
					test.interactiveObject.rotation = event.degrees;
				}
			
				movementController.interactiveObject.addEventListener(Event.ENTER_FRAME, scrollMap);
			}else if(event.joystick.name == "right_mc") {
				
				//# Only start shooting if not already shooting
				if(!shooting) {
					shootTimer.start();
				}
				
				shooting = true;
				test.interactiveObject.rotation = event.degrees;
				
			}
		}

		private function scrollMap(event:Event):void	{
			var angle:Number;
			if(!shooting) {
				angle = test.interactiveObject.rotation;
			}else {
				angle = left_je.degrees;
			}
			
			var speed:Number = 1;
			
			movementController.moveInteractiveObject(angle, speed);		
		}
		
	}
}