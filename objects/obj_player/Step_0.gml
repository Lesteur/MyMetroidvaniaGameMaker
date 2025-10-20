/// @description Step

// Get input values
GetControllerInput();

// Handle the solid platforms
HandleMovePlatforms();

// Handle the X movement
xSpeed = HandlePlayerMovement();

// Handle the X Speed
HandleXSpeed();

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
    SetOnGround(false);
}

// Get the Jump Speed
ySpeed = HandlePlayerJump();

// Handle the Y Speed
HandleYSpeed();

// Handle the final move platforms
HandleFinalMovePlatforms();

// Check if I'm "crushed"
image_blend = c_white;
if place_meeting(x, y, obj_solid)
{
	image_blend = c_blue;
	crushTimer ++;
	
	if crushTimer > crushDeathTime
		instance_destroy();
}
else
{
	crushTimer = 0;
}