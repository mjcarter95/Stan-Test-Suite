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
      temp += Beta[j + 1] * Xkernel[(i - 1) * Clength + j];
    }
    
    mu[i] = exp(temp);
    target += phi * poisson_lpmf(y[i] | mu[i]);
  }
  
  for (i in 2 : M) {
    target += -log(Gamma) - abs(Beta[i] / Gamma) ^ q;
  }
}

