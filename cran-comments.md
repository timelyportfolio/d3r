# Comments

Everything passes in below test environments except in `winbuilder` R under development in which I see:

```
> library(dplyr)
Error: package or namespace load failed for 'dplyr':
 .onLoad failed in loadNamespace() for 'pillar', details:
  call: utils::packageVersion("vctrs")
  error: there is no package called 'vctrs'
```

I believe this has nothing to do with this package but rather a `pillar` install problem.  I see some reference to this on the Internet but unfortunately I have no way to fix on the test machine.

## Test environments
* local Windows 10 install, R 3.4.0
* winbuilder
* ubuntu 14.04.5 LTS (on travis-ci), R 3.5.0
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


