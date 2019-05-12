context("add_days")

test_that("Special add_days cases", {
  expect_equivalent(add_days(gregorian_date(3114, 8, 11, TRUE), 1)$astronomical, "-3113-08-12")
  expect_equivalent(add_days(gregorian_date(3114, 8, 11, TRUE), 30)$astronomical, "-3113-09-10")
  expect_equivalent(add_days(gregorian_date(3114, 8, 11, TRUE), 1872000)$astronomical, "2012-12-21")
  expect_equivalent(add_days(as.Date("2012-01-01"), 1)$astronomical, "2012-01-02")
})

test_that("Special diff_day cases", {
 expect_equal(
   diff_days(
     gregorian_date(2014, 2, 5, FALSE), 
     gregorian_date(2000, 2, 4, FALSE)
     ), -5114
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
