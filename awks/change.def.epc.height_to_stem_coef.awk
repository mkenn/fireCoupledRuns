
($2 == "epc.height_to_stem_coef") {printf("\n%f %s",par,$2)}
($2 != "epc.height_to_stem_coef") {printf("\n%s %s",$1,$2)}
