\ProvidesClass{iksdagen-handlingar}[2019/07/01 Ett paket för att skapa snygga handlingar för /r/iksdagen]
\LoadClass[a4paper,12pt]{article}

% Option for type: motion, proposition, interpellation, misstroende, triumvirat (spelledare)

\PassOptionsToPackage{export}{adjustbox}

\RequirePackage{standalone}

\RequirePackage[swedish]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage[binary-units=true, per-mode=symbol]{siunitx}
\RequirePackage[parfill]{parskip}
\RequirePackage{csquotes}
\RequirePackage{icomma}
\RequirePackage{booktabs}
\RequirePackage{ifthen}
\RequirePackage{enumerate}
\RequirePackage[hidelinks, pageanchor]{hyperref}
\RequirePackage{newtxtext}
\RequirePackage{newtxmath}
\RequirePackage{fancyhdr}
\RequirePackage{adjustbox}
\RequirePackage{calc}
\RequirePackage{etoolbox}
\RequirePackage[includehead,hmargin={3cm,3cm},vmargin={2cm,2cm},headsep=6.5cm]{geometry}
\RequirePackage{tikzpagenodes}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{microtype}
\RequirePackage{pdfpages}
\RequirePackage{changepage}

% For font restoring later

\makeatletter
\newcommand{\savefont}{\xdef\oldfontsize{\f@size}\xdef\oldblskip{\f@baselineskip}}
\newcommand{\restorefont}{\fontsize{\oldfontsize}{\oldblskip}\selectfont}
\makeatother

% Patch calc

\makeatletter
\begingroup
\toks0=\expandafter{\@settodim{#1}{#2}{#3}}
\edef\x{\endgroup
  \long\def\noexpand\@settodim##1##2##3{\the\toks0 }}\x
\makeatother

% Option handling

\newcommand{\thetype}{Definiera dokumenttypen!}
\newcommand{\theshorttype}{X}
\newcommand{\thetoptitle}{Dokumenttyp!}
\newcommand{\thelogo}{../motion-tex/iksdagen-logo.eps}
\newcommand{\thelogoheight}{1.07cm}
\newcommand{\thelogox}{-1.07cm}
\newcommand{\thelogoy}{-1.07cm}
\newcommand{\thepreamble}{Fixa dokumenttypen!}
\newcommand{\bytext}{av \shortauthorlist}
\newcommand{\extradistance}{1.5cm}
\newcommand{\headerdistance}{1pt}

\newcounter{isinterpellation}
\newcounter{isregeringsbeslut}
\newcounter{DocNumberC}

\DeclareOption{motion}{%
    \renewcommand{\thetype}{Motion}
    \renewcommand{\theshorttype}{M}
    \renewcommand{\thetoptitle}{Motion till iksdagen}
    \renewcommand{\thepreamble}{Iksdagen tillkännager för regeringen vad som anförs i motionen om}
}
\DeclareOption{proposition}{%
    \renewcommand{\thetype}{Proposition}
    \renewcommand{\theshorttype}{P}
    \renewcommand{\thetoptitle}{Regeringens proposition}
    \renewcommand{\thepreamble}{Regeringen föreslår att iksdagen antar regeringens förslag om}
    \renewcommand{\thelogo}{../motion-tex/regeringen-logo.png}
    \renewcommand{\thelogoheight}{2.5cm}
    \renewcommand{\thelogox}{-3cm}
    \renewcommand{\thelogoy}{-1.75cm}
    \renewcommand{\bytext}{}
    \renewcommand{\extradistance}{-1cm}
    \renewcommand{\headerdistance}{-4cm}
}
\DeclareOption{interpellation}{%
    \renewcommand{\thetype}{Interpellation}
    \renewcommand{\theshorttype}{I}
    \renewcommand{\thetoptitle}{Interpellation till statsråd}
    \renewcommand{\bytext}{Till \interpellationrole~\interpellationreceiver~(\interpellationreceiverparty)}
    \stepcounter{isinterpellation}
    \renewcommand{\headerdistance}{-4cm}
}
\DeclareOption{regeringsbeslut}{%
    \renewcommand{\thetype}{Regeringsbeslut}
    \renewcommand{\theshorttype}{RB}
    \renewcommand{\thetoptitle}{Regeringsbeslut}
    \renewcommand{\thepreamble}{}
    \renewcommand{\thelogo}{../motion-tex/regeringen-logo.png}
    \renewcommand{\thelogoheight}{2.5cm}
    \renewcommand{\thelogox}{-3cm}
    \renewcommand{\thelogoy}{-1.75cm}
    \renewcommand{\bytext}{}
    \renewcommand{\extradistance}{-1cm}
    \renewcommand{\headerdistance}{-4cm}
    \stepcounter{isregeringsbeslut}
}
\DeclareOption{misstroende}{%
    \renewcommand{\thetype}{Misstroendeförklaring}
    \renewcommand{\theshorttype}{MTF}
    \renewcommand{\thetoptitle}{Misstroendeförklaring}
}
\DeclareOption{triumvirat}{%
    \renewcommand{\thetype}{Triumviratförslag}
    \renewcommand{\theshorttype}{TF}
    \renewcommand{\thetoptitle}{Triumviratförslag}
}
\DeclareOption{wip}{%
    \renewcommand{\thetoptitle}{WORK IN PROGRESS}
    \setcounter{DocNumberC}{0}
}
\ProcessOptions\relax

% "Counter" for the document number and version

\newcommand{\docnumberis}[1]{\setcounter{DocNumberC}{#1}}

\protected\def\docnum{%
    \ifnum \value{DocNumberC} < 10 00\else%
    \ifnum \value{DocNumberC} < 100 0\fi\fi%
    \arabic{DocNumberC}%
}

\newcounter{VersionC}

\newcommand{\versionis}[1]{\setcounter{VersionC}{#1}}

% Command for the complete document ID

\newcommand{\docID}{%
    \theshorttype%
    \docnum%
}

\newcommand{\docIDwVersion}{%
    \ifnum \value{VersionC} > 1 \docID:V\arabic{VersionC}\else\docID\fi%
}

% Commands for setting title

\newcommand{\doctitle}{Om att sätta titeln på dokumentet}
\newcommand{\docauthor}{Erik Eriksson}

\newcommand{\titleis}[1]{\renewcommand{\doctitle}{#1}}
\newcommand{\continuetitle}[1]{%
    \newcommand{\continuedtitle}{#1}
}
\newcommand{\authoris}[1]{\renewcommand{\docauthor}{#1 }}
\newcommand{\governmentname}{}

% Commands for authors

\newcommand{\authorlist}{}
\newcommand{\shortauthorlist}{}
\newcommand{\internalsiglist}{}
\newcommand{\signaturelist}{%
    \begin{multicols}{2}
        \begin{itemize}
            \internalsiglist
        \end{itemize}
    \end{multicols}
}

\newcounter{numAuthors}

\newcommand{\addauthor}[2]{%
    \stepcounter{numAuthors}%
    \ifthenelse{\value{numAuthors} = 1}{
        \renewcommand{\authorlist}{#1~(#2)}
        \renewcommand{\shortauthorlist}{#1~(#2)}
        \renewcommand{\internalsiglist}{\item[]{\textit{#1~(#2)}}}
    }{
        \appto\authorlist{, #1~(#2)}%
        %
        \ifthenelse{\value{numAuthors} = 2}{%
            \appto\shortauthorlist{~m.fl.}
        }{}
        \appto{\internalsiglist}{\item[]{\textit{#1 (#2)}}}
    }%
}

\newcommand{\addbackingparty}[1]{%
    \stepcounter{numAuthors}%
    \ifthenelse{\value{numAuthors} = 1}{
        \renewcommand{\authorlist}{#1}
        \renewcommand{\shortauthorlist}{#1}
        \renewcommand{\internalsiglist}{\item[]{\textit{#1}}}
    }{
        \preto\authorlist{#1, }%
        %
        \ifthenelse{\value{numAuthors} = 2}{%
            \appto\shortauthorlist{~m.fl.}
        }{}
        \preto{\internalsiglist}{\item[]{\textit{#1}}}
    }%
}

\newcommand{\bygovernment}[1]{%
    \renewcommand{\governmentname}{#1}
    \stepcounter{numAuthors}%
    \ifthenelse{\value{numAuthors} = 1}{
        \renewcommand{\authorlist}{Regeringen #1}
        \renewcommand{\shortauthorlist}{Regeringen #1}
        \renewcommand{\internalsiglist}{\item[]{\textit{Regeringen #1}}}
    }{
        \preto\authorlist{#1, }%
        %
        \ifthenelse{\value{numAuthors} = 2}{%
            \appto\shortauthorlist{~m.fl.}
        }{}
        \preto{\internalsiglist}{\item[]{\textit{Regeringen #1}}}
    }%
}


% Command for the full title

\newcommand{\fulltitle}{\docIDwVersion\;---\;\doctitle}

% Header work

\newcommand{\makeheader}{%
    \thispagestyle{fancy}
    \fancyhf{}

    \newcommand{\headleft}{%
        \savefont% Has standard 12pt TNR
        \fontsize{19.5pt}{22.4pt}\selectfont%
        \thetoptitle
        \\
        \docIDwVersion
        \vspace{1cm}\\        
        \fontsize{16pt}{18.4pt}\selectfont%
        \textbf{\bytext}%
        \vspace{\extradistance}\\
        \fontsize{24pt}{27,6pt}\selectfont%
        \vspace*{0mm}
        \doctitle
        \vspace*{2mm}
        \restorefont%
    }

    \settototalheight{\headheight}{\headleft}
    \addtolength{\headheight}{1pt}

    \begin{tikzpicture}[remember picture,overlay,shift={(current page.north east)}]
    \node[anchor=north east,xshift=\thelogox,yshift=\thelogoy]{\includegraphics[height=\thelogoheight]{\thelogo}};
    \end{tikzpicture}

    \fancyhead[L]{\headleft}
}

% Commands for attsatser

\newcommand{\internalattsatslist}{}
\newcommand{\attsatser}{%
    \begin{enumerate}[noitemsep]
        \internalattsatslist
    \end{enumerate}
}

\newcommand{\att}[1]{
    \appto{\internalattsatslist}{\item{att #1}}
}

\newcommand{\attAndra}[2]{
    \att{#1
        \begin{adjustwidth}{0.05\textwidth}{0.10\textwidth}
            \textit{#2}
        \end{adjustwidth} 
    }
}

% Main content command

\newcommand{\makecontent}{%
    \ifthenelse{\value{isinterpellation} = 1}{
        \makecontentinterpellation
    }{
        \ifthenelse{\value{isregeringsbeslut} = 1}{
            \makecontentregeringsbeslut
        }{
            \makecontentordinary
        }
    }
}

\newcommand{\makecontentordinary}{
    \vspace{\headerdistance}
    \savefont% Has standard 12pt TNR
    \fontsize{19pt}{21.9pt}\selectfont%
    Förslag till iksdagsbeslut
    \restorefont

    \thepreamble
    \attsatser

    \vspace{1cm}

    \savefont% Has standard 12pt TNR
    \fontsize{19pt}{21.9pt}\selectfont%
    Motivering
    \restorefont
}

\newcommand{\makesignatures}{%
    \vspace{1cm}
    \signaturelist
}

\newcommand{\rubrik}[1]{%
    \savefont% Has standard 12pt TNR
    \fontsize{16pt}{18.4pt}\selectfont%
    #1
    \restorefont
}

% For "interpellationer"

\newcommand{\interpellationrole}{ministerpost}
\newcommand{\interpellationreceiver}{Erik Eriksson}
\newcommand{\interpellationreceiverparty}{ABC}

\newcommand{\interpellationto}[3]{%
    \renewcommand{\interpellationrole}{#1}
    \renewcommand{\interpellationreceiver}{#2}
    \renewcommand{\interpellationreceiverparty}{#3}
}

\newcommand{\makecontentinterpellation}{%
    Med anledning av detta vill jag fråga \interpellationrole~\interpellationreceiver:

    \listquestions
}

\newcommand{\listquestions}{%
    \begin{enumerate}
        \internallistquestions
    \end{enumerate}
}

\newcommand{\internallistquestions}{}

\newcommand{\addquestion}[1]{%
    \appto\internallistquestions{\item{#1}}
}

% For "regeringsbeslut
\newcommand{\textofregeringsbeslut}{}
\newcommand{\beslut}[1]{%
    \renewcommand{\textofregeringsbeslut}{#1}
}

\newcommand{\makecontentregeringsbeslut}{%
    \vspace{\headerdistance}    

    \savefont% Has standard 12pt TNR
    \fontsize{19pt}{21.9pt}\selectfont%
    Regeringens beslut
    \restorefont

    \textofregeringsbeslut

    \vspace{1em}

    \savefont% Has standard 12pt TNR
    \fontsize{19pt}{21.9pt}\selectfont%
    Motivering
    \restorefont
}

\endinput