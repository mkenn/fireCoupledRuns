
($2 == "epc.root_growth_direction") {printf("\n%f %s",par,$2)}
($2 != "epc.root_growth_direction") {printf("\n%s %s",$1,$2)}
