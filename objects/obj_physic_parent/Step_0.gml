/// @description Step

// Handle the solid platforms
HandleMovePlatforms();

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

// Handle the Y Speed
HandleYSpeed();

// Handle the final move platforms
HandleFinalMovePlatforms();