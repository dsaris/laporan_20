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


# Tabel kumulatif september
kumulatif_sep_20 <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQUYsfUgVYlVMpSWUj0U20y7GjAFgdPdNQhMxry-_31ekA_9i1KIlNHoiDgI0H0N1ady3g2SGQUICBU/pub?gid=1958899369&single=true&output=csv"
)
#kumulatif_sep_20$kumulatif.target <- gsub("Rp", "", kumulatif_sep_20$kumulatif.target)

kumulatif_sep_20$average.target <- as.numeric(gsub("[Rp.]","", kumulatif_sep_20$average.target))
kumulatif_sep_20$kumulatif.target <- as.numeric(gsub("[Rp.]","", kumulatif_sep_20$kumulatif.target))
kumulatif_sep_20$realisasi <- as.numeric(gsub("[Rp.]","", kumulatif_sep_20$realisasi))
kumulatif_sep_20$kumulatif.realisasi <- as.numeric(gsub("[Rp.]","", kumulatif_sep_20$kumulatif.realisasi))



#mengubah format tanggal
kumulatif_sep_20 <- kumulatif_sep_20 %>% mutate(tanggal2 =as.Date(tanggal, format= '%d/%m/%y'))

str(kumulatif_sep_20)

#Plot kumulatif
grafik_kum_sep20 <- kumulatif_sep_20 %>%
  filter(kumulatif.realisasi != "NA")




o <- ggplot(data=kumulatif_sep_20,
            aes(x=tanggal2)) +
  geom_line(aes(y = kumulatif.target), color = "darkred", size = 1) +
  geom_line(aes(y = kumulatif.realisasi), color = "steelblue", size = 1) +
  
  xlab("tanggal") +
  ylab("Rupiah") +
  ggtitle("Realisasi Sparepart Kumulatif September 2020") +
  scale_y_continuous(name = "Milyar Rupiah", limits = c(0, 5000000000), labels = scales::comma)+
  
  scale_x_discrete(name = "Tanggal", limits = c(1:31))
#theme(legend.position = c(0.25, 0.9),
#legend.direction = "horizontal")

###CONTOH GRAFIK LINE  
real_1910 <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTXftGEbiYGbiKKkaeFwB71A56xeRtXWUauTTzrLS09CZeFByCVzkRtxhY_-wknV6vJWLseqiPx5gSp/pub?gid=0&single=true&output=csv")
str(real_1910)
real_1910$NOM_material = as.numeric(as.character(real_1910$NOM_material))
#Grouping dan summary per tanggal
by_day <-  real_1910 %>%
  group_by(DAY) %>%
  summarise(
    total_harian = sum(NOM_material, na.rm = TRUE)) %>%
  mutate(kum_real=cumsum(total_harian)) %>%
  rename('tanggal' = 'DAY')


by_day$kum_real = as.numeric(as.character(by_day$kum_real))
View(by_day)
str(by_day)

tabel1 <- tibble(
  tanggal = 1:31, 
  target = 5000000000/31 
)

tabel1_cum <- tabel1 %>% mutate(kum_target=cumsum(target))
View(tabel1_cum)
str(tabel1_cum)
gabung1 <- left_join(tabel1_cum, by_day, by = 'tanggal') 
#gabung1$kum_real = as.numeric(as.character(gabung1$kum_real))
View(gabung1)
ggplot() + 
  geom_line(data = gabung1, aes(x = tanggal, y = kum_target), color = "green", size = 1) +
  geom_line(data = gabung1, aes(x = tanggal, y = kum_real), color = "red", size = 1) +
  xlab('Tanggal') +
  ylab('Jumlah') +
  ggtitle("Realisasi Material Oktober 2019") +
  scale_y_continuous(name = "Rupiah", limits = c(0, 6000000000), labels = scales::comma)+
  scale_x_discrete(name = "Tanggal", limits = c(1:31))+ 
  theme(legend.position = "top")

#ubah kolom name dan jadikan 1 variabel 
gabung2 <- rename(gabung1, 'rencana' = 'kum_target',
                  'realisasi' = 'kum_real') %>%
  select(c(1,3,5)) %>%
  gather ('rencana','realisasi', key = "Kategori", value = "jumlah")
gabung2$tanggal = as.numeric(as.character(gabung2$tanggal))
gabung2$kategori = as.numeric(as.character(gabung2$kategori))
str(gabung2)  


#Gambar grafik2
library(ggplot2)
library(plotly)

d <- ggplot(data=gabung2,
       aes(x=tanggal, y=jumlah, colour=Kategori)) +
  geom_line(size = 1) +
  xlab("tanggal") +
  ylab("Rupiah") +
  ggtitle("Realisasi Material Oktober 2019") +
  scale_y_continuous(name = "Rupiah", limits = c(0, 6000000000), labels = scales::comma)+
  scale_x_discrete(name = "Tanggal", limits = c(1:31))+
  theme(legend.position = c(0.25, 0.9),
        legend.direction = "horizontal")


# Barchart
db_sep <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRluAGgaJnIMXTovQBTozWFZYeVroT8cgZwmH6DdmiGBJ3bKbR_82Y0zJgimGh-HqOIpZVP7x3OgIGU/pub?gid=0&single=true&output=csv")

db_sep$TOTAL.BIAYA <- as.numeric(as.character(db_sep$TOTAL.BIAYA))
db_sep$TARGET.AJUAN <- as.numeric(as.character(db_sep$TARGET.AJUAN))
db_sep$Realisasi <- as.numeric(as.character(db_sep$Realisasi))


db_09_20<-gather(db_sep, kategori, jumlah, TOTAL.BIAYA:Realisasi)

bar_db_09_20 <- db_09_20 %>% group_by(kategori) %>%
  summarize( tot = sum(jumlah, na.rm = TRUE)) 

p<-ggplot(bar_db_09_20, aes(x=kategori, y=tot, fill=kategori)) +
  geom_bar(stat="identity")+theme_minimal() +
  
  xlab("Kategori") +
  ylab("Rupiah") +
  ggtitle("SUMMARY BIAYA MATERIAL SEPTEMBER") +
  scale_y_continuous(name = "Milyar Rupiah", limits = c(0, 12000000000), labels = scales::comma)

ggplotly(p)



#alternatif geomline
View(kumulatif_sep_20)
kumulatif_sep_20 <- select(kumulatif_sep_20, tanggal2, kumulatif.target, kumulatif.realisasi)


akumulatif_sep_20 <- gather(kumulatif_sep_20, "KATEGORI", "TOTAL", kumulatif.target:kumulatif.realisasi)


ggplot(akumulatif_sep_20, aes(x=tanggal2, y=TOTAL, color=KATEGORI)) +
  geom_line(aes(y = TOTAL), size = 1, alpha=0.8)+
  geom_point(aes(y = TOTAL), size = 2, alpha=1)+
  scale_color_manual(values=c("#ff6550", "#15D7F9"))
  






