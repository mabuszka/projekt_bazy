library(shiny)
library(shinydashboard)
library(DT)




sidebar = dashboardSidebar(
  shinyjs::useShinyjs(),
  width = 320,
  sidebarMenu(
    menuItem("Strona startowa", tabName="start_tab", icon=icon("fas fa-globe")),
    menuItem("Oferty", tabName = "oferty_tab", icon = icon("fas fa-compass"),
             menuSubItem(
               "Zarządzaj", "zarzadzaj_oferty", icon = icon("fas fa-edit")
             ),
             menuSubItem(
               "Przeglądaj", "przegladaj_oferty", icon = icon("fas fa-search")
             ),
             menuSubItem(
               "Statystyki", "statystyki_oferty", icon = icon("fas fa-chart-bar")
             )
    ),
    menuItem("Wycieczki", tabName = "wycieczki_tab", icon = icon("fas fa-calendar")),
    menuItem("Klienci i uczestnicy", tabName = "uczestnicy_tab", icon = icon("fas fa-user-friends")
    ),
    menuItem("Zamówienia", tabName = "zamowienia_tab", icon = icon("fas fa-list-alt"),
             menuSubItem(
               "Złóż lub modyfikuj", "modyfikuj_zamowienie", icon = icon("fas fa-edit")
             ),
             menuSubItem(
               "Przeglądaj", "przegladaj_zamowienia", icon = icon("fas fa-search")
             )
             
    ),
    menuItem("Przewodnicy", tabName = "przewodnicy_tab", icon = icon("fas fa-address-card"),
             menuSubItem(
               "Zarządzaj", "zarzadzaj_przewodnicy", icon = icon("fas fa-edit")
             ),
             menuSubItem(
               "Przeglądaj", "przegladaj_przewodnicy", icon = icon("fas fa-search")
             )
    )
  )
)
##
tabs_color <- '.nav-tabs-custom .nav-tabs li.active {
    border-top-color: #3c8dbc;
}
.nav-tabs-custom>.nav-tabs {
                            background-color: #3c8dbc;
                            }
.nav-tabs-custom > .nav-tabs > li.header {
                            color: #FFFFFF;
}
.nav-tabs-custom>.nav-tabs>li>a {
    color: #FFFFFF;
}
                            
.nav-tabs-custom>.nav-tabs>li.active:hover>a, .nav-tabs-custom>.nav-tabs>li.active>a {
    background-color: #FFFFFF;
    color: #333;
}'



#################### zakładka UCZESTNICY 
## przeglądaj i modyfikuj
tabbox_uczestnicy_mod <- tabBox(title = span(icon("fas fa-clipboard"),"Zarządzaj uczestnikami"),
                                width = NULL,
                                side = "right",
                                
                                tabPanel(title = span(icon("fas fa-plus"),"Dodaj"),
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
                                         textInput(inputId = "ud_pesel_input", label = "Wpisz PESEL", placeholder = NA),
                                         textInput(inputId = "ud_nr_tel_input", label = "Wpisz numer telefonu"),
                                         
                                         
                                         actionButton(inputId = "uczestnik_dodaj_id", label = "Dodaj uczestnika")
                                ),
                                tabPanel(width = NULL,
                                         title = span(icon("fas fa-edit"),"Modyfikuj"),
                                         h4("Wybierz id uczestnika, którego dane chcesz zmodyfikować"),
                                         selectInput(inputId = "um_id_input", label = "Wybierz id ", choices = c(1)),
                                         textInput(inputId = "um_imie_input", label = "Wpisz imię"),
                                         textInput(inputId = "um_nazwisko_input", label = "Wpisz nazwisko"),
                                         selectInput(inputId = "um_kraj_input", label = "Wybierz kraj zamieszkania",
                                                     choices = list("Polska" = "Polska", "Niemcy" = "Niemcy", "Francja" = "Francja"), 
                                                     selected = "Polska"),
                                         textInput(inputId = "um_miasto_input", label = "Wpisz miasto zamieszkania"),
                                         textInput(inputId = "um_kod_input", label = "Wpisz kod pocztowy"),
                                         textInput(inputId = "um_ulica_input", label = "Wpisz ulicę"),
                                         textInput(inputId = "um_nr_domu_input", label = "Wpisz numer domu"),
                                         textInput(inputId = "um_data_input", label = "Wpisz datę urodzenia"),
                                         textInput(inputId = "um_pesel_input", label = "Wpisz PESEL", placeholder = NA),
                                         textInput(inputId = "um_nr_tel_input", label = "Wpisz numer telefonu"),
                                         
                                         
                                         actionButton(inputId = "uczestnik_modyfikuj_id", label = "Zmodyfikuj uczestnika")
                                )
)




## wyświetla tabelę z uczestnikami 
tabbox_uczestnicy <- tabBox(width = NULL,
                            title = span( icon("users"), " Uczestnicy i klienci"),
                            id = "uczestnicy_tabbox",
                            side = "right",
                            tabPanel(
                              title = span( icon("fas fa-user"),"Uczestnicy"),
                              DT::dataTableOutput(outputId = "uczestnicy_tbl")
                              
                            ),
                            tabPanel(
                              title = span(icon("fas fa-star"), " Stali klienci"),
                              DT::dataTableOutput(outputId = "stali_klienci_tbl")
                            ),
                            tags$head(tags$style(HTML(tabs_color)))
)

## NIESKOŃCZONE box z wyszukiwaniem i wyświetlaniem tych wyszukanych uczestników
box_wyszukaj_uczestnikow <- box(width = NULL,
                                status = "primary",
                                title = "Wyszukaj uczestników",
                                solidHeader = TRUE   
)

## stali klienci
# box_stali_klienci <-

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

# box_przegladaj_wycieczki <- box(width = NULL,
#                                 status = "primary",
#                                 title = "Przeglądaj",
#                                 solidHeader = TRUE,
#                                 DT::dataTableOutput(outputId = "przegladaj_wycieczki_tbl")
#                                 
# )
# 
# box_sprawdz_przewodnikow_do_wycieczki <- box(width = NULL,
#                                              status = "primary",
#                                              title = "Sprawdź przewodników wycieczek",
#                                              solidHeader = TRUE,
#                                              DT::dataTableOutput(outputId = "sprawdz_przewodnictwa_wycieczek_tbl")
#                                              
# )

tabbox_wycieczki_zarzadzaj <- tabBox(title = span(icon("fas fa-clipboard-list"), "Zarządzaj wycieczkami"),
                                     width = NULL,
                                     side = "right",
                                     tabPanel(title = span(icon("fas fa-calendar-plus"),"Utwórz"),
                                              
                                     ),
                                     
                                     tabPanel(title = span(icon("fas fa-edit"),"Modyfikuj"),

                                     ),
                                     
                                     tabPanel(title = span(icon("fas fa-calendar-minus"),"Usuń")
                                              
                                     )
)


tabbox_wycieczki_przegladaj <- tabBox(title = span(icon("fas fa-window-restore"), "Przeglądaj"),
                                      width = NULL,
                                      side = "right",
                                      tabPanel(title = span(icon("fas fa-calendar-plus"),"Zbliżające się wycieczki"),
                                               numericInput(inputId = "zbw_dni_input", label = "Wybierz w ciągu ilu dni wycieczka ma się rozpocząć", value =  30),
                                               DT::dataTableOutput(outputId = "zblizajace_sie_wycieczki_tbl")
                                               
                                      ),
                                      tabPanel(title = span(icon("fas fa-search-plus"),"Sprawdź przewodników"),
                                               solidHeader = TRUE,
                                               DT::dataTableOutput(outputId = "sprawdz_przewodnictwa_wycieczek_tbl")
                                      ),
                                      tabPanel(title = span(icon("fas fa-table"), "Wycieczki"),
                                               DT::dataTableOutput(outputId = "przegladaj_wycieczki_tbl"))
                                      
)

# box_zblizajace_sie_wycieczki <- box(width = NULL,
#                                     status = "primary",
#                                     title = span(icon("fas fa-buisness-time"),"Zbliżające się wycieczki"),
#                                     solidHeader = TRUE,
#                                     numericInput(inputId = "zbw_dni_input", label = "Wybierz w ciągu ilu dni wycieczka ma się rozpocząć", value =  30),
#                                     # actionButton("zbw_button", "Wyszukaj"),
#                                     DT::dataTableOutput(outputId = "zblizajace_sie_wycieczki_tbl")
#                                     
# )

#modyfikuj



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
                          # h4('Wycieczki kolidujące z wycieczkami wybranego przewodnika:'),
                          # DT::dataTableOutput(outputId = 'kolidujace_wycieczki'),
                          h4("Wycieczki możliwe do zlecenia - bez kolizji w terminach z innymi wycieczkami tego przewodnika:"),
                          selectInput("w_zlec_wycieczke_select",label='Wybierz wycieczkę',
                                      # choices=dbGetQuery(con,"SELECT wycieczka_id FROM wycieczki;")$wycieczka_id)
                                      choices = (DT::dataTableOutput(outputId = "wycieczki_do_zlecania"))$wycieczka_id)
                          ,
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
    tabItem(tabName = "uczestnicy_tab",
            column(4,
                   tabbox_uczestnicy_mod
            ),
            column(8,
                   # box_tabela_uczestnicy ,
                   tabbox_uczestnicy,
                   box_wyszukaj_uczestnikow
            )
    ),
    # zakładka stali klienci 
    tabItem(tabName = "stali_klienci"
            # box_stali_klienci
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
    tabItem(tabName = "wycieczki_tab",
            column(6,
                   tabbox_wycieczki_zarzadzaj
            ),
            column(6,
                   tabbox_wycieczki_przegladaj
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
