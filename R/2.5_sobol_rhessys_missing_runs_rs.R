# Patch Missing Sobol Output - RS
#
# This script isolates sobol calibration runs that are missing and reruns those
# parameters sets.

source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_rs.R")
source("R/2.4_sobol_rhessys_missing_runs_setup.R")

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 1: Isolate missing parameter sets


allsim_2.3_rs <- c(RHESSYS_ALLSIM_DIR_2.3_RS_STAND1,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND2,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND3,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND4,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND5,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND6,
                   RHESSYS_ALLSIM_DIR_2.3_RS_STAND7)

sobol_par_missing_rs <- c(RHESSYS_PAR_MISSING_2.5_RS_STAND1,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND2,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND3,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND4,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND5,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND6,
                          RHESSYS_PAR_MISSING_2.5_RS_STAND7)

ps_missing_rs <- vector()
for (aa in seq_along(allsim_2.3_rs)){
  # Find missing parameters
  ps_missing <- patch_missing_runs(sobol_par = RHESSYS_PAR_SOBOL_2.1_RS,
                                   rhessys_allsim_path = allsim_2.3_rs[aa],
                                   output_path=sobol_par_missing_rs[aa])
  ps_missing_rs[aa] <- ps_missing
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 2: RHESSys simulations for the missing parameter sets


# Set worldfile at various stand ages (Copy from 2.3)
world_ages_rs <- c("ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y1994M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2001M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2009M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2019M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2029M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2049M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2069M10D1H1.state")

hdr_rs <- c("2.5_rs_stand1",
            "2.5_rs_stand2",
            "2.5_rs_stand3",
            "2.5_rs_stand4",
            "2.5_rs_stand5",
            "2.5_rs_stand6",
            "2.5_rs_stand7")

output_2.5_rs <- c(RHESSYS_OUT_DIR_2.5_RS_STAND1,
                   RHESSYS_OUT_DIR_2.5_RS_STAND2,
                   RHESSYS_OUT_DIR_2.5_RS_STAND3,
                   RHESSYS_OUT_DIR_2.5_RS_STAND4,
                   RHESSYS_OUT_DIR_2.5_RS_STAND5,
                   RHESSYS_OUT_DIR_2.5_RS_STAND6,
                   RHESSYS_OUT_DIR_2.5_RS_STAND7)


for (aa in seq_along(world_ages_rs)){
  if (ps_missing_rs[aa] == TRUE){
    sobol_runs_rs(                   # This function is defined in 2.2
      core_par_path=OUTPUT_DIR_1_RS_TOP_PS,
      sobol_par_path=sobol_par_missing_rs[aa],
      world=world_ages_rs[aa],
      hdr=hdr_rs[aa],
      output_path=output_2.5_rs[aa]
    )
  }
}



# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 3: Stick data back together again


var_names <- c("canopy_target_prop_mort", "canopy_target_prop_mort_consumed",
               "canopy_target_prop_c_consumed", "canopy_target_prop_c_remain")

allsim_2.5_rs <- c(RHESSYS_ALLSIM_DIR_2.5_RS_STAND1,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND2,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND3,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND4,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND5,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND6,
                   RHESSYS_ALLSIM_DIR_2.5_RS_STAND7)

for (aa in seq_along(allsim_2.3_rs)){
  print(paste("---------------- Stand",aa,"-----------------"))
  if (ps_missing_rs[aa] == TRUE){
    # Copy rhessys output from 2.3 directory, patch missing, copy to 2.5 directory
    humpty_dumpty(var_names = var_names,
                  rhessys_allsim_path_orig = allsim_2.3_rs[aa],
                  sobol_par_patched = sobol_par_missing_rs[aa],
                  rhessys_allsim_path_patched = allsim_2.5_rs[aa])
  } else {
    # Copy rhessys output from 2.3 directory to 2.5 directory
    not_humpty_dumpty(var_names = var_names,
                      rhessys_allsim_path_orig = allsim_2.3_rs[aa],
                      rhessys_allsim_path_patched = allsim_2.5_rs[aa])
  }
}

