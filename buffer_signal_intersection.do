/****************************************************************************
* File name: buffer_signal_intersections.do
* Author(s): Sze, Jeremy
* Date: 11/7/2018
* Description: 
* Setting up control intersections that fall within 2000ft of LPIS intersection
*
* Inputs: 
* 
* "..\working_data\intersection_2000ft_LPIS.dta"
* 
* Outputs:
* "..\working_data\intersection_2000ft_LPIS_reshaped.dta"
***************************************************************************/

// Data is derived from "Intersection within 2000ft buffer of LPIS.ipynb"
use "..\working_data\intersection_2000ft_LPIS.dta",clear

drop index

//Set up so that the data is unique by intersection id
duplicates report
order(intersection_id), before(LPIS_ID)

sort intersection_id LPIS_ID

egen j = rank(LPIS_ID), track by(intersection_id)

reshape wide LPIS_ID, i(intersection_id) j(j)

save "..\working_data\intersection_2000ft_LPIS_reshaped.dta",replace
