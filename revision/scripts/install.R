# Project-only dependency installation; do not replace system libraries.
dir.create('revision/.Rlib',showWarnings=FALSE,recursive=TRUE)
install.packages(c('vroom','dplyr','readxl','digest'),lib='revision/.Rlib',repos='https://cloud.r-project.org')
