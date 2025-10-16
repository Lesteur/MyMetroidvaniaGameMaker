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
	if !place_meeting(x + xSpeed, y - abs(xSpeed) - 1, obj_slope_parent)
	{
		while place_meeting(x + xSpeed, y, obj_slope_parent)
			y -= _subPixel;
	}
	 // If there is no slope, regular collision
	else
	{
		// Ceiling Slopes
		if !place_meeting(x + xSpeed, y + abs(xSpeed) + 1, obj_slope_parent)
		{
			while place_meeting(x + xSpeed, y, obj_slope_parent)
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
if ySpeed >= 0 && !place_meeting(x + xSpeed, y + 1, obj_slope_parent) && place_meeting(x + xSpeed, y + abs(xSpeed) + 1, obj_slope_parent)
{
	while !place_meeting(x + xSpeed, y + _subPixel, obj_slope_parent)
		y += _subPixel;
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

// Initiate the jump
if jumpKeyBuffered && jumpCount < jumpMax
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
if ySpeed < 0 && place_meeting(x, y + ySpeed, obj_slope_parent)
{
	// Jump into sloped ceilings
	var _slopeSlide = false;
	
	// Slide UpLeft slope
	if xSpeed == 0 && !place_meeting(x - abs(ySpeed) - 1, y + ySpeed, obj_slope_parent)
	{
		while place_meeting(x, y + ySpeed, obj_slope_parent)
			x -= 1;
		
		_slopeSlide = true;
	}
	// Slide UpRight slope
	if xSpeed == 0 && !place_meeting(x + abs(ySpeed) + 1, y + ySpeed, obj_slope_parent)
	{
		while place_meeting(x, y + ySpeed, obj_slope_parent)
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
if ySpeed >= 0
{
	if place_meeting(x, y + ySpeed, obj_solid)
	{
	    // Move pixel by pixel until collision
	    var _pixelCheck = _subPixel * sign(ySpeed);
	    while !place_meeting(x, y + _pixelCheck, obj_solid)
	    {
	        y += _pixelCheck;
	    }

	    // Stop y movement
	    ySpeed = 0;
	}

	// Set if I'm on the ground
	if place_meeting( x, y + 1, obj_solid )
	{
	    setOnGround(true);
	}
}

// Move
y += ySpeed;

#endregion