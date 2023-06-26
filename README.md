# Stan Test Suite
This repository contains a collection of Stan models from the following sources:
* benchmark-models: From the Stan statistical comparison benchmarks repository, see [here](https://github.com/stan-dev/example-models)
* example-models: From the Stan example models repository, see [here](https://github.com/stan-dev/example-models)

All .data.R files associated with a model have been converted to JSON format.

## Pulling this repository

```
git clone https://github.com/mjcarter95/Stan-Test-Suite.git
cd Stan-Test-Suite
git submodule update --init --recursive
```