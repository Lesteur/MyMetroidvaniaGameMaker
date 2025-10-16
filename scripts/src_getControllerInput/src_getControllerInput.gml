function getControllerInput()
{
    // Directions inputs
    rightKey = keyboard_check(vk_right) + keyboard_check(ord("D")) + gamepad_button_check(0, gp_padr);
    rightKey = clamp(rightKey, 0, 1);

    leftKey = keyboard_check(vk_left) + keyboard_check(ord("A")) + gamepad_button_check(0, gp_padl);
    leftKey = clamp(leftKey, 0, 1);

    // Actions inputs
    jumpKeyPressed = keyboard_check_pressed(vk_space) + gamepad_button_check_pressed(0, gp_face1);
    jumpKeyPressed = clamp(jumpKeyPressed, 0, 1);

    jumpKey = keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
    jumpKey = clamp(jumpKey, 0, 1);
	
	runKey = keyboard_check(ord("X")) + gamepad_button_check(0, gp_face3);
    runKey = clamp(runKey, 0, 1);

    // Jump key buffering
    if jumpKeyPressed
    {
        jumpKeyBufferedTimer = jumpBufferTime;
    }
    
    if jumpKeyBufferedTimer > 0
    {
        jumpKeyBuffered = true;
        jumpKeyBufferedTimer --;
    }
    else
    {
        jumpKeyBuffered = false;
    }
}