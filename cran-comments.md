## Comments
Resolution of test failure and suggestions by Prof. Brian Ripley

"
See https://cran.r-project.org/web/checks/check_results_d3r.html

This is failing as

> file.path(v3_offline$src$href,v3$script)
[1] "https://unpkg.com/d3@3.5.17//d3.min.js"

and the site does not currently allow that double / (it does in some of the other URLs).  The trailing / is hard-coded in d3_dep_v3.

Please replace by something that much less fragile, ASAP.

While we are at it

Description: Helper functions for using 'd3.js' in R.

does not give any indication of that it does -- the manual asked for

'The mandatory ‘Description’ field should give a comprehensive description of what the package does. One can use several (complete) sentences, but only one paragraph. It should be intelligible to all the intended readership (e.g. for a CRAN package to all CRAN users).'
"

## Test environments
* local Windows 10 install, R 3.4.0
* ubuntu 14.04.5 LTS (on travis-ci), R 3.4.1
* rhub check_for_cran

## R CMD check results

0 errors | 0 warnings | 1 notes

```
* checking package dependencies ... NOTE
Packages which this enhances but not available for checking:
  ‘igraph’ ‘partykit’ ‘rpart’ ‘treemap’
```

R CMD check succeeded

## Reverse dependencies

Checked sunburstR: 0 errors | 0 warnings | 0 notes


