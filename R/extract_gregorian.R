#' @export
extract_gregorian <- function(.data, x,
                              include = c("year", "month", "day", 
                                          "astronomical", "full")) 
  UseMethod("extract_gregorian")

#' @export
extract_gregorian.data.frame <- function(.data, x,
                              include = c("year", "month", "day", 
                                          "astronomical", "full")) {
  x  <- enquo(x) 
  cx <- rlang::quo_text(x)
  d  <- pull(.data, !! x)
  gd <- as_gregorian(d)
  if("year" %in% include) .data <- get_single(.data, gd, cx, "year")
  if("month" %in% include) .data <- get_single(.data, gd, cx, "month")
  if("day" %in% include).data <- get_single(.data, gd, cx, "day")
  if("astronomical" %in% include)
    .data <- get_single(.data, gd, cx, "astronomical", TRUE)
  if("full" %in% include) 
    .data <- get_single(.data, gd, cx, "full_date", TRUE)
  .data
}

get_single <- function(.data, gregorian, var_name, field, char = FALSE) {
   as_selected <- ifelse(char, as.character, as.numeric)
   mutate(
     .data, 
     !! paste0(var_name, "_", field) := 
       as_selected(lapply(gregorian, function(x) x[field][[1]]))
   )
 }