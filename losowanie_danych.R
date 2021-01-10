require(randomNames)
require(stringi)
require(stringr)
require(maps)
require(dplyr)
require(lubridate)
require(DescTools)

data("world.cities")
#klienci: imie, nazwisko, kraj, data urodzenia, ulica, nr domu, miasto, kod pocztowy, pesel, nr telefonu
n_klientow <- 100

make_months <-function(m){
  if (str_length(as.character(m)) == 1){m = paste("0", m, sep = "")}
  else m = as.character(m)
  m
}

random_date <- function(n) {
  years <- sample(1900:2020, n, replace = TRUE)
  dates <- sample(seq(as.Date("2021/01/01"), as.Date("2021/12/31"),by = "day"),n)
  months <- month(dates)
  months <- sapply(months, make_months)
  days <- day(dates)
  paste(years,months,days,sep='-')
}


pesel_generator_z_daty <- function(wiersz){
  data <- wiersz["data"]
  kraj <- wiersz["kraj"]
  if (kraj=="Polska"){
    years <- str_sub(strsplit(data, "[-]")[[1]][1], 3,4)
    months <- strsplit(data, "[-]")[[1]][2]
    days <-  strsplit(data, "[-]")[[1]][3]
    rest <- stri_rand_strings(1, 5, pattern = "[0-9]") # patrzymy tyko zeby zgadzala sie liczba znakow, nie bawimy sie w sumy kontrolne
    return(paste(sprintf("%02d", as.integer(years)), sprintf("%02d", as.integer(months)), sprintf("%02d", as.integer(days)), rest, sep=''))
  }
  else{return(NA)}
}

apply(data.frame("kraj" = c("Polska", "Niemcy"), "data" = random_date(2)),1, pesel_generator_z_daty)


niemieckie_miasta <- world.cities[world.cities[2]=="Germany",][,1]
niemieckie_ulice <- c("Ackerstrasse","Bernauerstrasse","Frankfurter Allee","Invalidenstrasse","Silvio Meier Strasse","Legiendamm Allee","Mozartstrasse")
polskie_miasta <- world.cities[world.cities[2]=="Poland",][,1]
polskie_ulice <- c("Miodowa","Krakowska","Legionowa","Szkolna","Graniczna","Pokorna","Rycerska","Piwna","Boczna","Cicha")
francuskie_miasta <- world.cities[world.cities[2]=="France",][,1]
francuskie_ulice <- c("Avenue Victor Hugo","Avenue Montaigne","Rue de Rivoli","Passages Couverts","Boulevard de Clichy","Avenue de Lopera","Rue de la Paix")
adresy <- data.frame("kraj" = sample(c("Polska", "Niemcy", "Francja"), n_klientow, replace = TRUE),"miasto"=rep(NA,n_klientow),"kod_pocztowy"=rep(NA,n_klientow),"ulica"=rep(NA,n_klientow),"nr_domu"=rep(NA,n_klientow))
losuj_adres_dla_kraju <- function(wiersz) {
  kraj <- wiersz[1]
  if (kraj=="Polska"){
    wiersz[2] = sample(polskie_miasta,1)
    wiersz[3] = paste(sample(10:99,1),"-",sample(100:999,1),sep="")
    wiersz[4] = sample(polskie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }
  else if(kraj=="Francja"){
    wiersz[2] = sample(francuskie_miasta,1)
    wiersz[3] = sample(10000:99999,1)
    wiersz[4] = sample(francuskie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }
  else if(kraj=="Niemcy"){
    wiersz[2] = sample(niemieckie_miasta,1)
    wiersz[3] = sample(10000:99999,1)
    wiersz[4] = sample(niemieckie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }
  return(wiersz)
}

# ogarnąć żeby doklejać pesele
adresy <- t(apply(adresy,1,losuj_adres_dla_kraju))
klienci_rand <- data.frame("imie" = randomNames(n_klientow, ethnicity = 5, which.names = "first"),
                           "nazwisko" = randomNames(n_klientow, ethnicity = 5, which.names = "last"),
                           "data" = random_date(n_klientow),
                           "kraj" = adresy[,"kraj"],
                           "ulica" = adresy[,"ulica"],
                           "nr_domu" = adresy[,"nr_domu"],
                           "miasto" = adresy[,"miasto"],
                           "kod_pocztowy" = adresy[,"kod_pocztowy"],
                           "nr_telefonu" = stri_rand_strings(n_klientow, 9, pattern = "[0-9]"))

klienci_rand <- cbind( klienci_rand, "pesel" = apply(klienci_rand, 1, pesel_generator_z_daty))




# przewodnicy 
n_przewodnikow <- 30
przewodnicy_rand <- data.frame("imie" = randomNames(n_przewodnikow, ethnicity = 5, which.names = "first"),
                               "nazwisko" = randomNames(n_przewodnikow, ethnicity = 5, which.names = "last"),
                               "nr_telefonu" = stri_rand_strings(n_przewodnikow, 9, pattern = "[0-9]"))
emaile <- apply(przewodnicy_rand, 1, function(x){
  mail <- paste(str_to_lower(str_replace_all(x["imie"], " ", "_")), ".",
                str_to_lower(str_replace_all(x["nazwisko"], " ", "_")),
                "@biuro_bazy.com", sep = "")})
przewodnicy_rand <- cbind(przewodnicy_rand, emaile)


#oferty

n_ofert <- 20
world.cities %>%
  filter( pop > 300000) -> cities

oferty_rand <- data.frame("miejsce_wyjazdu" = sample(cities[["name"]], n_ofert,replace = TRUE),
                          
                          "limit_uczestnikow" = sample(10:35, n_ofert, replace = TRUE),
                          "dlugosc" = sample(2:14, n_ofert, replace = TRUE))
oferty_rand %>% 
  mutate("cena" = sample(400:1200, n_ofert) * dlugosc) -> oferty_rand
templatka_opisu <- c("Wspanialy wyjazd do city! Niewiarygodne przeżycia gwarantowane. Zrelaksuj sie az liczba_dni dni. W ramach wyjazdu wiele niesamowitych atrakcji.")

oferty_rand %>%
  mutate("opis" =  str_replace(templatka_opisu, "city", miejsce_wyjazdu )) %>%
  mutate(opis = str_replace(opis, "liczba_dni", as.character(dlugosc))) -> oferty_rand

oferty_rand %>%
  mutate("oferta_id" = 1:n_ofert) -> oferty_rand

# wycieczki
n_wycieczek <- 50
wycieczki_rand <- data.frame("oferta_id" = sample(oferty_rand$oferta_id,n_wycieczek, replace = TRUE))
wycieczki_rand %>%
  left_join( oferty_rand[,c("oferta_id", "dlugosc", "limit_uczestnikow")], by = "oferta_id")%>%
  mutate("data_rozpoczecia" = sample(seq(as.Date("2021/01/01"), as.Date("2021/12/31"),by = "day"), n_wycieczek, replace = TRUE)) %>%
  mutate("data_zakonczenia" = data_rozpoczecia + dlugosc) %>%
  mutate("liczba_uczestnikow" = sapply(limit_uczestnikow, function(x) {
    sample(seq(5, x, by = 1), 1)
    })) %>%
  select(!c(dlugosc, liczba_uczestnikow)) -> wycieczki_rand

# tagi
tagi_rand <- data.frame("nazwa_tagu" = c("morze", "zagranica", "kasyna", "jezioro", "hotel", "gory", "autokar", "samolot", "widoki"))
tagi_rand %>% 
  mutate("opis" = str_replace("To jest bardzo ladny opis tego o tutaj tagu - tag_holder", "tag_holder", nazwa_tagu)) -> tagi_rand

# atrakcje 
atrakcje_rand <- data.frame("nazwa_atrakcji" = c("kino", "teatr", "muzeum", "basen", "kregle", "dyskoteka",
                                                 "bar", "safari", "lot balonem", "zwiedzanie", "sesja zdjeciowa"))
atrakcje_rand%>%
  mutate("opis_atrakcji" = str_replace("W ramach wyjazdu - placeholder", "placeholder", nazwa_atrakcji)) %>%
  mutate("czy_dla_dzieci" = c(T,T,T,T,T, F, F, F, T, T, T)) -> atrakcje_rand

 platnosci <- c("karta", "gotowka", "przelew_internetowy", "przelew_tradycyjny", "paypal", "voucher")

#losowanie tagów do ofert
n_otagowan <- 200
#potem bedzie sciagniete z tabeli, na razie 1:nrow(tagi_rand) i 1:nrow(oferty_rand)
id_tagi <- 1:nrow(tagi_rand)
id_ofert <- 1:nrow(oferty_rand)

tagi_ofert <- data.frame("tag_id" = sample(id_tagi, n_otagowan, replace = TRUE),
                         "oferta_id" = sample(id_ofert, n_otagowan, replace = TRUE))
tagi_ofert_rand <- tagi_ofert %>% 
  distinct(`tag_id`, `oferta_id`)

# losowanie atrakcji wycieczek
n_atrakcji_w_ofertcie <- 200
#potem bedzie sciagniete z tabeli, na razie 1:nrow(atrakcje_rand) i 1:nrow(oferty_rand)
id_atrakcji <- 1:nrow(atrakcje_rand)
id_ofert <- 1:nrow(oferty_rand)

atrakcje_ofert <- data.frame("atrakcja_id" = sample(id_atrakcji, n_atrakcji_w_ofertcie, replace = TRUE),
                         "oferta_id" = sample(id_ofert, n_atrakcji_w_ofertcie, replace = TRUE))
atrakcje_ofert_rand <- atrakcje_ofert %>% 
  distinct(`atrakcja_id`, `oferta_id`)

#klasy ofert
klasy_ofert <- data.frame("mnoznik" = c(1.25, 1.5, 2),
                          "opis" = c("dostep do nielimitowanych przekasek",
                                     "dostep do nielimitowanych przekasek, pierwszenstwo w wyborze pokoju",
                                     "klasa VIP, pokoje VIP, trasport VIP"))


# zamowienia: klient_id, wycieczka_id, liczba_osob, klasa_oferty, sposob_platnosci

# n_zamowien <- 250
# #tymczasowo, potem trzeba zaci?gn?? z bazy
# id_wycieczki <- 1:n_wycieczek
# trwanie<-as.integer(unlist(wycieczki_rand["data_zakonczenia"]-wycieczki_rand["data_rozpoczecia"]))
# limit<-wycieczki_rand["limit_uczestnikow"]
# wycieczki<-wycieczki_rand
# 
#
# generator_zamowien <- function(wycieczki, oferty){
#temp
# 
# 
#   id_wycieczki <- 1:n_wycieczek
#   limit <- wycieczki["limit_uczestnikow"]
#   
#   klienci <- sample(1:n_klientow,n_zamowien,replace = TRUE)
#   wyjazdy <- sample(1:n_wycieczek,n_zamowien,replace=TRUE)
#   liczba <- sample(1:5,n_zamowien,replace=TRUE) # liczba ludzi w jednym zamówieniu
#   
#   limity_wyjazdow<-limit[wyjazdy]
#   poczatek_wyjazdu<-wycieczki[,2][wyjazdy]
#   koniec_wyjazdu<-wycieczki[,3][wyjazdy]
#   
# tymczasowe_zamowienia<-data.frame(klienci=klienci,wyjazdy=wyjazdy,liczba_osob=liczba,limity=limity_wyjazdow,poczatek=poczatek_wyjazdu,koniec=koniec_wyjazdu, tymczasowe_id = 1:n_zamowien)
#   for(i in 1:n_zamowien){
#     if (tymczasowe_zamowienia[[3]][i]<=tymczasowe_zamowienia[[4]][i]){
#       tymczasowe_zamowienia[[4]][i]=tymczasowe_zamowienia[[4]][i]-tymczasowe_zamowienia[[3]][i]
#     }else(tymczasowe_zamowienia[[3]][i]>tymczasowe_zamowienia[[4]][i] & tymczasowe_zamowienia[[4]]>0){
#       tymczasowe_zamowienia[[3]][i]=tymczasowe_zamowienia[[4]]
#     }else{
#       tymczasowe_zamowienia=tymczasowe_zamowienia[-c(i),] # uznalam ?e latwiej niz sie bawic b?dzie po prostu usunac te kilka zam?wie? co nie b?d? pasowac, nadal powinno zosta? sporo zamowien
#     }
#   }
#   for(i in unique(klienci)){
#     zamowienie<-tymczasowe_zamowienia[tymczasowe_zamowienia[["klienci"]]==i,]
#     daty<-zamowienie[c(5:7)]
#     daty <- daty[order(daty[[1]],decreasing = FALSE),]
#     ilosc_dat<-length(daty[[1]])
#     for (k in 1:ilosc_dat-1){
#       if(Overlap(c(daty[k,1],daty[k,2]),c(daty[k+1,1],daty[k+1,2]))>0){
#         zle_id <- daty[k, "tymczasowe_id"]
#         tymczasowe_zamowienia <- tymczasowe_zamowienia["tymczasowe_id"!=zle_id,]
#       }
#     }
#   }
#   zamowienia <- data.frame("klient" = klienci,
#                          "wycieczka" = wyjazdy,
#                          "liczba_osob" = liczba,
#                          "klasa" = sample(1:3,n_zamowien,replace=TRUE), #zakladajac ze bedziemy miec 3 klasy, bo jeszcze nie wiem ile
#                          "platnosc" = sample(platnosci,n_zamowien,replace=TRUE)
#                          )
#   return(zamowienia)
# }
# generator_zamowien(wycieczki_rand)



# przewodnictwa

generator_przewodnictw <- function(wycieczki,n_przewodnictw,przewodnicy){
  n_wycieczek<-nrow(wycieczki)
  n_przewodnikow<-nrow(przewodnicy)
  
  przewodnictwa_rand <- data.frame("wycieczka_id" = sample(1:n_wycieczek, n_przewodnictw, replace = TRUE),
                           "przewodnik_id" = sample(1:n_przewodnikow, n_przewodnictw, replace = TRUE))
  przewodnictwa_rand %>% 
    distinct(`wycieczka_id`, `przewodnik_id`) -> przewodnictwa_rand
  przewodnictwa_rand %>%
    left_join(wycieczki[,c("wycieczka_id", "data_rozpoczecia", "data_zakonczenia")], by = "wycieczka_id") -> przewodnictwa_rand_daty

  tymczasowe_przewodnictwa<-przewodnictwa_rand_daty
  for(i in unique(tymczasowe_przewodnictwa[,"przewodnik_id"])){
    przewodnictwo<-tymczasowe_przewodnictwa[tymczasowe_przewodnictwa[,"przewodnik_id"]==i,]
    przewodnictwo<-przewodnictwo[order(przewodnictwo[,"data_rozpoczecia"],decreasing = FALSE),]
    ilosc_dat<-length(przewodnictwo[[1]])
    if(ilosc_dat<2){next}
    for (k in 1:(ilosc_dat-1)){
      if(przewodnictwo[k+1,"data_rozpoczecia"]<=przewodnictwo[k,"data_zakonczenia"]){
        zle_id <- przewodnictwo[k, "wycieczka_id"]
        tymczasowe_przewodnictwa <- tymczasowe_przewodnictwa["wycieczka_id"!=zle_id,]
      }
    }
  }
  zamowienia <- data.frame("przewodnik_id" = tymczasowe_przewodnictwa[,"przewodnik_id"],
                         "wycieczka_id" = tymczasowe_przewodnictwa[,"wycieczka_id"]
                         )
  return(zamowienia)
}
przewodnictwa_rand<-generator_przewodnictw(cbind("wycieczka_id"=1:nrow(wycieczki_rand),wycieczki_rand),200,przewodnicy_rand)
