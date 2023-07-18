data {
  int<lower=0> I;
  int<lower=0> J;
  array[I, J] int<lower=0, upper=1> y;
  real<lower=0, upper=1> phi;
}
parameters {
  real<lower=0> sigma_theta;
  vector[J] theta;
  
  real<lower=0> sigma_a;
  vector<lower=0>[I] a;
  
  real mu_b;
  real<lower=0> sigma_b;
  vector[I] b;
}
model {
//  sigma_theta ~ cauchy(0, 2);
//  theta ~ normal(0, sigma_theta);
  
//  sigma_a ~ cauchy(0, 2);
//  a ~ lognormal(0, sigma_a);
  
//  mu_b ~ normal(0, 5);
//  sigma_b ~ cauchy(0, 2);
//  b ~ normal(mu_b, sigma_b);
  
  target += cauchy_lpdf(sigma_theta | 0, 2);
  target += normal_lpdf(theta | 0, sigma_theta);

  target += cauchy_lpdf(sigma_a | 0, 2);
  target += lognormal_lpdf(a | 0, sigma_a);

  target += normal_lpdf(mu_b | 0, 5);
  target += cauchy_lpdf(sigma_b | 0, 2);
  target += normal_lpdf(b | mu_b, sigma_b);

  for (i in 1 : I) {
    //    y[i] ~ bernoulli_logit(a[i] * (theta - b[i]));
    target += phi * bernoulli_logit_lpmf(y[i] | a[i] * (theta - b[i]));
  }
  
}