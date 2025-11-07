/// @description Step

// Get input values
GetControllerInput();

// Physic logic
event_inherited();

// Check if I'm "crushed"
image_blend = c_white;
if place_meeting(x, y, obj_solid)
{
	image_blend = c_blue;
}

// Update States
if (moveDir != 0 && xSpeed != 0 && onGround)
{
	if (runKey)
		state = STATE.RUN;
	else
		state = STATE.WALK;
}
else if (ySpeed < 0)
	state = STATE.JUMP;
else if (ySpeed > 0)
	state = STATE.FALL;
else
	state = STATE.IDLE;