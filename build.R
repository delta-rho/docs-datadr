## load packages (and install if not on system)
if(!requireNamespace("devtools"))
  install.packages("devtools")
if(!require("staticdocs"))
  devtools::install_github("hadley/staticdocs")
if(!require("packagedocs"))
  devtools::install_github("hafen/packagedocs")
if(!require("rmarkdown"))
  install.packages("rmarkdown")
if(!require("datadr"))
  devtools::install_github("tesseradata/datadr")
if(!require("housingData"))
  devtools::install_github("hafen/housingData")

# make sure your working directory is set to repo base directory
#code_path <- "~/Documents/Code/Tessera/hafen/datadr"
code_path <- "~/Work/github/datadr"

# set some options
pdof <- package_docs(lib_dir = "assets", toc_collapse = TRUE)
knitr::opts_knit$set(root.dir = normalizePath("."))

# generate code/*.R files
purl_docs()

# generate index.html
unlink("assets", recursive = TRUE)
render("index.Rmd", output_format = pdof)
check_output("index.html")

## This is a nasty hack to get around this error when I run .\build :
## Error in pkg_sd_path(pkg, site_path = site_path) : 
##   Folder inst/staticdocs doesn't exist. Specify site_path or create a package folder inst/staticdocs.
## Calls: source ... render_rd -> rd_template -> as.sd_package -> pkg_sd_path

## If I make sure inst/staticdocs exists in the package source, then staticdocs::pkg_sd_path() is happy

# If inst is not there, create it
if(!file.exists(instPath <- file.path(code_path, "inst"))) {
  dir.create(instPath)
  existed_instPath <- FALSE
} else {
  existed_instPath <- TRUE
}

# If inst/staticdocs is not there, create it
if(!file.exists(staticdocPath <- file.path(instPath, "staticdocs"))) {
  dir.create(staticdocPath)
  existed_staticdocPath <- FALSE
} else {
  existed_staticdocPath <- TRUE
}

# generate rd.html
render_rd("rd_skeleton.Rmd", "datadr", code_path,
  rd_index = "rd_index.yaml", output_format = pdof)
check_output("rd.html")

# Remove the staticdocs directory if it didn't previously exist
if(!existed_staticdocPath)
  unlink(staticdocPath, recursive = TRUE)
# Remove the inst directory if it didn't previously exist
if(!existed_instPath)
  unlink(instPath, recursive = TRUE)

# system("open rd.html")

# Open the viewer
system("open index.html")

# # get topics
# db <- tools::Rd_db("datadr")
# gsub("\\.Rd", "", names(db))
