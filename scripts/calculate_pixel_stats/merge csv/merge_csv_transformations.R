
mydf <- data.frame()
t_path <- "Y:/colorspace_transformations"
dir_list <- list.files(t_path)

for (i in 1:length(dir_list)) {
  f_list <- list.files(paste0(t_path, "/", dir_list[i]))
  for (j in 1:length(f_list)) {
    mycsv <- read.csv(paste0(t_path, "/", dir_list[i], "/", f_list[j], "/drone/pix_values.csv"))
    mycsv[ ,1] <- f_list[j]
    if (dir_list[i] == "gray") {
      mycsv$GPixVar <- mycsv$GrayPixVar
      mycsv$BPixVar <- mycsv$GrayPixVar
      colnames(mycsv)[3] <- "RPixVar"
    }
    mycsv$transformation <- dir_list[i]
    mydf <- rbind(mydf, mycsv)
  }
}

write.csv(mydf, "Y:/Aviv/ArcGIS/CoralSFM/data/TOT_pix_values.csv", row.names = F)

library(reshape2)

mydf2 <- dcast(setDT(mydf),  X + cell ~ transformation, value.var = c("RPixVar", "GPixVar", "BPixVar"))


write.csv(mydf2, "C:/Users/Aviv/colorspace/master/TOT_pix_values.csv", row.names = F)

