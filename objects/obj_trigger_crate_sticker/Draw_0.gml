if(!global.draw_debug) exit;

var c = image_blend;
var a = 0.5;

draw_set_alpha(a);
draw_rectangle_color(bbox_left + 1, bbox_top + 1, bbox_right - 1, bbox_bottom - 1, c,c,c,c, true);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_dos);
draw_text_color(x, y, object_get_name(object_index), c,c,c,c, a);
