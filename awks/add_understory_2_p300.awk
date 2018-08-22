BEGIN {h=0;}
{a = 0;}

{
if ($2 == "DELETE") 
	{
	printf("%f %s\n100000 canopy_strata_ID\n",$1,$2); a=1; h=1;
	printf("%f %s\n50 default_ID\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.5 cover_fraction\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 gap_fraction\n",$1,$2); a=1; h=1;
	printf("%f %s\n5.0 root_depth\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 snow_stored\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 rain_stored\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_cpool\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_leafc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_dead_leafc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_leafc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_leafc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_live_stemc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_livestemc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_livestemc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_dead_stemc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_deadstemc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_deadstemc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_live_crootc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_livecrootc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_livecrootc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_dead_crootc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_deadcrootc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_deadcrootc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_frootc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_frootc_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_frootc_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 cs_cwdc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 epv.prev_leafcalloc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_npool\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_leafn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_dead_leafn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_leafn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_leafn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_live_stemn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_livestemn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_livestemn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_dead_stemn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_deadstemn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_deadstemn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_live_crootn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_livecrootn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_livecrootn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_dead_crootn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_deadcrootn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_deadcrootn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_frootn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_frootn_store\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_frootn_transfer\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_cwdn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 ns_retransn\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 epv_wstress_days\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 epv_max_fparabs\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 epv_min_vwc\n",$1,$2); a=1; h=1;
	printf("%f %s\n0.0 n_basestations\n",$1,$2); a=1; h=0;
	}

} 

(a == 0) {printf("%s	%s\n",$1,$2);}
