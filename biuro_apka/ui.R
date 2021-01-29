library(shiny)
library(shinydashboard)




sidebar = dashboardSidebar(
    shinyjs::useShinyjs(),
    width = 320,
    sidebarMenu(
        menuItem("Oferty", tabName = "oferty_tab", icon = icon("fas fa-upload"),
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
        menuItem("Wycieczki", tabName = "wycieczki_tab", icon = icon("fas fa-upload"),
                 menuSubItem(
                     "Zarządzaj", "zarzadzaj_wycieczki", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_wycieczki", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Statystyki", "statystyki_wycieczki", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Klienci i uczestnicy", tabName = "uczestnicy_tab", icon = icon("fas fa-table"),
                 menuSubItem(
                     "Stali klienci", "stali_klienci", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przegladaj i modyfikuj", "uczestnicy", icon = icon("fas fa-search")
                 )
                 ),
        menuItem("Zamowienia", tabName = "zamowienia_tab", icon = icon("fas fa-chart-bar"),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_zamowienia", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Złóż lub modyfikuj", "modyfikuj_zamowienie", icon = icon("fas fa-search")
                 )
        ),
        menuItem("Przewodnicy", tabName = "przewodnicy_tab", icon = icon("fas fa-upload"),
                 menuSubItem(
                     "Zarządzaj", "zarzadzaj_przewodnicy", icon = icon("fas fa-search")
                 ),
                 menuSubItem(
                     "Przeglądaj", "przegladaj_przewodnicy", icon = icon("fas fa-search")
                 )
        )
    )
)

body = dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(
        tags$style(HTML(".main-sidebar { font-size: 18px; }")) #change the font size to 20
    ),
# 
    # zakładka przeglądaj i modyfikuj uczestników
    tabItems(
        tabItem(tabName = "uczestnicy",
                column(4,
                box(width = NULL,
                    status = "primary",
                    title = "Dodaj uczestnika",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    textInput(inputId = "ud_imie_input", label = "Wpisz imię"),
                    textInput(inputId = "ud_nazwisko_input", label = "Wpisz nazwisko"),
                    textInput(inputId = "ud_kraj_input", label = "Wpisz kraj zamieszkania"),
                    textInput(inputId = "ud_miasto_input", label = "Wpisz miasto zamieszkania"),
                    textInput(inputId = "ud_kod_input", label = "Wpisz kod pocztowy"),
                    textInput(inputId = "ud_ulica_input", label = "Wpisz ulicę"),
                    textInput(inputId = "ud_nr_domu_input", label = "Wpisz numer domu"),
                    textInput(inputId = "ud_data_input", label = "Wpisz datę urodzenia"),
                    textInput(inputId = "ud_pesel_input", label = "Wpisz PESEL"),
                    textInput(inputId = "ud_nr_tel_input", label = "Wpisz numer telefonu"),
                    
                    
                    actionButton(inputId = "uczestnik_dodaj_id", label = "Dodaj ksiazke")
                    
                ),
                box(width = NULL,
                    status = "primary",
                    title = "Wyszukaj uczestników",
                    solidHeader = TRUE
                    
                ),
                box(width = NULL,
                    status = "primary",
                    title = "Modyfikuj uczestnika",
                    solidHeader = TRUE
                    
                )
                ),
                column(8,
                       box(width = NULL,
                           status = "primary",
                           title = "Uczestnicy",
                           solidHeader = TRUE
                           
                       ),
                       box(width = NULL,
                           status = "primary",
                           title = "Wyszukani",
                           solidHeader = TRUE
                           
                       )
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
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
    # zarządzanie wycieczkami 
        tabItem(tabName = "zarzadzaj_wycieczki",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
    # przeglądaj wycieczki
        tabItem(tabName = "przegladaj_wycieczki",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
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
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        ),
    # przeglądanie przewodników 
        tabItem(tabName = "przegladaj_przewodnicy",
                box(width = NULL,
                    status = "primary",
                    title = "cos",
                    solidHeader = TRUE
                    
                )
        )
    )
)


dashboardPage(
    skin = "blue",
    dashboardHeader(title = "Biuro bazy"),
    sidebar,
    body
)                    