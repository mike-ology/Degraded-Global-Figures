
# HEADER #

scenario = "Image Generation 2019";
active_buttons = 3;
response_logging = log_active;
no_logfile = true; # default logfile not created
response_matching = simple_matching;
default_clear_active_stimuli = true;
default_background_color = 128, 128, 128;
default_font = "Arial";
default_font_size = 36;
default_text_color = 0, 0, 0;
default_formatted_text = true;

begin;

$fixation_duration = 750;
$exposure_duration = 300;
$trial_duration = 3000;

trial {
	trial_duration = '$fixation_duration + $trial_duration';
	trial_type = specific_response;
	terminator_button = 2, 3;
	all_responses = false;

	stimulus_event {
		picture {
			text {
				caption = "+";
				font_size = 48;
			};
			x = 0; y = 0;
		};
		time = 0;
		duration = next_picture;
		response_active = false;
	}event_fixation;
	
	stimulus_event {
		picture {};
		time = $fixation_duration;
		duration = next_picture;
		stimulus_time_in = 0;
		stimulus_time_out = never;
		response_active = true;
		target_button = 2, 3;
	}event_stimulus;
		
	stimulus_event {
		picture {
			text { 
				caption = "?";
				font_size = 48;
			};
			x = 0; y = 0;
		};
		time = '$fixation_duration + $exposure_duration';
		duration = next_picture;
		response_active = false;
	}event_prompt;
		
}main_trial;


begin_pcl;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# User Setup

bool debug_tools = true;

# User parameters for screen dimension
# Enter desired screen dimensions. Screens not set to these dimensions may be scaled
double req_screen_x = 1920.0;
double req_screen_y = 1080.0;
bool attempt_scaling_procedure = false;

# User parameters for logfile generation
# If filename already exists, a new file is created with an appended number
# Logfile may be optionally created on local disk (when running from network location)
string local_path = "C:/Presentation Output/Degraded Global Figures 2019/";
string filename_prefix = "DGF - Participant ";
string use_local_save = parameter_manager.get_string( "Use Local Save", "NO" );

#######################

# Load PCL code and subroutines from other files
include "sub_generate_prompt.pcl";
include "sub_screen_scaling.pcl";
include "sub_logfile_saving.pcl";

# Run start-up subroutines
if attempt_scaling_procedure == true then screen_check() else end;
create_logfile();
	# subroutine creates empty text file labelled "log"


# Setup complete
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


### Experimental Parameters ### 

	# Size of local elements (effects overall stimulus size)
	double local_element_size = 20.0;

	# Size of gab between local elements (effects overall stimulus size)
	int gap = 1;

	# Number of offsets to be used for each corner (ranges from 1-4)
	int total_offsets = 1;
	
	# Degradation levels - Enter integers ranging from 0 - 100 (no degradation to 100% degradation (i.e. random))
	# Note! Make sure array size is declared correctly!
	array <int> deg_levels [1] = { 50 };
	
	# !! Calculate manually, no need to change
	int unique_trials = 32 * total_offsets * deg_levels.count();
	
	# Number of unique blocks (should be a factor of 32)
	int max_blocks = 2;
	
	# !! Calculate manually, no need to change
	int trials_per_block = unique_trials/max_blocks;
	
	# Repetitions / Loops - for smaller numbers of unique trials, may want to repeat to increase experiment length
	int max_reps = 1;

#################################################################
# Setup logfile
# Logfile Header	
log.print("Degraded Global Figures Task\n");
log.print("Participant ");
log.print( participant );
log.print("\n");
log.print( date_time() );
log.print("\n");
log.print( "Scale factor: " + string( scale_factor ) );
log.print("\n");
log.print( "Exposure time: " + string( parameter_manager.get_int( "Trial Duration", 1000 ) ) );
log.print("\n\n");

# Data Table Header	
log.print( "rep" ); log.print( "\t" );
log.print( "block" ); log.print( "\t" );
log.print( "trial" ); log.print( "\t" );
log.print( "glob" ); log.print( "\t" );
log.print( "loc" ); log.print( "\t" );
log.print( "lum" ); log.print( "\t" );
log.print( "corn" ); log.print( "\t" );
log.print( "offset" ); log.print( "\t" );
log.print( "degrad" ); log.print( "\t" );
log.print( "|" ); log.print( "\t" );
log.print( "RT" ); log.print( "\t" );
log.print( "resp" ); log.print( "\t" );
log.print( "rslt" ); log.print( "\n" );

#################################################################
# Load local parts into an array for later global figure creation

int num_local_parts;
array <string> local_part_filenames [0];
num_local_parts = get_directory_files( stimulus_directory, local_part_filenames );

# array [shape][shape_colour][bg_colour[i]
array <bitmap> arr_local_parts [2][4][4][0];
# array [shape][i]
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
	next_bitmap.set_load_size( local_element_size, local_element_size, 0.0 );
	next_bitmap.load();
		
	i = i + 1;
end;

array <bitmap> l_light_circles [0];
array <bitmap> l_dark_circles [0];
array <bitmap> l_light_diamonds [0];
array <bitmap> l_dark_diamonds [0];

# Note: the following arrays are not completely filled. For example [1][2][2] is empty
# as identical background and shape colours result in a square of a single colour.

l_dark_circles.append( arr_local_parts[1][1][2] );
l_dark_circles.append( arr_local_parts[1][2][1] );
l_light_circles.append( arr_local_parts[1][3][4] );
l_light_circles.append( arr_local_parts[1][4][3] );
l_dark_diamonds.append( arr_local_parts[2][1][2] );
l_dark_diamonds.append( arr_local_parts[2][2][1] );
l_light_diamonds.append( arr_local_parts[2][3][4] );
l_light_diamonds.append( arr_local_parts[2][4][3] );

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

array <int> arr_offset [0][0][0];

# [corner][offset_amount][x/y coordinates]
array <int> arr_offset_4 [4][4][2] = {
{ { 0, 0}, { 1, 1 }, { 2, 2 }, { 3, 3 } },
{ { 8, 0}, { 7, 1 }, { 6, 2 }, { 5, 3 } },
{ { 0, 8}, { 1, 7 }, { 2, 6 }, { 3, 5 } },
{ { 8, 8}, { 7, 7 }, { 6, 6 }, { 5, 5 } }
};
	
array <int> arr_offset_3 [4][3][2] = {
{ { 0, 0}, { 1, 1 }, { 2, 2 } },
{ { 8, 0}, { 7, 1 }, { 6, 2 } },
{ { 0, 8}, { 1, 7 }, { 2, 6 } },
{ { 8, 8}, { 7, 7 }, { 6, 6 } }
};

array <int> arr_offset_2 [4][2][2] = {
{ { 0, 0}, { 1, 1 } },
{ { 8, 0}, { 7, 1 } },
{ { 0, 8}, { 1, 7 } },
{ { 8, 8}, { 7, 7 } }
};
array <int> arr_offset_1 [4][1][2] = {
{ { 0, 0} },
{ { 8, 0} },
{ { 0, 8} },
{ { 8, 8} }
};

if total_offsets == 4 then
	arr_offset.assign( arr_offset_4 );
elseif total_offsets == 3 then
	arr_offset.assign( arr_offset_3 );
elseif total_offsets == 2 then
	arr_offset.assign( arr_offset_2 );
elseif total_offsets == 1 then
	arr_offset.assign( arr_offset_1 );
end;

loop
	int shape = 1;
until
	shape > 2
begin

int shape_template = 1;

	loop
		int corner = 1
	until
		corner > arr_offset.count()
	begin
		
		loop
			int offset = 1
		until
			offset > arr_offset[corner].count()
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

array <int> arr_degradation_levels [0];
arr_degradation_levels.append( deg_levels );

# values to be divided by 100 later

array <int> arr_stimulus_variations [2][2][4][2][4][total_offsets][31][31];
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
						offset > total_offsets
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
										next_stimulus.add_part( background_part, (h_line - 16)*local_element_size + (h_line - 16)*gap, (v_line - 16)*local_element_size + (v_line - 16)*gap );
								elseif arr_stimulus_variations[l_shape][luminance][degradation][g_shape][corner][offset][v_line][h_line] == 1 then
										next_stimulus.add_part( shape_part, (h_line - 16)*local_element_size + (h_line - 16)*gap, (v_line - 16)*local_element_size + (v_line - 16)*gap ) ;
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

### ACTUALLY PRESENT TRIALS ###

loop
	int repetition = 1
until
	repetition > max_reps
begin

	int i = 1;
	arr_generated_stimuli.shuffle();

	loop
		int block = 1
	until
		block > max_blocks
	begin

		loop
			int h = 1;
		until
			h > trials_per_block
		begin
			array <string> stim_info [6];
			arr_generated_stimuli[i].description().split( ";", stim_info );
			
			string global_shape;
			string local_shape;
			string luminance;
			string corner;
			string edge_offset = stim_info[6];
			string degradation = stim_info[3];

			if debug_tools == true then
				line_graphic line1 = new line_graphic();
				line1.set_next_line_width( 3 );
				line1.set_next_line_color( 255, 0, 0, 255 );
				line1.add_line( 0, 400, 0, -400 );
				line1.add_line( -400, 0, 400, 0 );
				line1.redraw();
				arr_generated_stimuli[i].add_part( line1, 0, 0 );

				text text1 = new text();
				text text2 = new text();
				text1.set_caption( "Global shape: " + global_shape + " - " + "Local shape: " + local_shape + " - " + "Luminance: " + luminance, true);
				text2.set_caption( "Corner: " + corner + " - " + "Edge Offset: " + edge_offset + " - " + "Degration Level: " + degradation, true);
				arr_generated_stimuli[i].add_part( text1, 0, 480 );
				arr_generated_stimuli[i].add_part( text2, 0, 420 );
			else
			end;

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

			
			event_stimulus.set_stimulus( arr_generated_stimuli[i] );
			main_trial.present();
			
			log.print( repetition ); log.print( "\t" );
			log.print( block ); log.print( "\t" );
			log.print( h ); log.print( "\t" );
			log.print( global_shape ); log.print( "\t" );
			log.print( local_shape ); log.print( "\t" );
			log.print( luminance ); log.print( "\t" );
			log.print( corner ); log.print( "\t" );
			log.print( edge_offset ); log.print( "\t" );
			log.print( degradation ); log.print( "\t" );
			log.print( "|" ); log.print( "\t" );
			log.print( "RT" ); log.print( "\t" );
			log.print( "resp" ); log.print( "\t" );
			log.print( "rslt" ); log.print( "\n" );

			h = h + 1;
			i = i + 1;
		end;

		# End of block message
		if block != max_blocks || repetition != max_reps then
			create_new_prompt( 1 );
			prompt_trial.set_duration( forever );
			prompt_message.set_caption( "End of Block " + string(block + (repetition-1)*max_blocks) + "/" + string(repetition*max_blocks) + ".\n\nTake a short break and continue\nwhen ready", true );
			mid_button_text.set_caption( "Press " + response_manager.button_name( 1, false, true ) + " to begin next block", true );
			prompt_trial.present();
		else
		end;
		
		block = block + 1;
	end;

	repetition = repetition + 1;
end;

#########################################################
# Subroutine to copy logfile back to the default location
# Requires the strings associated with:
#	[1] the local file path
#	[2] the file name
#	[3] if save operation is to be performed ("YES"/"NO") 

bool copy_success = sub_save_to_network( local_path, filename, use_local_save );	

if copy_success == true then
	prompt_message.set_caption( "End of experiment! Thank you!\n\nPlease notify the experimenter.\n\n<font color = '0,255,0'>LOGFILE WAS SAVED TO DEFAULT LOCATION</font>", true )
elseif copy_success == false then
	prompt_message.set_caption( "End of experiment! Thank you!\n\nPlease notify the experimenter.\n\n<font color = '255,0,0'>LOGFILE WAS SAVED TO:\n</font>" + local_path, true );
else
end;

#########################################################
create_new_prompt( 1 );

if parameter_manager.configuration_name() == "Mobile / Touchscreen" then
	mid_button_text.set_caption( "CLOSE PROGRAM", true );
else
	mid_button_text.set_caption( "CLOSE PROGRAM [" + response_manager.button_name( 1, false, true ) + "]", true );
end;

prompt_trial.present();

