#' @export
diff_days <- function(from_date, to_date) UseMethod("diff_days")

#' @export
diff_days.Date <- function(from_date, to_date) {
  d1 <- as_gregorian(from_date)
  d2 <- as_gregorian(to_date)
  diff_days(d1, d2)
}

#' @export
diff_days.gregorian_date <- function(from_date, to_date) {
  diff_days2(
    from_date$year, from_date$month, from_date$day, from_date$bce,
    to_date$year, to_date$month, to_date$day, to_date$bce
  )$no_days
}
# -----------------------------------------------------------------------------
#' @export
diff_dates <- function(from_date, to_date) UseMethod("diff_dates")

#' @export
diff_dates.Date <- function(from_date, to_date) {
  d1 <- as_gregorian(from_date)
  d2 <- as_gregorian(to_date)
  diff_dates(d1, d2)
}

#' @export
diff_dates.gregorian_date <- function(from_date, to_date) {
  diff_days2(
    from_date$year, from_date$month, from_date$day, from_date$bce,
    to_date$year, to_date$month, to_date$day, to_date$bce
  )$dates
}

# -----------------------------------------------------------------------------
#' @export
diff_calendar <- function(from_date, to_date) UseMethod("diff_calendar")

#' @export
diff_calendar.Date <- function(from_date, to_date) {
  d1 <- as_gregorian(from_date)
  d2 <- as_gregorian(to_date)
  diff_calendar(d1, d2)
}

#' @export
diff_calendar.gregorian_date <- function(from_date, to_date) {
  diff_days2(
    from_date$year, from_date$month, from_date$day, from_date$bce,
    to_date$year, to_date$month, to_date$day, to_date$bce
  )$calendar
}

# -----------------------------------------------------------------------------
diff_days2 <- function(year_1, month_1, day_1, bce_1,
                      year_2, month_2, day_2, bce_2) {
  month_days <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  
  nd1 <- date_as_number(year_1, month_1, day_1, bce_1)
  nd2 <- date_as_number(year_2, month_2, day_2, bce_2)
  print(nd1)
  print(nd2)
  if(bce_1) year_1 <- -(year_1 - 1)
  if(bce_2) year_2 <- -(year_2 - 1)
  
  # If the first date is BCE and the second isn't, the result
  # should always be positive
  print(paste(bce_1, bce_2, nd1, nd2))
  
  if( (bce_1 && !bce_2) && (nd1 >= nd2) ) {
    print("COND 1")
    year_a <- year_1; month_a <- month_1; day_a <- day_1
    year_b <- year_2; month_b <- month_2; day_b <- day_2
    negative <- FALSE  
  } else if( (bce_1 && bce_2) && (nd1 >= nd2) ) {
    print("COND 2")
    year_a <- year_1; month_a <- month_1; day_a <- day_1
    year_b <- year_2; month_b <- month_2; day_b <- day_2
    negative <- FALSE  
  }else if ( (!bce_1 && bce_2) && (nd1 >= nd2) ) {
    print("COND 3")
    year_a <- year_2; month_a <- month_2; day_a <- day_2
    year_b <- year_1; month_b <- month_1; day_b <- day_1
    negative <- TRUE  
  } else if ( (bce_1 && !bce_2) && (nd1 <= nd2) ) {
    print("COND 4")
    year_a <- year_2; month_a <- month_2; day_a <- day_2
    year_b <- year_1; month_b <- month_1; day_b <- day_1
    negative <- TRUE
  } else if ( (!bce_1 && !bce_2) && (nd1 <= nd2) ) {
    print("COND 4")
    year_a <- year_1; month_a <- month_1; day_a <- day_1
    year_b <- year_2; month_b <- month_2; day_b <- day_2
    negative <- FALSE
  } else {
    year_a <- year_2; month_a <- month_2; day_a <- day_2
    year_b <- year_1; month_b <- month_1; day_b <- day_1
    print("COND 5")
    negative <- TRUE
  }
  
  p_yrs <- 0; p_mts <- 0; p_dys <- 0
  l_yrs <- 0; l_mts <- 0; l_dys <- 0
  if(year_a == year_b) {
    if(month_a == month_b) {
      res <- day_b - day_a
      p_dys <- res
      l_dys <- res
    } else {
      md <- month_days
      md[[2]] <- md[[2]] + is_leap_year(year_a)
      mi <- min(month_a:month_b)
      mx <- max(month_a:month_b)
      md <- md[mi:mx]
      md[[1]] <- md[[1]] - day_a
      md[length(md)] <- day_b
      p_mts <- length(mi:mx) - 2
      p_dys <- md[[1]] + md[[length(md)]]
      l_dys <- ifelse(day_b >= day_a, day_b - day_a, md[[1]] + md[[length(md)]]) 
      l_mts <- ifelse(month_b >= month_a, month_b - month_a, 0) 
      res <- sum(md)
    }
  } else {
    yrs <- as.integer(lapply(year_a:year_b, is_leap_year))
    yrs <- 365 + yrs
    md <- month_days
    md[[2]] <- md[[2]] + is_leap_year(year_a)
    md <- md[month_a:12]
    md[[1]] <- md[[1]] - day_a
    yrs[[1]] <- sum(md)
    
    p_dys <- md[[1]]
    p_mts <- length(md) - 1
    md1 <- md[[1]]
    
    md <- month_days
    md[[2]] <- md[[2]] + is_leap_year(year_b)
    md <- md[1:month_b]
    md[[length(md)]] <- day_b
    yrs[[length(yrs)]] <- sum(md)
    
    p_dys <- p_dys + day_b
    p_mts <- p_mts + length(md) - 1
    p_yrs <- length(yrs) - 2

    l_yrs <- year_b - year_a

    if(month_b < month_a) {
      l_yrs <- l_yrs - 1
      l_mts <- (12 - month_a) + month_b
    } else {
      l_mts <- month_b - month_a
    }
    if(day_b < day_a) {
      l_dys <- md1 + md[[length(md)]]
      if(month_a == month_b) {
        l_mts <- 11
        l_yrs <- l_yrs - 1
      } else {
          l_mts <- l_mts - 1
        }
    } else  {
      l_dys <- day_b - day_a
    }
    res <- sum(yrs)
  }
  if(negative) {
    res <- -(res)
  }
  list(
    calendar = list(
      years = p_yrs,
      months = p_mts,
      days = p_dys 
    ),
    dates = list(
      years = l_yrs,
      months = l_mts,
      days = l_dys 
    ),
    no_days = res
  )
}