//log using "..\working_files\setting_up_panel_log", replace

/****************************************************************************
* File name: setting_up_panel_quarter_2b.do
* Author(s): Sze, Jeremy
* Date: 11/11/2018
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
cd
// There are 13213 signal intersections
global intersect = 13213+1
global obs = 4*7*($intersect)

display $obs
set obs $obs

egen intersection_id = seq(), from(1) to($intersect)
sort intersection_id

egen quarter = seq(), from(1) to (4) by(intersection_id)
egen year = seq(), from(2012) to (2018) block(4) 

gen quarterly = yq(year,quarter)
format quarterly %tq

//These are outside of the range of our data
drop if quarter <= 2 & year == 2012
drop if quarter >= 4 & year == 2018

// Merge in Intersection data from "Signal intersection.ipynb"

// Intersection level data
mmerge intersection_id using "..\working_data\signal_intersection.dta", ///
type(n:1) ///
unmatched(using) ///
umatch(intersection_id)

codebook intersection_id
codebook nearest_LPIS
codebook nearest_Street 
codebook nearest_LTC 
codebook nearest_bikeroute 
codebook nearest_truckroute


// Create borough dummies
tab bname
gen bronx = (bname == "Bronx")
gen brooklyn = (bname == "Brooklyn")
gen manhattan = (bname == "Manhattan")
gen queens = (bname == "Queens")
gen statenisland = (bname == "Staten Island")

// Lion Street data 
// Variables: Number_Tra Number_Par Number_Tot TrafDir distance_to_Street nearest_Street
rename Number_Tra num_traveling_lanes
rename Number_Par num_parking_lanes
rename Number_Tot num_total_lanes
rename TrafDir trafdir

replace num_traveling_lanes = "" if num_traveling_lanes == "None"
replace num_parking_lanes = "" if num_parking_lanes == "None"
replace num_total_lanes = "" if num_total_lanes == "None"
destring num_traveling_lanes num_parking_lanes num_total_lanes, replace

replace trafdir = "1" if trafdir == "W"
replace trafdir = "2" if trafdir == "A"
replace trafdir = "3" if trafdir == "T"
replace trafdir = "4" if trafdir == "P"
replace trafdir = "" if trafdir == "None"
destring trafdir, replace

label define trafdir1 1 "With: One-way street, traffic flows with the segment's directionality" ///
2 "Against: One-way street, traffic flows from against the segment's directionality" ///
3 "Two-Way: Traffic flows in both directions" ///
4 "Pedestrian path: Non-vehicular"
label values trafdir trafdir1

// Problem 1: Missing intersection data
// Solution 1: Inpute it as mean
codebook num_traveling_lanes
gen mi_number_travel_lanes = mi(num_traveling_lanes), after(num_traveling_lanes)
sum num_traveling_lanes
replace num_traveling_lanes = round(r(mean)) if mi_number_travel_lanes == 1

codebook num_parking_lanes
gen mi_number_park_lanes = mi(num_parking_lanes), after(num_parking_lanes)
sum num_parking_lanes
replace num_parking_lanes = 0 if mi_number_park_lanes == 1

// Nearest Bike Route data
// Variables nearest_bikeroute distance_to_bikeroute
destring nearest_bikeroute,replace
mmerge nearest_bikeroute using "..\working_data\bike_routes_2263.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(objectid_1) ///
ukeep(date_instd tf_facilit)

gen bike_route_install_dt = date(date_instd, "YMD"), after(date_instd)
format bike_route_install_dt %td
gen bike_route_install_mt = mofd(bike_route_install_dt)
format bike_route_install_mt %tm
gen bike_route_install_qt = qofd(bike_route_install_dt)
format bike_route_install_qt %tq
drop date_instd

// Determine if collision is on bike route
sum distance_to_bikeroute, detail
sum distance_to_bikeroute if distance_to_bikeroute < r(p50) , detail

gen bike_route_ever = distance_to_bikeroute <= 3
tab bike_route_ever
label variable bike_route_ever "Indicates that bike route passes through this intersection (<3 ft)"


// Timevarient bike route indicator
gen bike_route_tv = 0 
replace bike_route_tv = 1 if quarterly >= bike_route_install_qt & bike_route_ever == 1

label variable bike_route_tv "Indicates that bike route passes through this intersection timevarient(<3 ft)"



// Truck Route
// Determine if collision is on truck route
sum distance_to_truckroute, detail
sum distance_to_truckroute if distance_to_truckroute < r(p50) , detail
sum distance_to_truckroute if distance_to_truckroute < r(p90) , detail
gen truck_route = distance_to_truckroute <= 3
tab truck_route

label variable truck_route "Indicates that truck route passes through this intersection (<3 ft)"

// Left turn calming interventions information
// Variables treatment_ completion nearest_LTC distance_to_LTC
rename treatment_ left_turn_treatment

gen left_turn_install_dt = date(completion, "YMD"), after(completion)
format left_turn_install_dt %td
gen int left_turn_install_mt = mofd(left_turn_install_dt), after(left_turn_install_dt)
format left_turn_install_mt %tm
gen int left_turn_install_qt = qofd(left_turn_install_dt), after(left_turn_install_dt)
format left_turn_install_qt %tq
drop completion

// Matching intersection to closest Left turn calming interventions
egen double left_turn_min = min(distance_to_LTC), by(nearest_LTC)
gen flag_left_turn_ever = .
replace flag_left_turn_ever = 1 if left_turn_min == distance_to_LTC
replace flag_left_turn_ever = 0 if mi(flag_left_turn_ever)

gen flag_left_turn = flag_left_turn_ever
replace flag_left_turn = 0 if flag_left_turn == 1 & quarterly < left_turn_install_qt


// Street Improv Project interventions information
// Variable DateComplt SIPProjTyp distance_to_StImpro nearest_StImpro
rename SIPProjTyp street_improv_treatment

gen street_improv_install_dt = date(DateComplt, "YMD"), after(DateComplt)
format street_improv_install_dt %td
gen int street_improv_install_mt = mofd(street_improv_install_dt), after(street_improv_install_dt)
format street_improv_install_mt %tm
gen int street_improv_install_qt = qofd(street_improv_install_dt), after(street_improv_install_dt)
format street_improv_install_qt %tq
drop DateComplt

// Matching intersection to closest street improvment interventions
egen double street_improv_min = min(distance_to_StImpro), by(nearest_StImpro)
gen flag_street_improv_ever = .
replace flag_street_improv_ever = 1 if street_improv_min == distance_to_StImpro
replace flag_street_improv_ever = 0 if mi(flag_street_improv_ever)

gen flag_street_improv = flag_street_improv_ever
replace flag_street_improv = 0 if flag_street_improv == 1 & quarterly < street_improv_install_qt



// LPIS information
// Variable distance_to_LPIS nearest_LPIS date_insta
gen LPIS_install_dt = date(date_insta, "YMD")
format LPIS_install_dt %td
gen int LPIS_install_mt = mofd(LPIS_install_dt), after(LPIS_install_dt)
format LPIS_install_mt %tm
gen int LPIS_install_qt = qofd(LPIS_install_dt), after(LPIS_install_mt)
format LPIS_install_qt %tq 
gen LPIS_install_yr = year(LPIS_install_dt), after(LPIS_install_qt)
drop date_insta

// Matching intersection to closest LPIS intersection
egen double LPIS_min = min(distance_to_LPIS), by(nearest_LPIS)
gen flag_LPIS_ever = .
replace flag_LPIS_ever = 1 if LPIS_min == distance_to_LPIS
replace flag_LPIS_ever = 0 if mi(flag_LPIS_ever)

gen flag_LPIS = flag_LPIS_ever

// Problem2: Missing Install date on some LPIS IDs
sum LPIS_install_qt, detail format
codebook LPIS_install_qt 
tab nearest_LPIS if mi(LPIS_install_qt) & flag_LPIS == 1
tab intersection_id if mi(LPIS_install_qt) & flag_LPIS == 1
sum distance_to_LPIS if mi(LPIS_install_qt)

// Solution2: Drop these intersections
tab flag_LPIS if mi(LPIS_install_qt)
drop if mi(LPIS_install_qt) & flag_LPIS == 1
//0 observations deleted

// Replace with indicator with 0 if quarter was before LPIS installation
replace flag_LPIS = 0 if flag_LPIS == 1 & quarterly < LPIS_install_qt
// 47,593 real changes made

// Problem3: Certain LPIS junctions have been installed 
// before the collisions datasets begin
// Removing junctions that cannot be analyzed because LPIS was done before 01jul2012
sum quarterly, detail format
sum LPIS_install_qt, detail format

// Solution3: Drop these observations 
tab flag_LPIS if LPIS_install_qt < tq(2013q1)
tab intersection_id if LPIS_install_qt < tq(2013q1) & flag_LPIS_ever == 1
drop if LPIS_install_qt < tq(2013q1) & flag_LPIS_ever == 1
* 5,650 observations deleted

// Decay effect
bysort intersection_id: gen flag_LPIS_1yr = 1 if quarterly == (LPIS_install_qt+1)
bysort intersection_id: replace flag_LPIS_1yr = 1 if quarterly == (LPIS_install_qt+2)
bysort intersection_id: replace flag_LPIS_1yr = 1 if quarterly == (LPIS_install_qt+3)
bysort intersection_id: replace flag_LPIS_1yr = 1 if quarterly == (LPIS_install_qt+4)
replace flag_LPIS_1yr = 0 if missing(flag_LPIS_1yr)
replace flag_LPIS_1yr = 0 if flag_LPIS_ever == 0

bysort intersection_id: gen flag_LPIS_2yr = 1 if quarterly == (LPIS_install_qt+5)
bysort intersection_id: replace flag_LPIS_2yr = 1 if quarterly == (LPIS_install_qt+6)
bysort intersection_id: replace flag_LPIS_2yr = 1 if quarterly == (LPIS_install_qt+7)
bysort intersection_id: replace flag_LPIS_2yr = 1 if quarterly == (LPIS_install_qt+8)
replace flag_LPIS_2yr = 0 if missing(flag_LPIS_2yr)
replace flag_LPIS_2yr = 0 if flag_LPIS_ever == 0

bysort intersection_id: gen flag_LPIS_3yrup = 1 if quarterly == (LPIS_install_qt+9)
bysort intersection_id: replace flag_LPIS_3yrup = 1 if flag_LPIS_3yrup[_n-1] == 1
replace flag_LPIS_3yrup = 0 if missing(flag_LPIS_3yrup)
replace flag_LPIS_3yrup = 0 if flag_LPIS_ever == 0

bysort intersection_id: gen flag_LPIS_2yrup = 1 if quarterly == (LPIS_install_qt+5)
bysort intersection_id: replace flag_LPIS_2yrup = 1 if flag_LPIS_2yrup[_n-1] == 1
replace flag_LPIS_2yrup = 0 if missing(flag_LPIS_2yrup)
replace flag_LPIS_2yrup = 0 if flag_LPIS_ever == 0

//Continous decay effect
gen flag_LPIS_since = quarterly - LPIS_install_qt  if flag_LPIS_ever == 1
replace flag_LPIS_since = 0 if flag_LPIS_since < 0 & flag_LPIS_ever == 1
replace flag_LPIS_since = 0 if flag_LPIS_ever == 0
gen flag_LPIS_since_sq = flag_LPIS_since*flag_LPIS_since

// Checking that panel is strongly balanced
duplicates tag intersection_id, gen(dup2)
tab dup2
drop dup2

label variable flag_LPIS "Indicates the intersection at the time they became an LPIS intervention"
label variable flag_LPIS_ever "Indicates the intersection if they ever received LPIS intervention"







// Determine if intersection is within 2000ft of LPIS intersection
mmerge intersection_id using "..\working_data\intersection_2000ft_LPIS_reshaped.dta", ///
type(n:1) ///
unmatched(master) ///
umatch(intersection_id)

// Outcomes data
mmerge quarter year intersection_id using "..\working_data\collision_quarterly.dta", ///
type(1:1) ///
unmatched(master) 
// Reason that we did not match every obs from using
// is that we droped intersections in the 
// 1.Intersection level data merge process
// 2. Problem2 Certain LPIS junctions have been installed 
// before the collisions datasets begin


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



save "..\working_data\analytical_file_panel_qt.dta",replace


//log close
