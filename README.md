
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gregorian

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/gregorian)](https://cran.r-project.org/package=gregorian)
[![Build
Status](https://travis-ci.org/edgararuiz/gregorian.svg?branch=master)](https://travis-ci.org/edgararuiz/gregorian)
[![Coverage
status](https://codecov.io/gh/edgararuiz/gregorian/branch/master/graph/badge.svg)](https://codecov.io/github/edgararuiz/gregorian?branch=master)
<!-- badges: end -->

Provides functions to convert between the gregoriann calendar dates and
Gregorian dates.

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edgararuiz/gregorian")
```

``` r
as.Date("-99-7-12")
```

    Error in charToDate(x) : 
      character string is not in a standard unambiguous format

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
#> List of 6
#>  $ year        : num 100
#>  $ month       : int 7
#>  $ day         : int 12
#>  $ bce         : logi TRUE
#>  $ day_name    :List of 2
#>   ..$ name  : chr "Friday"
#>   ..$ number: num 5
#>  $ astronomical: chr "-99-07-12"
#>  - attr(*, "class")= chr "gregorian_date"
```

``` r
get_date()
#> Sunday May 12, 2019 CE
```

``` r
diff_days(born, get_date())
#> [1] 773523
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
#> [1] 0
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
#> [1] 31
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
#> [1] 0
```

``` r
add_days(get_date(), 365)
#> Monday May 11, 2020 CE
```
