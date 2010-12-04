package net.smartsocket.gaming.events {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	
	import net.smartsocket.gaming.ui.Joystick;
	
	public class JoystickEvent extends Event {
		/**
		 *Dispatched when a Joystick buttonHead is moved around its boundaries. 
		 */	
		public static const JOYSTICK_MOVE:String = "move";
		/**
		 *Dispatched when a Joystick buttonHead is tapped (touch and release quickly). 
		 */	
		public static const JOYSTICK_TAP:String = "tap";
		/**
		 *Dispatched when a Joystick buttonHead is initially touched. 
		 */	
		public static const JOYSTICK_TOUCH:String = "touch";
		/**
		 *Dispatched when a Joystick buttonHead is released. 
		 */		
		public static const JOYSTICK_RELEASE:String = "release";
		
		private var _joystick:Joystick;
		private var _degrees:Number;
		private var _distanceAbsolute:Number;
		private var _distanceX:Number;
		private var _distanceY:Number;
		
		/**
		 *A simple debug string that contains all of the pertenent information about this event. 
		 */		
		public var debugString:String;
		
		public function JoystickEvent(type:String, _joystick:Joystick, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			this._joystick = _joystick;
			this._degrees = _joystick.degrees;
			this._distanceX = _joystick.buttonHead.x;
			this._distanceY = _joystick.buttonHead.y;
			this._distanceAbsolute = Point.distance( new Point(0,0), new Point(_distanceX, _distanceY) );
			
			debugString = "Event: "+type+", Degrees: "+degrees+", DistanceAbsolute: "+distanceAbsolute+", DistanceX: "+distanceX+", DistanceY: "+distanceY;
			
		}
		
		/**
		 * A reference to this event's Joystick object.
		 * @return Joystick
		 * 
		 */		
		public function get joystick():Joystick	{
			return _joystick;
		}
		/**
		 * he degree tilt of the Joystick. 
		 * @return Number
		 * 
		 */		
		public function get degrees():Number {
			return _degrees;
		}
		/**
		 * The distance of the Joystick buttonHead from the center of the Joystick buttonBase
		 * @return Number
		 * 
		 */		
		public function get distanceAbsolute():Number {
			return _distanceAbsolute;
		}
		/**
		 * The X distance of the Joystick buttonHead from the center of the Joystick buttonBase on the X axis.
		 * @return Number
		 * 
		 */		
		public function get distanceX():Number {
			return _distanceX;
		}
		/**
		 * The Y distance of the Joystick buttonHead from the center of the Joystick buttonBase on the Y axis. 
		 * @return Number
		 * 
		 */		
		public function get distanceY():Number {
			return _distanceY;
		}

	}
}