($2 == "understory_height_thresh") {printf("\n%f %s",par,$2)}
($2 != "understory_height_thresh") {printf("\n%s %s",$1,$2)}
