#' @export
add_days <- function(x, no_days) UseMethod("add_days")

#' @export
add_days.Date <- function(x, no_days) {
  add_days(as_gregorian(x), no_days)
}

#' @export
add_days.character <- function(x, no_days) {
  add_days(as_gregorian(x), no_days)
}

#' @export
add_days.gregorian_date <- function(x, no_days) {
  add_days2(x$year, x$month, x$day, x$bce, no_days)
}

add_days2 <- function(year, month, day, bce, no_days) {
  if (no_days < 0) stop("Only positive values are allowed for no_days")
  
  adj_year <- ifelse(bce, -(year -1), year)
  
  month_days <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  
  rmd <- month_days
  rmd[2] <- rmd[2] + is_leap_year(adj_year)
  rmd <- rmd[month:12]
  rmd[1] <- rmd[1] - day 
  rmd_agg <- as.integer(lapply(seq_along(rmd), function(x) sum(rmd[1:x])))
  rmd_over <- sum(rmd_agg < no_days)
  
  if(rmd_over == 0) {
    full_days <- no_days + day
    full_months <- month 
    full_year <- year
    is_bce <- bce
  } else {
    if(rmd_over < length(rmd_agg)) {
      rmd_full <- rmd_agg[rmd_over]
      full_days <- no_days - rmd_full
      full_months <- month + rmd_over
      full_year <- year
      is_bce <- bce
    } else {
      days_left <- no_days - rmd_agg[length(rmd_agg)]
      cycles <- ceiling(days_left / 365)
      yr_cycles <- seq_len(cycles) + adj_year
      ydays <- as.integer(lapply(yr_cycles, function(x) 365 + is_leap_year(x)))
      ydays_agg <- as.integer(lapply(seq_along(ydays), function(x) sum(ydays[1:x])))
      ydays_over <- sum(ydays_agg < days_left)
      curr_year <- adj_year + ydays_over + 1
      rmd <- month_days
      rmd[2] <- rmd[2] + is_leap_year(curr_year)
      rmd_agg <- as.integer(lapply(seq_along(rmd), function(x) sum(rmd[1:x])))
      curr_days <- days_left - ifelse(ydays_over > 0, ydays_agg[ydays_over], 0) 
      rmd_over <- sum(rmd_agg < curr_days)
      full_months <- rmd_over + 1
      full_days <- curr_days - ifelse(rmd_over > 0, rmd_agg[rmd_over],0)
      full_year <- ifelse(curr_year <= 0, -(curr_year - 1), curr_year)
      is_bce <- ifelse(curr_year <= 0, TRUE, FALSE)
    }
  }
  gregorian_date(abs(full_year), full_months, full_days, is_bce)
}
