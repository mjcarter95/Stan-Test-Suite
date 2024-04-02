data {
  int<lower=1> N; // Number of data
  int<lower=1> M; // Dimension of Beta
  real<lower=0> q; // prior on EP q \in (0,2)
  int<lower=1> Clength; // Dimension of Beta
  array[N] int y; // Observations
  array[N * Clength] real Xkernel; // Precalculated Gaussian kernel a 1- vector representing a N*Clength matrix
  real<lower=0, upper=1> phi;
}
parameters {
  array[M] real Beta;
  real<lower=0> Gamma;
}
model {
  array[N] real mu;
  real temp;
  
  target += inv_gamma_lpdf(Gamma | 2, 1.3);
  
  for (i in 1 : N) {
    temp = Beta[1];
    
    for (j in 1 : Clength) {
      temp += (Beta[j + 1] * Xkernel[(i - 1) * Clength + j]);
    }
    
    mu[i] = exp(temp);
    target += phi * poisson_lpmf(y[i] | mu[i]);
  }
  
  for (i in 2 : M) {
    target += -log(Gamma) - fabs(Beta[i] / Gamma) ^ q;
  }
}

Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/PRMwCD/PRMwCD.stan', line 6, column 2: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/PRMwCD/PRMwCD.stan', line 7, column 2: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/PRMwCD/PRMwCD.stan', line 12, column 2: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/PRMwCD/PRMwCD.stan', line 18, column 2: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/PRMwCD/PRMwCD.stan', line 37, column 28: fabs
    is deprecated and will be removed in Stan 2.33.0. Use abs instead. This
    can be automatically changed using the canonicalize flag for stanc
