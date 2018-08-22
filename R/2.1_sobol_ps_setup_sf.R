# Generate Sobol Models
# 
# Generates an empty model of sobol parameter sets to run rhessys.
# Four sobol models are included, sobol2002, sobol2007, soboljansen and sobolmartinez


source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Santa Fe


n_sim <- 1000

input_sobol <- list()
# Produce a list with two sets of parameter sets for Sobol method
input_sobol <- lapply(seq(1,2), function(x){
  
  tmp1 <- setNames(data.frame(runif(n_sim, min=6,max=8)), "ws_sf/defs/soil_sf_303verydeepsandyloam.def:overstory_height_thresh")
  tmp2 <- setNames(data.frame(runif(n_sim, min=4,max=5)), "ws_sf/defs/soil_sf_303verydeepsandyloam.def:understory_height_thresh")
  tmp3 <- setNames(data.frame(rlunif(n_sim, min=0.01,max=100)), "ws_sf/defs/veg_sf_understory.def:understory_mort")
  tmp4 <- setNames(data.frame(rlunif(n_sim, min=0.01,max=100)), "ws_sf/defs/veg_sf_understory.def:consumption")
  tmp5 <- setNames(data.frame(runif(n_sim, min=-20,max=-1)), "ws_sf/defs/veg_sf_understory.def:overstory_mort_k1")
  tmp6 <- setNames(data.frame(runif(n_sim, min=0.2,max=2)), "ws_sf/defs/veg_sf_understory.def:overstory_mort_k2")
  tmp7 <- setNames(data.frame(rlunif(n_sim, min=0.01,max=100)), "ws_sf/defs/veg_sf_1ponderosapine.def:understory_mort")
  tmp8 <- setNames(data.frame(rlunif(n_sim, min=0.01,max=100)), "ws_sf/defs/veg_sf_1ponderosapine.def:consumption")
  tmp9 <- setNames(data.frame(runif(n_sim, min=-20,max=-1)), "ws_sf/defs/veg_sf_1ponderosapine.def:overstory_mort_k1")
  tmp10 <- setNames(data.frame(runif(n_sim, min=0.2,max=2)), "ws_sf/defs/veg_sf_1ponderosapine.def:overstory_mort_k2")
  tmp_pspread <- setNames(data.frame(runif(n_sim, min=0.001,max=1)), "pspread")
  
  input_sobol[[x]] <- bind_cols(tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8,tmp9,tmp10,tmp_pspread)
})

# Produce empty model so that non-R model (RHESSys) can be used.
sobol_model_martinez <- sobolmartinez(model = NULL, X1 = input_sobol[[1]], X2 = input_sobol[[2]], order = 1, nboot = 200)   # runs=n_sim*(p+2)
sobol_model_2002 <- sobol2002(model = NULL, X1 = input_sobol[[1]], X2 = input_sobol[[2]], order = 1, nboot = 200)  # runs=n_sim*(p+2)
sobol_model_2007 <- sobol2007(model = NULL, X1 = input_sobol[[1]], X2 = input_sobol[[2]], order = 1, nboot = 200)  # runs=n_sim*(p+2)
sobol_model_jansen <- soboljansen(model = NULL, X1 = input_sobol[[1]], X2 = input_sobol[[2]], order = 1, nboot = 200)  # runs=n_sim*(p+2)


# Export the parameter sets to be used in the sobol model.
write.csv(sobol_model_martinez$X, RHESSYS_PAR_SOBOL_2.1_SF, row.names = FALSE, quote=FALSE) # Parameter sets
saveRDS(sobol_model_martinez, RHESSYS_PAR_SOBOL_MODEL_MARTINEZ_2.1_SF) # Empty model
saveRDS(sobol_model_2002, RHESSYS_PAR_SOBOL_MODEL_2002_2.1_SF) # Empty model
saveRDS(sobol_model_2007, RHESSYS_PAR_SOBOL_MODEL_2007_2.1_SF) # Empty model
saveRDS(sobol_model_jansen, RHESSYS_PAR_SOBOL_MODEL_JANSEN_2.1_SF) # Empty model

