/// @description Step

// Fullscreen toggle
if keyboard_check_pressed(vk_f1)
{
	window_set_fullscreen(!window_get_fullscreen());
}

// Exit if there is no player
if !instance_exists(obj_player)
	exit;
	
// Get camera size
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

// Get camera target coordinates
var _camX = obj_player.x - _camWidth/2;
var _camY = obj_player.y - _camHeight/2;

// Constrain cam to room borders
_camX = clamp(_camX, 0, room_width - _camWidth);
_camY = clamp(_camY, 0, room_height - _camHeight);

// Set camera coordinate variables
finalCamX += (_camX - finalCamX) * camTrailSpd;
finalCamY += (_camY - finalCamY) * camTrailSpd;

// Set camera coordinates
camera_set_view_pos(view_camera[0], finalCamX, finalCamY);