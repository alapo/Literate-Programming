# DESCRIPTION: As part of the workshop you will need to install some packages. 
# This script is meant to be run on your first install. You can delete it after you run it without errors


options(repos = getOption("repos")["CRAN"])

install.packages(c("devtools", "BiocManager", "pacman", "remotes", "ggstatsplot", "rmarkdown"), dependencies = TRUE) # rest omitted

# tinytex installation 
  # install.packages('tinytex')
  # tinytex::install_tinytex()
  # tinytex:::is_tinytex() # This will return "TRUE" if it is installed.
  # tinytex::pdflatex('test.tex') # to confirm run this line. If it fails, then there's a problem
  
# easystats packages
remotes::install_github("easystats/easystats")
remotes::install_github("easystats/report")  # You only need to do that once
remotes::install_github("easystats/correlation")
remotes::install_github("davidgohel/officedown")

devtools::install_github('achetverikov/apastats', subdir='apastats')
devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)
devtools::install_github('rstudio/rmarkdown')

pacman::p_load_current_gh(c("achetverikov/apastats",
							"benmarwick/wordcountaddin"), dependencies = TRUE)

#pacman::p_load_gh(c('christophergandrud/DataCombine'), dependencies = TRUE)

if (!require("pacman")) install.packages("pacman") # if pacman is not installed, the install it.
# load/install required packages
pacman::p_load(arsenal, hablar, tidyverse, report, googlesheets4, janitor, cgwtools,
               rstatix, ggpubr, ggstatsplot, jtools, sjPlot, sjmisc,
               esquisse, Rmisc, parameters, remotes, report, rio) 

rio::install_formats() # Will install rio formats required

# If you want a dark theme

remotes::install_github("anthonynorth/rscodeio") # install the package
rscodeio::install_theme() # install the theme


# pacman::p_load_gh(c('christophergandrud/DataCombine'), dependencies = TRUE) # This will load packages from GitHub
# easystats::easystats_update()
# pacman::p_unload(all) # detaches all packages. Very useful when you need to update a package OR install a packages which has dependencies that are already loaded in your R Session


# Andrew's Misc Installs -----

p_load_gh(c(
  "easystats/report",
  "easystats/easystats",
  "dcomtois/pathToClip",
  "nevrome/wellspell.addin",
  "nevrome/LanguageToolR",
  "fkeck/quickview"
), install = TRUE, 
   update = getOption("pac_update"),
   dependencies = TRUE)

pacman::p_install_gh(c(
  'benmarwick/wordcountaddin', 
  'achetverikov/apastats/apastats'), type = 'source', dependencies = NA)

remotes::install_github("dcomtois/pathToClip")
devtools::install_github("nevrome/wellspell.addin") #github.com/nevrome/wellspell.addin
devtools::install_github("nevrome/LanguageToolR")
devtools::install_github("fkeck/quickview")
devtools::install_github('achetverikov/apastats',subdir='apastats')


LanguageToolR::lato_quick_setup()

# Load/Install required packages ---------------------
if (!require("pacman")) install.packages("pacman") # if pacman is not installed, the install it.
install.packages("ggstatsplot", dependencies = TRUE)
pacman::p_load(addinslist,colourpicker, esquisse, googlesheets4, ggpubr, ggstatsplot, ggThemeAssist, Hmisc, janitor, jtools, officer, officedown, rmarkdown, rio, remotes, rstatix, Rmisc, report, sjPlot, sjmisc, parameters, see, tidyverse) # load/install required packages
rio::install_formats() # will install packages required by rio to function