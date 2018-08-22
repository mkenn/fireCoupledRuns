# Height of canopy on a given day


height_on_given_day <- function(allsim_path,
                                initial_date,
                                parameter_file,
                                num_canopies,
                                this_one,
                                which_canopy,
                                which_date){
  
  patch_height <- readin_rhessys_output_cal(var_names = c("height"),
                                            path = allsim_path,
                                            initial_date = ymd(initial_date),
                                            parameter_file = parameter_file,
                                            num_canopies = num_canopies)
  
  a <- dplyr::filter(patch_height, run==this_one, canopy_layer==which_canopy, dates==which_date)
  a$value        # This is the height
}


# HJA
height_on_given_day(num_canopies = 2,
                    allsim_path = RHESSYS_ALLSIM_DIR_1.1_HJA,
                    initial_date = "1957-10-01",
                    parameter_file = RHESSYS_PAR_FILE_1.1_HJA,
                    this_one = "X78",   # Printed from 1.2
                    which_canopy = 1,
                    #which_date = '1963-10-01'
                    which_date = '1968-10-01'
)

# P300
height_on_given_day(num_canopies = 2,
                    allsim_path = RHESSYS_ALLSIM_DIR_1.1_P300,
                    initial_date = "1941-10-01",
                    parameter_file = RHESSYS_PAR_FILE_1.1_P300,
                    this_one = "X230",   # Printed from 1.2
                    which_canopy = 1,
                    which_date = '1954-10-01'
)

# RS
height_on_given_day(num_canopies = 1,
                    allsim_path = RHESSYS_ALLSIM_DIR_1.1_RS,
                    initial_date = "1988-10-01",
                    parameter_file = RHESSYS_PAR_FILE_1.1_RS,
                    this_one = "X159",   # Printed from 1.2
                    which_canopy = 1,
                    which_date = '19??-10-01'
)

# SF
height_on_given_day(num_canopies = 2,
                    allsim_path = RHESSYS_ALLSIM_DIR_1.1_SF,
                    initial_date = "1941-10-01",
                    parameter_file = RHESSYS_PAR_FILE_1.1_SF,
                    this_one = "X43",   # Printed from 1.2
                    which_canopy = 1,
                    #which_date = '1947-10-01'
                    #which_date = '1954-10-01'
                    which_date = '1962-10-01'
)





