# Run scripts in batch

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# Tune the model and find top parameter set

source("R/1.1_patch_simulation_hja.R", echo=TRUE)
source("R/1.1_patch_simulation_p300.R", echo=TRUE)
source("R/1.1_patch_simulation_rs.R", echo=TRUE)
source("R/1.1_patch_simulation_sf.R", echo=TRUE)

source("R/1.2_patch_simulation_eval.R", echo=TRUE)

source("R/1.3_patch_export_stand_age_hja.R", echo=TRUE)
source("R/1.3_patch_export_stand_age_p300.R", echo=TRUE)
source("R/1.3_patch_export_stand_age_rs.R", echo=TRUE)
source("R/1.3_patch_export_stand_age_sf.R", echo=TRUE)

# ---------------------------------------------------------------------
# Sensitivity test

source("R/2.1_sobol_ps_setup_hja.R", echo=TRUE)
source("R/2.2_sobol_rhessys_setup_hja.R", echo=TRUE)
source("R/2.3_sobol_rhessys_simulation_hja.R", echo=TRUE)


source("R/2.1_sobol_ps_setup_p300.R", echo=TRUE)
source("R/2.2_sobol_rhessys_setup_p300.R", echo=TRUE)
source("R/2.3_sobol_rhessys_simulation_p300.R", echo=TRUE)


source("R/2.1_sobol_ps_setup_rs.R", echo=TRUE)
source("R/2.2_sobol_rhessys_setup_rs.R", echo=TRUE)
source("R/2.3_sobol_rhessys_simulation_rs.R", echo=TRUE)


source("R/2.1_sobol_ps_setup_sf.R", echo=TRUE)
source("R/2.2_sobol_rhessys_setup_sf.R", echo=TRUE)
source("R/2.3_sobol_rhessys_simulation_sf.R", echo=TRUE)



# ---------------------------------------------------------------------
# Patch Simulation



# ---------------------------------------------------------------------
# Final Figures and tables


# ---------------------------------------------------------------------
# Sample code for sink
# Sink directs the output from a sourced file
sink(file("backup.log"), append=TRUE)
sink(file=NULL)
#closeAllConnections()


