\ProvidesClass{problemset}[2018-10-19 0.0.1 COSI Problem sets at Brandeis University]
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
\RequirePackage{geometry}
\RequirePackage{changepage} % for adjustwidth env

% formatting
\RequirePackage{hyperref}
\RequirePackage{xcolor}
\RequirePackage{listings}
\RequirePackage{fancyhdr}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{titletoc}

% math
\RequirePackage{amsmath}
\RequirePackage{mathtools}

% tables
\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabu}

% package options
\RequirePackage{kvoptions}
\DeclareStringOption{duedate}[\undefined]
\DeclareStringOption{assignment}[\undefined]
\DeclareStringOption{instructor}[\undefined]
\DeclareStringOption{course}[\undefined]
\DeclareBoolOption{antonella}
\ProcessKeyvalOptions*

\newif\ifpseudocode@loaded
\newif\ifpseudocode@unicode
% pseudocode commands
\let\pseudocodesymbolfont\ttfamily

% fonts
\iffontspec@ok
	\RequirePackage{unicode-math}

	\setmainfont[
		Extension      = .otf,
		UprightFont    = *-regular,
		BoldFont       = *-bold,
		ItalicFont     = *-italic,
		BoldItalicFont = *-bolditalic,
	]{texgyretermes}

	\setmathfont{XITSMath-Regular.otf}
	\setmathfont{XITSMath-Bold.otf}[range={bfup->up,bfit->it}]
\else
	\RequirePackage{tgtermes}
	\RequirePackage{stix}
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

% additional options
\newcommand{\duedate}[1]         {\renewcommand{\problemset@duedate}{#1}}
\newcommand{\instructor}[1]      {\renewcommand{\problemset@instructor}{#1}}
\newcommand{\course}[1]          {\renewcommand{\problemset@course}{#1}}
\newcommand{\coursenumber}[1]    {\renewcommand{\problemset@course}{\Sc{cosi} #1}}
\newcommand{\assignment}[1]      {\renewcommand{\problemset@assignment}{#1}}
\newcommand{\problemsetnumber}[1]{\renewcommand{\problemset@assignment}{Problem Set #1}}
\newcommand{\setcodefont}[2][]{%
	% don't fail if fontspec isn't loaded
	\ifx\setmonofont\undefined\else
		\let\pseudocodesymbolfont\texttt
		\setmonofont[#1]{#2}%
	\fi
}

\define@cmdkeys{problemset}[problemset@]{duedate, instructor, course, assignment}
\define@key{problemset}{number}{\problemsetnumber{#1}}
\define@key{problemset}{coursenumber}{\course{#1}}
\define@key{problemset}{codefont}{%
	\setcodefont{#1}
}
\define@boolkey{problemset}[problemset@]{antonella}[true]{}
\newcommand{\problemsetsetup}[1] {\setkeys{problemset}{#1}}

% listings
\lstset{
	basicstyle=\ttfamily,
	numbers=left,
	numberstyle=\color{gray}\ttfamily,
	aboveskip=1em,
	belowskip=0.5em,
	breaklines,
	tabsize=4,
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
		keywords={Input,Output,Complexity,while,do,return,for,if,then,else,True,False,None},
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

\titleformat{\section}{}{}{0em}{\bfseries\large}[]
\titleformat{\subsection}{}{}{0em}{\llap{\alph{subsection}.\hspace{1em}}}[]
\titlespacing{\section}{0em}{1em}{0em}[0em]
\titlespacing{\subsection}{0em}{1em}{0em}[0em]

\titlecontents{section}
	[3.8em] % ie, 1.5em (chapter) + 2.3em
	{}
	{\hspace*{-3.8em}\contentspage\hspace*{3.8em}}
	{\hspace*{-2.3em}}
	{}

\newlength{\problemindent}
\setlength{\problemindent}{1in}

\newcounter{problemnumber}
\stepcounter{problemnumber} % start at 1
\newcommand{\problem@title}{}
\define@key{problem}{title}{\renewcommand{\problem@title}{: #1}}
\define@boolkey{problem}{pagebreak}[true]{\ifKV@problem@pagebreak
		\vfill\pagebreak
	\else\fi}
\define@cmdkey{problem}{number}{}
\presetkeys{problem}{pagebreak}{}

\NewDocumentEnvironment{problem}{O{}}{%
	\setkeys{problem}{#1}%
	\ifx\cmdKV@problem@number\undefined\stepcounter{problemnumber}%
		\newcommand{\cmdKV@problem@number}{\arabic{problemnumber}}%
	\else\fi
	\section{Problem \cmdKV@problem@number\problem@title}
	\begin{adjustwidth}{\problemindent}{0pt}}
	{\end{adjustwidth}}

\newcommand{\subproblem}[1][]{\subsection{#1}}

\newcommand{\maketitlepage}{\thispagestyle{empty}%
	\vspace*{2in}%
	\begin{center}%
	\Large\begin{tabular}{r|l}
	\ifx\undefined\problemset@assignment\else assignment & \problemset@assignment \\\fi
	by & \@author \\
	\ifx\undefined\problemset@course\else course & \problemset@course \\\fi
	\ifx\undefined\problemset@instructor\else instructor & \problemset@instructor \\\fi
	\ifx\undefined\problemset@due\else due & \problemset@due \\\fi
	\end{tabular}%
	\end{center}%
	\pagebreak}

\endinput
