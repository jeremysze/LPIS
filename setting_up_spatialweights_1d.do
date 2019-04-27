/****************************************************************************
* File name: setting_up_spatialweights_1b.do
* Author(s): Sze, Jeremy
* Date: 8/24/2018
* Description: 
* Loading the shapefile, setting up spatial data
*
* Inputs: 
*
* 
* Outputs:
* 
***************************************************************************/

clear

cd "..\working_data\\analytical_panel_shapefile\"
spshape2dta "analytical_panel_shapefile", replace

use "analytical_panel_shapefile"


drop _CY _CX
rename coordina_1 _CY 
rename coordina_2 _CX

drop _ID
gen _ID = intersecti
describe

gen monthly2 = ym(year, month), after(monthly)
format monthly2 %tm
drop monthly
rename monthly2 monthly

xtset intersecti monthly, monthly
spset
spset, coordsys(latlong, miles) modify 

spmatrix create contiguity W if month==7 & year == 2012

cd "..\"
cd "..\working_data"
spmatrix save W using "contiguity_W.stswm"

spmatrix dir
*estat moran, errorlag(W)
