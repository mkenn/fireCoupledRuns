($2 == "biomass_loss_rel_k2") {printf("\n%f %s",par,$2)}
($2 != "biomass_loss_rel_k2") {printf("\n%s %s",$1,$2)}
