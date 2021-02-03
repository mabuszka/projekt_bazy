library(shiny)
library(shinydashboard)
library(DT)




sidebar = dashboardSidebar(
    shinyjs::useShinyjs(),
    width = 320,
    sidebarMenu(
        menuItem("Strona startowa", tabName="start_tab", icon=icon("fas fa-globe")),
        menuItem("Oferty", tabName = "oferty_tab", icon = icon("fas fa-road"),
                 menuSubItem(
                     "Zarządzaj", "zarzadzaj_oferty", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_oferty", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Statystyki", "statystyki_oferty", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Wycieczki", tabName = "wycieczki_tab", icon = icon("fas fa-calendar"),
                 menuSubItem(
                     "Zarządzaj", "zarzadzaj_wycieczki", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_wycieczki", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Klienci i uczestnicy", tabName = "uczestnicy_tab", icon = icon("fas fa-user"),
                 menuSubItem(
                     "Stali klienci", "stali_klienci", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przegladaj i modyfikuj", "uczestnicy", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Zamówienia", tabName = "zamowienia_tab", icon = icon("fas fa-list-alt"),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_zamowienia", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Złóż lub modyfikuj", "modyfikuj_zamowienie", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Przewodnicy", tabName = "przewodnicy_tab", icon = icon("fas fa-briefcase"),
                 menuSubItem(
                     "Zarządzaj", "zarzadzaj_przewodnicy", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_przewodnicy", icon = icon("fas fa-search")
                 )
        )
    )
)

#################### zakładka UCZESTNICY 
## przeglądaj i modyfikuj

box_dodaj_uczestnika = box(width = NULL,
                           status = "primary",
                           title = "Dodaj uczestnika",
                           solidHeader = TRUE,
                           collapsible = TRUE,
                           collapsed = TRUE,
                           textInput(inputId = "ud_imie_input", label = "Wpisz imię"),
                           textInput(inputId = "ud_nazwisko_input", label = "Wpisz nazwisko"),
                           selectInput(inputId = "ud_kraj_input", label = "Wybierz kraj zamieszkania",
                                       choices = list("Polska" = "Polska", "Niemcy" = "Niemcy", "Francja" = "Francja"), 
                                       selected = "Polska"),
                           textInput(inputId = "ud_miasto_input", label = "Wpisz miasto zamieszkania"),
                           textInput(inputId = "ud_kod_input", label = "Wpisz kod pocztowy"),
                           textInput(inputId = "ud_ulica_input", label = "Wpisz ulicę"),
                           textInput(inputId = "ud_nr_domu_input", label = "Wpisz numer domu"),
                           textInput(inputId = "ud_data_input", label = "Wpisz datę urodzenia"),
                           textInput(inputId = "ud_pesel_input", label = "Wpisz PESEL"),
                           textInput(inputId = "ud_nr_tel_input", label = "Wpisz numer telefonu"),
                           
                           
                           actionButton(inputId = "uczestnik_dodaj_id", label = "Dodaj uczestnika")
)

## NIESKONCZONE
box_modyfikuj_uczestnika <- box(width = NULL,
                                status = "primary",
                                title = "Modyfikuj uczestnika",
                                solidHeader = TRUE
                                
)

## wyświetla tabelę z uczestnikami 
box_tabela_uczestnicy = box(width = NULL,
                            status = "primary",
                            title = "Uczestnicy",
                            solidHeader = TRUE, 
                            collapsible = TRUE,
                            DT::dataTableOutput(outputId = "uczestnicy_tbl")
                            
)

## NIESKOŃCZONE box z wyszukiwaniem i wyświetlaniem tych wyszukanych uczestników
box_wyszukaj_uczestnikow <- box(width = NULL,
                                status = "primary",
                                title = "Wyszukaj uczestników",
                                solidHeader = TRUE   
)

############ zakładka OFERTY

##statystyki

box_najczestsze_docelowe <- box(width = NULL,
                                status = "primary",
                                title = "Najczęściej odwiedzane miejsca wyjazdów",
                                solidHeader = TRUE,
                                collapsible = TRUE,
                                "Miasta, do których pojechało najwięcej wycieczek",
                                DT::dataTableOutput(outputId = "najczestsze_docelowe_tbl")
)

box_najbardziej_oblegane_docelowe <- box(width = NULL,
                                         status = "primary",
                                         title = "Najczęściej odwiedzane miejsca wyjazdów",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         "Miasta, które odwiedziło najwięcej uczestników",
                                         DT::dataTableOutput(outputId = "najbardziej_oblegane_tbl")
)

box_statystyki_ofert <- box(width = NULL,
                            status = "primary",
                            title = "Statystyki ofert",
                            solidHeader = TRUE,
                            collapsible = TRUE,
                            DT::dataTableOutput(outputId = "statystyki_ofert_tbl")
)


############ zakładka WYCIECZKI
# przegladaj

box_przegladaj_wycieczki <- box(width = NULL,
                                status = "primary",
                                title = "Przeglądaj",
                                solidHeader = TRUE,
                                DT::dataTableOutput(outputId = "przegladaj_wycieczki_tbl")
                                
)

box_sprawdz_przewodnikow_do_wycieczki <- box(width = NULL,
                                             status = "primary",
                                             title = "Sprawdź przewodników wycieczek",
                                             solidHeader = TRUE,
                                             DT::dataTableOutput(outputId = "sprawdz_przewodnictwa_wycieczek_tbl")
                                             
)

box_zblizajace_sie_wycieczki <- box(width = NULL,
                                    status = "primary",
                                    title = "Zbliżające się wycieczki",
                                    solidHeader = TRUE,
                                    DT::dataTableOutput(outputId = "zblizajace_sie_wycieczki_tbl")
                                    
)

#modyfikuj

box_stworz_wycieczke <- box(width = NULL,
                            status = "primary",
                            title = "Utwórz wycieczkę",
                            solidHeader = TRUE
                            
)

box_modyfikuj_wycieczke <- box(width = NULL,
                               status = "primary",
                               title = "Modyfikuj wycieczkę",
                               solidHeader = TRUE
                               
)

box_usun_wycieczke <- box(width = NULL,
                          status = "primary",
                          title = "Usuń wycieczkę",
                          solidHeader = TRUE
                          
)

#box_zlec_wycieczke_ww
#box_odwolaj_z_wycieczki


############# zakładka PRZEWODNICY
# przeglądaj: przewodnicy, widok najbardziej doświadczeni

box_przegladaj_przewodnikow <- box(width=NULL,
                                    status='primary',
                                    title='Przewodnicy',
                                    solidHeader = TRUE,
                                    collapsible = TRUE,
                                    selectInput('aktywnosc',label='Aktywność',choices=list("aktywni"=1,"wszyscy"=3,"nieaktywni"=2)),
                                    DT::dataTableOutput(outputId = 'przewodnicy')
                                   )

box_doswiadczeni_przewodnicy <- box(width=NULL,
                                   status='primary',
                                   title='Najbardziej doświadczeni przewodnicy',
                                   solidHeader = TRUE,
                                   collapsible = TRUE,
                                   DT::dataTableOutput(outputId = 'doswiadczeni_przewodnicy')
)

# modyfikuj: zwolnij, zatrudnij, aktualizuj informacje, zleć wycieczkę + kolidujące wycieczki
#wszędzie dodać powiadomienie że się udało

box_zatrudnij <- box(width=NULL,
                     status='primary',
                     title='Zatrudnij',
                     solidHeader = TRUE,
                     collapsible = TRUE,
                     textInput('p_imie_input',label="Imię"),
                     textInput('p_nazwisko_input',label='Nazwisko'),
                     textInput('p_telefon_input',label='Telefon'),
                     actionButton('zatrudnij',label='Zatrudnij')
)

box_zwolnij <- box(width=NULL,
                  status='primary',
                  title='Zwolnij przewodnika',
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  selectInput("zwolnij",label='Wybierz przewodnika do zwolnienia',choices=dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE;")$przewodnik_id),
                  textOutput("info_zwolnij"),
                  actionButton(inputId = "zwolnij_button", label = "Zwolnij")
)

# dodać defaultowe wpisywanie się dotychczasowych danych
box_aktualizuj_przewodnika <- box(width=NULL,
                     status='primary',
                     title='Zaktualizuj informacje',
                     solidHeader = TRUE,
                     collapsible = TRUE,
                     selectInput("przewodnik_do_akt_select",label='Wybierz przewodnika',choices=dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE;")$przewodnik_id),
                     textInput('p_akt_imie_input',label="Imię"),
                     textInput('p_akt_nazwisko_input',label='Nazwisko'),
                     textInput('p_akt_telefon_input',label='Telefon'),
                     actionButton('p_aktualizuj_id',label='Zaktualizuj informacje')
)

box_zlec_wycieczke <- box(width=NULL,
                         status='primary',
                         title='Zleć wycieczkę przewodnikowi',
                         solidHeader = TRUE,
                         collapsible = TRUE,
                         selectInput("p_zlec_wycieczke_select",label='Wybierz przewodnika',choices=dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE;")$przewodnik_id),
                         h4('Wycieczki kolidujące z wycieczkami wybranego przewodnika:'),
                         DT::dataTableOutput(outputId = 'kolidujace_wycieczki'),
                         selectInput("w_zlec_wycieczke_select",label='Wybierz wycieczkę',choices=dbGetQuery(con,"SELECT wycieczka_id FROM wycieczki;")$wycieczka_id),
                         actionButton('p_zlec_wycieczke_button',label='Zleć wycieczkę przewodnikowi')
)

box_wycieczki_przewodnikow <- box(width=NULL,
                                  status='primary',
                                  title='Wycieczki przewodników',
                                  solidHeader = TRUE,
                                  collapsible = TRUE,
                                  collapsed = TRUE,
                                  DT::dataTableOutput(outputId = 'wycieczki_przewodnikow')
)




body = dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(
        tags$style(HTML(".main-sidebar { font-size: 18px; }")) #change the font size to 20
    ),
    # zakładka przeglądaj i modyfikuj uczestników
    tabItems(
        tabItem(tabName = "start_tab",
                plotOutput("start")
        ),
        tabItem(tabName = "uczestnicy",
                column(4,
                       box_dodaj_uczestnika,
                       box_modyfikuj_uczestnika
                ),
                column(8,
                       box_tabela_uczestnicy ,
                       box_wyszukaj_uczestnikow
                )
        ),
        # zakładka stali klienci 
        tabItem(tabName = "stali_klienci",
                box(width = NULL,
                    status = "primary",
                    title = "Stali klienci",
                    solidHeader = TRUE
                    
                )
        ),
        # zakładki od ofert
        # zarządzanie ofertami
        tabItem(tabName = "zarzadzaj_oferty",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
        # przeglądanie ofert
        tabItem(tabName = "przegladaj_oferty",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
        # statystyki ofert
        tabItem(tabName = "statystyki_oferty",
                column(6,
                       box_najczestsze_docelowe,
                       box_najbardziej_oblegane_docelowe
                ),
                column(6,
                       box_statystyki_ofert
                )
        ),
        # zarządzanie wycieczkami 
        tabItem(tabName = "zarzadzaj_wycieczki",
                column(6,
                       box_stworz_wycieczke,
                       box_usun_wycieczke
                ),
                column(6,
                       box_modyfikuj_wycieczke
                )
        ),
        # przeglądaj wycieczki
        tabItem(tabName = "przegladaj_wycieczki",
                column(6,
                       box_przegladaj_wycieczki
                ),
                column(6,
                       box_sprawdz_przewodnikow_do_wycieczki,
                       box_zblizajace_sie_wycieczki
                )
        ),
        # statystyki wycieczek 
        tabItem(tabName = "statystyki_wycieczki",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
        # zakładki do zamówień
        #przeglądanie zamówień
        tabItem(tabName = "przegladaj_zamowienia",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
        #modyfikacja zamówień
        tabItem(tabName = "modyfikuj_zamowienie",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
        # zakładki do przewodników
        # zarządzanie przewodnikami
        tabItem(tabName = "zarzadzaj_przewodnicy",
                column(6,
                       box_zlec_wycieczke,
                       box_zatrudnij
                       
                ),
                column(6,
                       box_aktualizuj_przewodnika,
                       box_zwolnij
                )
        ),
        # przeglądanie przewodników 
        tabItem(tabName = "przegladaj_przewodnicy",
                column(6,
                       box_przegladaj_przewodnikow
                ),
                column(6,
                       box_doswiadczeni_przewodnicy,
                       box_wycieczki_przewodnikow
                )
        )
    )
)

dashboardPage(
    skin = "blue",
    dashboardHeader(title = "Biuro bazy"),
    sidebar,
    body,
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap_custom.css"))
)                    
