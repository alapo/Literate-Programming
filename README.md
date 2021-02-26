# Literate-Programming

# thesisUC
A short guide on writing your thesis with RMarkdown

*This is a work in progress*

This guide has the goal of introducing you to a new way of writing your thesis using RMarkdown. This repo stems from my frustration using Microsoft Word. In short RMarkdown with the help of a few tools will allow you to re-run your stats with the proper formatting in a very quick way. 


[This is a site](http://r-bio.github.io/intro-git-rstudio/) I saw which has a quick intro on why you should consider using version control. The image below from PhDComics should sum it up pretty quick for you.

![alt text](https://i.imgur.com/dxFzd7X.gif)

# Additional Links to Checkout

![Bookdown Thesis](https://eddjberry.netlify.com/post/writing-your-thesis-with-bookdown/)
![BookdownPlus](https://bookdown.org/baydap/bookdownplus/academic.html)
![Text Mining your Literature Review](https://bookdown.org/fgabriel1891/literature_review/text-mining-of-multispecies-interactions-in-published-literature.html)

# To Do

- [x] Add the citation style language into a folder in the repository.
- [ ] Add how to navigate using the Document Outline (`Ctrl+Shift+O`)
- [ ] Add `stats.R` and other documents so the person can run the document right off the bat. Test this using Ibukun's computer to make sure it works.
- [ ] Talk about picking between bookdown or the method I used in my thesis (which won't have proper labelling of the docx figures and tables).
- [ ] Fix the current UCalgary .cls files. They are fairly crap for inclusion in RMarkdown. Look into the University of Michigan version and adapt from there.
- [ ] Confirm that the template being used is accurate
- [ ] Create a docx template that we can use to export to `docx`.
- [ ] Find a way to automatically edit `D:\Users\~\Documents\.R\rstudio\keybindings\addins.json` to 
    {
    "citr::insert_citation" : "Alt+M"
    }
- [ ] Find a way to automatically edit `D:\Users\~\Documents\.R\rstudio\keybindings\rstudio_bindings.json` to 
    {
    "clearWorkspace" : "Ctrl+Alt+L",
    "layoutEndZoom" : "Ctrl+0"
    }
- [ ] Add video I sent to colleague on using the Spell Checker within Rmd documents.

# Installing Required Programs

Before we start there are a few things we need to make this go well.

1. Install [Java 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html)
   - Java 12 will not work.
2. Install [R](https://www.r-project.org/)
3. Install [RStudio](https://www.rstudio.com/products/rstudio/download/)
4. Install [RTools](https://cran.r-project.org/bin/windows/Rtools/)
5. Install [tinytex](https://yihui.org/tinytex/)
6. Install [MikTex](https://miktex.org/download) (if you are using Windows) or [MacTex](https://medium.com/@sorenlind/create-pdf-reports-using-r-r-markdown-latex-and-knitr-on-macos-high-sierra-e7b5705c9fd) (if you are using a Mac)

# Running R for the first time. 

In the Console run

     options(repos = getOption("repos")["CRAN"])
     
Create your own [GitHub token](https://happygitwithr.com/github-pat.html) and add it to *.Renviron 

Some packages I would recommend are shown below. These can be a bit of a pain to install the first time. 

    install.packages("devtools")
    install.packages("BiocManager")
    if (!require("pacman")) install.packages("pacman") # will install pacman which I use to load and install libraries.
    
    devtools::install_github('achetverikov/apastats',subdir='apastats')
    devtools::install_github("benmarwick/wordcountaddin", type = "source", dependencies = TRUE)
    pacman::p_load_current_gh(c("achetverikov/apastats","benmarwick/wordcountaddin"), dependencies = TRUE)
    pacman::p_load_gh(c('christophergandrud/DataCombine'), dependencies = TRUE)
    devtools::install_github("easystats/correlation")
    devtools::install_github("easystats/easystats")

# Using References
For using references we have 3 packages we need to install
1. Install [Zotero](https://www.zotero.org/download/) 
2. Install [Better BibTex Plugin](https://retorque.re/zotero-better-bibtex/installation/)
3. The citr package (optional) and make a keyboard shortcut for it (I like `Alt+M`)
4. The .cls file for University of Calgary thesis (of which there are two to choose from) and place it in the "styles" folder
   - [1st option](https://www.overleaf.com/latex/templates/university-of-calgary-thesis-template/zgjghsjjhmnj)
   - [2nd option](https://www.overleaf.com/latex/templates/university-of-calgary-thesis-template/jddnhskkgpms)

# Setting up your folder/work environment
There are many ways to go about this but here is a general setup which you can modify to your needs.
In my project files I have (at the very least) the following folders
- raw
   - *contains the original data which I never touch. If I ever need to go back to it I will make a copy and store it in "data".*
- data
    - tables
- images
   - *The "images" folder should be self explanatory. For beginners you can run your MATLAB scripts and save the images in this directory but be aware that RStudio can also produce graphs.*
- styles
   - *Contains files that will "style" the document.* 

We will be referencing both the `tables` and `images` folders when we write our document.

## Starting off 
The first thing to do is create a New Project in RStudio. File>New Project and create a folder on your computer that works. In my example this will be `\thesisUC` you'll notice on your computer a `.Rproj` file is now created. When you want to make edits to your document I would recommend opening this file.

## Types of documents
In order to make things simple I will break this up into a few sections. The goal here is to make your thesis as sustainable as possible which means if a committee member asks you to change "one little thing" you do not have an endless number of manual edits to make. In order to do this I have 3 separate documents I make. You could technically put all of this into the `.Rmd` document but that will slow down your compiling time substantially which is why I like to split them up into seperate files.

- 1 R script called `createPlots.R`
   - This is only used if you plan on creating figures using R. If you are doing this in MatLAB then you do not need this script
   - The results of this script are all saved in your `\images` folder.
- 1 R script called `stats.R` 
   - This will run your statistical models and save them as one .RData file.
   - For simplicity we will call it `stats.RData`
- 1 RMarkdown document (.Rmd)
   - This is what you write your document in.
      - The alternative is to have 1 `master.Rmd` file which compiles all your chapters. 
      - Every chapter would be its own markdown document (e.g. `Chapter1.Rmd`). 
   - It will load the `stats.Rdata` file that you created in `stats.R` 
   - There will be other files it will need to reference to run smoothly but we can break that down later
      - `.cls` file which is required to "style" the document when you export to pdf. This is stored in the `\styles` folder (see above)
         - You may also have a `.tex` file in your pre-amble in more complex designs but you can ignore that for now.
      - A reference `.docx` file which will "style" the document when you export to `docx`. I also store this into the `\styles` folder
      - A `.bib` file. This is what stores your bibliographic references. In Zotero this can be automatically updated everytime you add a citation. There are manual ways to accomplish this with EndNote but I will not cover them here. One of the reasons is that the *citekeys* that you would need to use are not ideal. By using Zotero and BetterBibTex plugin your citations being called in the document make much more sense (e.g. lapointe2017)
      - A `.csl` AKA citation style language file (e.g. `apa.csl`). This is what will dictate how your citations appear in your document (e.g. APA, MLA etc.). I recommend [downloading this repository](https://github.com/citation-style-language/styles) and saving it somewhere on your computer. I have placed it in the projects main directory **BUT I WOULD NOT RECOMMEND THIS**. There is no need to have a copy of these files for every project.
   
## Installing Packages
The first time you run RStudio you will need to install packages before you can load them. While installing it is possible that you need to set `opts(repositories` currently. This is a one time thing, do not let it intimidate you.

You only need to install a package once on any given computer. Normally you install packages using the following syntax:
`install.packages("PackageName")`
After a package is installed you can load it by writing
`library(PackageName)`

This can be a little tedious and span several lines when you have several packages to load. For this reason I use a package called `pacman` in my scripts to facilitate. In short, `pacman` will check to see if a package is installed (if not it will download it for you) and then subsequently load it for you. Grant a fair amount of time the first time you run the script since every package will need to be installed. The compiling will be much much faster the second time around.

There are a few packages where using pacman does not work. These include
- ggeffects
- apastats
In order for these packages to be installed you will need to use the devtools package (only the first time). 

## Creating your RMarkdown document
The layout for your projects are normally split into chapters. You have one document whose sole role is to compile the chapters into a `pdf` document which we will call `master`. File>New File>RMarkdown.

*Note: if you don't want to go through this process you can download the zip file contained on this repo.*

### Referencing an article in your writing.
In order to do this simply write the `@` symbol followed by the citekey. For example `[@michel2018]`. If you do not want the author to show up in your write-up simply add a negative sign like this `[-@michel2018]`.

## Running your Stats in R. 
*This part will be completed in the `stats.R` script* 
The basics here is that you run your statistics and save them in both their summarized version and their raw version. What does this mean? Well here is an example. 

First you need to load your data into your environment. For most, this will be an excel file. 
`db <- read_excel("G:/My Drive/Projects/R15_Pipeline/RExports/allData.xlsx", sheet = "Sheet1")`

Now you should be able to view your database in R. Here is an example.
`model <- lmer(MyIV~ Group + Gender+ Group*Gender ,data=db)`
This will save the statistic in its raw form. I usually give this a better name of the form `mod_` preceding the name of the statistic. For example, `mod_GroupEffect`.  Secondly, I also save the summary of the model. This is the nicely printed model which you will see in your console. I give this something in the form of `modsum` which is short for model summary. 
`modsum_GroupEffect <- summary(model)`

Once you are done running all your statistics we need to save your models and model summaries into an `.RData` file. Here is the code I use to accomplish this

`# Save the data ------------------------------`
`save(list=ls(pattern="mod|Table"), file = "G:/My Drive/Projects/MyThesis/data/stats.RData")`
`rm(list=ls(pattern="mod|Table"))`

The first line is simply a comment. Which I like having to be able to view everything in the document outline (`Ctrl+Shift+O`)
The second line saves all variables in your workspace that start with the word `mod` into your `/data` folder.
The final line removes/clears your workspace of these variables.

If ever you make any changes to a model, you can simply re-run the `stats.R` script by pressing `Ctrl+Shift+K` and an updated `stats.RData` file will be saved in your workspace. 

**At this point you have finished running your statistics and you are ready to put them into your document**

### Things you may need to do
In some cases you may need to convert a column into "Factors" this can be done very easily
`db$VarName <- factor(db$VarName)`
You can confirm this worked by typing
`levels(db$Varname)`

# Misc
Here are a list of notes that may be useful but did not fit specifically in any section above.

## Exporting your references from EndNote to Zotero
This part can suck for some people. But I would highly recommend switching to save yourself some headaches down the road. Start by

1. Installing [Zotero](https://www.zotero.org/download/) 
2. Installing the [Better BibTex Plugin](https://retorque.re/zotero-better-bibtex/installation/)

Screenshots and a more detailed guide are forthcoming. 

## Installing Git for RStudio

You can read about it [here](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN)
[here](https://happygitwithr.com/workshops.html) is a friendly intro to GitHub using RStudio

## For my use (sites on how to use Git with RStudio)
[Guide to initial setup with Mac](https://medium.com/@sorenlind/create-pdf-reports-using-r-r-markdown-latex-and-knitr-on-macos-high-sierra-e7b5705c9fd)

https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html

https://resources.github.com/whitepapers/github-and-rstudio/

[A review of Markdown syntax](https://guides.github.com/features/mastering-markdown/)

[A style guide to R](https://www.r-bloggers.com/my-r-style-guide/)

[Writing your thesis with Bookdown](https://eddjberry.netlify.com/post/writing-your-thesis-with-bookdown/)
[More on RMarkdown](https://annakrystalli.me/rrresearch/05_literate-prog.html)

[Reproducible Science](https://ecoinfaeet.github.io/2016/07/06/reproducibilidad/)
