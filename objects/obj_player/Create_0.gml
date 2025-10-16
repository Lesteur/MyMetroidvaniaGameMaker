/// @description Init

// Custom functions
function setOnGround(_onGround = true)
{
    if _onGround
    {
        onGround = true;
        coyoteHangTimer = coyoteHangFrames;
		
		y = round(y);
    }
    else
    {
        onGround = false;
        coyoteHangTimer = 0;
    }
}

// Controller for player movement
controllerSetup();

// Moving
face = 1;
moveDir = 0;
runType = 0;
moveSpeed[0] = 2;
moveSpeed[1] = 3.5;
xSpeed = 0;
ySpeed = 0;

// Jumping
grav = .275;
maxFallSpeed = 4;
onGround = true;

jumpMax = 2;
jumpCount = 0;
jumpHoldTimer = 0;

// Jump values for each successive jump
jumpHoldFrames[0] = 18;
jumpHoldFrames[1] = 10;
jumpSpeed[0] = -3.15;
jumpSpeed[1] = -2.85;

// Coyote time

// Hang time
coyoteHangFrames = 2;
coyoteHangTimer = 0;
// Jump buffer time
coyoteJumpFrames = 6;
coyoteJumpTimer = 0;