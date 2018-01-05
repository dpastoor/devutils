readme
=========

the overall build process uses remake. To use, 
from the packages/ folder simply run:

```
remake::make()
```

or to set up a script to run from the shell, run once:

```
remake::install_remake()
```


then can call via the plaform specific requirements:

windows: Rscript.exe .\remake
unix: ./remake


## usage

the package caching is built around monitoring the description file, so to re-fire the
doc/build/install flow, just 'kick' the DESCRIPTION file in some way - my suggestion
is via a change in the patch version, if nothing else applicable. This makes it easier
to check in your R session that you are using the most recent changes as well through `packageVersion()`