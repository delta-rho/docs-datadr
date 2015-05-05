## load packages (and install if not on system)
if(!require("staticdocs"))
  devtools::install_github("hadley/staticdocs")
if(!require("packagedocs"))
  devtools::install_github("hafen/packagedocs")
if(!require("rmarkdown"))
  install.packages("rmarkdown")
if(!require("datadr"))
  devtools::install_github("tesseradata/datadr")

# make sure your working directory is set to repo base directory
code_path <- "~/Documents/Code/Tessera/hafen/datadr"

# set some options
pdof <- package_docs(lib_dir = "assets", toc_collapse = TRUE)
knitr::opts_knit$set(root.dir = normalizePath("."))

# generate code/*.R files
purl_docs()

# generate index.html
unlink("assets", recursive = TRUE)
render("index.Rmd", output_format = pdof)
check_output("index.html")
system("open index.html")

# generate rd.html
render_rd("rd_skeleton.Rmd", "datadr", code_path,
  rd_index = "rd_index.yaml",output_format = pdof)
check_output("rd.html")
system("open rd.html")

# # get topics
# db <- tools::Rd_db("datadr")
# gsub("\\.Rd", "", names(db))
