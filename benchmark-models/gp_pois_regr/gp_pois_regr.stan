data {
  int<lower=1> N;
  array[N] real x;
  array[N] int k;
  real<lower=0, upper=1> phi;
}
parameters {
  real<lower=0> rho;
  real<lower=0> alpha;
  vector[N] f_tilde;
}
transformed parameters {
  vector[N] f;
  {
    matrix[N, N] cov = gp_exp_quad_cov(x, alpha, rho)
                       + diag_matrix(rep_vector(1e-10, N));
    matrix[N, N] L_cov = cholesky_decompose(cov);
    f = L_cov * f_tilde;
  }
}
model {
  //  rho ~ gamma(25, 4);
  // alpha ~ normal(0, 2);
  // f_tilde ~ normal(0, 1);
  
  target += normal_lpdf(f_tilde | 0, 1);
  target += gamma_lpdf(rho | 25, 4);
  target += normal_lpdf(alpha | 0, 2);
  
  // k ~ poisson_log(f);
  target += phi * poisson_log_lpmf(k | f);
}

