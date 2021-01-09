require(randomNames)
require(stringi)
require(stringr)
require(maps)
require(dplyr)
require(lubridate)
require(DescTools)

#klienci: imie, nazwisko, kraj, data urodzenia, ulica, nr domu, miasto, kod pocztowy, pesel, nr telefonu
n_klientow <- 100
random_date <- function(n) {
  years <- sample(1:99, n, replace = TRUE)
  months <- sample(c(1:12, 21:22),n, replace = TRUE)
  days <- sample(1:28, n, replace = TRUE)
  paste(years,months,days,sep='-')
}
pesel_generator_z_daty <- function(wiersz){
  data <- wiersz[3]
  kraj <- wiersz[4]
  if (kraj=="Polska"){
    years <- strsplit(data, "[-]")[[1]][1]
    months <- strsplit(data, "[-]")[[1]][2]
    days <-  strsplit(data, "[-]")[[1]][3]
    rest <- stri_rand_strings(1, 5, pattern = "[0-9]") # patrzymy tyko zeby zgadzala sie liczba znakow, nie bawimy sie w sumy kontrolne
    return(paste(sprintf("%02d", as.integer(years)), sprintf("%02d", as.integer(months)), sprintf("%02d", as.integer(days)), rest, sep=''))
  }else{return(NULL)}
}
niemieckie_miasta <- world.cities[world.cities[2]=="Germany"]
niemieckie_ulice <- c("Ackerstrasse","Bernauerstrasse","Frankfurter Allee","Invalidenstrasse","Silvio Meier Strasse","Legiendamm Allee","Mozartstrasse")
polskie_miasta <- world.cities[world.cities[2]=="Poland"]
polskie_ulice <- c("Miodowa","Krakowska","Legionowa","Szkolna","Graniczna","Pokorna","Rycerska","Piwna","Boczna","Cicha")
francuskie_miasta <- world.cities[world.cities[2]=="France"]
francuskie_ulice <- c("Avenue Victor Hugo","Avenue Montaigne","Rue de Rivoli","Passages Couverts","Boulevard de Clichy","Avenue de Lopera","Rue de la Paix")
adresy <- data.frame("kraj" = sample(c("Polska", "Niemcy", "Francja"), n_klientow, replace = TRUE),"miasto"=rep(NULL,n_klientow),"kod_pocztowy"=rep(NULL,n_klientow),"ulica"=rep(NULL,n_klientow),"nr_domu"=rep(NULL,n_klientow))
losuj_adres_dla_kraju<-function(wiersz){
  kraj<-wiersz[1]
  if (kraj=="Polska"){
    wiersz[2] = sample(polskie_miasta,1)
    wiersz[3] = paste(sample(10:99,1),"-",sample(100:999,1),sep="")
    wiersz[4] = sample(polskie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }else(kraj=="Francja"){
    wiersz[2] = sample(francuskie_miasta,1)
    wiersz[3] = sample(10000:99999,1)
    wiersz[4] = sample(francuskie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }else(kraj=="Niemcy"){
    wiersz[2] = sample(niemieckie_miasta,1)
    wiersz[3] = sample(10000:99999,1)
    wiersz[4] = sample(niemieckie_ulice,1)
    wiersz[5] = sample(1:199,1)
  }
  return(wiersz)
}
apply(adresy,1,losuj_adres_dla_kraju())
klienci_rand <- data.frame("imie" = randomNames(n_klientow, ethnicity = 5, which.names = "first"),
                           "nazwisko" = randomNames(n_klientow, ethnicity = 5, which.names = "last"),
                           "data" = random_date(n_klientow),
                           "kraj" = adresy[1],
                           "ulica" = adresy[4],
                           "nr_domu" = adresy[5],
                           "miasto" = adresy[2],
                           "kod_pocztowy" = adresy[3],
                           "nr_telefonu" = stri_rand_strings(n_klientow, 9, pattern = "[0-9]"),
                           "pesel" = rep(NULL,n_klientow)
)
apply(klienci_rand, 1, pesel_generator_z_daty())




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
templatka_opisu <- c("Wspanialy wyjazd do city! Niewiarygodne przeÅ¼ycia gwarantowane. Zrelaksuj sie az liczba_dni dni. W ramach wyjazdu wiele niesamowitych atrakcji.")

oferty_rand %>%
  mutate("opis" =  str_replace(templatka_opisu, "city", miejsce_wyjazdu )) %>%
  mutate(opis = str_replace(opis, "liczba_dni", as.character(dlugosc))) -> oferty_rand

#tymczasowe zanim zrobiÄ™ Å›ciÄ…gniÄ™cie z tabeli
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
  select(!c(dlugosc, limit_uczestnikow)) -> wycieczki_rand

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

# zamowienia: klient_id, wycieczka_id, liczba_osob, klasa_oferty, sposob_platnosci
n_zamowien <- 75
#tymczasowo, potem trzeba zaci¹gn¹æ z bazy
id_wycieczki <- 1:n_wycieczek
trwanie<-as.integer(unlist(wycieczki_rand[3]-wycieczki_rand[2]))
limit<-wycieczki_rand[4]
wycieczki<-wycieczki_rand

platnosci <- c("karta", "gotowka", "przelew_internetowy", "przelew_tradycyjny", "paypal", "voucher")
generator_zamowien <- function(wycieczki){
  id_wycieczki <- 1:n_wycieczek
  limit<-wycieczki[[4]]
  
  klienci <- sample(1:n_klientow,n_zamowien,replace = TRUE)
  wyjazdy <- sample(1:n_wycieczek,n_zamowien,replace=TRUE)
  liczba <- sample(1:5,n_zamowien,replace=TRUE)
  
  limity_wyjazdow<-limit[wyjazdy]
  poczatek_wyjazdu<-wycieczki[[2]][wyjazdy]
  koniec_wyjazdu<-wycieczki[[3]][wyjazdy]
  
  tymczasowe_zamowienia<-data.frame(klienci=klienci,wyjazdy=wyjazdy,liczba_osob=liczba,limity=limity_wyjazdow,poczatek=poczatek_wyjazdu,koniec=koniec_wyjazdu)
  for(i in 1:n_zamowien){
    if (tymczasowe_zamowienia[[3]][i]<=tymczasowe_zamowienia[[4]][i]){
      tymczasowe_zamowienia[[4]][i]=tymczasowe_zamowienia[[4]][i]-tymczasowe_zamowienia[[3]][i]
    }else(tymczasowe_zamowienia[[3]][i]>tymczasowe_zamowienia[[4]][i] & tymczasowe_zamowienia[[4]]>0){
      tymczasowe_zamowienia[[3]][i]=tymczasowe_zamowienia[[4]]
    }else{
      tymczasowe_zamowienia=tymczasowe_zamowienia[-c(i),] # uznalam ¿e latwiej niz sie bawic bêdzie po prostu usunac te kilka zamówieñ co nie bêd¹ pasowac, nadal powinno zostaæ sporo zamowien
    }
  }
  for(i in unique(klienci)){
    zamowienie<-tymczasowe_zamowienia[tymczasowe_zamowienia[[1]]==i,]
    daty<-zamowienie[5:6]
    daty[order(daty[[1]],decreasing = TRUE),]
    ilosc_dat<-length(daty[[1]])
    for (k in ilosc_dat-1){
      if(Overlap(c(daty[[1]][k],daty[[2]][k]),c(daty[[1]][k+1],daty[[2]][k+1]))>0){
        #nie wiem co tu zrobic, usunac pierwszy wyjazd tego klienta z tych co sie nachodza?
      }
    }
  }
  zamowienia <- data.frame("klient" = klienci,
                         "wycieczka" = wyjazdy,
                         "liczba_osob" = liczba,
                         "klasa" = sample(1:3,n_zamowien,replace=TRUE), #zakladajac ze bedziemy miec 3 klasy, bo jeszcze nie wiem ile
                         "platnosc" = sample(platnosci,n_zamowien,replace=TRUE)
                         )
  return(zamowienia)
}
generator_zamowien(wycieczki_rand)


