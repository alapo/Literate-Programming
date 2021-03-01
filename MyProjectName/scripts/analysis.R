# Header 1 ----------
# ▐ Header 2 --------
# ▐ ▬ Header 3 --------

# Load/Install required packages ---------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(conflicted,rio, ggplot2, esquisse, Rmisc, tidyverse, car, 
               janitor, hablar, rstatix, report, remotes, ggpubr,  ggstatsplot, jtools, sjPlot, sjmisc, parameters,
               easystats, apastats, sjlabelled, rio, googlesheets4) #p_load This function is a wrapper for library and require. It checks to see if a package is installed, if not it attempts to install the package from CRAN and/or any other repository in the pacman repository list.

# pacman::p_unload(all) # detaches all packages. Very useful when you need to update a package OR install a packages which has dependencies that are already loaded in your R Session
# conflict_scout() # let's check to make sure we don't have conflicts

conflicted::conflict_prefer("rename", "dplyr")
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("clean_names", "janitor")
conflicted::conflict_prefer("mutate", "dplyr")
conflicted::conflict_prefer("summarise", "dplyr")


# Import your dataset ---------------

#df <- as.data.frame(import_list("raw/data.xlsx", which = "Sheet1"))
#df <- import("raw/data.xlsx", which = "Sheet1")

df <- import("raw/data.xlsx", which = "anova-data")

#df <- import("https://docs.google.com/spreadsheets/d/1fFVmBFpdAKxzLMT8dx7pZm48mo9CE3kIwYhrkaZj7NM", which = "anova_data") %>%  # requires 'googlesheets4' library
#  filter(ID != 1)

df.demo <- import("raw/data.xlsx", which = "demographics") %>% # Imports the sheet with demographic data
  clean_names() %>% # Clean the column names
  rename(
    "ID" = "study_id",
    "Group" = "group"
  )

#df.mri <- import("raw/data.xlsx", which = "MRI-data") %>% # Imports the sheet with demographic data
#  janitor::clean_names(case = "snake", abbreviations = c("ID", "DOB")) # Clean the column names

df.mri <- import("raw/data.xlsx", which = "MRI-data") %>%
  clean_names() %>%
  remove_empty(c("rows", "cols")) %>%           # remove the empty rows and column.s
  remove_constant(na.rm = TRUE, quiet = FALSE)  # remove the column of all "Yes" values 

# Data Wrangling -----

# ▬ Cleaning df.mri ----------
    # df.mri <- df.mri %>%
    #   filter(site_mri == "Calgary") # remove all data that is not from Calgary
    # 
    # df.mri <- df.mri %>%
    #   filter(id %in% unique(df.demo$ID)) # I only want IDs that are in present in df.demo
    # 
    # # At the moment some cells in our df.mri columns contains text. Which is causing issues when we import. Below we force it to convert to a numeric column this will cause "text" columns to become blank (which we want)
    # df.mri <- df.mri %>% 
    #   hablar::convert(num(left_af:right_uf)) # Converts some of the columns into numeric -- requires hablar library
    # 
    # # Based on the missing data in left-af and right-af we are going to remove these columns from our data.frame
    # df.mri <- df.mri %>%
    #   select(-c("left_af", "right_af"))

    # ▬ Wide to long [df.mri] ----------
    
    # df.mri <- df.mri %>%
    #   gather(mriloc, dti_value, left_cst:right_uf)

# ▬  We can do this all in one step if we prefer -----------
    df.mri <- df.mri %>%
      filter(site_mri == "Calgary") %>% # remove all data that is not from Calgary
      filter(id %in% unique(df.demo$ID)) %>% # I only want IDs that are in present in df.demo
      hablar::convert(num(left_af:right_uf)) %>% # Converts some of the columns into numeric -- requires hablar library
      select(-c("left_af", "right_af", "site_mri", "completed_mri_1_yes_0_no")) %>%
      gather(mriloc, dti_value, left_cst:right_uf)
    

  # ▬ Merge dataframes --------
    # ▐ ▬ Merge [df] with [df.demo] --------
      # Make sure the columns in common (that you will use to merge) are named the same
      
    #tmp <- left_join(df, df.demo, by = "ID") # notice how this causes us to have 2 group columns
    
      tmp <- left_join(df, df.demo, by = c("ID", "Group")) # now we will only have one "Group" column
    
    
      df <- tmp 			# name the combined dataframe "df"
      rm(tmp, df.demo)  	# remove the datasets that we don't need
      
      # ▐ ▬ Merge [df] with [df.MRI] --------
      # Make sure the columns in common (that you will use to merge) are named the same
     
      #tmp <- left_join(df, df.mri, by = "ID") 
      
      # This line will not work....why?
      
      df.mri <- df.mri %>%
        rename(
          "ID" = "id"
        )
      tmp <- left_join(df, df.mri, by = "ID") 
      
      
      df <- tmp 			# name the combined dataframe "df"
      rm(tmp, df.mri)  	# remove the datasets that we don't need
      
  # ▐ ▬ create a BMI column --------
      # It should be noted that this stuff could have been completed when we imported the data as "df.demo"
        df <- df %>%
          add_column(., "BMI" = df$weight_kg/(df$height_m^2), .after = "height_m")
      
      # ▐ ▬ create an "obese" column --------
      # Here we create a column called "obese" where the output is conditional based on the values provided in another column (in this case `BMI`)

      df <- df %>%
        mutate(
          obese = case_when( 
            BMI < 18.5 ~ 'Underweight',
            BMI > 18.5 & BMI < 24.9 ~ 'Normal',
            BMI > 24.9 & BMI < 29.9 ~ 'Overweight',
            BMI > 29.9 ~ 'Obese')) 
      
      df$obese <- factor(df$obese, ordered = TRUE, levels=c("Underweight", "Normal", "Overweight", "Obese"), exclude = "")
      
  # ▬ Round columns --------
        df <- df %>% 
          mutate(across(c("weight_kg", "height_m", "BMI"), ~ round(., 2))) # where "vnum1" and "vnum2" are column names

# Plotting -------------
      df$sex <- factor(df$sex, ordered = TRUE, levels=c("F", "M"),labels=c("Female", "Male"), exclude = "")
      df$ID <- factor(df$ID)
      
      
      # Step 1       
        # ggplot(df) + 
        #   aes(y=Score, x = Group) +
        #   geom_boxplot()
      
      # Step 2 
        # ggplot(df) + 
        #   aes(y=Score, x = Group, color = sex) +
        #   geom_boxplot()
        
      # Step 3 
        # plot1 <- ggplot(df) + 
        #   aes(y=Score, x = Group) +
        #   geom_boxplot(outlier.shape = NA) +
        #   geom_jitter(size=8, aes(shape=sex, color=sex), position = position_dodge(.4)) + 
        #   
        #   #geom_point(size = 8, position= "dodge" +
        #   scale_shape_manual(values=c("👧","👦"), name = "Sex", labels = c("Female", "Male")) + # I need 9 values (I for each ID)
        #   scale_color_manual(values=c('springgreen4', 'red4'), name = "Sex", labels = c("Female", "Male"))  +
        #   labs(x = "Group", y = "Concussion Test Score", title = "My Plot Name") +
        #   theme_minimal() +
        #   theme(legend.position = "top",
        #         legend.title = element_text(size = 12),
        #         plot.title = element_text(hjust = 0.5),
        #         plot.caption = element_text(face = "italic"),
        #         #legend.key = element_rect(colour = 'white', fill = 'white', size = 0.5, linetype='dashed'),
        #         #legend.key.size = unit(2, "cm"),
        #         #legend.key.width = unit(2, "cm"),
        #   )
        #     # ▬ Save the plot we created in "/images" folder ====================
        #     ggsave("images/plot1.png",plot1, width=11, height=8.5, dpi=300)
        # rm(plot1)

  # ▬ Loop through plots for each MRI location
    for(xx in 1:length(unique(df$mriloc))){
      tmp.data <- df %>%
        filter(mriloc == unique(df$mriloc)[xx])
      
      plot1 <- ggplot(data = tmp.data,
                      aes(x = Group, y = dti_value)) +
        geom_boxplot(outlier.size = 0) + 
        geom_jitter(aes(color = ID, shape = sex), size = 2, position=position_jitter(width=.25, height=0)) +
        labs(x = "Group", 
             y = paste0(unique(df$mriloc)[xx]), 
             title = paste0("DTI in ", unique(df$mriloc)[xx])) +
        # title = paste0(str_replace_all(MetricNames[xx], c("~" =" ")), " by Day"), fill = "Subject") +
  
        theme(plot.title = element_text(hjust = 0.5),
              legend.position = "top")  +
        guides(color = FALSE) # This line is going to remove the extra legend we don't really need
      
      # Save the plot 
      dir_lbl = paste0("images/DTI/", unique(df$mriloc)[xx],".png") #using paste0 removes the spaces
      ggsave(dir_lbl, plot1, width=11, height=8.5, dpi=400)

    }
rm(dir_lbl, tmp.data, xx) # clear environment of variables we don't need
      
# Creating a Descriptive Table -----

tbl.demo <- df %>%
  distinct(ID, .keep_all = TRUE) %>%
  group_by(Group, sex) %>%
  rstatix::get_summary_stats(age, type = "mean_sd") %>% # requires the rstatix package
  select(-c("variable")) %>%
  dplyr::rename(
    "Sex" = "sex",
    "Mean Age" = "mean",
    "SD" = "sd"
  ) 
cgwtools::resave(tbl.demo, file = "data/analyzedData.RData") #resave a list of tables that I'll use in the .Rmd file.


# Statistics ----------

# ▬ Running an ANOVA ----------------
# testing to see if group has an impact on test scores

model <- aov(Score ~ Group + sex, data = df)
report(model) #requires easystats
modsum <- summary(model)
# describe.aov(modsum, "Group")
cgwtools::resave(modsum, model, file = "data/analyzedData.RData") #Save a list of tables that I'll use in the .Rmd file.




# Save your environment ------------
  # ▬  Save the tables into data/tables.RData using "patterns" ==================
  # save(list=ls(pattern="table"), file = "data/tables.RData") #Save a list of tables that I'll use in the .Rmd file.
  # save(list=ls(pattern="mod"), file = "data/stats.RData")
  
  
 
   # ▬ Optional - Save df as xlsx --------
  
  # rio::export(df, "data/myCleanData.xlsx")
  
  # ▬ Clear my environment --------
  
  rm(list=ls()) # Clear my environment completely
  