# Display Figures for Fire Effects Project
#
# Contains scripts for producing display figures

source("R/0.1_utilities.R")

theme_set(theme_bw(base_size = 18))

# ---------------------------------------------------------------------
# Consumption Output Figure
# Relation between percent canopy mortality and percent consumption


consumption_figure = function(consumption_parameter, title_name){
  
  percent_canopy_mortality <- seq(from=0,to=1,length.out=101)
  
  tmp_func = function (percent_canopy_mortality, consumption_parameter){
    if(consumption_parameter == 1){
      percent_mortality <- percent_canopy_mortality*100
    }
    else {
      percent_mortality <-  (((consumption_parameter^percent_canopy_mortality) - 1)/(consumption_parameter-1)*100)
    }
  }
  
  percent_canopy_mortality_rep <- rep(percent_canopy_mortality, length(consumption_parameter))
  consumption_parameter_rep <- rep(consumption_parameter, each=length(percent_canopy_mortality))
  
  happy <- percent_canopy_mortality_rep %>%
    cbind(percent_canopy_mortality_rep = ., consumption_parameter_rep) %>%
    as.data.frame()
  
  percent_mortality <- mapply(tmp_func,happy$percent_canopy_mortality_rep, happy$consumption_parameter_rep)
  happy <- cbind(happy, percent_mortality)
  happy$consumption_parameter_rep <- as.factor(happy$consumption_parameter_rep)
  
  
  x <- ggplot(data = happy) +
    geom_line(aes(x=percent_canopy_mortality_rep, y=percent_mortality, linetype = consumption_parameter_rep, color = consumption_parameter_rep), size=1.2) +
    #theme_bw(base_size=21) +
    labs(title = title_name, x = "Proportion Mortality", y = "Proportion of Mortality Consumed") +
    scale_linetype(name = "Consumption\nParameter\n(k2)") +
    scale_color_brewer(palette = "Dark2", name = "Consumption\nParameter\n(k2)")
  plot(x)
  return(x)
}

x = consumption_figure(consumption_parameter = c(0.01, 1, 100), title_name = "Consumption")
ggsave("display_consumption.pdf", plot = x, path = DISPLAY_FIGURES_DIR)



# Consumption Output Figures

consumption_output_figure = function(consumption_parameter, title_name){

  percent_mortality <- seq(from=0,to=1,length.out=101)
  percent_consumed <- vector()
  
  for(aa in seq_along(percent_mortality)){
    if(consumption_parameter == 1){
      percent_consumed[aa] <- percent_mortality[aa] * percent_mortality[aa]
    }
    else {
      percent_consumed[aa] <- percent_mortality[aa] * ((consumption_parameter^percent_mortality[aa]) - 1)/(consumption_parameter-1)
    }
  }
  
  percent_litter <- percent_mortality - percent_consumed

  happy = percent_mortality %>%
    cbind(percent_consumed, percent_litter) %>%
    `*`(100) %>%
    as.data.frame() %>%
    gather("carbon_pool", "Percent", 2:3)
  
  x <- ggplot(data = happy) +
    geom_line(aes(x=., y=Percent, linetype = carbon_pool, color = carbon_pool), size=1.2) +
    #theme_bw(base_size=16) +
    labs(title = title_name, x = "Canopy Mortality (%)", y = "Percent of Canopy Carbon") +
    scale_linetype(name = "Carbon Pool", labels=c("Litter","Consumed")) +
    scale_color_brewer(palette = "Dark2", name = "Carbon Pool", labels=c("Litter","Consumed"))
  plot(x)
  return(x)
}

x = consumption_output_figure(consumption_parameter = 0.01, title_name = "High Consumption")
ggsave("consumption_high.pdf", plot = x, path = DISPLAY_FIGURES_DIR)
x = consumption_output_figure(consumption_parameter = 1, title_name = "Medium Consumption")
ggsave("consumption_medium.pdf", plot = x, path = DISPLAY_FIGURES_DIR)
x = consumption_output_figure(consumption_parameter = 100, title_name = "Low Consumption")
ggsave("consumption_low.pdf", plot = x, path = DISPLAY_FIGURES_DIR)



# ---------------------------------------------------------------------
# Understory Mortality Figure
# Relation between pspread and percent mortality


understory_figure = function(pspread_mortality_parameter, title_name){
  
  pspread <- seq(from=0,to=1,length.out=101)
  
  tmp_func = function (pspread, pspread_mortality_parameter){
    if(pspread_mortality_parameter == 1){
      percent_mortality <- pspread*100
    }
    else {
      percent_mortality <-  (((pspread_mortality_parameter^pspread) - 1)/(pspread_mortality_parameter-1)*100)
    }
  }
  
  pspread_rep <- rep(pspread, length(pspread_mortality_parameter))
  pspread_mortality_parameter_rep <- rep(pspread_mortality_parameter, each=length(pspread))

  happy <- pspread_rep %>%
    cbind(pspread_rep = ., pspread_mortality_parameter_rep) %>%
    as.data.frame()
  
  percent_mortality <- mapply(tmp_func,happy$pspread_rep, happy$pspread_mortality_parameter_rep)
  happy <- cbind(happy, percent_mortality)
  happy$pspread_mortality_parameter_rep <- as.factor(happy$pspread_mortality_parameter_rep)
  
  
  x <- ggplot(data = happy) +
    geom_line(aes(x=pspread_rep, y=percent_mortality, linetype = pspread_mortality_parameter_rep, color = pspread_mortality_parameter_rep), size=1.2) +
    #theme_bw(base_size=16) +
#    labs(title = title_name, x = "Pspread", y = "Understory Mortality (%)") +
    labs(title = title_name, x = expression(Intensity~(i[u])), y = "Proportion Mortality") +
    scale_linetype(name = "Understory\nMortality\nParameter\n(k1)") +
    scale_color_brewer(palette = "Dark2", name = "Understory\nMortality\nParameter\n(k1)")
  plot(x)
  return(x)
}


x = understory_figure(pspread_mortality_parameter = c(0.01, 1, 100), title_name = "Understory Mortality")
ggsave("display_understory.pdf", plot = x, path = DISPLAY_FIGURES_DIR)



# ---------------------------------------------------------------------
# Overstory Mortality Figure
# Relation between understory biomass mortality and overstory mortality


overstory_figure = function(k1, k2, title_name){
  
  understory_biomass_mortality <- seq(from=0,to=2000, length.out = 201)   # gC/m2
  
  tmp_func = function (understory_biomass_mortality, k1, k2){
    overstory_percent_mortality <- (1-1/(1+exp(-(k1*(understory_biomass_mortality-k2))))*100)+100
    return(overstory_percent_mortality)
  }
  
  happy <- expand.grid(understory_biomass_mortality,k1,k2)
  happy <- dplyr::rename(happy, understory_biomass_mortality_rep = Var1, k1_rep = Var2, k2_rep = Var3)

  overstory_percent_mortality <- mapply(tmp_func, happy$understory_biomass_mortality_rep, happy$k1_rep, happy$k2_rep)

  happy <- cbind(happy, overstory_percent_mortality)
  happy$k1_rep <- as.factor(happy$k1_rep)
  happy$k2_rep <- as.factor(happy$k2_rep)

  x <- ggplot(data = happy) +
    geom_line(aes(x=understory_biomass_mortality_rep, y=overstory_percent_mortality, linetype = k1_rep, color = k2_rep), size=1.2) +
    #theme_bw(base_size=16) +
    labs(title = title_name, x = expression(Understory~"&"~Litter~Consumption~(gC/m^2)), y = "Proportion Mortality") +
    scale_linetype(name = "Slope\nParameter\n(k3)") +
    scale_color_brewer(palette = "Dark2", name = "Centerpoint\nParameter\n(k4)")
  plot(x)
  return(x)
}

x <- overstory_figure(k1 = c(-0.005, -0.01, -0.05), k2 = c(500, 1500), title_name = "Overstory Mortality")
ggsave("display_overstory.pdf", plot = x, path = DISPLAY_FIGURES_DIR)






