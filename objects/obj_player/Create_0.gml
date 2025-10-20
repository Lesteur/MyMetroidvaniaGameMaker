/// @description Init

// Custom functions
function setOnGround(_onGround = true)
{
    if _onGround
    {
        onGround = true;
        coyoteHangTimer = coyoteHangFrames;
    }
    else
    {
        onGround = false;
        myFloorPlat = noone;
        coyoteHangTimer = 0;
    }
}

function checkForSemisolidPlatform(_x, _y)
{
    // Create a return variable
    var _rtrn = noone;

    // We must not be moving upwards, and then we check for a normal collision
    if ySpeed >= 0 && place_meeting(_x, _y, obj_semisolid)
    {
        // Create a DS list to store all colliding instances of obj_semisolid
        var _list = ds_list_create();
        var _listSize = instance_place_list(_x, _y, obj_semisolid, _list, false);

        // Loop through the colliding instances and only return one if it's top is bellow the player
        for (var _i = 0; _i < _listSize; _i++)
        {
            // Get an instance from the list
            var _listInst = _list[| _i];

            // Return a semisolid that is bellow the player
            if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.ySpeed)
            {
                // Return the ID of the semisolid platform
                _rtrn = _listInst;
                // Break the loop
                _i = _listSize;
            }
        }

        // Destroy the DS list to prevent memory leaks
        ds_list_destroy(_list);
    }

    // Return our variable
    return _rtrn;
}

// Controller for player movement
controllerSetup();

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
myFloorPlat = noone;
earlyMovePlatXSpeed = false;
forgetSemiSolid = noone;
ignoreSemiSolid = false;
movePlatXSpeed = 0;
movePlatMaxYSpeed = maxFallSpeed; // How fast can the player follow a downwards moving platform

// 
crushTimer = 0;
crushDeathTime = 60;