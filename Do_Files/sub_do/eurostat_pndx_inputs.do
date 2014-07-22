
/*******************************************************
********************************************************
       Cathal O'Donoghue, REDP Teagasc
       &
       Patrick R. Gillespie                            
       Walsh Fellow                    
       Teagasc, REDP                           
       patrick.gillespie@teagasc.ie            
********************************************************

	Import price indices files
	Source: Eurostat

*******************************************************/


/*-----------------------------------------------------
 Temp header - sets necessary paramters to run as 
    standalone file. Remove when incorporating into
    IGM framework (or put inside if statement)     
-----------------------------------------------------*/
* databuild params
global countrylabels 	"ms2"
global 	ms 		"France Germany Ireland UnitedKingdom" 

* dir params
global 	datadir  C:\\Data   	// path to data directory
global 	project  multisward 	// name of the folder this file is in


* Directory check done, you can now define directory 
*   locals for this file (FADNprep.do's locals gone now)
local fadnpaneldir $datadir/data_FADNPanelAnalysis
local fadnoutdatadir `fadnpaneldir'/OutData/$project
local nfspaneldir $datadir/data_NFSPanelAnalysis
local origdatadir `fadnpaneldir'/OrigData 
local fadn9907dir  `fadnpaneldir'/OrigData/eupanel9907
local fadn2dir  `fadnpaneldir'/OrigData/FADN_2/TEAGSC


capture label define ms2 1 "BE" 2 "BG" 3 "CY" 4 "CZ" 5 "DK" 6 "DE" 7 "ES" 8 "EE" 9 "FR" 10 "HU" 11 "IT" 12 "LT" 13 "LU" 14 "LV" 15 "NL" 16 "AT" 17 "PL" 18 "PT" 19 "FI" 20 "RO" 21 "SE" 22 "SK" 23 "SI" 24 "UK" 25 "IE"
*--------------------------------------------------------



local 	eurostat_filelist	: dir "`origdatadir'/Eurostat" files "*data*"
macro	list			 _eurostat_filelist	

*********************************************************
* loop structure - do for all files in directory
*********************************************************
foreach file of local eurostat_filelist	{

	di "Reading `origdatadir'/Eurostat/`file'"

	insheet using `origdatadir'/Eurostat/`file', comma clear double
	
	
	gen 	country     = ""
	replace country = "OST"  if geo == "Austria"
	replace country = "BEL"  if geo == "Belgium"
	replace country = "BGR"  if geo == "Bulgaria"
	replace country = "CYP"  if geo == "Cyprus"
	replace country = "CZE"  if geo == "Czech Republic"
	replace country = "DAN"  if geo == "Denmark"
	replace country = "EST"  if geo == "Estonia"
	replace country = "SUO"  if geo == "Finland"
	replace country = "FRA"  if geo == "France"
	replace country = "DEU"  if word(geo, 1) == "Germany" 
	replace country = "ELL"  if geo == "Greece"
	replace country = "HUN"  if geo == "Hungary"
	replace country = "IRE"  if geo == "Ireland"
	replace country = "ITA"  if geo == "Italy"
	replace country = "LVA"  if geo == "Latvia"
	replace country = "LTU"  if geo == "Lithuania"
	replace country = "LUX"  if geo == "Luxembourg"
	replace country = "MLT"  if geo == "Malta"
	replace country = "NED"  if geo == "Netherlands"
	replace country = "POL"  if geo == "Poland"
	replace country = "POR"  if geo == "Portugal"
	replace country = "ROU"  if geo == "Romania"
	replace country = "SVK"  if geo == "Slovakia"
	replace country = "SVN"  if geo == "Slovenia"
	replace country = "ESP"  if geo == "Spain"
	replace country = "SVE"  if geo == "Sweden"
	replace country = "UKI"  if geo == "United Kingdom"
	*label values country $countrylabels 
	
	
	ds
	local prod_var : word 4 of `r(varlist)'
	
	
	local 	prodvar	: di `prod_var'[1]
	local 	short_prodvar	/*
	*/	: di subinstr("`prodvar'", " ","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", ":","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", "-","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", "(","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", ")","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", "%","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", ";","", .)
	local 	short_prodvar	/*
	*/	: di subinstr("`short_prodvar'", "/","_", .)
	local 	short_prodvar	/*
	*/	: di substr("`short_prodvar'", 1, 30)
	
	
	local 	currency	: di currency[1]
	macro 	list 		_currency
	local 	currency	/*
	*/ 	: di substr("`currency'", 1, strpos("`currency'", " ")-1)
	macro 	list 		_currency
	
	
	local 	varlabel	: di "`prodvar' (`currency')"
	macro 	list 		_varlabel
	
	
	rename 	time 	year
	rename 	value 	P`short_prodvar'
	
	
	keep country year geo P`short_prodvar'
	sort country year
	
	
	local 	thisfilename		/*
	*/	: di substr("`file'", 1, strpos("`file'", ".csv") -1)
	
	local 	tmp_filelist	"`tmp_filelist' `thisfilename'"
	macro list _thisfilename _fadnoutdatadir
	save `fadnoutdatadir'/tmp_`thisfilename', replace

}

*********************************************************
* End of loop structure
*********************************************************


macro	list _tmp_filelist



*local tmp_filelist "apri_ap_crpouta_1_data apri_ap_ina_10_data"
foreach file of local tmp_filelist{
	use `fadnoutdatadir'/tmp_`file', clear
	ds
	local thisvar: word 3 of `r(varlist)'
	local prod_vlist "`prod_vlist' `thisvar'"
}
macro list _prod_vlist


keep year country geo
foreach file of local tmp_filelist{
	merge 1:1 country year using `fadnoutdatadir'/tmp_`file'
	drop _merge
	save `fadnoutdatadir'/eurostat_indices, replace
  
}

/* Gives a varlist of all starting with P and is a string, which
    is ideal, as none of these should be                       */ 
ds P*, has(type 1/40) varwidth(32)
local destring_vlist "`r(varlist)'"


* Change to appropriate data types for string vars (should be numeric)
foreach var of local destring_vlist {

	replace `var' = subinstr(`var', ":", "", .)
	destring `var', replace

}

keep if country =="FRA" | country=="UKI" | country=="IRE" | country=="DEU"
keep if year <= 2007


ds
local misstable_vlist "`r(varlist)'"
foreach var of local misstable_vlist {

	misstable summarize `var'
	scalar define missing_count = `r(N_eq_dot)' + `r(N_gt_dot)'


	if missing_count > 0 & missing_count < . {

		drop `var'

	}
	
	scalar drop missing_count

}


br 
