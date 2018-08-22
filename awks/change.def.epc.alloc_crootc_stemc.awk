($2 == "epc.alloc_crootc_stemc") {printf("%f %s\n",par,$2)}
($2 != "epc.alloc_crootc_stemc") {printf("%s %s\n",$1,$2)}
