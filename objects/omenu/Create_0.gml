gui_width = display_get_gui_width();
gui_height = display_get_gui_height();
gui_margin = 0;

menu_x = gui_width + 200;
menu_y = gui_height - gui_margin + 6;
menu_x_target = gui_width - gui_margin;
menu_speed = 5; // lower is faster
menu_font = fMenu;
menu_itemheight = font_get_size(menu_font);
menu_committed = -1;
menu_control = true;

menu[2] = "continued";
menu[1] = "new";
menu[0] = "quit";

menu_items = array_length(menu);
menu_cursor = 2;

menu_top = menu_y - ((menu_itemheight * 1) * menu_items);

gamemanager = gm;
