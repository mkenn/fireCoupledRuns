# Test patch-level fire effects for Rattlesnake
# 
# This script evaluates fire effects for landscapes simulated at various time intervals.

source("R/0.1_utilities.R")


# ---------------------------------------------------------------------
# Import parameter sets

ps <- read_csv(OUTPUT_DIR_1_RS_TOP_PS)

# ---------------------------------------------------------------------
# Model inputs

# Processing options
parameter_method <- "all_combinations"

# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_rs/tecfiles/rs_patch_fire.tec"
input_rhessys$world_file <- c("ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y1994M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2001M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2009M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2019M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2029M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2049M10D1H1.state",
                              "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2069M10D1H1.state")
input_rhessys$world_hdr_prefix <- "rs_30m_1can_patch_40537"
input_rhessys$flow_file <- "ws_rs/flowtables/rs_30m_patch_40537.flow"
input_rhessys$start_date <- "1988 10 1 1"
input_rhessys$end_date <- "1988 10 15 1"
input_rhessys$output_folder <- "ws_rs/out/3.1_rs_patch_fire"
input_rhessys$output_filename <- "patch_fire"
input_rhessys$command_options <- c("-b -g -c -p")


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
input_preexisting_table <- NULL

n_sim <- NULL

# Def file parameter changes
# List of lists containing def_file, parameter and parameters values
#input_def_list <- NULL
input_def_list <- list(
  # Upper canopy parameters
  list(input_hdr_list$stratum_def[1], "epc.leaf_turnover", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.leaf_turnover`)),
  list(input_hdr_list$stratum_def[1], "epc.livewood_turnover", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.livewood_turnover`)),
  list(input_hdr_list$stratum_def[1], "epc.alloc_frootc_leafc", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.alloc_frootc_leafc`)),
  list(input_hdr_list$stratum_def[1], "epc.alloc_crootc_stemc", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.alloc_crootc_stemc`)),
  list(input_hdr_list$stratum_def[1], "epc.alloc_stemc_leafc", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.alloc_stemc_leafc`)),
  list(input_hdr_list$stratum_def[1], "epc.alloc_livewoodc_woodc", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.alloc_livewoodc_woodc`)),
  list(input_hdr_list$stratum_def[1], "epc.branch_turnover", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.branch_turnover`)),
  list(input_hdr_list$stratum_def[1], "epc.height_to_stem_exp", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.height_to_stem_exp`)),
  list(input_hdr_list$stratum_def[1], "epc.height_to_stem_coef", c(ps$`ws_rs/defs/veg_rs_shrub.def:epc.height_to_stem_coef`)),
  # -----
  # Patch fire parameters
  list(input_hdr_list$soil_def[1], "overstory_height_thresh", c(7)),
  list(input_hdr_list$soil_def[1], "understory_height_thresh", c(4)),
  # Upper canopy fire parameters
  list(input_hdr_list$stratum_def[1], "pspread_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[1], "vapor_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[1], "biomass_loss_rel_k1", c(-10)),
  list(input_hdr_list$stratum_def[1], "biomass_loss_rel_k2", c(1))
)


# Standard sub-surface parameters
# input_standard_par_list <- NULL
input_standard_par_list <- list(
  m = c(ps$m),
  k = c(ps$k),
  m_v = c(ps$m_v),
  k_v = c(ps$k_v),
  pa = c(ps$pa),
  po = c(ps$po),
  gw1 = c(ps$gw1),
  gw2 = c(ps$gw2)
)


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
input_dated_seq_list[[1]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.1,stringsAsFactors=FALSE)
input_dated_seq_list[[2]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.2,stringsAsFactors=FALSE)
input_dated_seq_list[[3]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.3,stringsAsFactors=FALSE)
input_dated_seq_list[[4]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.4,stringsAsFactors=FALSE)
input_dated_seq_list[[5]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.5,stringsAsFactors=FALSE)
input_dated_seq_list[[6]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.6,stringsAsFactors=FALSE)
input_dated_seq_list[[7]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.7,stringsAsFactors=FALSE)
input_dated_seq_list[[8]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.8,stringsAsFactors=FALSE)
input_dated_seq_list[[9]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=0.9,stringsAsFactors=FALSE)
input_dated_seq_list[[10]] <- data.frame(name="misreal",type="pspread",year=1988,month=10,day=7,hour=1,value=1.0,stringsAsFactors=FALSE)


# Make tec-file
#input_tec_data <- NULL
input_tec_data <- data.frame(year=integer(),month=integer(),day=integer(),hour=integer(),name=character(),stringsAsFactors=FALSE)
input_tec_data[1,] <- data.frame(1988, 10, 1, 1, "print_daily_on", stringsAsFactors=FALSE)
input_tec_data[2,] <- data.frame(1988, 10, 1, 2, "print_daily_growth_on", stringsAsFactors=FALSE)


# Data frame containing variable of interest, location/name of awk file (relative to output
# file location), and the location/name of rhessys output file with variable of interest.
# output_variables <- NULL
output_variables <- data.frame(variable=character(),awk_path=character(),out_file=character(),stringsAsFactors=FALSE)
output_variables[1,] <- data.frame("lai", "awks/output_var_bd_lai.awk","patch_fire_basin.daily",stringsAsFactors=FALSE)
output_variables[2,] <- data.frame("leafc", "awks/output_var_cdg_leafc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)
output_variables[3,] <- data.frame("stemc", "awks/output_var_cdg_stemc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)
output_variables[4,] <- data.frame("live_stemc", "awks/output_var_cdg_live_stemc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)
output_variables[5,] <- data.frame("dead_stemc", "awks/output_var_cdg_dead_stemc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)
output_variables[6,] <- data.frame("rootc", "awks/output_var_cdg_rootc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)

output_variables[7,] <- data.frame("litrc", "awks/output_var_bd_litrc.awk","patch_fire_basin.daily",stringsAsFactors=FALSE)
output_variables[8,] <- data.frame("cwdc", "awks/output_var_cdg_cwdc.awk","patch_fire_grow_stratum.daily",stringsAsFactors=FALSE)
output_variables[9,] <- data.frame("soil1c", "awks/output_var_pdg_soil1c.awk","patch_fire_grow_patch.daily",stringsAsFactors=FALSE)

output_variables[10,] <- data.frame("height", "awks/output_var_cd_height.awk","patch_fire_stratum.daily",stringsAsFactors=FALSE)



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


