function HandleXSpeed()
{
	// X collision
	var _subPixel = .5;
	if place_meeting(x + xSpeed, y, obj_solid)
	{
		// First check if there is a slope to go up
		if !place_meeting(x + xSpeed, y - abs(xSpeed) - 1, obj_solid)
		{
			while place_meeting(x + xSpeed, y, obj_solid)
				y -= _subPixel;
		}
		 // If there is no slope, regular collision
		else
		{
			// Ceiling Slopes
			if !place_meeting(x + xSpeed, y + abs(xSpeed) + 1, obj_solid)
			{
				while place_meeting(x + xSpeed, y, obj_solid)
					y += _subPixel;
			}
			// Normal collision
			else
			{
			    // Scoot up to wall precisely
			    var _pixelCheck = _subPixel * sign(xSpeed);
			    while !place_meeting(x + _pixelCheck, y, obj_solid)
			        x += _pixelCheck;
		
			    // Set Xspeed to zero to "collide"
			    xSpeed = 0;
			}
		}
	}

	// Go Down Slopes
	var _downSlopeSemisolid = noone;
	if ySpeed >= 0 && !place_meeting(x + xSpeed, y + 1, obj_solid) && place_meeting(x + xSpeed, y + abs(xSpeed) + 1, obj_solid)
	{
		// Check for a semisolid in the way
		_downSlopeSemisolid = CheckForSemisolidPlatform(x + xSpeed, y + abs(xSpeed) + 1);
		// Precisely move down the slope
		if !instance_exists(_downSlopeSemisolid)
		{
			while !place_meeting(x + xSpeed, y + _subPixel, obj_solid)
				y += _subPixel;
		}
	}

	// Move
	x += xSpeed;
}