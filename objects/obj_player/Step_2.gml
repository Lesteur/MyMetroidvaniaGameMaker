/// @description Handle sprites

if moveDir == 1
	image_xscale = 1;
else if moveDir == -1
	image_xscale = -1;
	
switch state
{
	case STATE.IDLE:
		sprite_index = spr_jonathan_idle;
		break
	case STATE.WALK:
	case STATE.RUN:
		sprite_index = spr_jonathan_run;
		break
	case STATE.JUMP:
		sprite_index = spr_jonathan_jump;
		break
	case STATE.FALL:
		sprite_index = spr_jonathan_fall;
		break
}