function HandleMovePlatforms()
{
	// Get out of solid moveplatform that have positioned themselves into the player in the begin step
	var _rightWall = noone;
	var _leftWall = noone;
	var _bottomWall = noone;
	var _topWall = noone;
	var _list = ds_list_create();
	var _listSize = instance_place_list(x, y, obj_solid_move, _list, false);

	// Loop through all colliding move platforms
	for (var _i = 0; _i < _listSize; _i++)
	{
		var _listInst = _list[| _i];
	
		// Find closest walls in each direction
		// Right walls
		if _listInst.bbox_left - _listInst.xSpeed >= bbox_right - 1
		{
			if !instance_exists(_rightWall) || _listInst.bbox_left < _rightWall.bbox_left
			{
				_rightWall = _listInst;
			}
		}
		// Left walls
		if _listInst.bbox_right - _listInst.xSpeed <= bbox_left + 1
		{
			if !instance_exists(_leftWall) || _listInst.bbox_right > _leftWall.bbox_right
			{
				_leftWall = _listInst;
			}
		}
		// Bottom walls
		if _listInst.bbox_top - _listInst.ySpeed >= bbox_bottom - 1
		{
			if !_bottomWall || _listInst.bbox_top < _bottomWall.bbox_top
			{
				_bottomWall = _listInst;
			}
		}
		// Top walls
		if _listInst.bbox_bottom - _listInst.ySpeed <= bbox_top + 1
		{
			if !_topWall || _listInst.bbox_bottom > _topWall.bbox_bottom
			{
				_topWall = _listInst;
			}
		}
	}

	// Destroy the DS list to free memory
	ds_list_destroy(_list);

	// Get out of the walls
	// Right wall
	if instance_exists(_rightWall)
	{
		var _rightDist = bbox_right - x;
		var _targetX = _rightWall.bbox_left - _rightDist;
	
		if !place_meeting(_targetX, y, obj_solid)
			x = _targetX;
	}
	// Left wall
	if instance_exists(_leftWall)
	{
		var _leftDist = x - bbox_left;
		var _targetX = _leftWall.bbox_right + _leftDist;
	
		if !place_meeting(_targetX, y, obj_solid)
			x = _targetX;
	}
	// Bottom wall
	if instance_exists(_bottomWall)
	{
		var _bottomDist = bbox_bottom - y;
		y = _bottomWall.bbox_top - _bottomDist;
	}
	// Top wall (includes, collision for polish and crouching)
	if instance_exists(_topWall)
	{
		var _topDist = y - bbox_top;
		var _targetY = _topWall.bbox_bottom + _topDist;
		// Check if there isn't a wall in the way
		if !place_meeting(x, _targetY, obj_solid)
			y = _targetY;
	}

	// Don't get left behind my move platform
	earlyMovePlatXSpeed = false;
	if instance_exists(myFloorPlat) && myFloorPlat.xSpeed != 0 && !place_meeting(x, y + movePlatMaxYSpeed + 1, myFloorPlat)
	{
		// Go ahead and move ourselves back onto that platform if there is no wall in the way
		if !place_meeting(x + myFloorPlat.xSpeed, y, obj_solid)
		{
			x += myFloorPlat.xSpeed;
			earlyMovePlatXSpeed = true;
		}
	}
}