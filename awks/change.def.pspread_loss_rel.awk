($2 == "pspread_loss_rel") {printf("\n%f %s",par,$2)}
($2 != "pspread_loss_rel") {printf("\n%s %s",$1,$2)}
