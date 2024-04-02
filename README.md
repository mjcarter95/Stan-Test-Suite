# Stan Test Suite
This repository contains a collection of Stan models from the following sources:
* benchmark-models: From the Stan statistical comparison benchmarks repository, see [here](https://github.com/stan-dev/stat_comp_benchmarks)
* example-models: From the Stan example models repository, see [here](https://github.com/stan-dev/example-models)

The `gold_standards` folder contains mean, standard deviation, skew and kurtosis estimates and parameter names for each Stan model. These gold standars are generated from a single MCMC chain with 50,000 warm-up iterations and 50,000 sampling iterations. Where possible, we estimate the step-size of each model by `np.mean(step_size * diag_mass_matrix)`, if we are unable to calculate this value, we return the step-size from the model config or 0.5. 

All .data.R files associated with a model have been converted to JSON format.

## Pulling this repository

```
git clone https://github.com/mjcarter95/Stan-Test-Suite.git
cd Stan-Test-Suite
git submodule update --init --recursive
```
