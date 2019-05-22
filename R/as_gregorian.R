#' @export
as_gregorian <- function(x, date_format = "") UseMethod("as_gregorian")

#' @export
as_gregorian.Date <- function(x, date_format = "") {
  if(length(x) == 1){
    date_to_gregorian(x, date_format)
  } else {
    lapply(x, date_to_gregorian, date_format)
  }
}

date_to_gregorian <- function(x, date_format = "") {
  yr <- as.integer(format(x, "%Y"))
  bce <- FALSE
  if(yr <= 0) {
    yr <- abs(yr) + 1
    bce <- TRUE
  }
  mn <- as.integer(format(x, "%m"))
  dy <- as.integer(format(x, "%d"))
  gregorian_date(yr, mn, dy, bce)
}

#' @export
as_gregorian.character <- function(x, date_format = "%Y-%m-%d") {
  if(length(x) == 1){
    character_to_gregorian(x, date_format)
  } else {
    lapply(x, character_to_gregorian, date_format)
  }
}
  
character_to_gregorian <- function(x, date_format = "%Y-%m-%d") {
  d <- NULL
  if(date_format == "%Y-%m-%d") {
    xs <- strsplit(x, "-")[[1]]
    dy <- as.integer(xs[length(xs)])
    mn <- as.integer(xs[length(xs) - 1])
    yr <- as.integer(xs[length(xs) - 2])
    if(xs[[1]] == "") {
      bce <- TRUE
      yr <- yr + 1
    } else {
      bce <- FALSE
    }
    if(yr == 0) yr <- 1
    d <- gregorian_date(yr, mn, dy, bce)
  }
  if(is.null(d)) stop("Requested date format is not supported")
  d
}
