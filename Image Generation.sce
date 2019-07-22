
# HEADER #

scenario = "Image Generation 2019";
active_buttons = 0;
response_logging = log_active;
no_logfile = true; # default logfile not created
response_matching = simple_matching;
default_background_color = 0, 0, 0;
default_font = "Arial";
default_font_size = 36;
default_text_color = 255, 255, 255;
default_formatted_text = true;

begin;

$scale_f = 10;

picture{} main_pic;

box {
	height = '31 * $scale_f';
	width = '31 * $scale_f';
} background_box;

ellipse_graphic {
	ellipse_height = '23 * $scale_f';
	ellipse_width = '23 * $scale_f';
} circle;

line_graphic {
	polygon_coordinates = '-11 * $scale_f', '0 * $scale_f', '0 * $scale_f', '11 * $scale_f', '11 * $scale_f', '0 * $scale_f', '0 * $scale_f', '-11 * $scale_f';
	join_type = join_point;
	fill_color = 128, 128, 128;
	line_width = '1 * ($scale_f/2)';
} diamond;
	

begin_pcl;

int scaling = int(get_sdl_variable( "scale_f" ));

array <int> positions [4][2] = {	{ -1, 1 }, {1, 1 }, { 1, -1 }, { -1, -1 } };
	
array <int> shape_colours [4] = { 0, 85, 171, 255 };
array <int> background_colours [4] = { 0, 85, 171, 255 }; 

loop
	int shapes = 1
until
	shapes > 2
begin
	
	
	loop
		int corner = 1
	until
		corner > 4
	begin
		
		loop
			int offset = 1
		until
			offset > 4
		begin
			
			loop
				int shape_variation = 1
			until
				shape_variation > shape_colours.count()
			begin
			
				loop
					int background_variation = 1
				until
					background_variation > background_colours.count()
				begin

					if shape_colours[shape_variation] == background_colours[background_variation] then
						# skip all of this
					else

						main_pic.clear();
						 
						int x_align;
						int y_align;
						picture_part shape;
													
						if shapes == 1 then
							shape = circle;
						elseif shapes == 2 then
							shape = diamond;
						end;
						
						background_box.set_color( background_colours[background_variation], background_colours[background_variation], background_colours[background_variation] );
						main_pic.add_part( background_box, 0, 0 );
						
						circle.set_color( shape_colours[shape_variation], shape_colours[shape_variation], shape_colours[shape_variation], 255 );
						circle.redraw();
						diamond.set_fill_color( shape_colours[shape_variation], shape_colours[shape_variation], shape_colours[shape_variation], 255 );
						diamond.set_line_color( shape_colours[shape_variation], shape_colours[shape_variation], shape_colours[shape_variation], 255 );
						diamond.redraw();
						
						main_pic.add_part( shape, 0, 0 );
						main_pic.set_part_x( 2, positions[corner][1]* offset * (scaling) );
						main_pic.set_part_y( 2, positions[corner][2]* offset * (scaling) );
						
						main_pic.present();
						wait_interval( 500 );
						
						string shape_name;
						if shapes == 1 then
							shape_name = "circle"
						else
							shape_name = "diamond"
						end;
						
						string image_name = ( shape_name + "_" + string(shape_variation) + "_" + string (background_variation) + "_" + string(corner) + "_" + string(offset) + ".bmp" );
						display_device.screenshot( image_name );
					end;
					
					background_variation = background_variation + 1;
				end;
				
				shape_variation = shape_variation + 1;
				end;
			
			offset = offset + 1;
		end;
		
		corner = corner + 1;
	end;
	
	shapes = shapes + 1;
	
end;