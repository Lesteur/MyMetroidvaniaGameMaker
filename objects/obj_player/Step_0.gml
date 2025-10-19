/// @description Step

// Get input values
getControllerInput();

#region X movement

// Direction
moveDir = rightKey - leftKey;
// Get my face
if moveDir != 0
	face = moveDir;
// Get x speed
runType = runKey;
xSpeed = moveDir * moveSpeed[runType];

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
	_downSlopeSemisolid = checkForSemisolidPlatform(x + xSpeed, y + abs(xSpeed) + 1);
	// Precisely move down the slope
	if !instance_exists(_downSlopeSemisolid)
	{
		while !place_meeting(x + xSpeed, y + _subPixel, obj_solid)
			y += _subPixel;
	}
}

// Move
x += xSpeed;

#endregion

#region Y movement

// Gravity
if coyoteHangTimer > 0
{
    // Count the timer down
    coyoteHangTimer --;
}
else
{
    // Apply gravity
    ySpeed += grav;
    // We're not longer on the ground
    setOnGround(false);
}

// Reset/Prepare jumping variables
if onGround
{
    jumpCount = 0;
    coyoteJumpTimer = coyoteJumpFrames;
}
else
{
    // If the player is in the air, do not make an extra jump
	coyoteJumpTimer --;
	
    if jumpCount == 0 && coyoteJumpTimer <= 0
        jumpCount = 1;
}

// Initate the jump
var _floorIsSolid = false;

if instance_exists(myFloorPlat)
&& (myFloorPlat.object_index == obj_solid || object_is_ancestor(myFloorPlat.object_index, obj_solid))
	_floorIsSolid = true;

// Initiate the jump
if jumpKeyBuffered && jumpCount < jumpMax && (!downKey || _floorIsSolid)
{
    // Reset the buffer
    jumpKeyBuffered = false;
    jumpKeyBufferedTimer = 0;
    // Increment jump count
    jumpCount ++;
    // Set the jump hold timer
    jumpHoldTimer = jumpHoldFrames[jumpCount - 1];
    // Not on ground anymore
    setOnGround(false);
}

// Cut off jump if the player releases the jump key
if !jumpKey
{
    jumpHoldTimer = 0;
}

// Jump based on the timer/holding the jump key
if jumpHoldTimer > 0
{
	// Constantly set the yspd to be jumping speed
    ySpeed = jumpSpeed[jumpCount - 1];
	// Count down the timer
    jumpHoldTimer --;
}

// Handle falling
if ySpeed > maxFallSpeed
    ySpeed = maxFallSpeed;

// Y collision
_subPixel = .5;

// Upwards Y Collision (with ceiling slopes)
if ySpeed < 0 && place_meeting(x, y + ySpeed, obj_solid)
{
	// Jump into sloped ceilings
	var _slopeSlide = false;
	
	// Slide UpLeft slope
	if xSpeed == 0 && !place_meeting(x - abs(ySpeed) - 1, y + ySpeed, obj_solid)
	{
		while place_meeting(x, y + ySpeed, obj_solid)
			x -= 1;
		
		_slopeSlide = true;
	}
	// Slide UpRight slope
	if xSpeed == 0 && !place_meeting(x + abs(ySpeed) + 1, y + ySpeed, obj_solid)
	{
		while place_meeting(x, y + ySpeed, obj_solid)
			x += 1;
		
		_slopeSlide = true;
	}
	
	// Normal Y Collision
	if !_slopeSlide
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
	
var _semisolid = checkForSemisolidPlatform(x, _yCheck);

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
	setOnGround(true);
}

// Manually fall through a semisolid platform
if downKey && jumpKeyPressed
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
			setOnGround(false);
		}
	}
}

// Move vertically
y += ySpeed;

// Reset forgetSemiSolid variable
if instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid)
{
	forgetSemiSolid = noone;
}

#endregion

#region Final moving platform collisions and movement

// X - movePlatXSpeed and collision
// Get the movePlatXSpeed
movePlatXSpeed = 0;
if instance_exists(myFloorPlat)
	movePlatXSpeed = myFloorPlat.xSpeed;

// Move with movePlatXSpeed
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

// Y - Snap myself to myFloorPlat if it's moving vertically
if instance_exists(myFloorPlat)
&& (myFloorPlat.ySpeed != 0)
{
	// Snap to the top of the floor platform ( unfloor to prevent jitter )
	if !place_meeting(x, myFloorPlat.bbox_top, obj_solid)
	&& myFloorPlat.bbox_top >= bbox_bottom - movePlatMaxYSpeed
	{
		y = myFloorPlat.bbox_top;
	}

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
		setOnGround(false);
	}
}

#endregion