
($2 == "epc.height_to_stem_exp") {printf("\n%f %s",par,$2)}
($2 != "epc.height_to_stem_exp") {printf("\n%s %s",$1,$2)}
