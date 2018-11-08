//log using "..\working_files\analytical_file_panel_log", replace
/****************************************************************************
* File name: analysis_panel_3.do
* Author(s): Sze, Jeremy
* Date: 10/11/2018
* Description: 
* 
*
* Inputs: 
* "..\working_data\analytical_file_panel.dta"
* 
* Outputs:
* 
***************************************************************************/


use "..\working_data\analytical_file_panel.dta",clear

// Definitions
* flag_LPIS captures the intersection at the time they became an LPIS intervention
* flag_LPIS_ever captures the intersection if they EVER received LPIS intervention

// Variables of interest
// global location_var 		bronx brooklyn manhattan queens
global distance_var 		distance_to_Sch
global road_var 			number_travel_lanes number_park_lanes truck_route
global time_variant_var 	bike_route_tv /*flag_street_improv*/ flag_left_turn
global outcome_var 			collision_count flag_collision personsinjured pedestriansinjured

// Descriptive statistics
/*
preserve
global location_var 		bronx brooklyn manhattan queens statenisland
keep intersection_id flag_LPIS_ever $location_var $distance_var $road_var
duplicates drop
gen treated = 1
global treated "flag_LPIS_ever"		// Treatment variable
global weight_used "treated"	// Weights
global varlist "$location_var $distance_var $road_var"		// Variables list
global filename "table1"		// Name of file
cd "..\working_files\"
run "Z:\GEDI-WISE-INVESTIGATORS\Gediwise Do Files\tools\Table_1_descriptives.do"
di "Saved"
restore
*/

/*
preserve 
global location_var 		bronx brooklyn manhattan queens
keep intersection_id flag_LPIS_ever $distance_var $road_var $location_var
duplicates drop

// Entropy Balance
ebalance flag_LPIS_ever $distance_var $road_var $location_var

// Standardize Difference calculation
global treated 		"flag_LPIS_ever"
global weight_used 	"_webal"
global varlist 		$distance_var $road_var $location_var
global printname 	"Dist._from_intersection_to_school Dist._from_intersection_to_hospial  No._of_travel_lanes No._of_parking_lanes Truck_route Bronx Brooklyn Manhattan Queens"			
global graphtitle 	"Entropy Balance"	// Title of graph
global ytitle 		""	// Axis title
global site 		"Ebalance"	// Name of site
cd "..\manuscripts" 	//Location to save graph
do "Z:\GEDI-WISE-INVESTIGATORS\Gediwise Do Files\tools\std_diff_graph.do"

// Inverse Probability of treatment weighting
logit flag_LPIS_ever $distance_var $road_var $location_var
predict pi, p

gen ipw = 1
*replace ipw = 1/pi if flag_LPIS_ever==1
replace ipw = pi/(1-pi) if flag_LPIS_ever==0

sum ipw, detail

// Standardize Difference calculation
global treated 		"flag_LPIS_ever"
global weight_used 	"ipw"
global varlist 		$distance_var $road_var $location_var
global printname 	"Dist._from_intersection_to_school Dist._from_intersection_to_hospial No._of_travel_lanes No._of_parking_lanes Truck_route Bronx Brooklyn Manhattan Queens"			
global graphtitle 	"Inverse Probability of treatment weighting"	// Title of graph
global ytitle 		""	// Axis title
global site 		"IPTW"	// Name of site
cd "..\manuscripts" 	//Location to save graph
do "Z:\GEDI-WISE-INVESTIGATORS\Gediwise Do Files\tools\std_diff_graph.do"


save "..\working_data\LPIS_intersections_wgts", replace
restore

do "..\dofiles\Graphs combine.do"
*/

// Spatial Matrix
*spmatrix use W using "..\working_data\contiguity_W.stswm"


/*
// Merging in the weights from previous calculation
mmerge intersection_id using "..\working_data\LPIS_intersections_wgts", ///
type(n:1) ///
unmatched(master)
drop _merge
*/

egen time = group(monthly)
order(time), after(monthly)
xtset intersection_id time, monthly


// Variables of interest
// global location_var 		bronx brooklyn manhattan queens
global distance_var 		distance_to_Sch
global road_var 			number_travel_lanes number_park_lanes truck_route
global time_variant_var 	bike_route_tv /*flag_street_improv*/ flag_left_turn
global outcome_var 			collision_count flag_collision personsinjured pedestriansinjured

global count_outcome_var 	collision_count personsinjured pedestriansinjured cyclistinjured motoristinjured
global logit_outcome_var 	flag_collision  
global time_var 			i.monthly



cd "..\manuscripts"


egen max_collision_count = max(collision_count), by(intersection_id)
codebook intersection_id if max_collision_count == 0
codebook intersection_id if max_collision_count > 0

log close



**************************************
global outcome1 collision_count
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1


xtpoisson $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word replace ctitle(xtpoisson robust_se $outcome1) 
xtreg $outcome1 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome1) 

xtpoisson $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome2) 
xtreg $outcome2 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome2) 

xtpoisson $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome3)				
xtreg $outcome3 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome3) 
 
capture erase $filename.txt
**************************************
**************************************
global outcome1 personsinjured
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1

xtpoisson $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word replace ctitle(xtpoisson robust_se $outcome1) 
xtreg $outcome1 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome1) 

xtpoisson $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome2) 
xtreg $outcome2 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome2) 

xtpoisson $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome3)				
xtreg $outcome3 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome3) 
 
capture erase $filename.txt

**************************************
global outcome1 pedestriansinjured
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1

xtpoisson $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word replace ctitle(xtpoisson robust_se $outcome1) 
xtreg $outcome1 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome1) 

xtpoisson $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome2) 
xtreg $outcome2 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome2) 

xtpoisson $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome3)				
xtreg $outcome3 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome3) 
 
capture erase $filename.txt

**************************************
global outcome1 cyclistinjured
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1

xtpoisson $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word replace ctitle(xtpoisson robust_se $outcome1) 
xtreg $outcome1 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome1) 

xtpoisson $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome2) 
xtreg $outcome2 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome2) 

xtpoisson $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(xtpoisson robust_se $outcome3)				
xtreg $outcome3 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome3) 


capture erase $filename.txt
**************************************
global outcome1 motoristinjured
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1

xtpoisson $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word replace ctitle(xtpoisson robust_se $outcome1) 
xtreg $outcome1 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(xtreg cluster intersection_id $outcome1) 

xtpoisson $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(cluster robust_se $outcome2) 
xtreg $outcome2 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(cluster intersection_id $outcome2) 

xtpoisson $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe vce(robust)
		*outreg2 using "$filename", word append ctitle(cluster robust_se $outcome3)				
xtreg $outcome3 i.flag_LPIS  $time_variant_var $time_var if e(sample)==1, fe vce(cluster intersection_id)
		*outreg2 using "$filename", word append ctitle(cluster intersection_id $outcome3) 
 
capture erase $filename.txt

**************************************
global outcome1 flag_collision
global outcome2 latenight_$outcome1
global outcome3 day_$outcome1
global filename results_xt_$outcome1

xtlogit $outcome1 i.flag_LPIS  $time_variant_var $time_var, fe
		*outreg2 using "$filename", word replace ctitle(xtlogit fe $outcome1) 
margins, dydx(flag_LPIS) post
		*outreg2 using "$filename", word append ctitle(margins $outcome1) 

xtlogit $outcome2 i.flag_LPIS  $time_variant_var $time_var, fe 
		*outreg2 using "$filename", word append ctitle(xtlogit fe $outcome2) 
margins, dydx(flag_LPIS) post
		*outreg2 using "$filename", word append ctitle(margins $outcome2) 

xtlogit $outcome3 i.flag_LPIS  $time_variant_var $time_var, fe 
		*outreg2 using "$filename", word append ctitle(xtlogit fe $outcome3)				
margins, dydx(flag_LPIS) post
 		*outreg2 using "$filename", word append ctitle(margins $outcome3) 

capture erase $filename.txt 


