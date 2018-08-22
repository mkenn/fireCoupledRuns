# Patch Fire Evaluation
#
# Contains scripts for evaluating patch-level fire effects

source("R/0.1_utilities.R")

theme_set(theme_bw(base_size = 11))
#theme_set(theme_bw(base_size = 16))


# ---------------------------------------------------------------------
# RS Patch Fire data processing
# Computes differences in variables for several days before to several days after a fire.
# This will be updated when explicit fire effects output is implemented.


# Gather dated sequence values for binding to all_options table 
dated_data <- data.frame(dated_id = seq_along(input_dated_seq_list),
                         dated_seq_values = unlist(sapply(input_dated_seq_list, function(x) x[7])))

rs_patch_canopy <- readin_rhessys_output_cal(var_names = c("leafc", "stemc", "rootc"),
                                               path = RHESSYS_ALLSIM_DIR_3.1_RS,
                                               initial_date = ymd("1988-10-01"),
                                               parameter_file = RHESSYS_ALL_OPTION_3.1_RS,
                                               num_canopies = 1)
rs_patch_canopy_diff <- rs_patch_canopy %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1988-10-03") | dates == ymd("1988-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1988-10-11` - `1988-10-03`)/`1988-10-03`)*100, 
         absolute_change = `1988-10-11` - `1988-10-03`)
rm(rs_patch_canopy)


rs_patch_ground <- readin_rhessys_output_cal(var_names = c("litrc", "soil1c"),
                                               path = RHESSYS_ALLSIM_DIR_3.1_RS,
                                               initial_date = ymd("1988-10-01"),
                                               parameter_file = RHESSYS_ALL_OPTION_3.1_RS,
                                               num_canopies = 1)
rs_patch_ground_diff <- rs_patch_ground %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1988-10-03") | dates == ymd("1988-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1988-10-11` - `1988-10-03`)/`1988-10-03`)*100, 
         absolute_change = `1988-10-11` - `1988-10-03`)
rm(rs_patch_ground)


rs_patch_cwdc <- readin_rhessys_output_cal(var_names = c("cwdc"),
                                             path = RHESSYS_ALLSIM_DIR_3.1_RS,
                                             initial_date = ymd("1988-10-01"),
                                             parameter_file = RHESSYS_ALL_OPTION_3.1_RS,
                                             num_canopies = 1)
rs_patch_cwdc_diff <- rs_patch_cwdc %>%
  full_join(dated_data, by="dated_id") %>% 
  group_by(run, dates, var_type, world_file, dated_seq_values) %>%
  summarize(value = sum(value)) %>%
  dplyr::filter(dates == ymd("1988-10-03") | dates == ymd("1988-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1988-10-11` - `1988-10-03`)/`1988-10-03`)*100, 
         absolute_change = `1988-10-11` - `1988-10-03`)
rm(rs_patch_cwdc)


rs_patch_height <- readin_rhessys_output_cal(var_names = c("height"),
                                               path = RHESSYS_ALLSIM_DIR_3.1_RS,
                                               initial_date = ymd("1988-10-01"),
                                               parameter_file = RHESSYS_ALL_OPTION_3.1_RS,
                                               num_canopies = 1)
rs_patch_height_diff <- rs_patch_height %>%
  full_join(dated_data, by="dated_id") %>% 
  dplyr::filter(dates == ymd("1988-10-03") | dates == ymd("1988-10-11")) %>%
  spread(dates, value) %>%
  mutate(relative_change = ((`1988-10-11` - `1988-10-03`)/`1988-10-03`)*100, 
         absolute_change = `1988-10-11` - `1988-10-03`)
rm(rs_patch_height)


# ---
world_file_yr <- c(
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y1994M10D1H1.state" = "Stand\nage:\n5 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2001M10D1H1.state" = "Stand\nage:\n12 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2009M10D1H1.state" = "Stand\nage:\n20 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2019M10D1H1.state" = "Stand\nage:\n30 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2029M10D1H1.state" = "Stand\nage:\n40 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2049M10D1H1.state" = "Stand\nage:\n60 yrs",
  "ws_rs/worldfiles/rs_30m_1can_patch_40537.world.Y2069M10D1H1.state" = "Stand\nage:\n80 yrs"
)

canopy <- c("1" = "Conifer","2" = "Shrub")


# ---------------------------------------------------------------------
# Figures: 

tmp <- dplyr::filter(rs_patch_ground_diff, var_type == "litrc")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity",aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(.~world_file, labeller = labeller(world_file = world_file_yr)) +
  theme(legend.position = "none") +
  labs(title = "Litter Carbon", x = "Intensity", y = "Change in Litter Carbon (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_litrc.pdf",plot = x, path = OUTPUT_DIR_2)

tmp <- dplyr::filter(rs_patch_ground_diff, var_type == "soil1c")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity",aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(.~world_file, labeller = labeller(world_file = world_file_yr)) +
  theme(legend.position = "none") +
  labs(title = "Soil Carbon", x = "Intensity", y = "Change in Soil Carbon (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_soil1c.pdf",plot = x, path = OUTPUT_DIR_2)

tmp <- dplyr::filter(rs_patch_cwdc_diff, var_type == "cwdc")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity",aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(.~world_file, labeller = labeller(world_file = world_file_yr, canopy_layer = canopy)) +
  theme(legend.position = "none") +
  labs(title = "Coarse Woody Debris Carbon", x = "Intensity", y = "Change in CWD Carbon (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_cwdc.pdf",plot = x, path = OUTPUT_DIR_2)


# ----

tmp <- dplyr::filter(rs_patch_canopy_diff,var_type == "leafc")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity", aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(canopy_layer~world_file, labeller = labeller(world_file = world_file_yr, canopy_layer = canopy)) +
  theme(legend.position = "none") +
  labs(title = "Leaf Carbon", x = "Intensity", y = "Change in Leaf Carbon (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_leafc.pdf",plot = x, path = OUTPUT_DIR_2)


tmp <- dplyr::filter(rs_patch_canopy_diff,var_type == "stemc")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity",aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(canopy_layer~world_file, labeller = labeller(world_file = world_file_yr, canopy_layer = canopy)) +
  theme(legend.position = "none") +
  labs(title = "Stem Carbon", x = "Intensity", y = "Change in Stem Carbon (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_stemc.pdf",plot = x, path = OUTPUT_DIR_2)


tmp <- dplyr::filter(rs_patch_height_diff,var_type == "height")
x <- ggplot(data = tmp) +
  geom_bar(stat="identity",aes(x=dated_seq_values,y=relative_change), color="olivedrab3") +
  facet_grid(canopy_layer~world_file, labeller = labeller(world_file = world_file_yr, canopy_layer = canopy)) +
  theme(legend.position = "none") +
  labs(title = "Height", x = "Intensity", y = "Change in Height (%)") +
  scale_x_continuous(breaks = c(0.2, 0.8))
plot(x)
#ggsave("rs_patch_sim_change_height.pdf",plot = x, path = OUTPUT_DIR_2)




