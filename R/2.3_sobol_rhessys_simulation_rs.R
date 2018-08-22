# Run RHESSys sensitivity runs
# 
# This script calls sobol_runs_rs in 2.2.


source("R/0.1_utilities.R")
source("R/2.2_sobol_rhessys_setup_rs.R")

# ---------------------------------------------------------------------
# RS

# Set worldfile at various stand ages 
world_ages_rs <- c("ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y1994M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2001M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2009M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2019M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2029M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2049M10D1H1.state",
                   "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2069M10D1H1.state")

output_2.3 <- c(RHESSYS_OUT_DIR_2.3_RS_STAND1,
                RHESSYS_OUT_DIR_2.3_RS_STAND2,
                RHESSYS_OUT_DIR_2.3_RS_STAND3,
                RHESSYS_OUT_DIR_2.3_RS_STAND4,
                RHESSYS_OUT_DIR_2.3_RS_STAND5,
                RHESSYS_OUT_DIR_2.3_RS_STAND6,
                RHESSYS_OUT_DIR_2.3_RS_STAND7)


# ----
# Run model for Sobol sensitivity

for (aa in seq_along(world_ages_rs)){
  sobol_runs_rs(
    core_par_path=OUTPUT_DIR_1_RS_TOP_PS,
    sobol_par_path=RHESSYS_PAR_SOBOL_2.1_RS,
    world=world_ages_rs[aa],
    hdr="2.3",
    output_path=output_2.3[aa]
  )
}

