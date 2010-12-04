package net.smartsocket.gaming.ui {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	
	import net.smartsocket.gaming.events.*;
	
	[Event(name="move",type="events.JoystickEvent")];
	[Event(name="tap",type="events.JoystickEvent")];
	[Event(name="touch",type="events.JoystickEvent")];
	[Event(name="release",type="events.JoystickEvent")];
	public class Joystick extends MovieClip {
		//# The actual interactive clip
		private var _buttonHead:MovieClip;
		//# The base of the joystick; defines how far the head can move
		private var _buttonBase:MovieClip;
		//# The buttonStick clip allows us to easily conver width and height into useable x and y locations for boundaries of the buttonBase
		private var buttonStick:MovieClip;
		
		private var point:Point;
		private var _degrees:Number;
		private var distance:Number;
		private var xDist:Number;
		private var yDist:Number;
		
		private var touchID:int = -1;
		
		private var buttonHeadActiveOpacity:Number = 1;
		private var buttonHeadInactiveOpacity:Number = .7;
		
		public var interactiveObject:InteractiveObject;
		
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		public static const OMNIDIRECTIONAL:String = "omnidirectional";
		
		public var joystickMovementType:String = OMNIDIRECTIONAL;
		
		public function Joystick() {
			super();
			
			
			
			//# Set the multi-touch mode.
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			
			_buttonHead = this["buttonHead_mc"];
			_buttonHead.alpha = buttonHeadInactiveOpacity;
			
			_buttonBase = this["buttonBase_mc"];
			
			buttonStick = addChild( new MovieClip() );
			buttonStick.alpha = 0;
			
			//# Draw the buttonStick
			with(buttonStick.graphics) {
				lineStyle(0, 0x000000, 1, true, "none");
				lineTo(0, (_buttonBase.height / 2) * (-1) );
			}
			
			//# Add  touch events upon being added to the stage.
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}

		/**
		 * The actual interactive clip of the joystick.
		 * @return 
		 * 
		 */		
		public function get buttonHead():MovieClip {
			return _buttonHead;
		}
		/**
		 * The base of the joystick; defines how far the head can move
		 * @return 
		 * 
		 */		
		public function get buttonBase():MovieClip {
			return _buttonBase;
		}
		/**
		 * The degree angle of the Joystick tilt.
		 * @return 
		 * 
		 */		
		public function get degrees():Number {
			return _degrees;
		}

		private function onAddedToStage(event:Event):void {
			_buttonHead.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			
			_buttonHead.addEventListener(MouseEvent.MOUSE_DOWN, onTouchBegin);
		}		
		
		private function onTouchBegin(e:Event):void {
			//# Assign a touchevent id to this joystick
			try {
				touchID = e.touchPointID;
			}catch(er:Error){
				stage.addEventListener(MouseEvent.MOUSE_UP, onTouchEnd);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			}
			
			setJoystickValues(e);
			_buttonHead.alpha = buttonHeadActiveOpacity;
			buttonStick.alpha = 1;
			
			try {
				interactiveObject.dispatchEvent( new JoystickEvent(JoystickEvent.JOYSTICK_TOUCH, this) );
			}catch(er:Error) {
				trace("There doesn't seem to be an InteractiveObject associated with this Joystick object ("+this.name+")");
			}
		}
		
		private function onTouchMove(e:Event):void {
			//# Check to see if the touch event is for this joystick
			try {
				if(e.touchPointID != touchID) {
					return;
				}
			}catch(er:Error){				
			}
			
			
			//# Setup all of the position values for the joystick
			setJoystickValues(e);
			
			//# Rotate the buttonStick accordingly
			buttonStick.rotation = _degrees;
			
			//# Ensure we are allowing horizontal movements;
			if(this.joystickMovementType == Joystick.HORIZONTAL || this.joystickMovementType == Joystick.OMNIDIRECTIONAL) {
				//# Render the buttonHead movement on the x axis
				//# First we check to see if it's within acceptable bounds.
				if(xDist > buttonStick.width) {
					//# The touch position is not within legal bounds of the buttonBase.
					//# We do some simple math to position the buttonHead accordingly				
					if(point.x < 0) {
						_buttonHead.x = (buttonStick.width * (-1));
					}else {
						_buttonHead.x = buttonStick.width;
					}					
				}else {
					//# If the buttonHead is within legal bounds, just position the buttonHead to the point of touch contact.
					_buttonHead.x = point.x;
				}
			}
			
			//# Ensure we are allowing vertical movements;
			if(this.joystickMovementType == Joystick.VERTICAL || this.joystickMovementType == Joystick.OMNIDIRECTIONAL) {
				//# Render the buttonHead movement on the y axis
				//# First we check to see if it's within acceptable bounds.
				if(yDist > buttonStick.height) {
					//# The touch position is not within legal bounds of the buttonBase.
					//# We do some simple math to position the buttonHead accordingly	
					if(point.y < 0) {
						_buttonHead.y = (buttonStick.height * (-1));
					}else {
						_buttonHead.y = buttonStick.height;
					}					
				}else {
					//# If the buttonHead is within legal bounds, just position the buttonHead to the point of touch contact.
					_buttonHead.y = point.y;
				}
			}
			
			try {
				interactiveObject.dispatchEvent( new JoystickEvent(JoystickEvent.JOYSTICK_MOVE, this) );
			}catch(er:Error) {
				trace("There doesn't seem to be an InteractiveObject associated with this Joystick object ("+this.name+")");
			}
			
		}
		
		private function onTouchEnd(e:Event):void {
			//# Check to see if the touch event is for this joystick
			try {
				if(e.touchPointID != touchID) {
					return;
				}
			}catch(er:Error){				
			}
			
			//# Reset the buttonHead to dead center
			_buttonHead.x = 0;
			_buttonHead.y = 0;
			_buttonHead.alpha = buttonHeadInactiveOpacity;
			buttonStick.alpha = 0;
			
			//# Remove the touch id for this joystick.
			touchID = -1;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTouchEnd);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			
			setJoystickValues(e);
			
			try {
				interactiveObject.dispatchEvent( new JoystickEvent(JoystickEvent.JOYSTICK_RELEASE, this) );
			}catch(er:Error) {
				trace("There doesn't seem to be an InteractiveObject associated with this Joystick object ("+this.name+")");
			}
			
			
		}
		
		private function setJoystickValues(e:Event):void {
			//# Get local coordinates from the touch event on the stage.
			point = globalToLocal( new Point(e.stageX, e.stageY) );
			
			//# Convert the points to radians
			var radians:Number = Math.atan2(point.y, point.x);
			
			//# Convert radians to degrees
			_degrees = 360 * radians / (2 * Math.PI) + 90;
			
			//# Distance between dead center, and the touched point.
			distance = Point.distance(new Point(0, 0), point);
			
			//# Distance on X axis from dead center
			xDist = Math.abs(point.x - 0);
			
			//# Distance on Y axis from dead center
			yDist = Math.abs(point.y - 0);
		}
		
	}
}