($2 == "epc.alloc_stemc_leafc") {printf("%f %s\n",par,$2)}
($2 != "epc.alloc_stemc_leafc") {printf("%s %s\n",$1,$2)}
