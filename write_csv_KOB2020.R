library(kableExtra)
library(knitr)
library(tidyverse)
library(stringr)
library(DT)
library(lubridate)
library(scales)
library(RCurl)



real_kob_2020_agt <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQRCjDFPAbRWG29tZi-ElqxltS79tuT4Yhn4LfTUYJVufwjtad25YJp4rsFPCrC1SEg_4A_V3IITH6B/pub?gid=0&single=true&range=A1:AK21613&chrome=false&output=csv")

real_kob_2020_sep <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQUYsfUgVYlVMpSWUj0U20y7GjAFgdPdNQhMxry-_31ekA_9i1KIlNHoiDgI0H0N1ady3g2SGQUICBU/pub?gid=0&single=true&output=csv")

real_kob_2020_okt <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vT8rvKbveA6zpqnmjRLfpkFszVZWSVHhLsx0Ldxhpj_SRv5L7aO9oBKGEVzjqeWPiDCY_a45FFRMYwc/pub?gid=0&single=true&output=csv")

real_kob_2020_nop <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQIvsNVJyuQNIpTzUzQ-ja9F0VTE9kCNby-EeLX5bvfDoMY_0SPkkXkpytVJ21iaUub526CVokhPVeX/pub?gid=0&single=true&output=csv")

real_kob_2020_des <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRTg75PePS-rwn6bt7OpCbvn4CBNbhjiYZHgYmKjlh1OhVBdmCOx9VugmsAufPP2AbPPDbm_8NkEh7c/pub?gid=0&single=true&output=csv")
#Gabungkan realisasi 2020
real_kob_2020 <- rbind(real_kob_2020_agt, real_kob_2020_sep, real_kob_2020_okt, real_kob_2020_nop, real_kob_2020_des)


#tulis csv
library(xl)

write.csv(real_kob_2020,"D:\\olahdata_R\\real_kob_2020.csv", row.names = FALSE)

saveRDS(real_kob_2020, file = "D:\\olahdata_R\\real_kob_2020.rds")



#menggunakan library googlesheets4
library(googledrive)
drive_find(n_max = 30)






