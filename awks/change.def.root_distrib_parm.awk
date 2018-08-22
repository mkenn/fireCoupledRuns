
($2 == "epc.root_distrib_parm") {printf("\n%f %s",par,$2)}
($2 != "epc.root_distrib_parm") {printf("\n%s %s",$1,$2)}
