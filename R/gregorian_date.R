#' @export
gregorian_date <- function(year_no, month_no, day_no, bce) {
  
  validate_gregorian(year_no, month_no, day_no, bce)
  dn     <- day_name(year_no, month_no, day_no, bce)
  astro  <- atronomical_date(year_no, month_no, day_no, bce)
  output <- full_date(year_no, month_no, day_no, bce, dn$name)
  
  structure(
    list(
      year = year_no,
      month = month_no,
      day = day_no,
      bce = bce,
      day_name = dn,
      astronomical = astro,
      full_date = output
    ),
    class = "gregorian_date"
  )
  
}

setOldClass("gregorian_date")

#' @export
print.gregorian_date <- function(x, ...) {
  print(x$full_date)
  invisible(x)
}

validate_gregorian <- function(year_no, month_no, day_no, bce) {
  c_date <- c(year_no, month_no, day_no)
  ai <- as.logical(lapply(c_date, is_integer))
  if(!all(ai)) stop("Year, month and day must be an integer number")
  ai <- as.logical(lapply(c_date, function(x) x > 0)) 
  if(!all(ai)) stop("Year, month and day must be a positive number")
  bce <- as.logical(bce)
  if(month_no > 12) stop("Month entry not valid. Valid numbers are between 1 and 12")
  if(day_no > 31) stop("Day entry not valid. Valid numbers are between 1 and 31")
}

atronomical_date <- function(year_no, month_no, day_no, bce) {
  yr_astro <- ifelse(bce, year_no - 1, year_no)
  paste0(
    ifelse(yr_astro > 0 && bce, "-", ""), 
    yr_astro, "-" ,
    ifelse(nchar(month_no) == 1, "0", ""), month_no, "-", 
    ifelse(nchar(day_no) == 1, "0", ""), day_no
  )
}

full_date <- function(year_no, month_no, day_no, bce, day_name) {
  paste0(
    day_name, " ", 
    month.name[month_no], " ", 
    day_no, ", ", 
    year_no," ", 
    ifelse(bce, "BCE", "CE")
  )
}