# Run RHESSys sensitivity runs
# 
# This script calls sobol_runs_hja in 2.2.


source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_hja.R")

# ---------------------------------------------------------------------
# HJA

# Set worldfile at various stand ages 
world_ages_hja <- c("ws_hja/worldfiles/hja_2can_patch_6018.world.Y1968M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1978M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y1998M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2028M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2058M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2098M10D1H1.state",
                    "ws_hja/worldfiles/hja_2can_patch_6018.world.Y2148M10D1H1.state")

output_2.3 <- c(RHESSYS_OUT_DIR_2.3_HJA_STAND1,
                RHESSYS_OUT_DIR_2.3_HJA_STAND2,
                RHESSYS_OUT_DIR_2.3_HJA_STAND3,
                RHESSYS_OUT_DIR_2.3_HJA_STAND4,
                RHESSYS_OUT_DIR_2.3_HJA_STAND5,
                RHESSYS_OUT_DIR_2.3_HJA_STAND6,
                RHESSYS_OUT_DIR_2.3_HJA_STAND7)

# ----
# Run model for Sobol sensitivity

for (aa in seq_along(world_ages_hja)){
  sobol_runs_hja(
    core_par_path=OUTPUT_DIR_1_HJA_TOP_PS,
    sobol_par_path=RHESSYS_PAR_SOBOL_2.1_HJA,
    world=world_ages_hja[aa],
    hdr="2.3",
    output_path=output_2.3[aa]
  )
}

