/*******************************************************************************
*                                                                              *
* Title - SQLTYPES                                                             *
*                                                                              *
* Description - Program used to map Stata types to SQL data types.  Dates and  *
*               Datetimes are still treated as numeric values to ensure the    *
*               data can be imported back into Stata consistently and without  *
*               any loss of information. Program also returns the DDL for a    *
*               table in a local macro.  This will not work in cases where     *
*               there are many variables and handlers for that case will be    *
*               added at a future date.                                        * 
*                                                                              *
* Dependencies -                                                               *
*     Internal - none                                                          *
*     External - none                                                          *
*                                                                              *
* Parameters -                                                                 *
*     Required -                                                               *
*         varlist - variables to map.                                          *
*     Optional -                                                               *
*         nodestring - option to prevent attempts to remove dataset            *
*                      characteristics related to destring command from varlist*
*                                                                              *
* Output -                                                                     *
*     Returns a local macro in r(tabledef) containing the DDL used to define a *
*     table in an RDBMS.                                                       *
*                                                                              *
* Usage -                                                                      *
*     Typically/recommended usage would follow a call to the -ds- command      *
*     Example:                                                                 *
*               qui: ds                                                        *
*               sqltypes `r(varlist)'                                          *
*                                                                              *
* Lines - 108                                                                  *
*                                                                              *
*******************************************************************************/

// Drop program from memory if it exists
cap prog drop sqltypes

// Sub routine that defines SQL types for variables and stores them in 
// characteristics
prog def sqltypes, rclass

	// Defines the syntax used to call the program
	syntax varlist [, noDEString ]
	
	// Define string scalar used to store the table definition
	sca mktable = ""
	
	// Loops over the variable list
	foreach v of var `varlist' {
	
		// Gets the storage type of the variable
		loc vtype `: type `v''
				
		// For any text of 1-2045 characters a VARCHAR will be defined
		if ustrregexm(`"`vtype'"', "str[0-9]{1,4}") == 1 {
		
			// Pulls the number from the type and inserts it into the SQL type
			char `v'[sqltype] `"`v' VARCHAR(`: subinstr loc vtype "str" "", all')"'
			
		} // End IF Block for string types
		
		// Handles Binary Large OBject types
		if `"`vtype'"' == "strL" char `v'[sqltype] `"`v' BLOB"'
		
		// Maps a Stata byte to a SQL TINYINT (1 byte integer)
		else if `"`vtype'"' == "byte" char `v'[sqltype] `"`v' TINYINT"'

		// Maps a Stata int to a SQL SMALLINT (2 byte integer)
		else if `"`vtype'"' == "int" char `v'[sqltype] `"`v' SMALLINT"'
		
		// Maps a Stata long to a SQL INT (4 byte integer)
		else if `"`vtype'"' == "long" char `v'[sqltype] `"`v' INT"'
		
		// Maps a Stata float
		else if inlist(`"`vtype'"', "float", "double") == 1 {
			
			// Map all floating point values to SQL DOUBLE PRECISION (8 byte floats)
			char `v'[sqltype] `"`v' DOUBLE PRECISION"'
			
		} // End ELSE IF Block for floating point values	

		// Handles destring option
		if `"`destring'"' == "" {

			// Removes characteristics related to destringing variables
			qui: char `v'[destring] 
			
			// Removes characteristics related to the destring command used
			qui: char `v'[destring_cmd] 
			
		} // End IF Block for destring option	
		
		// Adds variable's sqltype definition to the string scalar
		sca mktable = mktable + `"`: char `v'[sqltype]', "'
		
	} // Ends Loop over the variable list
	
	// Removes trailing comma
	sca mktable = substr(mktable, 1, length(mktable) - 1)
	
	// Returns the string scalar
	ret loc tabledef = mktable
	
// End of program	
end	

