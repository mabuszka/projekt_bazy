require(randomNames)
require(stringi)
require(stringr)
require(maps)
require(dplyr)
require(lubridate)

#klienci
n_klientow <- 100
# pesel_generator <- function(n){
#   years <- sample(1:99, n, replace = TRUE)
#   months <- sample(c(1:12, 21:22),n, replace = TRUE)
#   days <- sample(1:28, n, replace = TRUE) # żeby się za bardzo nie bawić które miesiące mają ile dni
#   rest <- stri_rand_strings(n, 5, pattern = "[0-9]") # patrzymy tyko żeby zgadzała się liczba znaków, nie bawimy się w sumy kontrolne
#   paste(years, months, days, )
# }
# pesel bierzemy z zewnetrznej bazy peselów żeby nie bawić się ze sprawdzaniem wszystkich sum kontrolnych etc
klient_pesel <- read
klienci_rand <- data.frame("imie" = randomNames(n_klientow, ethnicity = 5, which.names = "first"),
                           "nazwisko" = randomNames(n_klientow, ethnicity = 5, which.names = "last"),
                           "kraj" = 
                           )
losowanie_adresu <- function(n){
  adresy = data.frame("kraj" = sample(c("Polska", "Niemcy", "Francja"), n, replace = TRUE))
  miasta = list("Polska" = c("Wrocław", "Kraków", ))
  
}




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
  mutate("cena" = sample(400:1200, n_ofert) * dlugosc_trwania) -> oferty_rand
templatka_opisu <- c("Wspanialy wyjazd do city! Niewiarygodne przeżycia gwarantowane. Zrelaksuj sie az liczba_dni dni. W ramach wyjazdu wiele niesamowitych atrakcji.")

oferty_rand %>%
  mutate("opis" =  str_replace(templatka_opisu, "city", miejsce_wyjazdu )) %>%
  mutate(opis = str_replace(opis, "liczba_dni", as.character(dlugosc))) -> oferty_rand

#tymczasowe zanim zrobię ściągnięcie z tabeli
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



