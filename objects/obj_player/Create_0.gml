/// @description Init

// Inherit event
event_inherited();

// Controller for player movement
ControllerSetup();

// Moving
face = 1;
moveDir = 0;
runType = 0;
moveSpeed[0] = 2;
moveSpeed[1] = 4;
xSpeed = 0;
ySpeed = 0;

// Gravity
grav = .3;
maxFallSpeed = 4;

// Jumping
jumpMax = 2;
jumpCount = 0;
jumpHoldTimer = 0;

// Jump values for each successive jump
jumpHoldFrames[0] = 18;
jumpHoldFrames[1] = 10;
jumpSpeed[0] = -3.40;
jumpSpeed[1] = -3.10;

// Hang time
coyoteHangFrames = 2;

// Jump buffer time
coyoteJumpFrames = 6;
coyoteJumpTimer = 0;

// Crush Time
crushTimer = 0;
crushDeathTime = 60;

// How fast can the player follow a downwards moving platform
movePlatMaxYSpeed = maxFallSpeed;