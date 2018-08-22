# Run RHESSys sensitivity runs
# 
# This script calls sobol_runs_sf in 2.2.


source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_sf.R")

# ---------------------------------------------------------------------
# SF

# Set worldfile at various stand ages 
world_ages_sf <- c("ws_sf/worldfiles/sf_2can_patch_2777.world.Y1947M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1954M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1962M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1972M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y1982M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y2002M10D1H1.state",
                   "ws_sf/worldfiles/sf_2can_patch_2777.world.Y2022M10D1H1.state")

output_2.3 <- c(RHESSYS_OUT_DIR_2.3_SF_STAND1,
                RHESSYS_OUT_DIR_2.3_SF_STAND2,
                RHESSYS_OUT_DIR_2.3_SF_STAND3,
                RHESSYS_OUT_DIR_2.3_SF_STAND4,
                RHESSYS_OUT_DIR_2.3_SF_STAND5,
                RHESSYS_OUT_DIR_2.3_SF_STAND6,
                RHESSYS_OUT_DIR_2.3_SF_STAND7)

# ----
# Run model for Sobol sensitivity

for (aa in seq_along(world_ages_sf)){
  sobol_runs_sf(
    core_par_path=OUTPUT_DIR_1_SF_TOP_PS,
    sobol_par_path=RHESSYS_PAR_SOBOL_2.1_SF,
    world=world_ages_sf[aa],
    hdr="2.3",
    output_path=output_2.3[aa]
  )
}

