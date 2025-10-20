function SetOnGround(_onGround = true)
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