#script ini untuk menyimpan daftar alamat file csv google sheet yang berkaitan dengan 
#website daftar ajuan dan realisasi activity 2020

#Daftar ajuan mso 2020
#https://docs.google.com/spreadsheets/d/e/2PACX-1vT5NOKrXq2ABEnoW8c9pX4lKRA_rB1nNkbhOa934mXIB6OFwO9_9g6bBnw848nO3vqPiXnRskpV2osy/pub?gid=0&single=true&output=csv

library(kableExtra)
library(knitr)
library(tidyverse)
library(stringr)
library(DT)
library(lubridate)
library(scales)

ajuan_mso <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vT5NOKrXq2ABEnoW8c9pX4lKRA_rB1nNkbhOa934mXIB6OFwO9_9g6bBnw848nO3vqPiXnRskpV2osy/pub?gid=0&single=true&output=csv")

str(ajuan_mso)
ajuan_mso$PLANT <- month.abb[ajuan_mso$PLANT]
total_ajuan <- ajuan_mso %>%
                select(PLANT, NAMA.SEKSI.PLANNER, EQUIP, RENCANA.KEGIATAN, STOCK.NO., NAMA.MATERIAL...JASA, SAT, QTY, TOTAL.BIAYA) %>%
                rename(Bulan = PLANT,
                       UNITKERJA = NAMA.SEKSI.PLANNER,
                       Equipment = EQUIP
                       
                       )
str(total_ajuan)  

datatable(total_ajuan)

  
  
  
  
  
  








