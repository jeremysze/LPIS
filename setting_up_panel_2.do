//log using "..\working_files\setting_up_panel_log", replace

/****************************************************************************
* File name: setting_up_panel_2.do
* Author(s): Sze, Jeremy
* Date: 11/7/2018
* Description: 
* Setting up the observations, merging in the different sources of the data
*
* Inputs: 
*
* 
* Outputs:
* "..\working_data\analytical_file_panel.dta"
***************************************************************************/



clear

// There are 13,277 signal intersections
di 12*7*13277
set obs 1115268


egen intersection_id = seq(), from(1) to(13277)
sort intersection_id

egen month = seq(), from(1) to (12) by(intersection_id)
egen year = seq(), from(2012) to (2018) block(12) 

gen monthly = ym(year, month)
format monthly %tm

//These are outside of the range of our data
drop if month < 7 & year == 2012
drop if month > 9 & year == 2018

// Merge in Intersection data from "Signal intersection.ipynb"

// Intersection level data
mmerge intersection_id using "..\working_data\signal_intersection.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(intersection_ID)

codebook intersection_id
codebook nearest_LPIS
codebook nearest_Street 
codebook nearest_LTC 
codebook nearest_bikeroute 
codebook nearest_truckroute

//Issue with the calculations of nearests for a few intersections
// drop them for the time being
drop if mi(nearest_Street)

// Merge in Lion Street map data - no. of lanes
mmerge nearest_Street using "..\working_data\nyc_lionstreet.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(objectid) ///
ukeep(number_travel_lanes posted_speed number_park_lanes number_total_lanes ///
streetwidth_irr streetwidth_max streetwidth_min trafdir) 

drop _merge

replace trafdir = "1" if trafdir == "W"
replace trafdir = "2" if trafdir == "A"
replace trafdir = "3" if trafdir == "T"
replace trafdir = "4" if trafdir == "P"
destring trafdir, replace
label define trafdir1 1 "With: One-way street, traffic flows with the segment's directionality" ///
2 "Against: One-way street, traffic flows from against the segment's directionality" ///
3 "Two-Way: Traffic flows in both directions" ///
4 "Pedestrian path: Non-vehicular"
label values trafdir trafdir1

// Merging in Nearest Bike Route data
destring nearest_bikeroute, replace
mmerge nearest_bikeroute using "..\working_data\bike_routes_2263.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(objectid_1) ///
ukeep(date_instd date_modda onoffst lanecount)

gen bike_route_install_dt = date(date_instd, "YMD"), after(date_instd)
format bike_route_install_dt %td
gen bike_route_install_mt = mofd(bike_route_install_dt)
format bike_route_install_mt %tm
drop date_instd

gen bike_route_modif_dt = date(date_modda, "YMD"), after(date_modda)
format bike_route_modif_dt %td
gen bike_route_modif_mt = mofd(bike_route_modif_dt)
format bike_route_modif_mt %tm
drop date_modda

// Merging in Left turn calming interventions information
mmerge nearest_LTC using "..\working_data\VZV_Left_Turn_Traffic_Calming_shapefile_2263.dta" , ///
type(n:1) ///
unmatched(master) ///
umatch(id) ///
ukeep( date_compl treatment_)

rename treatment_ left_turn_treatment

gen left_turn_install_dt = date(date_compl, "YMD"), after(date_compl)
format left_turn_install_dt %td
drop date_compl
gen int left_turn_install_month = mofd(left_turn_install_dt), after(left_turn_install_dt)
format left_turn_install_month %tm

// Matching intersection to closest Left turn calming interventions
egen double left_turn_min = min(distance_to_LTC), by(nearest_LTC)
gen flag_left_turn_ever = .
replace flag_left_turn_ever = 1 if left_turn_min == distance_to_LTC
replace flag_left_turn_ever = 0 if mi(flag_left_turn_ever)

gen flag_left_turn = flag_left_turn_ever
replace flag_left_turn = 0 if flag_left_turn == 1 & monthly < left_turn_install_month

// Is not in the data, error in python file
/*
// Merging in Street Improv Project interventions information
mmerge street_improv_id using "..\working_data\VZV_street_improve_proj_shapefile_2263.dta" , ///
type(n:1) ///
unmatched(master) ///
umatch(id) ///
ukeep(sipproj_ty date_date )

rename sipproj_ty street_improv_treatment

gen street_improv_install_dt = date(date_date, "YMD"), after(date_date)
format street_improv_install_dt %td
drop date_date
gen int street_improv_install_month = mofd(street_improv_install_dt), after(street_improv_install_dt)
format street_improv_install_month %tm

// Matching intersection to closest street improvment interventions
egen double street_improv_min = min(intersec_to_street_improv_dist), by(street_improv_id)
gen flag_street_improv_ever = .
replace flag_street_improv_ever = 1 if street_improv_min == intersec_to_street_improv_dist
replace flag_street_improv_ever = 0 if mi(flag_street_improv_ever)

gen flag_street_improv = flag_street_improv_ever
replace flag_street_improv = 0 if flag_street_improv == 1 & monthly < street_improv_install_month
*/


// Merging in LPIS information
mmerge nearest_LPIS using "..\working_data\VZV_LPIS_data.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(LPIS_ID) 

drop _merge
gen LPIS_install_date = date(date_insta, "YMD")
format LPIS_install_date %td
drop date_insta
gen int LPIS_install_month = mofd(LPIS_install_date), after(LPIS_install_date)
format LPIS_install_month %tm
gen LPIS_install_year = year(LPIS_install_date)


// Matching intersection to closest LPIS intersection
egen double LPIS_min = min(distance_to_LPIS), by(nearest_LPIS)
gen flag_LPIS_ever = .
replace flag_LPIS_ever = 1 if LPIS_min == distance_to_LPIS
replace flag_LPIS_ever = 0 if mi(flag_LPIS_ever)

gen flag_LPIS = flag_LPIS_ever

// Problem1: Missing Install date on some LPIS IDs
sum LPIS_install_month, detail format
codebook LPIS_install_month 
tab nearest_LPIS if mi(LPIS_install_month) & flag_LPIS == 1
tab intersection_id if mi(LPIS_install_month) & flag_LPIS == 1
sum distance_to_LPIS if mi(LPIS_install_month)

// Solution1: Drop these intersections
tab flag_LPIS if mi(LPIS_install_month)
drop if mi(LPIS_install_month) & flag_LPIS == 1
//0 observations deleted
replace flag_LPIS = 0 if flag_LPIS == 1 & monthly < LPIS_install_month


// Problem2: Certain LPIS junctions have been installed 
// before the collisions datasets begin
// Removing junctions that cannot be analyzed because LPIS was done before 01jul2012
sum monthly, detail format
sum LPIS_install_month, detail format
// Solution2: Drop these observations 
tab flag_LPIS if LPIS_install_month < tm(2013m1)
tab intersection_id if LPIS_install_month < tm(2013m1) & flag_LPIS_ever == 1
drop if LPIS_install_month < tm(2013m1) & flag_LPIS_ever == 1
* 17,100 observations deleted
duplicates tag intersection_id, gen(dup)
tab dup
drop dup

label variable flag_LPIS "Indicates the intersection at the time they became an LPIS intervention"
label variable flag_LPIS_ever "Indicates the intersection if they ever received LPIS intervention"


// Determine if collision is on bike route
histogram distance_to_bikeroute
graph close
sum distance_to_bikeroute, detail
sum distance_to_bikeroute if distance_to_bikeroute < r(p50) , detail

gen bike_route_ever = distance_to_bikeroute <= 3
tab bike_route_ever

label variable bike_route_ever "Indicates that bike route passes through this intersection (<2 ft)"


// Timevarient bike route indicator
gen bike_route_tv = 0 
replace bike_route_tv = 1 if monthly >= bike_route_install_mt & bike_route_ever == 1

label variable bike_route_tv "Indicates that bike route passes through this intersection timevarient(<3 ft)"

// Determine if collision is on truck route
histogram distance_to_truckroute
graph close
sum distance_to_truckroute, detail
sum distance_to_truckroute if distance_to_truckroute < r(p50) , detail
sum distance_to_truckroute if distance_to_truckroute < r(p90) , detail
gen truck_route = distance_to_truckroute <= 3
tab truck_route

label variable truck_route "Indicates that truck route passes through this intersection (<3 ft)"

// Problem 3: Missing intersection data
// Solution 3: Inpute it as mean
codebook number_travel_lanes
gen mi_number_travel_lanes = mi(number_travel_lanes), after(number_travel_lanes)
sum number_travel_lanes
replace number_travel_lanes = r(mean) if mi_number_travel_lanes == 1

codebook number_park_lanes
gen mi_number_park_lanes = mi(number_park_lanes), after(number_park_lanes)
sum number_park_lanes
replace number_park_lanes = 0 if mi_number_park_lanes == 1


// Determine if intersection is within 2000ft of LPIS intersection
mmerge intersection_id using "..\working_data\intersection_2000ft_LPIS_reshaped.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(intersection_ID)


// Outcomes data
mmerge month year intersection_id using "..\working_data\collision_monthly.dta", ///
type(1:1) ///
unmatched(master) 

// Reason why there are some in the using that were not matched is because
// we dropped some intersections in the steps above

sort intersection_id year month

// Fill in '0' for intersection month year that did not have collisions
replace personsinjured = 0 if _merge == 1
replace personskilled = 0 if _merge == 1
replace pedestriansinjured = 0 if _merge == 1
replace pedestrianskilled = 0 if _merge == 1
replace cyclistinjured = 0 if _merge == 1
replace cyclistkilled = 0 if _merge == 1
replace motoristinjured = 0 if _merge == 1
replace motoristkilled = 0 if _merge == 1
replace collision_count = 0 if mi(collision_count)

replace latenight_personsinjured = 0 if _merge == 1
replace latenight_personskilled = 0 if _merge == 1
replace latenight_pedestriansinjured = 0 if _merge == 1
replace latenight_pedestrianskilled = 0 if _merge == 1
replace latenight_cyclistinjured = 0 if _merge == 1
replace latenight_cyclistkilled = 0 if _merge == 1
replace latenight_motoristinjured = 0 if _merge == 1
replace latenight_motoristkilled = 0 if _merge == 1
replace latenight_collision_count = 0 if mi(latenight_collision_count)

replace day_personsinjured = 0 if _merge == 1
replace day_personskilled = 0 if _merge == 1
replace day_pedestriansinjured = 0 if _merge == 1
replace day_pedestrianskilled = 0 if _merge == 1
replace day_cyclistinjured = 0 if _merge == 1
replace day_cyclistkilled = 0 if _merge == 1
replace day_motoristinjured = 0 if _merge == 1
replace day_motoristkilled = 0 if _merge == 1
replace day_collision_count = 0 if mi(day_collision_count)

gen flag_collision = collision_count > 0
gen latenight_flag_collision = latenight_collision_count > 0
gen day_flag_collision = day_collision_count > 0


label variable personsinjured "No. of persons injured during that month"
label variable personskilled "No. of persons killed during that month"
label variable pedestriansinjured "No. of pedestrians injured during that month"
label variable pedestrianskilled "No. of pedestrians killed during that month"
label variable cyclistinjured "No. of cyclist injured during that month"
label variable cyclistkilled "No. of cyclist killed during that month"
label variable motoristinjured "No. of motorist injured during that month"
label variable motoristkilled "No. of motorist killed during that month"
label variable collision_count "No. of collisions occured during that month"
label variable flag_collision "At least one collision occurred that month"

label variable latenight_personsinjured "No. of persons injured during that month between 11pm - 5am"
label variable latenight_personskilled "No. of persons killed during that month between 11pm - 5am"
label variable latenight_pedestriansinjured "No. of pedestrians injured during that month between 11pm - 5am"
label variable latenight_pedestrianskilled "No. of pedestrians killed during that month between 11pm - 5am"
label variable latenight_cyclistinjured "No. of cyclist injured during that month between 11pm - 5am"
label variable latenight_cyclistkilled "No. of cyclist killed during that month between 11pm - 5am"
label variable latenight_motoristinjured "No. of motorist injured during that month between 11pm - 5am"
label variable latenight_motoristkilled "No. of motorist killed during that month between 11pm - 5am"
label variable latenight_collision_count "No. of collisions occured during that month between 11pm - 5am"
label variable latenight_flag_collision " At least one collision occurred that month between 11pm - 5am"

label variable day_personsinjured "No. of persons injured during that month between 5am - 11pm"
label variable day_personskilled "No. of persons killed during that month between 5am - 11pm"
label variable day_pedestriansinjured "No. of pedestrians injured during that month between 5am - 11pm"
label variable day_pedestrianskilled "No. of pedestrians killed during that month between 5am - 11pm"
label variable day_cyclistinjured "No. of cyclist injured during that month between 5am - 11pm"
label variable day_cyclistkilled "No. of cyclist killed during that month between 5am - 11pm"
label variable day_motoristinjured "No. of motorist injured during that month between 5am - 11pm"
label variable day_motoristkilled "No. of motorist killed during that month between 5am - 11pm"
label variable day_collision_count "No. of collisions occured during that month between 5am - 11pm"
label variable day_flag_collision " At least one collision occurred that month between 5am - 11pm"

drop _merge


split geometry, gen(coordinate)
replace coordinate2 = subinstr(coordinate2,"(","",1)
replace coordinate3 = subinstr(coordinate3,")","",1)
destring coordinate2, replace
destring coordinate3, replace

drop geometry


save "..\working_data\analytical_file_panel.dta",replace


//log close
