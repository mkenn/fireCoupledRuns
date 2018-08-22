# Patch Missing Sobol Output - HJA
#
# This script isolates sobol calibration runs that are missing and reruns those
# parameters sets.

source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_hja.R")
source("R/2.4_sobol_rhessys_missing_runs_setup.R")

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 1: Isolate missing parameter sets


allsim_2.3_hja <- c(RHESSYS_ALLSIM_DIR_2.3_HJA_STAND1,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND2,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND3,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND4,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND5,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND6,
                    RHESSYS_ALLSIM_DIR_2.3_HJA_STAND7)

sobol_par_missing_hja <- c(RHESSYS_PAR_MISSING_2.5_HJA_STAND1,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND2,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND3,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND4,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND5,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND6,
                           RHESSYS_PAR_MISSING_2.5_HJA_STAND7)

ps_missing_hja <- vector()
for (aa in seq_along(allsim_2.3_hja)){
  # Find missing parameters
  ps_missing <- patch_missing_runs(sobol_par = RHESSYS_PAR_SOBOL_2.1_HJA,
                                   rhessys_allsim_path = allsim_2.3_hja[aa],
                                   output_path=sobol_par_missing_hja[aa])
  ps_missing_hja[aa] <- ps_missing
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 2: RHESSys simulations for the missing parameter sets


# Set worldfile at various stand ages (Copy from 2.3)
world_ages_hja <- c("ws_hja/worldfiles/hja_2can_patch_6018.world.Y1968M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1978M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1998M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2028M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2058M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2098M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2148M10D1H1.state")

hdr_hja <- c("2.5_hja_stand1",
             "2.5_hja_stand2",
             "2.5_hja_stand3",
             "2.5_hja_stand4",
             "2.5_hja_stand5",
             "2.5_hja_stand6",
             "2.5_hja_stand7")

output_2.5_hja <- c(RHESSYS_OUT_DIR_2.5_HJA_STAND1,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND2,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND3,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND4,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND5,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND6,
                    RHESSYS_OUT_DIR_2.5_HJA_STAND7)


for (aa in seq_along(world_ages_hja)){
  if (ps_missing_hja[aa] == TRUE){
    sobol_runs_hja(                   # This function is defined in 2.2
      core_par_path=OUTPUT_DIR_1_HJA_TOP_PS,
      sobol_par_path=sobol_par_missing_hja[aa],
      world=world_ages_hja[aa],
      hdr=hdr_hja[aa],
      output_path=output_2.5_hja[aa]
    )
  }
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 3: Stick data back together again


var_names <- c("canopy_target_prop_mort", "canopy_target_prop_mort_consumed",
               "canopy_target_prop_c_consumed", "canopy_target_prop_c_remain")

allsim_2.5_hja <- c(RHESSYS_ALLSIM_DIR_2.5_HJA_STAND1,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND2,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND3,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND4,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND5,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND6,
                    RHESSYS_ALLSIM_DIR_2.5_HJA_STAND7)

for (aa in seq_along(allsim_2.3_hja)){
  print(paste("---------------- Stand",aa,"-----------------"))
  if (ps_missing_hja[aa] == TRUE){
    # Copy rhessys output from 2.3 directory, patch missing, copy to 2.5 directory
    humpty_dumpty(var_names = var_names,
                  rhessys_allsim_path_orig = allsim_2.3_hja[aa],
                  sobol_par_patched = sobol_par_missing_hja[aa],
                  rhessys_allsim_path_patched = allsim_2.5_hja[aa])
  } else {
    # Copy rhessys output from 2.3 directory to 2.5 directory
    not_humpty_dumpty(var_names = var_names,
                      rhessys_allsim_path_orig = allsim_2.3_hja[aa],
                      rhessys_allsim_path_patched = allsim_2.5_hja[aa])
  }
}

