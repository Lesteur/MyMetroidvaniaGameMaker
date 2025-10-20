function HandlePlayerJump()
{
	var _ySpeed = ySpeed;
	
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
	    SetOnGround(false);
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
	    _ySpeed = jumpSpeed[jumpCount - 1];
		// Count down the timer
	    jumpHoldTimer --;
	}
	
	return _ySpeed;
}