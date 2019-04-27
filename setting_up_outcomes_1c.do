/****************************************************************************
* File name: setting_up_outcomes_1.do
* Author(s): Sze, J
* Date: 4/12/2018
* Description: Building the Collisions dataset
* 
*
* Inputs: 
* Intersection to Collision data "..\working_data\NYPD_collisions_intersections_shapefile_2263.dta"
* Intersection to school data "..\working_data\intersection_school_shapefile_2263.dta"
* Intersection to LION data "..\working_data\intersection_lionstreet_shapefile_2263.dta"
* LION data "..\working_data\nyc_lionstreet.dta"
* Bike Route to Collision data "..\working_data\NYPD_collisions_nearest_bikeroute_2263.dta"
* Bike Route data "..\working_data\bike_routes_2263.dta"
* Truck Route to Collision data "..\working_data\NYPD_collisions_ALL_truck_routes.dta"
* Truck Route data "..\working_data\All_truck_routes_nyc_lion14A.dta"
* LPIS to intersection data ""..\working_data\intersections_nyc_LPIS_shapefile_2263.dta"
* LPIS data "..\working_data\leading_pedestrian_interval_signals_shapefile_2263.dta"
*
* Outputs:
* 
***************************************************************************/
use "..\working_data\NYPD_Motor_Vehicle_Collisions_clean.dta",clear
drop if mi(uniquekey)

// Merging in Nearest Intersection to Collisions data
/*
mmerge uniquekey using "..\input_data\NYPD_collisions_intersections_shapefile_2263\NYPD_collisions_intersections_shapefile_2263.dta", ///
type(1:1) ///
unmatched(master) ///
ukeep(HubName HubDist) ///
uif(!mi(uniquekey))
*/

mmerge uniquekey using "..\input_data\collision_to_intersection_2263\collision_to_intersection_2263.dta", ///
type(1:1) ///
unmatched(master) ///
ukeep(HubName HubDist) ///
uif(!mi(uniquekey))


drop _merge
rename HubName intersection_id
rename HubDist intersection_to_collision_dist
label variable intersection_id "ID of nearest intersection"
label variable intersection_to_collision_dist "Dist. of nearest intersection to collision"

// Determine if collisions that are close to an intersection
sum intersection_to_collision_dist, detail
sum intersection_to_collision_dist if intersection_to_collision_dist < r(p75), detail
gen intersection = intersection_to_collision_dist < 4
tab intersection
// 65.9% of collisions occur at intersections with NYPD_collisions_intersections_shapefile_2263
// 68.29% of collisions occur at intersections with collision_to_intersection_2263
keep if intersection == 1

gen month = month(date)
gen collision_count = 1 


gen latenight_collision_count = latenight*collision_count
gen latenight_personsinjured = latenight*personsinjured
gen latenight_personskilled = latenight*personskilled
gen latenight_pedestriansinjured = latenight*pedestriansinjured
gen latenight_pedestrianskilled = latenight*pedestrianskilled
gen latenight_cyclistinjured = latenight*cyclistinjured
gen latenight_cyclistkilled = latenight*cyclistkilled
gen latenight_motoristinjured = latenight*motoristinjured
gen latenight_motoristkilled = latenight*motoristkilled

gen day = (latenight == 0)

gen day_collision_count = day*collision_count
gen day_personsinjured = day*personsinjured
gen day_personskilled = day*personskilled
gen day_pedestriansinjured = day*pedestriansinjured
gen day_pedestrianskilled = day*pedestrianskilled
gen day_cyclistinjured = day*cyclistinjured
gen day_cyclistkilled = day*cyclistkilled
gen day_motoristinjured = day*motoristinjured
gen day_motoristkilled = day*motoristkilled


global counts collision_count latenight_collision_count day_collision_count
global all_outcome personsinjured personskilled pedestriansinjured pedestrianskilled cyclistinjured cyclistkilled motoristinjured motoristkilled 
global late_outcome latenight_personsinjured latenight_personskilled latenight_pedestriansinjured latenight_pedestrianskilled latenight_cyclistinjured latenight_cyclistkilled latenight_motoristinjured latenight_motoristkilled
global day_outcome day_personsinjured day_personskilled day_pedestriansinjured day_pedestrianskilled day_cyclistinjured day_cyclistkilled day_motoristinjured day_motoristkilled

collapse ///
(sum) "$counts $all_outcome $late_outcome $day_outcome" ///
 , by(intersection_id month year )

save "..\working_data\collision_monthly.dta",replace


