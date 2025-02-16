Using the exposure models to impute missing variables
================
Joshua Edefo
2025-02-16

This R script used an exposure model to impute missing values in a
dataset. It began by loading the necessary libraries for data
manipulation and Excel file operations, and it set the working directory
and random seed for reproducibility. The script then imported the
dataset from an Excel file and checked for missing values across the
entire dataset as well as in each individual column. Next, a linear
regression model was fitted using Age and Income as predictors for
TobaccoSmoking, and this model was used to impute any missing
TobaccoSmoking values. Finally, after verifying that the missing values
had been addressed, the script saved the updated dataset to a new Excel

Libraries

``` r
library(tidyverse)
```

    ## Warning: package 'tidyverse' was built under R version 4.3.2

    ## Warning: package 'ggplot2' was built under R version 4.3.3

    ## Warning: package 'dplyr' was built under R version 4.3.3

    ## Warning: package 'forcats' was built under R version 4.3.2

    ## Warning: package 'lubridate' was built under R version 4.3.3

``` r
library(readxl)
library(usethis)
```

    ## Warning: package 'usethis' was built under R version 4.3.2

``` r
library(writexl)  
```

    ## Warning: package 'writexl' was built under R version 4.3.3

Using Exposure model to impute missing values

``` r
## Set directory
setwd("C:\\Users\\joe62\\OneDrive - Aberystwyth University\\Apps\\Desktop\\Destop Folder\\R code")

## Set seed for reproducibility
set.seed(42)

## Importing the data 
data <- read_excel("Using exposure model to predict missing values.xlsx")

## View the data with missing values
head(data)
```

    ## # A tibble: 6 × 4
    ##     Age Income TobaccoSmoking HealthOutcome
    ##   <dbl>  <dbl>          <dbl>         <dbl>
    ## 1    66  69251           9.79          55.7
    ## 2    54  55113          17.1           38.0
    ## 3    18  85626          15.3           59.6
    ## 4    42  60116           9.57          55.1
    ## 5    27  80240          14.3           46.3
    ## 6    53  79220           2.31          64.2

``` r
view(data)

## Check for missing values in the entire dataset
sum(is.na(data))  # Returns the total number of missing values in the entire dataset
```

    ## [1] 13

``` r
## Count the missing values in each column
colSums(is.na(data))  # Returns a count of missing values for each column in the dataset
```

    ##            Age         Income TobaccoSmoking  HealthOutcome 
    ##              0              0             13              0

``` r
## Exposure Model: Impute missing TobaccoSmoking using Age and Income as predictors
## Fit a linear regression model to predict TobaccoSmoking
model <- lm(TobaccoSmoking ~ Age + Income, data = data, na.action = na.exclude)
summary(model)
```

    ## 
    ## Call:
    ## lm(formula = TobaccoSmoking ~ Age + Income, data = data, na.action = na.exclude)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -15.6373  -3.3479   0.0592   3.1157  13.6112 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.336e+01  2.478e+00   5.391  6.3e-07 ***
    ## Age         -3.635e-02  3.722e-02  -0.977    0.332    
    ## Income      -3.864e-05  2.505e-05  -1.543    0.127    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 5.311 on 84 degrees of freedom
    ##   (13 observations deleted due to missingness)
    ## Multiple R-squared:  0.03331,    Adjusted R-squared:  0.0103 
    ## F-statistic: 1.447 on 2 and 84 DF,  p-value: 0.241

``` r
## Impute missing TobaccoSmoking values using the model
data$TobaccoSmoking <- ifelse(
  is.na(data$TobaccoSmoking),
  predict(model, newdata = data[is.na(data$TobaccoSmoking),]),
  data$TobaccoSmoking
)

## View the imputed data
head(data)
```

    ## # A tibble: 6 × 4
    ##     Age Income TobaccoSmoking HealthOutcome
    ##   <dbl>  <dbl>          <dbl>         <dbl>
    ## 1    66  69251           9.79          55.7
    ## 2    54  55113          17.1           38.0
    ## 3    18  85626          15.3           59.6
    ## 4    42  60116           9.57          55.1
    ## 5    27  80240          14.3           46.3
    ## 6    53  79220           2.31          64.2

``` r
view(data)

## Check if any missing values remain
sum(is.na(data$TobaccoSmoking))
```

    ## [1] 0

``` r
## Save to an Excel file
write_xlsx(data, "using_exposure_model_to_impute_missing_data.xlsx")
```

Session information

    ## R version 4.3.1 (2023-06-16 ucrt)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 11 x64 (build 22631)
    ## 
    ## Matrix products: default
    ## 
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United Kingdom.utf8 
    ## [2] LC_CTYPE=English_United Kingdom.utf8   
    ## [3] LC_MONETARY=English_United Kingdom.utf8
    ## [4] LC_NUMERIC=C                           
    ## [5] LC_TIME=English_United Kingdom.utf8    
    ## 
    ## time zone: Europe/London
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] writexl_1.5.1   usethis_2.2.2   readxl_1.4.3    lubridate_1.9.3
    ##  [5] forcats_1.0.0   stringr_1.5.0   dplyr_1.1.4     purrr_1.0.2    
    ##  [9] readr_2.1.4     tidyr_1.3.0     tibble_3.2.1    ggplot2_3.5.1  
    ## [13] tidyverse_2.0.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.4      compiler_4.3.1    tidyselect_1.2.0  scales_1.3.0     
    ##  [5] yaml_2.3.7        fastmap_1.2.0     R6_2.5.1          generics_0.1.3   
    ##  [9] knitr_1.44        munsell_0.5.0     pillar_1.9.0      tzdb_0.4.0       
    ## [13] rlang_1.1.1       utf8_1.2.3        stringi_1.7.12    xfun_0.40        
    ## [17] fs_1.6.3          timechange_0.2.0  cli_3.6.1         withr_2.5.0      
    ## [21] magrittr_2.0.3    digest_0.6.33     grid_4.3.1        rstudioapi_0.15.0
    ## [25] hms_1.1.3         lifecycle_1.0.3   vctrs_0.6.5       evaluate_0.21    
    ## [29] glue_1.6.2        cellranger_1.1.0  fansi_1.0.4       colorspace_2.1-0 
    ## [33] rmarkdown_2.25    tools_4.3.1       pkgconfig_2.0.3   htmltools_0.5.8.1
