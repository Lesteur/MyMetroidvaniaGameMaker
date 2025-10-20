function HandleFinalMovePlatforms()
{
	// X - movePlatXSpeed and collision
	// Get the movePlatXSpeed
	movePlatXSpeed = 0;
	if instance_exists(myFloorPlat)
		movePlatXSpeed = myFloorPlat.xSpeed;

	// Move with movePlatXSpeed
	if !earlyMovePlatXSpeed
	{
		if place_meeting(x + movePlatXSpeed, y, obj_solid)
		{
			// Scoot up to wall precisely
			var _pixelCheck = .5 * sign(movePlatXSpeed);
			while !place_meeting(x + _pixelCheck, y, obj_solid)
				x += _pixelCheck;

			// Set Xspeed to zero to "collide"
			movePlatXSpeed = 0;
		}

		x += movePlatXSpeed;
	}

	// Y - Snap myself to myFloorPlat if it's moving vertically
	if instance_exists(myFloorPlat)
	&& (myFloorPlat.ySpeed != 0
	|| myFloorPlat.object_index == obj_solid_move
	|| object_is_ancestor(myFloorPlat.object_index, obj_solid_move)
	|| myFloorPlat.object_index == obj_semisolid_move
	|| object_is_ancestor(myFloorPlat.object_index, obj_semisolid_move))
	{
		// Snap to the top of the floor platform ( unfloor to prevent jitter )
		if !place_meeting(x, myFloorPlat.bbox_top, obj_solid)
		&& myFloorPlat.bbox_top >= bbox_bottom - movePlatMaxYSpeed
		{
			y = myFloorPlat.bbox_top;
		}

		/* Redundant code
		// Going up into a solid wall while on a semisolid platform
		if myFloorPlat.ySpeed < 0 && place_meeting(x, y + myFloorPlat.ySpeed, obj_solid)
		{
			// Going up into a solid while on a semisolid platform
			if myFloorPlat.object_index == obj_semisolid || object_is_ancestor(myFloorPlat.object_index, obj_semisolid)
			{
				// Get pushed down through the semisolid
				_subPixel = .25;
				while place_meeting(x, y + myFloorPlat.ySpeed, obj_solid)
					y += _subPixel;
		
				// If we got pushed down into a solid while going downwards, push ourselves back out
				while place_meeting(x, y, obj_solid)
					y -= _subPixel;
		
				y = round(y);
			}
			// Cancel the myFloorPlat variable
			SetOnGround(false);
		}
		*/
	}

	// Get pushed down through a semisolid by a moving solid platform
	if instance_exists(myFloorPlat)
	&& (myFloorPlat.object_index == obj_semisolid || object_is_ancestor(myFloorPlat.object_index, obj_semisolid))
	&& place_meeting(x, y, obj_solid)
	{
		// If I'm already stuck in a wall at this point, try and move me down to get below a semisolid
		// If I'm still stuck afterwards, that just means I've been properly "crushed"
	
		// Also, don't check too far, we don't want to warp below walls
		var _maxPushDist = 10;
		var _pushedDist = 0;
		var _startY = y;
	
		while place_meeting(x, y, obj_solid) // && _pushedDist <= _maxPushDist
		{
			y ++;
			_pushedDist ++;
		}
	
		// Forget myFloorPlat
		myFloorPlat = noone;
	
		// If I'm still in a wall at this point, I've been crushed regardless, take me back to my start y
		if _pushedDist > _maxPushDist
			y = _startY;
	}
}