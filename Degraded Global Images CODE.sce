
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

#picture{}main_pic;

begin_pcl;

#################################################################
# Load local parts into an array for later global figure creation

int num_local_parts;
array <string> local_part_filenames [0];
num_local_parts = get_directory_files( stimulus_directory, local_part_filenames );

# array [shape][shape_colour][xxx]
array <bitmap> arr_local_parts [2][3][3][0];
array <bitmap> arr_l_parts [2][0];

loop
	int i = 1
until
	i > num_local_parts
begin
	
	# Get next bitmap in stimulus folder
	bitmap next_bitmap = new bitmap( local_part_filenames[i] );

	# Get filename from overall filepath
	array <string> filepath_parts[0];
	local_part_filenames[i].split( "\\", filepath_parts );
	
	# Get sections of filename to use to assign to array
	string bitmap_filename = filepath_parts[filepath_parts.count()];
	array <string> filename_parts[0];
	bitmap_filename.split( "_", filename_parts );
		
	int stimulus_type;
	if filename_parts[1] == "circle" then
		stimulus_type = 1
	elseif filename_parts[1] == "diamond" then
		stimulus_type = 2
	end;
		
	int shape_colour = int( filename_parts[2] );
	int background_colour = int( filename_parts[3] );

	# put bitmap in array according to shape and colour
	arr_local_parts[stimulus_type][shape_colour][background_colour].add( next_bitmap );
	arr_l_parts[stimulus_type].add( next_bitmap );
	next_bitmap.set_load_size( 20.0, 20.0, 0.0 );
	next_bitmap.load();
		
	i = i + 1;
end;

array <bitmap> l_light_circles [0];
array <bitmap> l_dark_circles [0];
array <bitmap> l_light_diamonds [0];
array <bitmap> l_dark_diamonds [0];
l_light_circles.append( arr_local_parts[1][1][1] );
#l_light_circles.append( arr_local_parts[1][2] );
#l_dark_circles.append( arr_local_parts[1][2] );
l_dark_circles.append( arr_local_parts[1][3][2] );
l_light_diamonds.append( arr_local_parts[2][1][1] );
#l_light_diamonds.append( arr_local_parts[2][2] );
#l_dark_diamonds.append( arr_local_parts[2][2] );
l_dark_diamonds.append( arr_local_parts[2][3][2] );

#################################################################
# Create global shapes using local shapes

# global shape consists of a 31x31 array of smaller shapes

array <int> arr_shape [2][23][23] = {{
{0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0	},
{0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0	},
{0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0	}
},
{
{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0	},
{0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1	},
{0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0	},
{0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0	},
{0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0	},
{0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0	},
{0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0	}
}};

# create empty stimulus

array <int> arr_temp_zero [31];
arr_temp_zero.fill( 1, 31, 0, 0 );

array <int> arr_temp_stimulus[31][0];
array <int> arr_all_temp_stimuli [2][4][4][31][31];
# [shape][corner][offset]

loop
	int i = 1
until
	i > arr_temp_stimulus.count()
begin
	arr_temp_stimulus[i].append( arr_temp_zero );
	i = i + 1;
end;

#term.print_line( arr_temp_stimulus );

array <int> arr_offset [4][4][2] = {
{ { 0, 0}, { 1, 1 }, { 2, 2 }, { 3, 3 } },
{ { 8, 0}, { 7, 1 }, { 6, 2 }, { 5, 3 } },
{ { 0, 8}, { 1, 7 }, { 2, 6 }, { 3, 5 } },
{ { 8, 8}, { 7, 7 }, { 6, 6 }, { 5, 5 } }
};

loop
	int shape = 1;
until
	shape > 2
begin

int shape_template = 1;

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

			# next template

			array <int> arr_next_template [0][0];
			arr_next_template.assign( arr_temp_stimulus );

			loop
				int v_line = 1;
			until
				v_line > 23
			begin
			
				loop
					int h_line = 1
				until
					h_line > 23
				begin
					
					int horizontal_offet = h_line + arr_offset[corner][offset][1];
					int vertical_offset = v_line + arr_offset[corner][offset][2];
				
					if arr_shape[shape][v_line][h_line] == 1 then #####
						arr_next_template[vertical_offset][horizontal_offet] = 1;
					else
					end;
					
					#term.print_line( string(shape) + "\t" + string(corner) + "\t" + string(offset) + "\t" + string(v_line) + "\t" + string(h_line) );
					h_line = h_line + 1;
				end;
				
				v_line = v_line + 1;
			end;
			
			arr_all_temp_stimuli[shape][corner][offset] = arr_next_template;
			shape_template = shape_template + 1;
			offset = offset + 1;
		end;
		
		corner = corner + 1;
	end;
	
	shape = shape + 1;
end;

#################				

# Create stimulus array (for presentation)

array <int> arr_degradation_levels [4] = { 20, 40, 60, 80 };
# values to be divided by 100 later

array <int> arr_stimulus_variations [2][2][4][2][4][4][31][31];
# [local shape][luminance][degradation]...[[values stored in arr_all_temp_stimuli]]

array <picture> arr_generated_stimuli [0];

loop
	int l_shape = 1
until
	l_shape > 2
begin
	
	loop
		int luminance = 1
	until
		luminance > 2
	begin
		
		loop
			int degradation = 1
		until
			degradation > arr_degradation_levels.count()
		begin
			
			arr_stimulus_variations[l_shape][luminance][degradation] = arr_all_temp_stimuli;
			
			loop
				int g_shape = 1
			until
				g_shape > 2
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

						picture next_stimulus = new picture();
						
						loop
							int v_line = 1
						until
							v_line > 31
						begin
							
							loop
								int h_line = 1
							until
								h_line > 31
							begin
								
								picture_part shape_part;
								picture_part background_part;

								if l_shape == 1 then
									# local circles
									l_light_circles.shuffle();
									l_dark_circles.shuffle();
									if	luminance == 1 then
										# light on dark
										shape_part = l_light_circles[1];
										background_part = l_dark_circles[1];
									elseif luminance == 2 then
										# dark on light
										shape_part = l_dark_circles[1];
										background_part = l_light_circles[1];
									end;
								elseif l_shape == 2 then
									# local diamonds
									l_light_diamonds.shuffle();
									l_dark_diamonds.shuffle();
									if	luminance == 1 then
										# light on dark
										shape_part = l_light_diamonds[1];
										background_part = l_dark_diamonds[1];
									elseif luminance == 2 then
										# dark on light
										shape_part = l_dark_diamonds[1];
										background_part = l_light_diamonds[1];
									end;
								end;
								
								# degradation check
								if arr_degradation_levels[degradation] >= random( 1, 100 ) then
									# degraded (random element of same shape
									arr_l_parts[l_shape].shuffle();
									shape_part = arr_l_parts[l_shape][1];
									background_part = arr_l_parts[l_shape][1];
								else
									# intact
								end;
								
								if arr_stimulus_variations[l_shape][luminance][degradation][g_shape][corner][offset][v_line][h_line] == 0 then
										next_stimulus.add_part( background_part, (h_line * 20.0) - (16 * 20.0), (v_line * 20.0) - (16 * 20.0) );
								elseif arr_stimulus_variations[l_shape][luminance][degradation][g_shape][corner][offset][v_line][h_line] == 1 then
										next_stimulus.add_part( shape_part, (h_line * 20.0) - (16 * 20.0), (v_line * 20.0) - (16 * 20.0) );
								end;
								
								h_line = h_line + 1;
							end;
							
							v_line = v_line + 1;
						end;
						
						next_stimulus.set_description( string(l_shape)+";"+string(luminance)+";"+string(arr_degradation_levels[degradation])+";"+string(g_shape)+";"+string(corner)+";"+string(offset) );
						arr_generated_stimuli.add( next_stimulus );
						#next_stimulus.present();
						#wait_interval(2000);

						offset = offset + 1;
					end;
					
					corner = corner + 1;
				end;
				
				g_shape = g_shape + 1;
			end;
			
					
			degradation = degradation + 1;
		end;
		
		luminance = luminance + 1;
	end;
	
	l_shape = l_shape + 1;
end;

## STIMULI NOW ALL STORED IN AN 1-D ARRAY (arr_generated_stimuli)

arr_generated_stimuli.shuffle();

loop
	int i = 1
until
	i > arr_generated_stimuli.count()
begin
	line_graphic line1 = new line_graphic();
	line1.set_next_line_width( 3 );
	line1.set_next_line_color( 255, 0, 0, 255 );
	line1.add_line( 0, 400, 0, -400 );
	line1.add_line( -400, 0, 400, 0 );
	line1.redraw();
	#arr_generated_stimuli[i].add_part( line1, 0, 0 );

	array <string> stim_info [6];
	arr_generated_stimuli[i].description().split( ";", stim_info );
	
	string global_shape;
	string local_shape;
	string luminance;
	string corner;
	string edge_offset = stim_info[6];
	string degradation = stim_info[3];

	if stim_info[4] == "1" then global_shape = "circle" elseif stim_info[4] == "2" then global_shape = "diamond"; end;
	if stim_info[1] == "1" then local_shape = "circle" elseif stim_info[1] == "2" then local_shape = "diamond"; end;
	if stim_info[2] == "1" then luminance = "dark-on-light" elseif stim_info[2] == "2" then luminance = "light-on-dark"; end;
	if stim_info[5] == "1" then 
		corner = "bottom left"
	elseif stim_info[5] == "2" then 
		corner = "bottom right";
	elseif stim_info[5] == "top left" then 
		corner = "3";
	elseif stim_info[5] == "top right" then 
		corner = "4";
	end;

	text text1 = new text();
	text text2 = new text();
	text1.set_caption( "Global shape: " + global_shape + " - " + "Local shape: " + local_shape + " - " + "Luminance: " + luminance, true);
	text2.set_caption( "Corner: " + corner + " - " + "Edge Offset: " + edge_offset + " - " + "Degration Level: " + degradation, true);
	arr_generated_stimuli[i].add_part( text1, 0, 480 );
	arr_generated_stimuli[i].add_part( text2, 0, 420 );
	
	
	arr_generated_stimuli[i].present();
	#display_device.screenshot( string(i) + ".bmp" );
	wait_interval(2500);
	i = i + 1;
end;
