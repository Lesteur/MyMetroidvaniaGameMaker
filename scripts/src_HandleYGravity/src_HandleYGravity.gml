function HandleYGravity()
{
	var _ySpeed = ySpeed;
	
	if coyoteHangTimer > 0
	{
	    // Count the timer down
	    coyoteHangTimer --;
	}
	else
	{
	    // Apply gravity
	    _ySpeed += grav;
	    // We're not longer on the ground
	    SetOnGround(false);
	}
	
	return _ySpeed;
}