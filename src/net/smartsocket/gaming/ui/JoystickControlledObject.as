package net.smartsocket.gaming.ui {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	
	import net.smartsocket.gaming.controlers.GenericControler;
	import net.smartsocket.gaming.events.*;
	
	public class JoystickControlledObject extends EventDispatcher {
		
		private var _invertControls:Boolean;		
		private var _interactiveObject:InteractiveObject;
		private var _joystick:Joystick;
		private var _controller:GenericControler;
		public var moveSpeed:Number = 1;
		private var _timer:Timer;
		public var joystickEvent:JoystickEvent;
		public var moveListeners:Vector.<Function> = new Vector.<Function>();
		public var releaseListeners:Vector.<Function> = new Vector.<Function>();
		private var _extraJoystickControlledObjects:Vector.<JoystickControlledObject>;
		
		/**
		 *ScrollableDisplayObject is the map-like display object that enables a centered-view of
		 * a player on your map stage. 
		 * 
		 */		
		public function JoystickControlledObject(pInteractiveObject:InteractiveObject, pJoystick:Joystick, pControler:GenericControler, pInvertControls:Boolean = false, pUpdateInterval:Number = 10) {
			super();
			_interactiveObject = pInteractiveObject;
			_joystick = pJoystick;
			_joystick.joystickControlledObject = this;
			_controller = pControler;
			_invertControls = pInvertControls;
			_timer = new Timer(pUpdateInterval);
			
			
			addEventListener(JoystickEvent.JOYSTICK_MOVE, onJoystickMove);
			addEventListener(JoystickEvent.JOYSTICK_RELEASE, onJoystickRelease);
			_timer.addEventListener(TimerEvent.TIMER, update);
		}
		
		public function addJoystickControlledObject(object:JoystickControlledObject):void {
			_extraJoystickControlledObjects.push(object);
		}


		public function get interactiveObject():InteractiveObject
		{
			return _interactiveObject;
		}

		public function get joystick():Joystick
		{
			return _joystick;
		}

		public function get controller():GenericControler
		{
			return _controller;
		}

		protected function onJoystickRelease(event:JoystickEvent):void {
			joystickEvent = event;
			_timer.reset();
			_timer.stop();
			
			for each(var func:Function in releaseListeners) {
				func(joystickEvent);
			}
		}

		protected function onJoystickMove(event:JoystickEvent):void {
			//trace(event.debugString);
			joystickEvent = event;
			_timer.start();
		}
		
		private function update(event:TimerEvent):void {
			
			for each(var func:Function in moveListeners) {
				func(joystickEvent);
			}
						
		}
		
		public function movementGeneric(event:JoystickEvent = null):void {
			
			var js:JoystickEvent = event;
			var degrees:Number;
			
			if(event) {
				degrees = event.degrees;
			}else {
				degrees = joystickEvent.degrees;
			}
			
			if(_invertControls) {
				controller.moveInverted(degrees, this.moveSpeed);
			}else {
				controller.move(degrees, this.moveSpeed);
			}
		}
		
		public function rotateGeneric(event:JoystickEvent = null):void {
			
			var js:JoystickEvent = event;
			var degrees:Number;
			
			if(event) {
				degrees = event.degrees;
			}else {
				degrees = joystickEvent.degrees;
			}
			
			_interactiveObject.rotation = degrees;
		}
		
		public function setMoveListeners(array:Array):void {
			for each(var func:Function in array) {
				moveListeners.push(func);
			}
		}
		
		public function setReleaseListeners(array:Array):void {
			for each(var func:Function in array) {
				releaseListeners.push(func);
			}
		}
		
	}
}