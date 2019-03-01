\ProvidesClass{brandeis-problemset}[2019/02/26 0.4.4 COSI problem sets at
	Brandeis University]
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

\RequirePackage{xparse}
\RequirePackage{xkeyval}
\RequirePackage{kvoptions}

\SetupKeyvalOptions{
	family=bps,
	prefix=bps@,
}

% passes an option to rebeccastyle
\newcommand{\bps@passoption}[1]
	{\DeclareVoidOption{#1}{%
		\PassOptionsToPackage{\CurrentOption}{brandeis-problemset}%
	}}

% pass a comma-list of options
\NewDocumentCommand{\bps@passoptions}{>{\SplitList{,}} m}
	{\ProcessList{#1}{\bps@passoption}}

\bps@passoptions{
	scheme,     noscheme,
	pseudocode, nopseudocode,
	assembly,   noassembly,
	gantt,      nogantt,
	solution,   nosolution,
	maketitle,  nomaketitle,
	header,     noheader,
	listings,   nolistings,
}

\NewDocumentCommand{\bps@comploption}{O{false} m}{%
	\DeclareBoolOption[#1]{#2}%
	\DeclareComplementaryOption{no#2}{#2}}

\bps@comploption{antonella}
\bps@comploption{tabu}
\bps@comploption{math}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*

\let\bps@comploption\relax
\let\bps@passoption\relax
\let\bps@passoptions\relax

\LoadClass[12pt]{article}

\RequirePackage[
	maketitle,
	header,
	listings,
]{brandeis-problemset}

% tables
\ifbps@tabu
	\RequirePackage{multirow}
	\RequirePackage{booktabs}
	\RequirePackage{longtable}
	\RequirePackage{tabu}
	\NewExpandableDocumentCommand{\Th}{O{l} m}
		{\multicolumn{1}{#1}{\Bf{#2}}}
\fi

% formatting
\RequirePackage{xcolor}
\RequirePackage{enumitem}
\RequirePackage{titletoc}

% utility
\RequirePackage{hyperref}
\RequirePackage[
	letterpaper,
	margin=1.25in,
	tmargin=1.5in,
	bmargin=1.5in,
]{geometry}

% fonts
% NOTE: The order these packages are loaded in is very important.
% - unicode-math overwrites a bunch of commands, so should be loaded after
%   amsmath and others
% - amsmath should be loaded after stix2 (not sure why, but the stix2
%   documentation specifies this) -- however, if we can use fontspec, we
%   just load the stix2 fonts without the stix2 package itself, so we load
%   amsmath before unicode-math (and the stix2 fonts)
\iffontspec@ok
	\ifbps@math
		\RequirePackage{amsmath}[2013/01/14]
		% unicode-math makes equations copy/pastable in pdf output
		\RequirePackage[
			warnings-off={mathtools-colon,mathtools-overbracket}
		]{unicode-math}
	\else
		\RequirePackage{fontspec}
	\fi
	\setmainfont[
		Extension      = .otf,
		UprightFont    = *-Regular,
		BoldFont       = *-Bold,
		ItalicFont     = *-Italic,
		BoldItalicFont = *-BoldItalic,
	]{STIX2Text}
	\ifbps@math
		\setmathfont[
			Extension = .otf,
			StylisticSet={
				1, % better caligraphic forms
				8, % upright integrals
			},
		]{STIX2Math}
	\fi
	\newcommand{\setcodefont}[2][]{%
		% don't fail if fontspec isn't loaded
		\@ifundefined{setmonofont}{}{%
			\let\pseudocodesymbolfont\texttt
			\setmonofont[#1]{#2}%
		}%
	}
\else
	\ifbps@math
		\RequirePackage[upint]{stix2}
		\RequirePackage{amsmath}[2013/01/14]
	\fi
\fi

% math
\ifbps@math
	\RequirePackage{mathtools}

	% for whatever reason, redefining this before the \begin{document}
	% has no effect
	\AtBeginDocument{\renewcommand{\Re}{\mathbb{R}}}
\fi

\ifbps@antonella
	\instructor{Dr.~Antonella DiLillio}
	\iffontspec@ok
		\setmonofont{Courier New}%
	\else
		\RequirePackage{couriers}% package courier-scaled
	\fi
\fi

% config commands
\define@cmdkeys{bps}[bps@]{duedate, instructor, course, assignment}
% wrappers
\define@key{bps}{author}{\author{#1}}
\define@key{bps}{date}{\date{#1}}

% helpers
\define@key{bps}{number}{\def\bps@assignment{Problem Set #1}}
\define@key{bps}{coursenumber}{\def\bps@course{\textsc{cosi} #1}}
\define@key{bps}{codefont}{\setcodefont{#1}}
\newcommand{\bpsset}[1]{\setkeys{bps}{#1}}
\let\problemsetsetup\bpsset

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

%% {command}[shape]{format}{label}{sep}{before}[after]
%\titleformat{\part}{\bfseries\Large}{Part \thepart}{1em}{}[]
%\titleformat{\section}{\bfseries\large}{}{0em}{}[]
%\titleformat{\subsection}{\llap{\thesubsection.}}{}{1em}{}[]
%% {command}{left}{before}{after}[right]
%\titlespacing{\part}{0em}{-0.25in}{0em}[0em]
%\titlespacing{\section}{0em}{1em}{0em}[0em]
%\titlespacing{\subsection}{0em}{1em}{0em}[0em]

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

\titlecontents{subsection}
	[5.8em]
	{}
	{\hspace*{-4.8em}\contentspage\hspace*{4.8em}\small}
	{\hspace*{-3.3em}}
	{}
	[]
