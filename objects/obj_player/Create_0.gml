/// @description Init

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

// Jumping
grav = .3;
maxFallSpeed = 4;
onGround = true;

jumpMax = 2;
jumpCount = 0;
jumpHoldTimer = 0;

// Jump values for each successive jump
jumpHoldFrames[0] = 18;
jumpHoldFrames[1] = 10;
jumpSpeed[0] = -3.40;
jumpSpeed[1] = -3.10;

// Coyote time

// Hang time
coyoteHangFrames = 2;
coyoteHangTimer = 0;

// Jump buffer time
coyoteJumpFrames = 6;
coyoteJumpTimer = 0;

// Moving platforms
slopeSlide = false;
myFloorPlat = noone;
earlyMovePlatXSpeed = false;
forgetSemiSolid = noone;
ignoreSemiSolid = false;
movePlatXSpeed = 0;
movePlatMaxYSpeed = maxFallSpeed; // How fast can the player follow a downwards moving platform

// 
crushTimer = 0;
crushDeathTime = 60;