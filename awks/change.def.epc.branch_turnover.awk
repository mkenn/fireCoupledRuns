($2 == "epc.branch_turnover") {printf("%f %s\n",par,$2)}
($2 != "epc.branch_turnover") {printf("%s %s\n",$1,$2)}
