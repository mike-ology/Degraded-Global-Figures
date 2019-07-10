
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
array <bitmap> arr_local_parts [2][3][0];

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
		
	int stimulus_colour = int( filename_parts[2] );

	# put bitmap in array according to shape and colour
	arr_local_parts[stimulus_type][stimulus_colour].add( next_bitmap );
	next_bitmap.set_load_size( 20.0, 20.0, 0.0 );
	next_bitmap.load();
		
	i = i + 1;
end;

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
{0,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	0,	0,	0	},
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
{ { 0, 0 }, { 1, 1 }, { 2, 2 }, { 3, 3 } },
{ { 8, 0}, { 7, 1 }, { 6, 2 }, { 5,  3 } },
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
loop
	int shape = 1
until
	shape > 2
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

			term.print_line( "\n" );

			loop
				int v_line = 1
			until
				v_line > 31
			begin
				
				term.print_line( arr_all_temp_stimuli[shape][corner][offset][v_line] );
				v_line = v_line + 1;
			end;
			
			offset = offset + 1;
		end;

		corner = corner + 1;
	end;
	
	shape = shape + shape;
end;

#################				

# Create stimulus array (for presentation)


