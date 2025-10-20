function HandleYSpeed()
{
	// Handle falling
	if ySpeed > maxFallSpeed
	    ySpeed = maxFallSpeed;
	
	// Y collision
	var _subPixel = .5;

	// Upwards Y Collision (with ceiling slopes)
	if ySpeed < 0 && place_meeting(x, y + ySpeed, obj_solid)
	{
		// Jump into sloped ceilings
		slopeSlide = false;
	
		// Slide UpLeft slope
		if xSpeed == 0 && !place_meeting(x - abs(ySpeed) - 1, y + ySpeed, obj_solid)
		{
			while place_meeting(x, y + ySpeed, obj_solid)
				x -= 1;
		
			slopeSlide = true;
		}
		// Slide UpRight slope
		if xSpeed == 0 && !place_meeting(x + abs(ySpeed) + 1, y + ySpeed, obj_solid)
		{
			while place_meeting(x, y + ySpeed, obj_solid)
				x += 1;
		
			slopeSlide = true;
		}
	
		// Normal Y Collision
		if !slopeSlide
		{
			// Move pixel by pixel until collision
		    var _pixelCheck = _subPixel * sign(ySpeed);
		    while !place_meeting(x, y + _pixelCheck, obj_solid)
		    {
		        y += _pixelCheck;
		    }
		
			if ySpeed < 0
				jumpHoldTimer = 0;

		    // Stop y movement
		    ySpeed = 0;
		}
	}

	// Downwards Y Collision

	// Check for solid and semisolid platforms under me
	var _clampYSpeed = max(0, ySpeed);
	var _list = ds_list_create(); // Create a DS list to store all the objects we run into
	var _array = array_create(1);
	array_push(_array, obj_solid, obj_semisolid)

	// Do the actual check and add objects to list
	var _listSize = instance_place_list(x, y + 1 + _clampYSpeed + movePlatMaxYSpeed, _array, _list, false)

	// Fix for high resolution
	var _yCheck = y + 1 +_clampYSpeed;

	if instance_exists(myFloorPlat)
		_yCheck += max(0, myFloorPlat.ySpeed);
	
	var _semisolid = CheckForSemisolidPlatform(x, _yCheck);

	// Loop through the colliding instances and only return one if it's top is bellow the player
	for (var i = 0; i < _listSize; i++)
	{
		// Get an instance from the list
		var _listInst = _list[| i];

		// Avoid magnetism
		if (_listInst != forgetSemiSolid
		&& (_listInst.ySpeed <= ySpeed || instance_exists(myFloorPlat))
		&& (_listInst.ySpeed > 0 || place_meeting(x, y + 1 + _clampYSpeed, _listInst)))
		|| (_listInst == _semisolid)
		{
			// Return a solid collision or any semisolid that is bellow the player
			if _listInst.object_index == obj_solid
			|| object_is_ancestor(_listInst.object_index, obj_solid)
			|| floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.ySpeed)
			{
				// Return the "highest" solid instance
				if !instance_exists(myFloorPlat)
				|| _listInst.bbox_top + _listInst.ySpeed <= myFloorPlat.bbox_top + myFloorPlat.ySpeed
				|| _listInst.bbox_top + _listInst.ySpeed <= bbox_bottom
				{
					myFloorPlat = _listInst;
				}
			}
		}
	}

	// Destroy the DS list to prevent memory leaks
	ds_list_destroy(_list);

	// One final check with the found floor platform
	if instance_exists(myFloorPlat) && !place_meeting(x, y + movePlatMaxYSpeed, myFloorPlat)
	{
		myFloorPlat = noone;
	}

	// Land on the ground platform if there is one
	if instance_exists(myFloorPlat)
	{
		// Scoot up to platform precisely
		_subPixel = .5;
		while !place_meeting(x, y + _subPixel, myFloorPlat) && !place_meeting(x, y, obj_solid)
			y += _subPixel;

		// Make sure we don't end up below the top of a semisolid platform
		if myFloorPlat.object_index == obj_semisolid || object_is_ancestor(myFloorPlat.object_index, obj_semisolid)
		{
			while place_meeting(x, y, myFloorPlat)
				y -= _subPixel;
		}

		// Floor the y variable to prevent subpixel issues
		y = floor(y);

		// Set on ground
		ySpeed = 0;
		SetOnGround(true);
	}

	// Manually fall through a semisolid platform
	if ignoreSemiSolid
	{
		// Make sure we have a floor platform that's a semisolid
		if instance_exists(myFloorPlat)
		&& (myFloorPlat.object_index == obj_semisolid || object_is_ancestor(myFloorPlat.object_index, obj_semisolid))
		{
			// Check if we can go below the semisolid
			_yCheck = max(1, myFloorPlat.ySpeed + 1);
		
			if !place_meeting(x, y + _yCheck, obj_solid)
			{
				// Move below the platform
				y += 1;
			
				// Inherit any downward speed from my floor platform so it doesn't catch me
				ySpeed = _yCheck - 1;
			
				// Forget this platform for a brief time so we don't get caught again
				forgetSemiSolid = myFloorPlat;
			
				// No more floor platform
				SetOnGround(false);
			}
		}
	}

	// Move vertically
	if !place_meeting(x, y + ySpeed, obj_solid)
		y += ySpeed;

	// Reset forgetSemiSolid variable
	if instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid)
	{
		forgetSemiSolid = noone;
	}
}