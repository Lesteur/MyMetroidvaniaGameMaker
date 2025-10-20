function HandlePlayerMovement()
{
	var _xSpeed = xSpeed;
	
	// Direction
	moveDir = rightKey - leftKey;
	// Get my face
	if moveDir != 0
		face = moveDir;
	// Get x speed
	runType = runKey;
	
	_xSpeed = moveDir * moveSpeed[runType];
	
	return _xSpeed;
}