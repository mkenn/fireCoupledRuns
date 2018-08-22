# Fire Effects Project Misc Setup Scripts
# This file is not to be called directly


# ---------------------------------------------------------------------
# Change P300 canopy_fraction

par_value <- 0.5
awk_file <- "awks/change.world.cf.awk"
input_file <- "ws_p300/worldfiles/world.p300_30m_2can"
output_folder <- " ws_p300/worldfiles/world.p300_30m_2can_pre_spinup"

change_parameters(par_value, awk_file, input_file, output_folder)


# ---------------------------------------------------------------------
# Extend p300 timeseries

p300_lowprov <- read_rhessys_met("ws_p300/clim/Grove_lowprov_clim")

# Note that write_sample_clim does not currently produce a climate base file
write_sample_clim("ws_p300/clim/Grove_lowprov_clim_1942_2453", p300_lowprov, seq(1942,2005),8)


# ---------------------------------------------------------------------
# Extend Santa Fe timeseries

happy <- read_rhessys_met("ws_sf/clim/snoelktr50")

# Note that write_sample_clim does not currently produce a climate base file
write_sample_clim("ws_sf/clim/snoelktr50_1942_2477", clim=happy, 
                  samplewyrs = seq(1942,2008), reps=8, startwyr = 1942)

# ---------------------------------------------------------------------





