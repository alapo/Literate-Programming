# DESCRIPTION: As part of the workshop you will need to install some packages. 
# This script is meant to be run on your first install. You can delete it after you run it without errors

options(repos = getOption("repos")["CRAN"])
install.packages(c("devtools", "BiocManager", "pacman", "remotes", "ggstatsplot", "rmarkdown", "credentials"), dependencies = TRUE) # rest omitted

# Creating a GitHub Personal Token Key
credentials::set_github_pat()

# if you want a dark theme then run the following code
remotes::install_github("anthonynorth/rscodeio") # install the package
rscodeio::install_theme() # install the theme
 
# remotes installation.
remotes::install_github("easystats/easystats") # installs the whole easystats suite
remotes::install_github("davidgohel/officedown")
devtools::install_github('achetverikov/apastats', subdir='apastats')
devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)
remotes::install_github("dcomtois/pathToClip")
devtools::install_github("nevrome/wellspell.addin") #github.com/nevrome/wellspell.addin
devtools::install_github("nevrome/LanguageToolR")
devtools::install_github("fkeck/quickview")

LanguageToolR::lato_quick_setup()
easystats::easystats_update() # updates easystats packages

if (!require("pacman")) install.packages("pacman") # if pacman is not installed, the install it.
# load/install required packages
pacman::p_load(addinslist, arsenal, cgwtools, colourpicker, easystats, esquisse, ggpubr, ggstatsplot, 
	       ggThemeAssist, googlesheets4, hablar, Hmisc, janitor, jtools, officer, parameters, 
	       rio, Rmisc, rstatix, see, sjmisc, sjPlot, tidyverse) 

rio::install_formats() # will install packages required by rio to function

# pacman::p_unload(all) # detaches all packages. Very useful when you need to update a package OR install a packages which has dependencies that are already loaded in your R Session


# Misc Code -----

# tinytex installation 
  # install.packages('tinytex')
  # tinytex::install_tinytex()
  # tinytex:::is_tinytex() # This will return "TRUE" if it is installed.
  # tinytex::pdflatex('test.tex') # to confirm run this line. If it fails, then there's a problem
