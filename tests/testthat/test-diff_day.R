context("diffs")

test_that("diff_days cases", {
  expect_equal(
    diff_days(
      gregorian_date(2014, 2, 5, FALSE), 
      gregorian_date(2000, 2, 4, FALSE)
    ), -5115
  )
  expect_equal(
    diff_days(
      gregorian_date(2012, 12,21, FALSE), 
      gregorian_date(3114,8,11, TRUE)
    ), -1872000
  )
  expect_equal(
    diff_days(
      gregorian_date(2014, 2, 5, FALSE), 
      gregorian_date(2014, 3, 4, FALSE)
    ), 27
  )
  expect_equal(
    diff_days(as.Date("2012-01-01"), as.Date("2012-01-10"))
    , 9)
})

test_that("diff_dates cases", {
  xd <- diff_dates(
    gregorian_date(2014, 2, 5, FALSE), 
    gregorian_date(2000, 2, 4, FALSE)
  )
  expect_equal(
    c(xd$years, xd$months, xd$days),
    c(14, 0, 1)
  )
  xd2 <- diff_dates(
    as.Date("2014-2-5"), 
    as.Date("2000-2-4")
  )
  expect_equal(
    c(xd2$years, xd2$months, xd2$days),
    c(14, 0, 1)
  )
})

test_that("diff_calendar cases", {
  xd <- diff_calendar(
    gregorian_date(2014, 2, 5, FALSE), 
    gregorian_date(2000, 2, 4, FALSE)
  )
  expect_equal(
    c(xd$years, xd$months, xd$days),
    c(13, 11, 30)
  )
})
