/// @description Begin move

dir += rotationSpeed;

// Get our target positions
var _targetX = xstart + lengthdir_x(radius, dir)
var _targetY = ystart + lengthdir_y(radius, dir)

// Get our xSpeed and ySpeed
//xSpeed = _targetX - x;
ySpeed = _targetY - y;

// Move
x += xSpeed;
y += ySpeed;