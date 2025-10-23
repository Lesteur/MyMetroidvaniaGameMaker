/// @description Init

xSpeed = 0;
ySpeed = 0;

// Gravity
grav = .3;
maxFallSpeed = 4;
onGround = true;

// Hang time
coyoteHangFrames = 2;
coyoteHangTimer = 0;

// Moving platforms
slopeSlide = false;
myFloorPlat = noone;
earlyMovePlatXSpeed = false;
forgetSemiSolid = noone;
ignoreSemiSolid = false;
movePlatXSpeed = 0;
movePlatMaxYSpeed = maxFallSpeed; // How fast can the player follow a downwards moving platform