# Patch Fire Sensitivity Analysis
#
# Contains scripts for evaluating parameter sensitivity of fire effects model

source("R/0.1_utilities.R")

theme_set(theme_bw(base_size = 11))


# ---------------------------------------------------------------------
# P300 Patch Fire data processing
# Computes differences in variables for several days before to several days after a fire.
# This will be updated when explicit fire effects output is implemented.


# Gather dated sequence values for binding to all_options table 
dated_data <- data.frame(dated_id = seq_along(input_dated_seq_list),
                         dated_seq_values = unlist(sapply(input_dated_seq_list, function(x) x[7])))

p300_patch_canopy <- readin_rhessys_output_cal(var_names = c("leafc", "stemc", "rootc"),
                                               path = ALLSIM_DIR_p300_2.1,
                                               initial_date = ymd("1941-10-01"),
                                               parameter_file = PARAMETER_FILE_p300_2.1_FIRE,
                                               num_canopies = 2)
p300_patch_canopy_diff <- p300_patch_canopy %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1941-10-03") | dates == ymd("1941-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1941-10-11` - `1941-10-03`)/`1941-10-03`)*100, absolute_change = `1941-10-11` - `1941-10-03`)
rm(p300_patch_canopy)


p300_patch_ground <- readin_rhessys_output_cal(var_names = c("litrc", "soil1c"),
                                               path = ALLSIM_DIR_p300_2.1,
                                               initial_date = ymd("1941-10-01"),
                                               parameter_file = PARAMETER_FILE_p300_2.1_FIRE,
                                               num_canopies = 1)
p300_patch_ground_diff <- p300_patch_ground %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1941-10-03") | dates == ymd("1941-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1941-10-11` - `1941-10-03`)/`1941-10-03`)*100, absolute_change = `1941-10-11` - `1941-10-03`)
rm(p300_patch_ground)


p300_patch_cwdc <- readin_rhessys_output_cal(var_names = c("cwdc"),
                                             path = ALLSIM_DIR_p300_2.1,
                                             initial_date = ymd("1941-10-01"),
                                             parameter_file = PARAMETER_FILE_p300_2.1_FIRE,
                                             num_canopies = 2)
p300_patch_cwdc_diff <- p300_patch_cwdc %>%
  full_join(dated_data, by="dated_id") %>% 
  group_by(run, dates, var_type, world_file, dated_seq_values) %>%
  summarize(value = sum(value)) %>%
  dplyr::filter(dates == ymd("1941-10-03") | dates == ymd("1941-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1941-10-11` - `1941-10-03`)/`1941-10-03`)*100, absolute_change = `1941-10-11` - `1941-10-03`)
rm(p300_patch_cwdc)


p300_patch_height <- readin_rhessys_output_cal(var_names = c("height"),
                                               path = ALLSIM_DIR_p300_2.1,
                                               initial_date = ymd("1941-10-01"),
                                               parameter_file = PARAMETER_FILE_p300_2.1_FIRE,
                                               num_canopies = 2)
p300_patch_height_diff <- p300_patch_height %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1941-10-03") | dates == ymd("1941-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1941-10-11` - `1941-10-03`)/`1941-10-03`)*100, absolute_change = `1941-10-11` - `1941-10-03`)
rm(p300_patch_height)




# ---------------------------------------------------------------------
# Sensitivity analysis

# Todo

# Variables

# Patch parameters
# overstory_height_thresh
# understory_height_thresh

# Upper canopy fire parameters
# pspread_loss_rel
# vapor_loss_rel
# biomass_loss_rel_k1
# biomass_loss_rel_k2

# Lower canopy fire parameters
# pspread_loss_rel
# vapor_loss_rel
# biomass_loss_rel_k1
# biomass_loss_rel_k2

# Stand age
# Pspread?



tmp <- p300_patch_height_diff %>% 
  dplyr::filter(canopy_layer==1, 
                #world_file == "ws_p300/worldfiles/p300_30m_2can_patch_9445.world.Y2022M10D1H1.state",
                dated_seq_values == .1)

X <- tmp %>% 
  dplyr::select(ws_p300.defs.patch_p300.def.overstory_height_thresh,
                ws_p300.defs.patch_p300.def.understory_height_thresh,
                ws_p300.defs.veg_p300_conifer.def.biomass_loss_rel_k1, 
                ws_p300.defs.veg_p300_conifer.def.biomass_loss_rel_k2,
                ws_p300.defs.veg_p300_conifer.def.pspread_loss_rel,
                ws_p300.defs.veg_p300_conifer.def.vapor_loss_rel,
                ws_p300.defs.veg_p300_shrub.def.biomass_loss_rel_k1, 
                ws_p300.defs.veg_p300_shrub.def.biomass_loss_rel_k2,
                ws_p300.defs.veg_p300_shrub.def.pspread_loss_rel,
                ws_p300.defs.veg_p300_shrub.def.vapor_loss_rel,
                world_file
                )

y <- tmp %>% 
  dplyr::select(relative_change)

pcc(X, y, nboot = 10, rank = TRUE)


plot(X$awks.change.def.overstory_height_thresh.awk, y$relative_change)
#summary(lm(X$awks.change.def.overstory_height_thresh.awk~y$relative_change))

plot(X$awks.change.def.understory_height_thresh.awk, y$relative_change)
#summary(lm(X$awks.change.def.understory_height_thresh.awk~y$relative_change))

plot(X$awks.change.def.pspread_loss_rel.awk, y$relative_change)
#summary(lm(X$awks.change.def.pspread_loss_rel.awk~y$relative_change))

plot(X$awks.change.def.vapor_loss_rel.awk, y$relative_change)
#summary(lm(X$awks.change.def.vapor_loss_rel.awk~y$relative_change))

plot(X$awks.change.def.biomass_loss_rel_k1.awk, y$relative_change)
#summary(lm(X$awks.change.def.biomass_loss_rel_k1.awk~y$relative_change))

plot(X$awks.change.def.biomass_loss_rel_k2.awk, y$relative_change)
#summary(lm(X$awks.change.def.biomass_loss_rel_k2.awk~y$relative_change))


# --- 



plot(X$dated_seq_values, y$relative_change)
summary(lm(X$dated_seq_values~y$relative_change))




















# ---------------------------------------------------------------------
# Sensitivity analysis


tmp <- p300_patch_height_diff %>% 
  dplyr::filter(canopy_layer==1, 
                world_file == "ws_p300/worldfiles/world.p300_30m_2can_patch_9445.Y2022M10D1H1.state",
                awks.change.def.pspread_loss_rel.awk.1 == 1, 
                awks.change.def.vapor_loss_rel.awk.1 == 1,
                dated_seq_values == .8)

X <- tmp %>% 
  dplyr::select(awks.change.def.biomass_loss_rel_k1.awk.1, awks.change.def.biomass_loss_rel_k2.awk.1)

y <- tmp %>% 
  dplyr::select(relative_change)

pcc(X, y, nboot = 100)


plot(X$awks.change.def.overstory_height_thresh.awk, y$relative_change)
#summary(lm(X$awks.change.def.overstory_height_thresh.awk~y$relative_change))

plot(X$awks.change.def.understory_height_thresh.awk, y$relative_change)
#summary(lm(X$awks.change.def.understory_height_thresh.awk~y$relative_change))

plot(X$awks.change.def.pspread_loss_rel.awk.1, y$relative_change)
#summary(lm(X$awks.change.def.pspread_loss_rel.awk~y$relative_change))

plot(X$awks.change.def.vapor_loss_rel.awk.1, y$relative_change)
#summary(lm(X$awks.change.def.vapor_loss_rel.awk~y$relative_change))

plot(X$awks.change.def.biomass_loss_rel_k1.awk.1, y$relative_change)
#summary(lm(X$awks.change.def.biomass_loss_rel_k1.awk~y$relative_change))

plot(X$awks.change.def.biomass_loss_rel_k2.awk.1, y$relative_change)
#summary(lm(X$awks.change.def.biomass_loss_rel_k2.awk~y$relative_change))






