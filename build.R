## if you haven't installed buildDocs:
# library(devtools)
# install_github("buildDocs", "hafen")

library(buildDocs)
library(staticdocs)

# make sure your working directory is set to repo base directory

buildFunctionRef(
   packageLoc = "~/Documents/Code/Tessera/hafen/datadr",
   outLoc = ".",
   navPill = packageNavPill("https://github.com/tesseradata/datadr", docsActive = FALSE),
   copyrightText = "Tessera"
)

buildDocs(
   docsLoc = "docs",
   outLoc = ".",
   pageList = c("1intro.Rmd", "2data.Rmd", "3dnr.Rmd", "4mr.Rmd", "5divag.Rmd", "6backend.Rmd", "7faq.Rmd"),
   navPill = packageNavPill("https://github.com/tesseradata/datadr"),
   copyrightText = "Tessera",
   root.dir = "."
)
