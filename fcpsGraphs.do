// Creates scheme that can be used for the test data graphs.  
// The lines are print, photocopy, and color blind friendly.  
// Similar criteria were used to find colors with sufficient contrast/accessibility
// to make the graphs easier to interpret view/share with a wider audience.
brewscheme, scheme(fcpstestlevs) linesty(set1) linec(8) barsty(spectral) 	 ///   
barc(9) scatsty(tableau) scatc(3) areasty(pastel1) areac(3) dotsty(tableau)  ///   
dotc(3) cisty(paired) cic(3) cisat(40) symbols(plus triangle circle) 		 ///   
somesty(puor) somec(4)

loc cover keepus(distnm schnm schtype title1 mingrade maxgrade poc)
loc grinfo keepus(distnm schnm)
loc join qui: merge m:1 schid schyr using clean/profile.dta, nogen keep(3)
loc yr 2016
loc getfcps qui: keep if inlist(substr(schid, 1, 3), "165", "999")
loc root /Users/billy/Desktop/kytest		
qui: use clean/acctSummary.dta, clear
`join' `cover'
`getfcps'

merge 1:1 schyr schid level using clean/acctProfile.dta, keep(1 3)			 ///   
keepus(classification reward amomet amogoal)

qui: levelsof schnm, loc(schools)
loc i = 0
foreach v of loc schools {
	loc i `= `i' + 1'
	
	cap confirm new file `"`root'/`v'"'
	if _rc == 0 {
		mkdir `"`root'/`v'"'
		mkdir `"`root'/`v'/graphs/"'
	}	
	else {
		cap confirm new file `"`root'/`v'/graphs/"'
		if _rc == 0 mkdir `"`root'/`v'/graphs/"'
	}
	
	qui: levelsof poc if schnm == `"`v'"', loc(authorname)
	qui: levelsof classification if schnm == `"`v'"' & schyr == `yr', loc(classif)
	qui: levelsof reward if schnm == `"`v'"' & schyr == `yr', loc(rewsch)
	qui: levelsof amomet if schnm == `"`v'"' & schyr == `yr', loc(metamo)
	qui: levelsof amogoal if schnm == `"`v'"' & schyr == `= 1 + `yr'', loc(nxtgoal)
	qui: levelsof title1 if schnm == `"`v'"' & schyr == `yr', loc(ti1)
	qui: levelsof schtype if schnm == `"`v'"' & schyr == `yr', loc(stype)
	
	loc classif `"`: label (classification) `classif''"'
	loc rewsch `"`: label (reward) `rewsch''"'
	loc metamo `"`: label (amomet) `metamo''"'
	loc ti1 `"`: label (title1) `ti1''"'
	loc stype `"`: label (schtype) `stype''"'
	loc stype `"`: subinstr loc stype "&" "\&", all'"'
	
	tempname v`i'
	
		// Create a new LaTeX File
		file open `v`i'' using `"`root'/`v'/reportCard.tex"', w replace

		// Write a LaTeX file Heading
		file write `v`i'' "\documentclass[12pt,oneside,fleqn,final,letterpaper]{report}" _n
		file write `v`i'' "\usepackage{pdflscape}" _n
		file write `v`i'' `"\usepackage{tocloft}"' _n
		file write `v`i'' `"\usepackage{titlesec}"' _n
		file write `v`i'' `"\usepackage{fixltx2e}"' _n
		file write `v`i'' "\usepackage[letterpaper,margin=0.25in]{geometry}" _n
		file write `v`i'' "\usepackage{graphicx}" _n
		file write `v`i'' "\usepackage[hidelinks]{hyperref}" _n
		file write `v`i'' "\usepackage{longtable}" _n
		file write `v`i'' "\usepackage[toc,page,titletoc]{appendix}" _n
		file write `v`i'' "\DeclareGraphicsExtensions{.pdf, .png}" _n
		file write `v`i'' `"\graphicspath{{"`root'/`v'/graphs/"}}"' _n
		file write `v`i'' `"\title{School Report Card Data: \\ \normalsize{`v' \\ `stype' \\ Point of Contact: `authorname' \\ School Classification: `classif' \\ Reward Status: `reward' \\ Title I Status: `ti1'}}"'  _n
		file write `v`i'' `"\author{`authorname'}"' _n
		file write `v`i'' "\let\mypdfximage\pdfximage" _n
		file write `v`i'' "\def\pdfximage{\immediate\mypdfximage}" _n
		file write `v`i'' `"\titleformat{\chapter}[display]"' _n 
		file write `v`i'' `"{\centering\normalfont\normalsize\bfseries}{\chaptertitlename\ \thechapter.}{5pt}{}"' _n 
		file write `v`i'' `"\titleformat{\section}[display]"' _n 
		file write `v`i'' `"{\centering\normalfont\normalsize\bfseries}{}{0pt}{}"' _n 
		file write `v`i'' `"\titleformat{\subsection}[hang]"' _n 
		file write `v`i'' `"{\normalfont\normalsize\bfseries}{}{0pt}{}"' _n 
		file write `v`i'' `"\titleformat{\subsubsection}[runin]"' _n 
		file write `v`i'' `"{\normalfont\normalsize\bfseries}{}{0pt}{}[.\rule{0.5em}{0pt}]"' _n 
		file write `v`i'' `"\titleformat{\paragraph}[runin]"' _n 
		file write `v`i'' `"{\normalfont\normalsize\bfseries\itshape}{}{0pt}{}[.\rule{0.5em}{0pt}]"' _n 
		file write `v`i'' `"\titleformat{\subparagraph}[runin]"' _n 
		file write `v`i'' `"{\normalfont\normalfont\itshape}{}{0pt}{}[.\rule{0.5em}{0pt}]"' _n 
		file write `v`i'' `"\titlespacing{\chapter}{0em}{*0}{*0}"' _n  
		file write `v`i'' `"\titlespacing{\section}{0em}{*0}{*0}"' _n 
		file write `v`i'' `"\titlespacing{\subsection}{0em}{*0}{*0}"' _n 
		file write `v`i'' `"\titlespacing{\subsubsection}{1.5em}{*0}{*0}"' _n  
		file write `v`i'' `"\titlespacing{\paragraph}{1.5em}{*0}{*0}"' _n 
		file write `v`i'' `"\setcounter{tocdepth}{5}"' _n 
		file write `v`i'' `"\setcounter{LTchunksize}{50}"' _n 
		file write `v`i'' "\begin{document}" _n
		file write `v`i'' "\begin{titlepage} \maketitle \end{titlepage}" _n
		file write `v`i'' "\newpage\clearpage \tableofcontents \newpage\clearpage" _n
		file write `v`i'' "\listoffigures \newpage\clearpage" _n 
		file write `v`i'' "\listoftables \newpage\clearpage" _n
				
		file write `v`i'' "\chapter{Accountability} \newpage\clearpage" _n
		file write `v`i'' "\section{Summary} \newpage\clearpage"_n
		
		tw line achievepts gappts growthpts schyr if schnm == `"`v'"', 		 ///   
		by(level, ti(`"`v'"') subti("Achievement, Gap, & Growth Points")) 	 ///   
		scheme(fcpstestlevs) legend(rows(2)) sort
		
		gr export `"`root'/`v'/graphs/achGapGrowth.pdf"', as(pdf) replace
		file write `v`i'' "\begin{figure}[h!]" _n
		file write `v`i'' `"\caption{Achievement, Gap, \& Growth Points \label{fig:agglong}}"' _n
		file write `v`i'' `"\includegraphics[width=\textwidth]{achGapGrowth.pdf}"' _n
		file write `v`i'' "\end{figure} \newpage\clearpage" _n

		tw line ccrpts gradpts ctotalpr coverall schyr if schnm == `"`v'"',	 ///   
		by(level, subti("CCR, Graduation, Program Review, & Overall Points") ///   
		ti(`"`v'"')) scheme(fcpstestlevs) legend(rows(2)) sort

		gr export `"`root'/`v'/graphs/cteGradPROver.pdf"', as(pdf) replace
		file write `v`i'' "\begin{figure}[h!]" _n
		file write `v`i'' `"\caption{CCR, Graduation, Program Review, \& Overall Points \label{fig:cgpolong}}"' _n
		file write `v`i'' `"\includegraphics[width=\textwidth]{cteGradPROver.pdf}"' _n
		file write `v`i'' "\end{figure} \newpage\clearpage" _n
		
}

qui: use clean/acctGrowth.dta, clear
`join' `grinfo'
`getfcps'
loc i = 0
foreach v of loc schools {	
	loc i `= `i' + 1'

	file write `v`i'' "\section{Student Growth}"_n
	
	tw line sgprla sgpmth sgpboth schyr if schnm == `"`v'"', 				 ///   
	by(level, ti(`"`v'"') subti("Student Growth Percentiles"))				 ///   
	scheme(fcpstestlevs) legend(rows(2))  sort

	gr export `"`root'/`v'/graphs/studentGrowthPercentiles.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Student Growth Percentiles \label{fig:sgp}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{studentGrowthPercentiles.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	gr hbar (asis) catrla catmth catboth if schnm == `"`v'"', over(schyr)	 ///   
	bargap(45) by(level, ti(`"`v'"') subti("Categorical Growth"))			 ///   
	scheme(fcpstestlevs) legend(rows(2)) 

	gr export `"`root'/`v'/graphs/categoricalGrowth.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Categorical Growth \label{fig:catgrow}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{categoricalGrowth.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

}

qui: use clean/acctAchievementGrade.dta, clear
`join' `grinfo'
`getfcps'
loc i = 0
foreach v of loc schools {
	loc i `= `i' + 1'

	file write `v`i'' "\section{Grade-Level Achievement}"_n
	
	qui: levelsof content if schnm == `"`v'"', loc(areas)
	
	foreach c of loc areas {

		file write `v`i'' "\subsection{`: label (content) `c''}" _n 
	
		qui: levelsof grade if schnm == `"`v'"' & content == `c', loc(grs)
		
		foreach g of loc grs {
	
			tw line novice apprentice proficient distinguished schyr if		 ///   
			schnm == `"`v'"' & content == `c' & grade == `g', by(amogroup,	 ///   
			ti(, size(vsmall))) scheme(fcpstestlevs) sort legend(rows(2)) 

			gr export `"`root'/`v'/graphs/achievementGrade`g'Content`c'.pdf"', as(pdf) replace
			file write `v`i'' "\begin{figure}[h!]" _n
			file write `v`i'' `"\caption{Grade `g' Achievement in `: label (content) `c'' by Student Subgroup \label{fig:ag`g'c`c'}}"' _n
			file write `v`i'' `"\includegraphics[width=\textwidth]{achievementGrade`g'Content`c'.pdf}"' _n
			file write `v`i'' "\end{figure} \newpage\clearpage" _n

		}
		
	}
	
}	

qui: use clean/acctAchievementLevel.dta, clear
`join' `grinfo'
`getfcps'
loc i = 0
foreach v of loc schools {
	loc i `= `i' + 1'

	file write `v`i'' "\section{Educational-Level Achievement}"_n
	
	qui: levelsof content if schnm == `"`v'"', loc(areas)
	
	foreach c of loc areas {

		file write `v`i'' "\subsection{`: label (content) `c''}" _n 
	
		qui: levelsof level if schnm == `"`v'"' & content == `c', loc(levs)
		
		foreach l of loc levs {
	
			tw line novice apprentice proficient distinguished schyr if		 ///   
			schnm == `"`v'"' & content == `c' & level == `l', by(amogroup,	 ///   
			ti(`"`v'"', size(vsmall))										 ///   
			subti(`"`c' Achievement by Educational Level"'))				 ///   
			scheme(fcpstestlevs) sort legend(rows(2)) 

			gr export `"`root'/`v'/graphs/achievementLevel`l'Content`c'.pdf"', as(pdf) replace
			file write `v`i'' "\begin{figure}[h!]" _n
			file write `v`i'' `"\caption{`: label (level) `l'' Achievement in `: label (content) `c'' by Student Subgroup \label{fig:al`l'c`c'}}"' _n
			file write `v`i'' `"\includegraphics[width=\textwidth]{achievementLevel`l'Content`c'.pdf}"' _n
			file write `v`i'' "\end{figure} \newpage\clearpage" _n

		}
		
	}
	
}	

qui: use clean/acctAttendance.dta, clear
`join' `grinfo'
`getfcps'
loc i = 0
foreach v of loc schools {
	loc i `= `i' + 1'

	file write `v`i'' "\section{Attendance}" _n
	
	tw line adarate schyr if schnm == `"`v'"',  scheme(fcpstestlevs) sort 	 ///   
	legend(rows(2)) ti(`"`v'"') subti("Average Daily Attendance Rate")
	
	gr export `"`root'/`v'/graphs/averageDailyAttendance.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Other Academic Indicator - Average Daily Attendance Rates \label{fig:ada}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{averageDailyAttendance.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n
	
}



qui: use clean/programReview.dta, clear
`join' `grinfo'
`getfcps'
loc i = 0
foreach v of loc schools {
	loc i `= `i' + 1'

	file write `v`i'' "\section{Program Review}" _n
	
	file write `v`i'' "\subsection{Component Scores}" _n
	
	tw line ahcia ahassess ahprofdev ahadmin schyr if schnm == `"`v'"', ///   
	by(level, ti(`"`v'"') subti("Arts & Humanities")) ///   
	scheme(fcpstestlevs) sort legend(rows(4)) xlab(#3) ylab(0(1)5)

	gr export `"`root'/`v'/graphs/programReviewAH.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Arts \& Humanities \label{fig:prah}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewAH.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	tw line k3cia k3assess k3profdev k3admin schyr if schnm == `"`v'"', ///   
	by(level, ti(`"`v'"') subti("Kindergarten - 3rd Grade")) ///   
	scheme(fcpstestlevs) sort legend(rows(4)) xlab(#3) ylab(0(1)5)

	gr export `"`root'/`v'/graphs/programReviewK3.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Kindergarten --- 3\textsuperscript{rd} Grade \label{fig:prk3}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewK3.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	tw line plcia plassess plprofdev pladmin schyr if schnm == `"`v'"', ///   
	by(level, ti(`"`v'"') subti("Practical Living & Career Studies")) ///   
	scheme(fcpstestlevs) sort legend(rows(4)) xlab(#3) ylab(0(1)5)

	gr export `"`root'/`v'/graphs/programReviewPL.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Practical Living \& Career Studies \label{fig:prpl}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewPL.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	tw line wlcia wlassess wlprofdev wladmin schyr if schnm == `"`v'"', ///   
	by(level, ti(`"`v'"') subti("World Language")) ///   
	scheme(fcpstestlevs) sort legend(rows(4)) xlab(#3) ylab(0(1)5)

	gr export `"`root'/`v'/graphs/programReviewWL.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{World Language \label{fig:prwl}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewWL.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	tw line wrcia wrassess wrprofdev wradmin schyr if schnm == `"`v'"', ///   
	by(level, ti(`"`v'"') subti("Writing")) ///   
	scheme(fcpstestlevs) sort legend(rows(4)) xlab(#3) ylab(0(1)5)

	gr export `"`root'/`v'/graphs/programReviewWR.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Writing \label{fig:prwr}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewWR.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	file write `v`i'' "\subsection{Component and Overall Summaries}" _n

	gr bar (asis) ahlev k3lev pllev wllev wrlev if schnm == `"`v'"', ///   
	over(level) bargap(45) by(schyr, ti(`"`v'"') ///   
	subti("Program Review Levels")) scheme(fcpstestlevs) legend(rows(4)) ///   
	ylab(0 `"`: label (ahlev) 0'"' 1 `"`: label (ahlev) 1'"' ///   
	2 `"`: label (ahlev) 2'"')

	gr export `"`root'/`v'/graphs/programReviewLevTot.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Program Review Levels \label{fig:prah}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewLevTot.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n
	
	tw line ahtotpts k3totpts pltotpts wltotpts wrtotpts schyr if ///   
	schnm == `"`v'"', by(level, ti(`"`v'"') ///   
	subti("Program Review Component Points")) scheme(fcpstestlevs) ///   
	legend(rows(4)) sort ylab(0(3)15) xlab(#3)

	gr export `"`root'/`v'/graphs/programReviewCompTotal.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Component Total Scores \label{fig:prcomptot}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewCompTotal.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	tw line totpts schyr if schnm == `"`v'"', by(level, ti(`"`v'"') ///   
	subti("Program Review Total Points")) scheme(fcpstestlevs) sort ///   
	xlab(#3) ylab(0(5)50)

	gr export `"`root'/`v'/graphs/programReviewTotal.pdf"', as(pdf) replace
	file write `v`i'' "\begin{figure}[h!]" _n
	file write `v`i'' `"\caption{Program Review Total Points \label{fig:prtotpts}}"' _n
	file write `v`i'' `"\includegraphics[width=\textwidth]{programReviewTotal.pdf}"' _n
	file write `v`i'' "\end{figure} \newpage\clearpage" _n

	file write `v`i'' "\end{document}"
	file close `v`i''
	
}

foreach v of loc schools {
	! pdflatex `"`root'/`v'/reportCard.tex"'
	! pdflatex `"`root'/`v'/reportCard.tex"'
	! pdflatex `"`root'/`v'/reportCard.tex"'
}
		


