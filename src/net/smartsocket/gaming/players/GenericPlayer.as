package net.smartsocket.gaming.players {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import net.smartsocket.gaming.controlers.GenericControler;
	import net.smartsocket.gaming.ui.JoystickControlledObject;
	
	public class GenericPlayer extends MovieClip {
		
		public var actionController:GenericControler;
		
		public function GenericPlayer()	{
			super();
			this["feet_mc"].stop();
		}
		
	}
}