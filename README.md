
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gregorian

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/gregorian)](https://cran.r-project.org/package=gregorian)
[![Build
Status](https://api.travis-ci.com/edgararuiz/gregorian.svg?branch=master)](https://travis-ci.com/edgararuiz/gregorian)
[![Coverage
status](https://codecov.io/gh/edgararuiz/gregorian/branch/master/graph/badge.svg)](https://codecov.io/github/edgararuiz/gregorian?branch=master)
<!-- badges: end -->

Provides a robust date object. It also provides date calculation
functions that work on top of the new object. Many of the functions
seamlessly convert `Date` and `character` objects into the new
`gregorian_date` object.

## Problem

``` r
as.Date("-99-7-12")
```

    Error in charToDate(x) : 
      character string is not in a standard unambiguous format

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edgararuiz/gregorian")
```

## Gregorian object

``` r
library(gregorian)
as_gregorian("-99-7-12")
#> Friday July 12, 100 BCE
```

``` r
born <- as_gregorian("-99-7-12")
```

``` r
str(born)
#> List of 7
#>  $ year        : num 100
#>  $ month       : int 7
#>  $ day         : int 12
#>  $ bce         : logi TRUE
#>  $ day_name    :List of 2
#>   ..$ name  : chr "Friday"
#>   ..$ number: num 5
#>  $ astronomical: chr "-99-07-12"
#>  $ full_date   : chr "Friday July 12, 100 BCE"
#>  - attr(*, "class")= chr "gregorian_date"
```

``` r
get_date()
#> Monday May 13, 2019 CE
```

## Date calculations

``` r
diff_days(born, get_date())
#> [1] 773524
```

``` r
diff_dates(born, get_date())
#> $years
#> [1] 2117
#> 
#> $months
#> [1] 10
#> 
#> $days
#> [1] 1
```

``` r
diff_calendar(born, get_date())
#> $years
#> [1] 2117
#> 
#> $months
#> [1] 9
#> 
#> $days
#> [1] 32
```

``` r
add_days(get_date(), 365)
#> Tuesday May 12, 2020 CE
```

## Leap Year

``` r
is_leap_year(2012)
#> [1] TRUE
```

``` r
is_leap_year(2019)
#> [1] FALSE
```

## Day Rotation

``` r
# Sunday plus one day (1 == Monday)
day_rotation(1, 7, 6) + 1
#> [1] 1
```

``` r
# Sunday plus 100 days (2 == Tuesday)
day_rotation(100, 7, 6) + 1
#> [1] 2
```

## In the `tidyverse`

``` r
library(dplyr)

dt <- tribble(~dates,
        as.Date("12/12/2014"),
        as.Date("1/1/1") - 1000,
        as.Date("1/1/1") - 365
        )

dt
#> # A tibble: 3 x 1
#>   dates     
#>   <date>    
#> 1 12-12-20  
#> 2 -2-04-07  
#> 3 0-01-02
```

``` r
library(purrr)

dt %>%
  mutate(new_date = map(dates, as_gregorian))
#> # A tibble: 3 x 2
#>   dates      new_date            
#>   <date>     <list>              
#> 1 12-12-20   <S3: gregorian_date>
#> 2 -2-04-07   <S3: gregorian_date>
#> 3 0-01-02    <S3: gregorian_date>
```

``` r
dt %>%
  mutate(new_date = map_chr(dates, ~as_gregorian(.x)$full_date))
#> # A tibble: 3 x 2
#>   dates      new_date                   
#>   <date>     <chr>                      
#> 1 12-12-20   Thursday December 20, 12 CE
#> 2 -2-04-07   Tuesday April 7, 3 BCE     
#> 3 0-01-02    Sunday January 2, 1 BCE
```

``` r
dt %>%
  mutate(
    today_diff = map2_dbl(dates, Sys.Date(), diff_days)
    ) 
#> # A tibble: 3 x 2
#>   dates      today_diff
#>   <date>          <dbl>
#> 1 12-12-20       732820
#> 2 -2-04-07       738191
#> 3 0-01-02        737556
```
