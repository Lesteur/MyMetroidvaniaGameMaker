/// @description Begin move

if place_meeting(x + xSpeed, y, obj_solid)
{
	xSpeed *= -1;
}

x += xSpeed;