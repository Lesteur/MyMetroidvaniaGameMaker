/// @description Drawing

draw_text(10, 10, "X : " + string(x));
draw_text(10, 30, "Y : " + string(y));

draw_text(120, 10, "X Speed : " + string(xSpeed));
draw_text(120, 30, "Y Speed : " + string(ySpeed));

var _text;

switch (state)
{
	case STATE.IDLE: _text = "IDLE"; break;
	case STATE.WALK: _text = "WALK"; break;
	case STATE.RUN: _text = "RUN"; break;
	case STATE.JUMP: _text = "JUMP"; break;
	case STATE.FALL: _text = "FALL"; break;
}

draw_text(10, 50, _text);