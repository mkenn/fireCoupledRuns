
($2 == "root_depth") {printf("\n%f %s",par,$2)}
($2 != "root_depth") {printf("\n%s %s",$1,$2)}
