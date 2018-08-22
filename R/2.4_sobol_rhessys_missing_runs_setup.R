# Patch Missing Sobol Output - Functions
#
# This script isolates sobol calibration runs that are missing and reruns those
# parameters sets. 
#
# It is unclear why output is missing from periodic rhessys runs,
# but approximately 1 in ~500-1000 runs is missing. Sobol_martinez can handle
# missing data, but other Sobol tests cannot.
#

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 1: Isolate missing parameter sets

patch_missing_runs <- function(sobol_par, rhessys_allsim_path, output_path){
  
  # Read in allsim file to detect whether there are any missing data It
  # appears that the same error shows up in each allsim file, so only need to
  # look for missing data in one file.

  var_names <- c("canopy_target_prop_mort", "canopy_target_prop_mort_consumed",
                 "canopy_target_prop_c_consumed", "canopy_target_prop_c_remain")
  allsim_file <- read_tsv(file.path(rhessys_allsim_path, var_names[1]), skip = 2, col_names = FALSE,
                col_types = cols(X1 = col_skip()))
  
  # Identify rows with na
  tmp1 <- allsim_file %>% 
    sapply(function(x) sum(is.na(x)))
  na_rows <- names(tmp1[tmp1>0])
  
  # Establish parameter sets (ps) for missing data
  if (identical(na_rows, character(0))){
    print(paste("Stand", aa, ": Data looks awesome. Time to move on"))
    ps_missing <- FALSE
  } else {
    print(paste("Stand", aa, ": Data missing at:", na_rows))
    ps_all <-  read_csv(sobol_par, col_names = TRUE)
    ps_na_rows <- bind_cols(run = sapply(seq_len(nrow(ps_all)), function (x) paste("X",as.character(x+1),sep="")), ps_all)
    ps_patch <- ps_na_rows %>% 
      dplyr::filter(run%in%na_rows)
    ps_missing <- TRUE
    
    # Write out sobol missing parameter sets
    write.csv(ps_patch, output_path, row.names = FALSE, quote=FALSE)
  }

  return(ps_missing)
}


# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part 2: RHESSys simulations for the missing parameter sets

# No new functions

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Part3: Stick data back together again

# humpty_dumpty name comes from two things. First, recently read a humpty dumpty
# book to kids. Second, this function puts the results back together again.

humpty_dumpty <- function(var_names,
                          rhessys_allsim_path_orig,
                          sobol_par_patched, 
                          rhessys_allsim_path_patched){

  # Loop through rhessys output variables that need patching
  for (aa in seq_along(var_names)){
    
    # Import original rhessys output data
    allsim_file_orig <- read_tsv(file.path(rhessys_allsim_path_orig, var_names[aa]), skip = 0, col_names = FALSE)
    
    # Import patched rhessys output data
    allsim_file_patched <- read_tsv(file.path(rhessys_allsim_path_patched, var_names[aa]), skip = 0, 
                                    col_names = FALSE, col_types = cols(X1 = col_skip()))
    sobol_ps_patched <- read_csv(sobol_par_patched)
    
    # Get run id's that need patching and add to allsim_file_patched
    patched_runs <- sobol_ps_patched$run
    names(allsim_file_patched) <- patched_runs
    
    # Substitue patched runs for NA runs in allsim_file_orig
    allsim_file_new <- allsim_file_orig %>% 
      dplyr::select(-patched_runs) %>%         # Eliminate columns with missing data
      dplyr::bind_cols(allsim_file_patched)     # Add back those colums with patched data
    
    allsim_file_new <- dplyr::select(allsim_file_new, mixedorder(names(allsim_file_new))) # Rearrange columns to original order 
    
    # Export allsim_file_new
    write_tsv(allsim_file_new, file.path(rhessys_allsim_path_patched,paste(var_names[aa],"_patched",sep="")),
              col_names=FALSE, na="")
  }
}

# The following function is used when no patching is needed.
not_humpty_dumpty <- function(var_names,
                              rhessys_allsim_path_orig,
                              rhessys_allsim_path_patched){
  # Loop through variables 
  for (aa in seq_along(var_names)){
    # Import Original data
    allsim_file_orig <- read_tsv(file.path(rhessys_allsim_path_orig, var_names[aa]), skip = 0, col_names = FALSE)
    # Export allsim_file_new
    write_tsv(allsim_file_orig, file.path(rhessys_allsim_path_patched,paste(var_names[aa],"_patched",sep="")),
              col_names=FALSE, na="")
  }
}






