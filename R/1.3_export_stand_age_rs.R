# Patch Simulation for Rattlesnake
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
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_rs/tecfiles/rs_patch_simulation.tec"
input_rhessys$world_file <- "ws_rs/worldfiles/rs_30m_1can_patch_40537.world"
input_rhessys$world_hdr_prefix <- "1.3"
input_rhessys$flow_file <- "ws_rs/flowtables/rs_30m_patch_40537.flow"
input_rhessys$start_date <- "1988 10 1 1"
input_rhessys$end_date <- "2088 10 1 1"
input_rhessys$output_folder <- "ws_rs/out/1.3_rs_patch_simulation"
input_rhessys$output_filename <- "patch_sim"
input_rhessys$command_options <- c("-b -g -c -p -tchange 0 0")


# HDR (header) file
input_hdr_list <- list()
input_hdr_list$basin_def <- c("ws_rs/defs/basin_rs.def")
input_hdr_list$hillslope_def <- c("ws_rs/defs/hill_rs.def")
input_hdr_list$zone_def <- c("ws_rs/defs/zone_rs.def")
input_hdr_list$soil_def <- c("ws_rs/defs/patch_rs.def")
input_hdr_list$landuse_def <- c("ws_rs/defs/lu_rs.def")
input_hdr_list$stratum_def <- c("ws_rs/defs/veg_rs_shrub.def")
input_hdr_list$base_stations <- c("ws_rs/clim/misreal_extended.base")


# Define path to a pre-selected df containing parameter sets
input_preexisting_table <- OUTPUT_DIR_1_RS_TOP_PS


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
input_clim_base_list[[1]][[1]][1,] <- data.frame(c1=104, c2="base_station_id",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][2,] <- data.frame(c1=100.0, c2="x_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][3,] <- data.frame(c1=100.0, c2="y_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][4,] <- data.frame(c1=640, c2="z_coordinate",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][5,] <- data.frame(c1=3.5, c2="effective_lai",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[1]][6,] <- data.frame(c1=10, c2="screen_height",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[2]][1,] <- data.frame(c1="annual", c2="annual_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[2]][2,] <- data.frame(c1=0, c2="number_non_critical_annual_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[3]][1,] <- data.frame(c1="monthly", c2="monthly_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[3]][2,] <- data.frame(c1=0, c2="number_non_critical_monthly_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[4]][1,] <- data.frame(c1="ws_rs/clim/misreal_extended", c2="daily_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[4]][2,] <- data.frame(c1=0, c2="number_non_critical_daily_sequences",stringsAsFactors=FALSE)

input_clim_base_list[[1]][[5]][1,] <- data.frame(c1="hourly", c2="hourly_climate_prefix",stringsAsFactors=FALSE)
input_clim_base_list[[1]][[5]][2,] <- data.frame(c1=0, c2="number_non_critical_hourly_sequences",stringsAsFactors=FALSE)


# Make a list of dated sequence data.frames (file name, year, month, day, hour, value)
# input_dated_seq_list <- NULL
input_dated_seq_list = list()
input_dated_seq_list[[1]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.95,stringsAsFactors=FALSE)



# Make tec-file
#input_tec_data <- NULL
input_tec_data <- data.frame(year=integer(),month=integer(),day=integer(),hour=integer(),name=character(),stringsAsFactors=FALSE)
input_tec_data[1,] <- data.frame(1988, 10, 1, 1, "print_daily_on", stringsAsFactors=FALSE)
input_tec_data[2,] <- data.frame(1988, 10, 1, 2, "print_daily_growth_on", stringsAsFactors=FALSE)
input_tec_data[3,] <- data.frame(1994, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[4,] <- data.frame(2001, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[5,] <- data.frame(2009, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[6,] <- data.frame(2019, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[7,] <- data.frame(2029, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[8,] <- data.frame(2049, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[9,] <- data.frame(2069, 10, 1, 1, "output_current_state", stringsAsFactors=FALSE)


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

