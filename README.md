docs-datadr
===========

Tutorial and package reference for datadr.

## How to contribute

- Fork and check out this repository
- Check out the [datadr](https://github.com/delta-rho/datadr) repository
- Change `code_path` in `build.R` to point to your checkout of the datadr repository
- Edit the files in `docs/*.Rmd`
- Generate the html output by running code in `build.R` or simply calling

```
./build
```

## To keep your fork in sync

If others are editing the docs as well and you want to keep your checkout in sync with what is live, do the following (in the repository directory):

One time only:

```
git remote add upstream https://github.com/delta-rho/docs-datadr
```

Each time you want to sync with the live version of the docs:

```
git fetch upstream
git merge upstream/gh-pages
```
