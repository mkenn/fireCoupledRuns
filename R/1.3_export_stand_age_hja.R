# Patch Simulation for HJA
# 
# This script is used to simulate vegetation at patch level, beginning with no
# vegetation. A copy of the landscape (worldfile) is exported at various time 
# intervals for patch level fire analysis.

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# Model inputs

# Processing options
parameter_method <- "all_combinations"


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1_self_thinning"    # Code for self thinning
input_rhessys$tec_file <- "ws_hja/tecfiles/hja_patch_simulation.tec"
input_rhessys$world_file <- "ws_hja/worldfiles/hja_2can_patch_6018_ts.world"  # Worldfile for not using dated sequence. hja_2can_patch_6018.world is for dated sequence. 
input_rhessys$world_hdr_prefix <- "1.3"
input_rhessys$flow_file <- "ws_hja/flowtables/hja_patch_6018.flow"
input_rhessys$start_date <- "1957 10 1 1"
input_rhessys$end_date <- "2157 10 1 1"
input_rhessys$output_folder <- "ws_hja/out/1.3_hja_patch_simulation"
input_rhessys$output_filename <- "patch_sim"
input_rhessys$command_options <- c("-b -g -c -p -tchange 0 0")


# HDR (header) file
input_hdr_list <- list()
input_hdr_list$basin_def <- c("ws_hja/defs/basin_hja.def")
input_hdr_list$hillslope_def <- c("ws_hja/defs/hill_hja.def")
input_hdr_list$zone_def <- c("ws_hja/defs/zone_hja.def")
input_hdr_list$soil_def <- c("ws_hja/defs/patch_hja.def")
input_hdr_list$landuse_def <- c("ws_hja/defs/lu_hja.def")
input_hdr_list$stratum_def <- c("ws_hja/defs/veg_hja_7dougfir.def", "ws_hja/defs/veg_hja_understory.def")
input_hdr_list$base_stations <- c("ws_hja/clim/cs2met_450yr.base")


# Define path to a pre-selected df containing parameter sets
input_preexisting_table <- OUTPUT_DIR_1_HJA_TOP_PS


# Def file parameter changes
# List of lists containing def_file, parameter and parameters values
input_def_list <- NULL


# Standard sub-surface parameters
input_standard_par_list <- NULL


# Make climate base station file
#input_clim_base_list <- NULL
input_clim_base_list <- list(
  list(core = data.frame(c1=character(),c2=character(),stringsAsFactors=FALSE),
       annual = data.frame(c1=character(),c2=character(),stringsAsFactors=FALSE),
       monthly = data.frame(c1=character(),c2=character(),stringsAsFactors=FALSE),
       daily = data.frame(c1=character(),c2=character(),stringsAsFactors=FALSE),
       hourly = data.frame(c1=character(),c2=character(),stringsAsFactors=FALSE)
  )
)
input_clim_base_list[[1]][[1]][1,] <- data.frame(c1=101, c2="base_station_id",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][2,] <- data.frame(c1=100.0, c2="x_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][3,] <- data.frame(c1=100.0, c2="y_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][4,] <- data.frame(c1=485, c2="z_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][5,] <- data.frame(c1=3.5, c2="effective_lai",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][6,] <- data.frame(c1=2, c2="screen_height",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[2]][1,] <- data.frame(c1="annual", c2="annual_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[2]][2,] <- data.frame(c1=0, c2="number_non_critical_annual_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[3]][1,] <- data.frame(c1="monthly", c2="monthly_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[3]][2,] <- data.frame(c1=0, c2="number_non_critical_monthly_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[4]][1,] <- data.frame(c1="ws_hja/clim/cs2met_450yr", c2="daily_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[4]][2,] <- data.frame(c1=0, c2="number_non_critical_daily_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[5]][1,] <- data.frame(c1="hourly", c2="hourly_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[5]][2,] <- data.frame(c1=0, c2="number_non_critical_hourly_sequences",stringsAsFactors=FALSE)


# Make a list of dated sequence data.frames (file name, year, month, day, hour, value)
input_dated_seq_list <- NULL
#input_dated_seq_list = list()
#input_dated_seq_list[[1]] <- data.frame(name="cs2met_dated",type="pspread",year=1957,month=10,day=7,hour=1,value=0.95,stringsAsFactors=FALSE)
# Dated sequence doesn't work when combined with redefine world (which is needed
# to change cover fraction). Therefore, I do not use an initial disturbance to
# kill off vegetation. I also use hja_2can_patch_6018_ts.world instead of
# hja_2can_patch_6018.world because the latter doesn't have patch level base
# station needed for dated sequence.


# Make tec-file
#input_tec_data <- NULL
input_tec_data <- data.frame(year=integer(),month=integer(),day=integer(),hour=integer(),name=character(),stringsAsFactors=FALSE)
input_tec_data[1,] <- data.frame(1957, 10, 1, 1, "print_daily_on", stringsAsFactors=FALSE)
input_tec_data[2,] <- data.frame(1957, 10, 1, 2, "print_daily_growth_on", stringsAsFactors=FALSE)
input_tec_data[3,] <- data.frame(1968, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[4,] <- data.frame(1978, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[5,] <- data.frame(1998, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[6,] <- data.frame(2028, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[7,] <- data.frame(2057, 10, 1, 1, "redefine_world", stringsAsFactors=FALSE)
input_tec_data[8,] <- data.frame(2058, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[9,] <- data.frame(2098, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[10,] <- data.frame(2148, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)


# List of lists containing variable of interest, location/name of awk file (relative to output
# file location), and the location/name of rhessys output file with variable of interest.
output_variables <- NULL
#output_variables <- list()

# ---------------------------------------------------------------------

system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_clim_base_list = input_clim_base_list,
              input_dated_seq_list = input_dated_seq_list,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

beep(1)



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Add extra line to worldfiles so that they can be used with dated sequence.

world_ages_in <- c("ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y1968M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y1978M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y1998M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y2028M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y2058M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y2098M10D1H1.state",
                   "ws_hja/worldfiles/hja_2can_patch_6018_ts.world.Y2148M10D1H1.state")

world_ages_out <- c("ws_hja/worldfiles/hja_2can_patch_6018.world.Y1968M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1978M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1998M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2028M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2058M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2098M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2148M10D1H1.state")


add_dated_seq <- function(world_name_in, world_name_out){
  newrow <- data.frame(a=101, b="p_base_station_ID", stringsAsFactors = FALSE)
  
  # Read in worldfile
  worldfile <- read.table(world_name_in, header = FALSE, stringsAsFactors = FALSE)
  
  for (aa in seq(2,nrow(worldfile))){         # Note that this should be a while loop since worldfile is extended. (see other examples)
    if (aa%%1000 == 0 ){print(paste(aa,"out of", nrow(worldfile)))} # Counter
    if (worldfile[aa,2] == "num_canopy_strata" && worldfile[aa-1,2] == "n_basestations"){
      # Change previous n_basestations to 1
      worldfile[aa-1,1] = 1
      
      # Add new line containing p_base_station_ID
      worldfile[seq(aa+1,nrow(worldfile)+1),] <- worldfile[seq(aa,nrow(worldfile)),]
      worldfile[aa,] <- newrow[1,]
    }
  }
  
  # Write new file
  worldfile$V1 <- format(worldfile$V1, scientific = FALSE)
  write.table(worldfile, file = world_name_out, row.names = FALSE, col.names = FALSE, quote=FALSE, sep="  ")
} 


# Produces new world files with extra line for patch-level dated sequence
for (aa in seq_along(world_ages_in)){
  add_dated_seq(world_ages_in[aa],world_ages_out[aa])
}

