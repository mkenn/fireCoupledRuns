
($2 == "gap_fraction") {printf("\n%f %s",par,$2)}
($2 != "gap_fraction") {printf("\n%s %s",$1,$2)}
