
test_that("parameter space explorer works", {

  # exposure - control run
  exp <- data.frame(time = c(0,3,5,7,7.01,10,12,14),
                    conc = rep(0, 8))

  # observations - control run
  obs <- data.frame(time = c(0,3,5,7,7.01,10,12,14),
                    BM = c(12,38,92,176,176,627,1283,2640))

  # parameters after calibration
  params <- c(k_phot_max = 5.663571,
              k_resp = 1.938689)

  bounds = list(k_phot_max = list(0,30),
                    k_resp = list(0,10))


  # update metsulfuron
  sc <- metsulfuron %>%
    set_init(c(BM  = 5, E = 1,  M_int = 0)) %>%
    set_param(list(k_0 = 5E-5,
                   a_k =  0.25,
                   BM50 = 17600,
                   mass_per_frond = 0.1)) %>%
    set_exposure(exp) %>%
    set_param(params)

  sc <- sc %>%
    set_bounds(bounds)

  # Likelihood profiling
  suppressMessages(
    res <- lik_profile(x = sc,
                       data = obs,
                       output = "BM",
                       par = params,
                       refit = FALSE,
                       type = "fine",
                       method="Brent")
  )

  # parameter space explorer
  suppressMessages(
    Par_exp <- explore_space(x = list(caliset(sc, obs)),
                  par = params,
                  res = res,
                  output = "BM",
                  sample_size = 1000,
                  max_runs = 1,   # for speed, here put to 1, please increase for improved results
                  nr_accept = 100)
  )

  # tests
  expect_equal(ncol(Par_exp), 5)
  expect_equal(Par_exp[1,4], 0)
  expect_equal(Par_exp[1,5], "Original fit")
})
