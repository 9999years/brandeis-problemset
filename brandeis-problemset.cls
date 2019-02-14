\ProvidesClass{brandeis-problemset}[2019/02/14 0.4.4 COSI Problem sets at Brandeis University]
% Description: A document class for Brandeis University's computer science
%              courses' problem sets
% Homepage:    https://github.com/9999years/brandeis-problemset
%              https://ctan.org/pkg/brandeis-problemset
% Maintainer:  Rebecca Turner <rebeccaturner@brandeis.edu>
%
% Copyright 2019 Rebecca Turner
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3c
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Rebecca Turner.

\errorcontextlines 10

\PassOptionsToClass{12pt}{article}
\LoadClass{article}

\RequirePackage{xparse}

\newif\iffontspec@ok
\fontspec@okfalse
\ExplSyntaxOn
\sys_if_engine_luatex:T
{
	\fontspec@oktrue
}
\sys_if_engine_xetex:T
{
	\fontspec@oktrue
}
\ExplSyntaxOff

% pages
\PassOptionsToPackage{
	letterpaper,
	margin=1.25in,
	tmargin=1.5in,
	bmargin=1.5in,
}{geometry}

\PassOptionsToPackage{
	warnings-off={mathtools-colon,mathtools-overbracket}
}{unicode-math}

% utility
\RequirePackage{xkeyval}
\RequirePackage{environ}
\RequirePackage{geometry}
\RequirePackage{changepage} % for adjustwidth env

% formatting
\RequirePackage{hyperref}
\RequirePackage{xcolor}
\RequirePackage{comment}
\RequirePackage{listings}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{titletoc}

% tables
\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabu}

% package options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
	family=problemset,
	prefix=problemset@,
}
\DeclareBoolOption{antonella}
\DeclareBoolOption{scheme}
\DeclareBoolOption{gantt}
\DeclareBoolOption{solutions}
\ProcessKeyvalOptions*

\newif\ifpseudocode@loaded
\newif\ifpseudocode@unicode
% pseudocode commands
\let\pseudocodesymbolfont\ttfamily

% fonts
% NOTE: The order these packages are loaded in is very important.
% - unicode-math overwrites a bunch of commands, so should be loaded after
%   amsmath and others
% - amsmath should be loaded after stix2 (not sure why, but the stix2
%   documentation specifies this) -- however, if we can use fontspec, we
%   just load the stix2 fonts without the stix2 package itself, so we load
%   amsmath before unicode-math (and the stix2 fonts)
\iffontspec@ok
	\RequirePackage{amsmath}[2013/01/14]
	% unicode-math makes equations copy/pastable in pdf output
	\RequirePackage{unicode-math}
	\setmainfont[
		Extension      = .otf,
		UprightFont    = *-Regular,
		BoldFont       = *-Bold,
		ItalicFont     = *-Italic,
		BoldItalicFont = *-BoldItalic,
	]{STIX2Text}
	\setmathfont[
		Extension = .otf,
		StylisticSet={
			1, % better caligraphic forms
			8, % upright integrals
		},
	]{STIX2Math}
\else
	\RequirePackage[upint]{stix2}
	\RequirePackage{amsmath}[2013/01/14]
\fi

% math
\RequirePackage{mathtools}

% for whatever reason, redefining this here has no effect
\AtBeginDocument{\renewcommand{\Re}{\mathbb{R}}}

\ifproblemset@scheme
	% Language definition by Rebecca Turner and Andreas Stuhlmüller.
	\lstdefinelanguage[R5RS]{Scheme}{
		morekeywords={*,/,<=,<,=>,=,>=,>,+,-,%
			% ``These procedures are compositions of car and cdr \dots\
			% Arbitrary compositions, up to four deep, are provided. There are
			% twenty-eight of these procedures in all.'' (6.3.2)
			car,cbr,caar,cabr,cbar,cbbr,caaar,caabr,cabar,cabbr,cbaar,%
			cbabr,cbbar,cbbbr,caaaar,caaabr,caabar,caabbr,cabaar,cababr,%
			cabbar,cabbbr,cbaaar,cbaabr,cbabar,cbabbr,cbbaar,cbbabr,cbbbar,%
			cbbbbr,%
			% Define the rest of the primitives, from R5RS'
			% \href{https://schemers.org/Documents/Standards/R5RS/HTML/r5rs-Z-H-15.html#%_chap_Temp_11}{``Alphabetic
			% Index of Definitions of Concepts, Keywords, and Procedures''}
			abs,acos,and,angle,append,apply,asin,assoc,%
			assq,assv,atan,begin,boolean?,%
			call-with-current-continuation,call-with-input-file,%
			call-with-output-file,call-with-values,case,%
			ceiling,char->integer,char-alphabetic?,char-ci<=?,char-ci<?,%
			char-ci=?,char-ci>=?,char-ci>?,char-downcase,char-lower-case?,%
			char-numeric?,char-ready?,char-upcase,char-upper-case?,%
			char-whitespace?,char<=?,char<?,char=?,char>=?,char>?,char?,%
			close-input-port,close-output-port,complex?,cond,cons,cos,%
			current-input-port,current-output-port,define,define-syntax,delay,%
			denominator,display,do,dynamic-wind,else,eof-object?,eq?,%
			equal?,eqv?,eval,even?,exact->inexact,exact?,exp,expt,floor,%
			for-each,force,gcd,if,imag-part,inexact->exact,inexact?,%
			input-port?,integer->char,integer?,interaction-environment,lambda,%
			lcm,length,let,let*,let-syntax,letrec,letrec-syntax,list,%
			list->string,list->vector,list-ref,list-tail,list?,load,log,%
			magnitude,make-polar,make-rectangular,make-string,make-vector,%
			map,max,member,memq,memv,min,modulo,negative?,newline,not,%
			null-environment,null?,number->string,number?,numerator,odd?,%
			open-input-file,open-output-file,or,output-port?,pair?,peek-char,%
			port?,positive?,procedure?,quasiquote,quote,quotient,rational?,%
			rationalize,read,read-char,real-part,real?,remainder,reverse,%
			round,scheme-report-environment,set!,set-car!,set-cdr!,setcar,%
			sin,sqrt,string,string->list,string->number,string->symbol,%
			string-append,string-ci<=?,string-ci<?,string-ci=?,string-ci>=?,%
			string-ci>?,string-copy,string-fill!,string-length,string-ref,%
			string-set!,string<=?,string<?,string=?,string>=?,string>?,%
			string?,substring,symbol->string,symbol?,syntax-rules,tan,%
			transcript-off,transcript-on,truncate,values,vector,vector->list,%
			vector-fill!,vector-length,vector-ref,vector-set!,vector?,%
			with-input-from-file,with-output-to-file,write,write-char,zero?},
		otherkeywords={\#b,\#o,\#d,\#x,\#e,\#i,\#t,\#f,%
			',`,{,},\,\@,...},
		alsoletter={!\$\%&*/:<=>?@^_~+-},
		alsodigit={.},
		sensitive=true,
		morecomment=[l]{;},
		morecomment=[s]{\#|}{|\#},
		morestring=[b]",
		upquote=true,
		literate=*{`}{{`}}{1}
	}[keywords,comments,strings]
	\lstset{
		defaultdialect=[R5RS]Scheme
	}
	\lstnewenvironment{scheme}[1][]
		{\lstset{language=Scheme, #1}}
		{}
\fi

\newcommand{\@antonella}{%
	\ifproblemset@antonella
		\instructor{Dr.\ Antonella DiLillio}
		\iffontspec@ok
			\setmonofont{Courier New}%
		\else
			\RequirePackage{couriers}% package courier-scaled
		\fi
	\fi
}
\AtBeginDocument{\@antonella}

% lazily loads pseudocode environment
\newcommand{\ensure@pseudocode}{%
	\ifpseudocode@loaded
	\else
		\iffontspec@ok
			% use unicode shortcuts
			\ProvideDocumentCommand{\pseudocodeleftarrow} {}{\pseudocodesymbolfont ←}
			\ProvideDocumentCommand{\pseudocoderightarrow}{}{\pseudocodesymbolfont →}
			\ProvideDocumentCommand{\pseudocodele}        {}{\pseudocodesymbolfont ≤}
			\ProvideDocumentCommand{\pseudocodege}        {}{\pseudocodesymbolfont ≥}
			\ProvideDocumentCommand{\pseudocodeemptyset}  {}{\pseudocodesymbolfont ∅}
			\ProvideDocumentCommand{\pseudocodene}        {}{\pseudocodesymbolfont ≠}
			\ProvideDocumentCommand{\pseudocodeinfty}     {}{\pseudocodesymbolfont ∞}
			\let\lmmath\undefined% ensure no '\lmmath already defined' errors
			\newfontface{\lmmath}{latinmodern-math.otf}%
			\let\pseudocodesymbolfont\lmmath
		\else
			% use math-mode fallbacks
			\ProvideDocumentCommand{\pseudocodeleftarrow} {}{\ensuremath{\leftarrow}}
			\ProvideDocumentCommand{\pseudocoderightarrow}{}{\ensuremath{\rightarrow}}
			\ProvideDocumentCommand{\pseudocodele}        {}{\ensuremath{\le}}
			\ProvideDocumentCommand{\pseudocodege}        {}{\ensuremath{\ge}}
			\ProvideDocumentCommand{\pseudocodeemptyset}  {}{\ensuremath{\emptyset}}
			\ProvideDocumentCommand{\pseudocodene}        {}{\ensuremath{\ne}}
			\ProvideDocumentCommand{\pseudocodeinfty}     {}{\ensuremath{\infty}}
		\fi
		\pseudocode@loadedtrue
	\fi
}

% loads the ganttschedule environment dependencies
\newif\ifgantt@loaded
\newcommand{\ensure@gantt}
	{\ifgantt@loaded
	\else
		\RequirePackage{tikz}
		\RequirePackage{fp}
		\RequirePackage{calc}
		\newcounter{@gantt@time}
		\newcounter{gantt@time@after}
		\newlength{\gantt@unit}
		\gantt@loadedtrue
	\fi}
\newcommand{\@loadgantt}
	{\ifproblemset@gantt
		\ensure@gantt
	\fi}
% if 'gantt' package option was given
\@loadgantt

\newcommand{\problemset@course}{\relax}
\newcommand{\problemset@assignment}{\relax}
% config commands
\newcommand{\duedate}[1]         {\def\problemset@duedate{#1}}
\newcommand{\instructor}[1]      {\def\problemset@instructor{#1}}
\newcommand{\course}[1]          {\def\problemset@course{#1}}
\newcommand{\coursenumber}[1]    {\def\problemset@course{\Sc{cosi} #1}}
\newcommand{\assignment}[1]      {\def\problemset@assignment{#1}}
\newcommand{\problemsetnumber}[1]{\def\problemset@assignment{Problem Set #1}}
\newcommand{\setcodefont}[2][]{%
	% don't fail if fontspec isn't loaded
	\ifx\setmonofont\undefined\else
		\let\pseudocodesymbolfont\texttt
		\setmonofont[#1]{#2}%
	\fi
}

\define@cmdkeys{problemset}[problemset@]{duedate, instructor, course, assignment}
\define@key{problemset}{number}{\problemsetnumber{#1}}
\define@key{problemset}{coursenumber}{\coursenumber{#1}}
\define@key{problemset}{author}{\author{#1}}
\define@key{problemset}{date}{\date{#1}}
\define@key{problemset}{codefont}{%
	\setcodefont{#1}
}
\define@boolkey{problemset}{antonella}[true]{}
\define@boolkey{problemset}{solutions}[true]{}
\define@boolkey{problemset}{gantt}[true]{\@loadgantt}
% carry values from package options over
\newcommand{\@carryclasskey}[1]{%
	\csname ifproblemset@#1\endcsname
		\presetkeys{problemset}{#1}{}
	\fi
}
\@carryclasskey{antonella}
\@carryclasskey{solutions}
\@carryclasskey{gantt}
\newcommand{\problemsetsetup}[1]{\setkeys{problemset}{#1}}

% listings
\lstset{
	basicstyle=\ttfamily,
	numbers=left,
	numberstyle=\color{gray}\ttfamily,
	aboveskip=1em,
	belowskip=0.5em,
	breaklines,
	breakatwhitespace=true,
	tabsize=4,
	keywordstyle={\bf\ttfamily\color[rgb]{0,.3,.7}},
	commentstyle={\color[rgb]{0.133,0.545,0.133}},
	stringstyle={\color[rgb]{0.75,0.49,0.07}},
}

\lstnewenvironment{assembly}[1][]
	{\lstset{
		keywords={LOAD,STORE,ADD,SUB,MUL,DIV,INC,SKIP,BR,BLT,BGT,BLEQ,BGEQ,
		BEQ,BNEQ,READ,WRITE,HALT},
		firstnumber=-3,
		numberstyle={\color{gray}\ttfamily\addtocounter{lstnumber}{3}x +\ },
		morecomment=[l]{;},
		#1
	}}{}

\lstnewenvironment{pseudocode}[1][]
	{\ensure@pseudocode
	\lstset{
		keywords={Input,Output,Complexity,while,do,return,for,to,if,then,else,True,False,None,and,or,nil,len},
		literate={<-}{{\pseudocodeleftarrow}}2
			{->} {{\pseudocoderightarrow}}2
			{(/)}{{\pseudocodeemptyset}}2
			{inf}{{\pseudocodeinfty}}3
			{!=} {{\pseudocodene}}2
			{>=} {{\pseudocodege}}2
			{<=} {{\pseudocodele}}2,
		morecomment=[l]{\#},
		morekeywords={#1},
}}{}

\lstnewenvironment{java}[1][]
	{\lstset{language=java, #1}}
	{}

\errorcontextlines 10
\widowpenalties 1 10000
\raggedbottom
\setlength{\parindent}{0em}
\setlength{\parskip}{0.5em}

\let\Sc\textsc
\let\Rm\textrm
\let\Up\textup
\let\Bf\textbf
\let\It\textit
\let\Tt\texttt
\let\ac\textsc

\renewcommand{\labelitemi}{---}
\setlist[1]{
	leftmargin=0em,
}
\setlist{
	partopsep=0em,
	topsep=0em,
	%bottomsep=1em,
	leftmargin=2em,
}

\NewExpandableDocumentCommand{\Th}{O{l} m}
	{\multicolumn{1}{#1}{\Bf{#2}}}

% page headers
\fancyhf{}
\lhead{\@author
	\hfill
	\if\relax\problemset@assignment\else\problemset@assignment\fi
	\if\relax\problemset@duedate\else\ (due \problemset@duedate)\fi\hfill
	\if\relax\problemset@instructor\else\problemset@instructor\hfill\fi
	\thepage}
\setlength{\headheight}{24pt}
\fancypagestyle{plain}{\fancyhead[L]{}}
\AtBeginDocument{\pagestyle{fancy}}

% {command}[shape]{format}{label}{sep}{before}[after]
\titleformat{\part}{\bfseries\Large}{Part \thepart}{1em}{}[]
\titleformat{\section}{\bfseries\large}{}{0em}{}[]
\titleformat{\subsection}{\llap{\thesubsection.}}{}{1em}{}[]
% {command}{left}{before}{after}[right]
\titlespacing{\part}{0em}{-0.25in}{0em}[0em]
\titlespacing{\section}{0em}{1em}{0em}[0em]
\titlespacing{\subsection}{0em}{1em}{0em}[0em]

\titlecontents{part}
	[3.8em] % left
	{\large\bfseries} % above-code
	% numbered entry format
	{\hspace*{-3.8em}\large\bfseries\contentspage\hspace*{3.8em}}
	% numberless entry format
	{\hspace*{-2.3em}}
	% filler pg format
	{}
	% below code
	[]

\titlecontents{section}
	[4.8em]
	{}
	{\hspace*{-3.8em}\contentspage\hspace*{3.8em}}
	{\hspace*{-2.3em}}
	{}
	[]

\newlength{\problemindent}
\setlength{\problemindent}{1in}

\newcounter{problemnumber}
\newcommand{\problem@title}{}
\define@key{problem}{title}{\renewcommand{\problem@title}{: #1}}
\define@boolkey{problem}{pagebreak}[true]{\ifKV@problem@pagebreak
		\vfill\pagebreak
	\else\fi}
\define@cmdkeys{problem}{number, label, partlabel}
\define@cmdkey{problem}{part}[]{%
		\part{\cmdKV@problem@part}%
		\@ifundefined{cmdKV@problem@partlabel}{}{%
			\expandafter\label{\cmdKV@problem@partlabel}%
		}%
}
\presetkeys{problem}{pagebreak}{}

\NewDocumentEnvironment{problem}{O{}}{%
	\setkeys{problem}{#1}%
	\@ifundefined{cmdKV@problem@number}{%
		\stepcounter{problemnumber}%
		\newcommand{\cmdKV@problem@number}{\arabic{problemnumber}}%
	}{}%
	\section{Problem \cmdKV@problem@number\problem@title}%
	% fix up ref commands
	\edef\@currentlabel{\cmdKV@problem@number}%
	\edef\@currentlabelname{Problem \cmdKV@problem@number\problem@title}%
	\@ifundefined{cmdKV@problem@label}{}{%
		\expandafter\label{\cmdKV@problem@label}%
	}%
	\begin{adjustwidth}{\problemindent}{0pt}}
	{\end{adjustwidth}}

\newcommand{\subproblem}[1][]{\subsection{#1}}

\newcommand{\solutionstyle}{\color{blue}}
\NewEnviron{solution}{%
	\solutionstyle%
	\ifproblemset@solutions\expandafter\BODY\fi}

\newcommand{\maketitlepage}{\thispagestyle{empty}%
	\vspace*{2in}%
	\begin{center}%
	\Large\begin{tabular}{r|l}
	\if\relax\problemset@assignment\else assignment & \problemset@assignment \\\fi
	by & \@author \\
	\if\relax\problemset@course\else course & \problemset@course \\\fi
	\if\relax\problemset@instructor\else instructor & \problemset@instructor \\\fi
	\if\relax\problemset@duedate\else due & \problemset@duedate \\\fi
	\end{tabular}%
	\end{center}%
	\pagebreak}

\renewcommand{\maketitle}{\thispagestyle{empty}%
	%\vspace*{2in}%
	\begin{center}%
	\large\begin{tabular}{r|l}
	\@ifundefined{problemset@assignment}{}{assignment & \problemset@assignment \\}
	by & \@author \\
	\@ifundefined{problemset@course}{}{course & \problemset@course \\}
	\@ifundefined{problemset@instructor}{}{instructor & \problemset@instructor \\}
	\@ifundefined{problemset@duedate}{}{due & \problemset@duedate \\}
	\end{tabular}%
	\end{center}%
	\vspace*{2em}%
	}

\NewDocumentEnvironment{ganttschedule}{m o} % total size, title
	{\ifgantt@loaded
	\else
		\PackageError{brandeis-problemset}{ganttschedule enviornment
		not loaded in preamble}{Did you mean to use the 'gantt'
		option for the brandeis-problemset document class?}
	\fi
	\setlength{\gantt@unit}{\linewidth / \real{#1}}%
	\setcounter{@gantt@time}{0}%
	\DeclareDocumentCommand{\burst}{m m} % pid, burst
		{\setcounter{gantt@time@after}{\value{@gantt@time}}%
		\addtocounter{gantt@time@after}{##2}%
		\FPeval\gantthalf{(\arabic{@gantt@time}
			+ \arabic{gantt@time@after}) / 2}%

		\draw (\value{@gantt@time}, 0) rectangle
			(\value{gantt@time@after}, 1);
		\node at (\gantthalf, 0.5) {$P_{##1}$};
		\draw [|<->|] (\value{@gantt@time} + 0.05, 1.25)
			-- node[above=1mm] {##2}
			(\value{gantt@time@after} - 0.05, 1.25);

		\setcounter{@gantt@time}{\value{gantt@time@after}}}%

	\IfValueT{#2}{\begin{center} #2 \end{center}}%
	\begin{tikzpicture}[x=\gantt@unit]}
	{\end{tikzpicture}}
