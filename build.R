## install packagedocs if not installed:
# options(repos = c(tessera = "http://packages.deltarho.org",
#   getOption("repos")))
# install.packages("packagedocs")

library(datadr)
library(housingData)
knitr::opts_knit$set(root.dir = normalizePath("."))

packagedocs::render_docs(
  code_path = "~/Documents/Code/DeltaRho/datadr",
  docs_path = ".",             # location of docs directory
  package_name = "datadr",     # name of the package
  main_toc_collapse = TRUE,    # use collapsing toc on main page
  rd_toc_collapse = TRUE,      # use collapsing toc on rd page
  lib_dir = "assets",          # put assets in "assets" directory
  render_main = TRUE,          # render main page
  render_rd = TRUE,            # render rd page
  view_output = TRUE,          # look at the output after render
  rd_index = "./rd_index.yaml" # optional path to rd layout yaml
)
