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
    menuItem("Zamówienia", tabName = "zamowienia_tab", icon = icon("fas fa-list-alt")),


    menuItem("Przewodnicy", tabName = "przewodnicy_tab", icon = icon("fas fa-address-card")
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



############ zakładka OFERTY

####zarządzaj
tabbox_zarzadzaj_oferty <- tabBox(width = NULL,
                                  title = span(icon("fas fa-edit"), "Zarządzaj ofertami"),
                                  side = 'right',
                                  tabPanel(title=span(icon("fas fa-file-plus"),"Dodaj ofertę"),
                                           textInput("o_utworz_miasto","Miejsce wyjazdu"),
                                           numericInput("o_utworz_limit","limit ilości uczestników"),
                                           numericInput("o_utworz_dni","Długość wyjazdu w dniach"),
                                           numericInput("o_utworz_cena","Cena podstawowa"),
                                           textInput("o_utworz_opis","Opis"),
                                           numericInput("o_utworz_foto","Zdjęcie"),
                                           actionButton("o_utworz_button","Utwórz ofertę")
                                  ),
                                  tabPanel(title=span(icon("fas fa-file-edit"),"Modyfikuj ofertę"),
                                           selectInput("o_modyfikuj_select",label="Wybierz ofertę do modyfikacji",choices=NULL),
                                           textInput("o_modyfikuj_opis","Nowy opis"),
                                           numericInput("o_modyfikuj_foto","Nowe zdjęcie"),
                                           actionButton("o_modyfikuj_button","Edytuj ofertę")
                                  ),
                                  tabPanel(title=span(icon("fas fa-file-minus"),"Usuń ofertę"),
                                           selectInput("o_usun_select",label="Wybierz ofertę do modyfikacji",choices=NULL),
                                           textOutput("o_usun_text"),
                                           actionButton("o_usun_button","Edytuj ofertę")
                                  )
)

####statystyki
tabbox_statystyki_oferty <- tabBox(width = NULL,
                                   title = span( icon("fas fa-chart-bar"), "Statystyki ofert"),
                                   id = "uczestnicy_tabbox",
                                   side = "right",
                                   tabPanel(title = span( icon("fas fa-list"),"Statystyki uczestników"),
                                            h3("Statystyki uczestników, którzy pojechali na wyjazdy w ramach danych ofert"),
                                            DT::dataTableOutput('statystyki_ofert_tbl')
                                            
                                   ),
                                   tabPanel(title = span(icon("fas fa-list-ol"), "Najczęstsze cele podróży"),
                                            radioButtons("najczestsze_sele_tab_select", label = NULL, choices = list("Najwięcej wycieczek" = "najczestsze_cele_w", "Najwięcej odwiedzających"  = "najczestsze_cele_u")),
                                            tabsetPanel(id = "najczestsze_cele_tabs", selected = "najczestsze_cele_w", type = "hidden",
                                                        tabPanel("najczestsze_cele_w",
                                                                 h4("Miejsca, do których pojechało najwięcej wycieczek"),
                                                                 DT::dataTableOutput(outputId = "najczestsze_docelowe_tbl")
                                                                 
                                                        ),
                                                        
                                                        tabPanel("najczestsze_cele_u",
                                                                 h4("Miejsca, które odwiedziło najwięcej uczestników"),
                                                                 DT::dataTableOutput(outputId = "najbardziej_oblegane_tbl")
                                                                 
                                                        )
                                            )
                                   ))

# box_najczestsze_docelowe <- box(width = NULL,
#                                 status = "primary",
#                                 title = "Najczęściej odwiedzane miejsca wyjazdów",
#                                 solidHeader = TRUE,
#                                 collapsible = TRUE,
#                                 "Miasta, do których pojechało najwięcej wycieczek",
#                                 DT::dataTableOutput(outputId = "najczestsze_docelowe_tbl")
# )
# 
# box_najbardziej_oblegane_docelowe <- box(width = NULL,
#                                          status = "primary",
#                                          title = "Najczęściej odwiedzane miejsca wyjazdów",
#                                          solidHeader = TRUE,
#                                          collapsible = TRUE,
#                                          "Miasta, które odwiedziło najwięcej uczestników",
#                                          DT::dataTableOutput(outputId = "najbardziej_oblegane_tbl")
# )



############ zakładka WYCIECZKI

# dodać aktualizacje
tabbox_wycieczki_zarzadzaj <- tabBox(title = span(icon("fas fa-cog"), "Zarządzaj wycieczkami"),
                                     width = NULL,
                                     side = "right",
                                     tabPanel(title = span(icon("fas fa-calendar-plus"),"Utwórz"),
                                              dateInput('w_stworz_data_input',label='Początek wycieczki'),
                                              selectInput(inputId = "w_stworz_oferta_input", label = "Wybierz ofertę", choices = dbGetQuery(con,'SELECT oferta_id FROM oferty;')$oferta_id),
                                              textOutput("w_info_oferta"),
                                              actionButton('w_utworz',label='Utwórz wycieczkę')
                                     ),
                                     
                                     tabPanel(title = span(icon("fas fa-edit"),"Modyfikuj"),
                                              selectInput(inputId = "w_modyfikuj_select", label = "Wybierz wycieczkę", choices = NULL),
                                              textOutput("w_info_modyfikuj"),
                                              dateInput('w_modyfikuj_data_input',label='Nowy początek wycieczki'),
                                              actionButton('w_modyfikuj',label='Modyfikuj wycieczkę')
                                     ),
                                     
                                     tabPanel(title = span(icon("fas fa-calendar-minus"),"Usuń"),
                                              selectInput(inputId = "w_usun_select", label = "Wybierz wycieczkę do usunięcia", choices = NULL),
                                              textOutput("w_info_usun"),
                                              actionButton('w_usun',label='Usuń wycieczkę')
                                     )
)

tabbox_wycieczki_przewodnictwa <- tabBox(title = span(icon("fas fa-user-cog"), "Zarządzaj przewodnictwami"),
                                         width=NULL,
                                         side="right",
                                         tabPanel(title = span(icon("fas fa-calendar-plus"),"Zleć wycieczkę przewodnikowi"),
                                                  selectInput("ww_zlec_wycieczke_select",label='Wybierz wycieczkę',choices=NULL),
                                                  h4("Przewodnicy możliwi do wybrania - bez kolizji w terminach z innymi wycieczkami tego przewodnika:"),
                                                  selectInput("wp_zlec_wycieczke_select",label='Wybierz przewodnika',
                                                              # choices=dbGetQuery(con,"SELECT wycieczka_id FROM wycieczki;")$wycieczka_id)
                                                              choices = (DT::dataTableOutput(outputId = "przewodnicy_do_zlecania"))$przewodnik_id)
                                                  ,
                                                  actionButton('w_zlec_wycieczke_button',label='Zleć wycieczkę przewodnikowi')
                                         ),
                                         
                                         tabPanel(title = span(icon("fas fa-calendar-minus"),"Odwołaj przewodnika z wycieczki"),
                                                  DT::dataTableOutput('w_odwolaj_tbl'),
                                                  actionButton('w_odwolaj',label='Odwołaj przewodnika')
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
                                               dateRangeInput("wyc_data_input", label='Wybierz przedział czasowy wycieczki', language = "pl", separator = " do "),
                                               selectInput("wyc_oferta_select",label='Wybierz ofertę',choices=(dbGetQuery(con,"SELECT oferta_id FROM oferty;")$oferta_id),multiple=TRUE,selected = 1),
                                               DT::dataTableOutput(outputId = "przegladaj_wycieczki_tbl")
                                      )
                                      
)


############# zakładka PRZEWODNICY

tabbox_przewodnicy_przegladaj <- tabBox(title = span(icon("fas fa-window-restore"), "Przeglądaj"),
                                        width = NULL,
                                        side = "right",
                                        tabPanel(title = span(icon("fas fa-address-card"), "Przewodnicy"),
                                                 selectInput('aktywnosc',label='Aktywność',choices=list("aktywni"=1,"wszyscy"=3,"nieaktywni"=2)),
                                                 DT::dataTableOutput(outputId = 'przewodnicy')
                                        ),
                                        tabPanel(title = span(icon("fas fa-star"),"Najbardziej doświadczeni przewodnicy"),
                                                 solidHeader = TRUE,
                                                 DT::dataTableOutput(outputId = 'doswiadczeni_przewodnicy')
                                        ),
                                        tabPanel(title = span(icon("fas fa-calendar-alt"), "Wycieczki przewodników"),
                                                 DT::dataTableOutput(outputId = 'wycieczki_przewodnikow')
                                        )
                                        
)

tabbox_przewodnicy_zarzadzaj <- tabBox(title = span(icon("fas fa-cog"), "Zarządzaj"),
                                       width = NULL,
                                       side = "right",
                                       tabPanel(title = span(icon("fas fa-user-edit"),"Zaktualizuj informacje"),
                                                solidHeader = TRUE,
                                                selectInput("przewodnik_do_akt_select",label='Wybierz przewodnika',choices=dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE;")$przewodnik_id),
                                                textInput('p_akt_imie_input',label="Imię"),
                                                textInput('p_akt_nazwisko_input',label='Nazwisko'),
                                                textInput('p_akt_telefon_input',label='Telefon'),
                                                actionButton('p_aktualizuj_id',label='Zaktualizuj informacje')
                                       ),
                                       tabPanel(title = span(icon("fas fa-user-minus"), "Zwolnij"),
                                                selectInput("zwolnij",label='Wybierz przewodnika do zwolnienia',choices=dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE;")$przewodnik_id),
                                                textOutput("info_zwolnij"),
                                                actionButton(inputId = "zwolnij_button", label = "Zwolnij")
                                       ),
                                       tabPanel(title = span(icon("fas fa-user-plus"), "Zatrudnij"),
                                                textInput('p_imie_input',label="Imię"),
                                                textInput('p_nazwisko_input',label='Nazwisko'),
                                                textInput('p_telefon_input',label='Telefon'),
                                                actionButton('zatrudnij',label='Zatrudnij')
                                       )
)

#### zakładka ZAMOWIENIA

box_zloz_mod_zamowienie <- box(id = "box_zloz_mod_zamowienie",width = NULL,
                               title = "Złóż zamówienie",
                               solidHeader = TRUE,
                               status = "primary",
                               numericInput("ile_w_zamowieniu", "Na ile osób składane jest zamówienie?", value = 1, min = 1),
                               selectInput("zamowienie_wycieczka", "Wybierz id wycieczki", choices = NULL),
                               selectInput("zamowienie_klasa", "Wybierz klasę zamówienia", choices = NULL),
                               selectInput("zamowienie_platnosc", "Wybierz sposób płatności", choices = c('karta','gotowka','przelew internetowy','przelew tradycyjny','paypal','voucher')),
                               uiOutput("ludzie_w_zamowieniu"),
                               actionButton("zatwierdz_dane", span("Złóż zamówienie", icon("fas fa-check")))
                               # ,
                               # uiOutput("dane_ludzi_w_zamowieniu")
)


### zamowienia koniec



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
    
    # zakładki od ofert
    # zarządzanie ofertami
    tabItem(tabName = "zarzadzaj_oferty",
            tabbox_zarzadzaj_oferty
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
            column(12, tabbox_statystyki_oferty
            )
    ),
    # zarządzanie wycieczkami 
    tabItem(tabName = "wycieczki_tab",
            column(6,
                   tabbox_wycieczki_zarzadzaj,
                   tabbox_wycieczki_przewodnictwa
            ),
            column(6,
                   tabbox_wycieczki_przegladaj
            )
    ),
    # zakładki do zamówień
    #przeglądanie zamówień
    tabItem(tabName = "zamowienia_tab",
            column(6,
                   box_zloz_mod_zamowienie
            )
    ),
    # zakładka do przewodników
    tabItem(tabName = "przewodnicy_tab",
            column(6,
                   tabbox_przewodnicy_zarzadzaj
                   
            ),
            column(6,
                   tabbox_przewodnicy_przegladaj
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
