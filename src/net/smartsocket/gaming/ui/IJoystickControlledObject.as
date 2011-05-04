package net.smartsocket.gaming.ui
{
	import net.smartsocket.gaming.events.JoystickEvent;

	public interface IJoystickControlledObject	{
		
		function onJoystickMove(event:JoystickEvent):void;
		function onJoystickRelease(event:JoystickEvent):void;
		
	}
}