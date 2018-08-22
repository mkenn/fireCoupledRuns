($2 == "epc.alloc_frootc_leafc") {printf("%f %s\n",par,$2)}
($2 != "epc.alloc_frootc_leafc") {printf("%s %s\n",$1,$2)}
