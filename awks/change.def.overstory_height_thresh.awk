($2 == "overstory_height_thresh") {printf("\n%f %s",par,$2)}
($2 != "overstory_height_thresh") {printf("\n%s %s",$1,$2)}
