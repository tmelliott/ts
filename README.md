
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ts

<!-- badges: start -->

<!-- badges: end -->

The **ts** package makes it easy for users to write functions that can
be used in [**rserve-ts**](https://www.npmjs.com/package/rserve-ts)
applications.

## Installation

You can install the development version of ts from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tmelliott/ts")
```

## Example

Writing functions is easy, just use the `ts_*()` functions to define
formals and return types.

``` r
library(ts)
app <- ts_list(
  add = ts_fun(
    function(x, y) {
      x + y
    },
    x = ts_number(1),
    y = ts_number(1),
    # ideally this will use a generic type where x OR y can be vectors
    # and, if one is a vector, the return type will be a vector too...
    result = r_numeric(1)
  ),
  sample = ts_fun(
    function(x, n) {
      sample(x, n)
    },
    x = ts_string(),
    n = ts_number(1),
    result = r_character()
  )
)

ts_compile(app)
```

This will generate the following rserve-ts function definitions:

``` typescript
import { types as R } from "rserve-ts";

export const app = {
  add: z.function(
    z.tuple([z.number(), z.number()]),
    z.promise(R.numeric(1))
  ),
  sample: z.function(
    z.tuple([z.array(z.string()), z.integer()]),
    z.promise(R.character())
  )
};
```

which will generate the following types:

``` typescript
type App = {
  add: (x: number, y: number) => Promise<Robj.Numeric<1>>;
  sample: (x: string[], n: number) => Promise<Robj.Character>;
};
```

## State of the project

Here’s what’s currently working:

``` r
library(ts)

myfun <- ts_function(mean, x = ts_numeric(), result = ts_numeric(1))
myfun(1:5)
#> [1] 3

myfun("hello world")
#> Error: Expected a number

cat(readLines("tests/testthat/app.R"), sep = "\n")
#> library(ts)
#> 
#> fn_mean <- ts_function(mean, x = ts_numeric(), result = ts_numeric(1))
#> fn_first <- ts_function(function(x) x[1],
#>     x = ts_character(-1), result = ts_character(1)
#> )
#> 
#> sample_num <- ts_function(
#>     sample,
#>     x = ts_numeric(0),
#>     result = ts_numeric(1)
#> )

ts_compile("tests/testthat/app.R", file = "")
#> import { stringArray, character, numeric } from 'rserve-ts';
#> 
#> const fn_first = R.ocap([z.union([z.string(), stringArray])], character(1)]);
#> const fn_mean = R.ocap([z.union([z.number(), z.instanceof(Float64Array)])], numeric(1)]);
#> const sample_num = R.ocap([z.instanceof(Float64Array)], numeric(1)]);
```

## TODO

  - [ ] Add support for more types

  - [ ] Allow generic types (e.g., `<T>(x: T) => T`)

  - [ ] Add support for conditional return types
    
    e.g., `const sample = <T, N extends number>(x: T[], n: N) => N
    extends 1 ? T : T[]`

  - [ ] Function overloads? Perhaps just a wrapper around several
    function definitions…
