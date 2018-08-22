BEGIN {h=0;}
{a = 0;}

($2 == "num_canopy_strata") {printf("%f	%s\n",2,$2); a=1;}

($2 == "canopy_strata_ID") { h=1; }


{
if ($2 == "n_basestations" && h==1) 
	{
	printf("%f %s\n0 DELETE\n",$1,$2); a=1; h=0;
	}
}


(a == 0) {printf("%s	%s\n",$1,$2);}
