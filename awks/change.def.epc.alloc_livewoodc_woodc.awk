($2 == "epc.alloc_livewoodc_woodc") {printf("%f %s\n",par,$2)}
($2 != "epc.alloc_livewoodc_woodc") {printf("%s %s\n",$1,$2)}
