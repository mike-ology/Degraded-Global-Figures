
# HEADER #

scenario = "Image Generation 2019 - First Run Parameter Check";
active_buttons = 1;
response_logging = log_active;
no_logfile = true; # default logfile not created
response_matching = simple_matching;
default_clear_active_stimuli = true;
default_background_color = 0, 0, 0;
default_font = "Arial";
default_font_size = 20;
default_text_color = 255, 255, 255;
default_formatted_text = true;

begin;

trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
	all_responses = true;

	stimulus_event {
		picture {} message_pic;
		time = 0;
		duration = next_picture;
		response_active = true;
	};
}message_trial;

begin_pcl;

int message_width = 1800;

text text_header = new text();
text_header.set_caption( "The experiment will run using the following parameters. Many of these can be changed in the Experiment Parameter window prior to running the experiment. Please check that they are suitable for your study prior to running participants.\n\nYou may disable this screen from appearing by deselecting the First Run scenario when initiating the experiment.", true );
text_header.set_max_text_width( message_width );
text_header.set_height( 200 );
text_header.set_width( 1900 );
text_header.set_background_color( 0, 205, 205 );
text_header.set_font_color( 0, 0, 0 );
text_header.redraw();

text text_screen_size = new text();
text_screen_size.set_caption( "This task was programmed for monitors running at 1920 x 1080. The current display is running at " + string(display_device.width()) + " x " + string(display_device.height()) + ". If these values do not match, Presentation will warn you and attempt to scale the display. However it is preferable to run the experiment at the specified resolution.", true );
text_screen_size.set_max_text_width( message_width );
text_screen_size.redraw();

text text_corner_offset = new text();
text_corner_offset.set_caption( "The corner offset value is " + string(parameter_manager.get_int( "Corner Offsets", 2 )) + ", which means that the global stimuli will be presented in " + string(parameter_manager.get_int( "Corner Offsets", 2 )) + " different position(s) at each of the four courners.", true );
text_corner_offset.set_max_text_width( message_width );
text_corner_offset.redraw();

array <int> deg_levels [4] = { 20, 40, 60, 80 }; # note - used if nothing specified in parameter window
parameter_manager.get_ints( "Degradation Levels", deg_levels, false );
string deg_levels_string;

loop int i = 1 until i > deg_levels.count() begin
	deg_levels_string.append( string(deg_levels[i]) );
	if i < deg_levels.count() then
		deg_levels_string.append( ", " );
	else end;
	i = i + 1;
end;

text text_degradation = new text();
text_degradation.set_caption( "The selected degradation levels to be generated are " + deg_levels_string, true );
text_degradation.set_max_text_width( message_width );
text_degradation.redraw();

text text_trials = new text();
text_trials.set_caption( "Based on the offset and degradation parameters, the number of unique trials to be generated is " + string( 32 * parameter_manager.get_int( "Corner Offsets", 2 ) * deg_levels.count() ), true );
text_trials.set_max_text_width( message_width );
text_trials.redraw();

text text_blocks = new text();
text_blocks.set_caption( "These trials will be divided into " + string(parameter_manager.get_int( "Maximum Blocks", 4 )) + " block(s), which means there will be " + string(( 32 * parameter_manager.get_int( "Corner Offsets", 2 ) * deg_levels.count() )/parameter_manager.get_int( "Maximum Blocks", 4 )) + " trials in each block before a break is presented.", true ); 
text_blocks.set_max_text_width( message_width );
text_blocks.redraw();

text text_reps = new text();
text_reps.set_caption( "This will continue for " + string(parameter_manager.get_int( "Maximum Repetitions", 1)) + " reptition(s), resulting in a total of " + string( 32 * parameter_manager.get_int( "Corner Offsets", 2 ) * deg_levels.count() * parameter_manager.get_int( "Maximum Repetitions", 1) ) + " trials being presented before the experiment ends.", true ); 
text_reps.set_max_text_width( message_width );
text_reps.redraw();

string practice;
if parameter_manager.get_bool( "Run Practice Trials", true ) == true then
	practice = ( "active. Each practice block consists of " + string(parameter_manager.get_int( "Practice Block Size", 15 )) + " trials." )
else
	practice = "not active."
end;

text text_practice = new text();
text_practice.set_caption( "Practice trials are " + practice, true ); 
text_practice.set_max_text_width( message_width );
text_practice.redraw();

string save;
if parameter_manager.get_string( "Use Local Save", "NO" ) == "NO" then
	save = "NO. Logfiles will be saved in the default directory in the experiment folder. Consider changing this to YES if running from a network location to reduce network read/write errors.";
else
	save = "YES. Logfiles will initially be saved to C:/Presentation Output/Degraded Global Figures 2019/ whilst the experiment is running. Presentation will attempt to copy the logfile to the default directory when all trials have been presented.\n\nThis setting is included to improve reliability of running experiments from a network location. If you encounter issues with saving logfiles, trying changing this parameter to NO.";
end;

text text_save = new text();
text_save.set_caption( "The 'Use Local Save' setting is set to " + save, true ); 
text_save.set_max_text_width( message_width );
text_save.redraw();

text text_close = new text();
text_close.set_caption( "Press SPACEBAR or ESCAPE to close this message and continue.\nIf the experiment continues and you need to change the parameters, please use ESCAPE to close the experiment.", true ); 
text_close.set_max_text_width( message_width );
text_close.redraw();

###

message_pic.add_part( text_header, 0, 460 );
message_pic.add_part( text_screen_size, 0, 320 );
message_pic.add_part( text_corner_offset, 0, 210 );
message_pic.add_part( text_degradation, 0, 140 );
message_pic.add_part( text_trials, 0, 70 );
message_pic.add_part( text_blocks, 0, 0 );
message_pic.add_part( text_reps, 0, -70 );
message_pic.add_part( text_practice, 0, -210 );
message_pic.add_part( text_save, 0, -350 );
message_pic.add_part( text_close, 0, -490 );

message_trial.present();
