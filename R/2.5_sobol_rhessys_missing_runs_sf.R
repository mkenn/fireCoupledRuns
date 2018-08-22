# Patch Missing Sobol Output - SF
#
# This script isolates sobol calibration runs that are missing and reruns those
# parameters sets.

source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_sf.R")
source("R/2.4_sobol_rhessys_missing_runs_setup.R")

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 1: Isolate missing parameter sets


allsim_2.3_sf <- c(RHESSYS_ALLSIM_DIR_2.3_SF_STAND1,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND2,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND3,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND4,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND5,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND6,
                   RHESSYS_ALLSIM_DIR_2.3_SF_STAND7)

sobol_par_missing_sf <- c(RHESSYS_PAR_MISSING_2.5_SF_STAND1,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND2,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND3,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND4,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND5,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND6,
                          RHESSYS_PAR_MISSING_2.5_SF_STAND7)

ps_missing_sf <- vector()
for (aa in seq_along(allsim_2.3_sf)){
  # Find missing parameters
  ps_missing <- patch_missing_runs(sobol_par = RHESSYS_PAR_SOBOL_2.1_SF,
                                   rhessys_allsim_path = allsim_2.3_sf[aa],
                                   output_path=sobol_par_missing_sf[aa])
  ps_missing_sf[aa] <- ps_missing
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 2: RHESSys simulations for the missing parameter sets


# Set worldfile at various stand ages (Copy from 2.3)
world_ages_sf <- c("ws_sf/worldfiles/sf_2can_patch_2777.world.Y1947M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1954M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1962M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1972M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1982M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y2002M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y2022M10D1H1.state")

hdr_sf <- c("2.5_sf_stand1",
            "2.5_sf_stand2",
            "2.5_sf_stand3",
            "2.5_sf_stand4",
            "2.5_sf_stand5",
            "2.5_sf_stand6",
            "2.5_sf_stand7")

output_2.5_sf <- c(RHESSYS_OUT_DIR_2.5_SF_STAND1,
                   RHESSYS_OUT_DIR_2.5_SF_STAND2,
                   RHESSYS_OUT_DIR_2.5_SF_STAND3,
                   RHESSYS_OUT_DIR_2.5_SF_STAND4,
                   RHESSYS_OUT_DIR_2.5_SF_STAND5,
                   RHESSYS_OUT_DIR_2.5_SF_STAND6,
                   RHESSYS_OUT_DIR_2.5_SF_STAND7)


for (aa in seq_along(world_ages_sf)){
  if (ps_missing_sf[aa] == TRUE){
    sobol_runs_sf(                   # This function is defined in 2.2
      core_par_path=OUTPUT_DIR_1_SF_TOP_PS,
      sobol_par_path=sobol_par_missing_sf[aa],
      world=world_ages_sf[aa],
      hdr=hdr_sf[aa],
      output_path=output_2.5_sf[aa]
    )
  }
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 3: Stick data back together again


var_names <- c("canopy_target_prop_mort", "canopy_target_prop_mort_consumed",
               "canopy_target_prop_c_consumed", "canopy_target_prop_c_remain")

allsim_2.5_sf <- c(RHESSYS_ALLSIM_DIR_2.5_SF_STAND1,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND2,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND3,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND4,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND5,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND6,
                   RHESSYS_ALLSIM_DIR_2.5_SF_STAND7)

for (aa in seq_along(allsim_2.3_sf)){
  print(paste("---------------- Stand",aa,"-----------------"))
  if (ps_missing_sf[aa] == TRUE){
    # Copy rhessys output from 2.3 directory, patch missing, copy to 2.5 directory
    humpty_dumpty(var_names = var_names,
                  rhessys_allsim_path_orig = allsim_2.3_sf[aa],
                  sobol_par_patched = sobol_par_missing_sf[aa],
                  rhessys_allsim_path_patched = allsim_2.5_sf[aa])
  } else {
    # Copy rhessys output from 2.3 directory to 2.5 directory
    not_humpty_dumpty(var_names = var_names,
                      rhessys_allsim_path_orig = allsim_2.3_sf[aa],
                      rhessys_allsim_path_patched = allsim_2.5_sf[aa])
  }
}

