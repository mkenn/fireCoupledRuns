($2 == "epc.leaf_turnover") {printf("%f %s\n",par,$2)}
($2 != "epc.leaf_turnover") {printf("%s %s\n",$1,$2)}
