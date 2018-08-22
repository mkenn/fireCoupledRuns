($2 == "cover_fraction") {printf("%f %s\n",0.5,$2)}
($2 != "cover_fraction") {printf("%s %s\n",$1,$2)}

