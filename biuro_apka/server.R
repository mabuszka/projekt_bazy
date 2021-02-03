library(RPostgres)
library(shiny)
library(DT)
library(stringi)
library(stringr)


shinyServer<- function(input, output, session){
  
  options(DT.options = list(language = list(processing=     "Przetwarzanie...",
                                            search=         "Szukaj:",
                                            lengthMenu=     "Pokaż _MENU_ pozycji",
                                            info=           "Pozycje od _START_ do _END_ z _TOTAL_ łącznie",
                                            infoEmpty=      "Pozycji 0 z 0 dostępnych",
                                            infoFiltered=   "(filtrowanie spośród _MAX_ dostępnych pozycji)",
                                            infoPostFix=    "",
                                            loadingRecords= "Wczytywanie...",
                                            zeroRecords=    "Nie znaleziono pasujących pozycji",
                                            emptyTable=     "Brak danych",
                                            paginate = list(first=      "Pierwsza",
                                                            previous=   "Poprzednia",
                                                            `next`=       "Następna",
                                                            last=       "Ostatnia")
                                            
  ),scrollX=TRUE
  # search = 'Wyszukaj:', info = 'Wyświetla _START_ do _END_, z _TOTAL_',
  #                                         paginate = list(previous = 'Poprzednia', `next` = 'Następna')
  ))
  
  #### UCZESTNICY
  # dodawanie nowego uczestnika
  observeEvent(input$uczestnik_dodaj_id, {
    imie <- input$ud_imie_input
    nazwisko  <- input$ud_nazwisko_input 
    kraj_zamieszkania <- input$ud_kraj_input
    miasto <- input$ud_miasto_input
    kod_pocztowy  <- input$ud_kod_input
    ulica  <- input$ud_ulica_input
    numer_domu  <- input$ud_nr_domu_input
    data_urodzenia  <- input$ud_data_input
    PESEL  <- input$ud_pesel_input
    nr_telefonu  <- input$ud_nr_tel_input
    if (kraj_zamieszkania == 'Polska'){
      sql <- paste0("SELECT dodaj_klienta('", imie,"','", nazwisko,"','", kraj_zamieszkania,"','", miasto,"','", ulica,"','", numer_domu,"','", kod_pocztowy,"','", nr_telefonu,"','",  data_urodzenia,"','", PESEL, "');")
    }
    else{
      sql <- paste0("SELECT dodaj_klienta('", imie,"','", nazwisko,"','", kraj_zamieszkania,"','", miasto,"','", ulica,"','", numer_domu,"','", kod_pocztowy,"','", nr_telefonu,"','",  data_urodzenia,"');")
      
    }
    tryCatch({
      res <-dbSendQuery(con, sql)
      dbFetch(res)
      if(dbHasCompleted(res)){
        showNotification("Pomyślnie dodano uczestnika do bazy",type = "message")
        
      }
      dbClearResult(res)
    },
    error = function(e){
      error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
      if (str_detect(error_to_show, "CONTEXT: ")){
        error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
      }
      if (str_detect(error_to_show, "DETAIL: ")){
        error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
      }
      if (str_detect(error_to_show, "check constraint")){
        # ogolnie to trzeba ogarnąć te case'y błędów które checki mogą zwracać
        switch (str_split(error_to_show, '"')[[1]][4],
                "pesel" = (error_to_show <- "Niepoprawny PESEL"),
                "kraj" = (error_to_show <- "Niepoprawny kraj zamieszkania")
        )
      }
      showModal(modalDialog(title = "Błąd dodawania",error_to_show ,easyClose = TRUE,footer = NULL))
      
      
    })
    
    #update tabeli z uczestnikami
    output$uczestnicy_tbl <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM uczestnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    # update inputu do modyfikacji uczestników
    uczestnicy <- dbGetQuery(con, "SELECT uczestnik_id FROM uczestnicy ORDER BY uczestnik_id ASC;")
    updateSelectInput(session, "um_id_input", choices = uczestnicy$uczestnik_id)
    
  }
  )
  ## dodawanie nowego uczestnika koniec
  
  # wyświetlanie tabeli z uczestnikami
  output$uczestnicy_tbl <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM uczestnicy;")},
              error = function(e){
                return(data.frame())
              })
    }
  )
  
  # tabela ze stałymi klientami
  output$stali_klienci_tbl <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM stali_klienci;")},
              error = function(e){
                return(data.frame())
              })
    }
  )
  
  ## update inputu do modyfikacji
  tryCatch({
    uczestnicy <- dbGetQuery(con, "SELECT uczestnik_id FROM uczestnicy ORDER BY uczestnik_id ASC;")
    updateSelectInput(session, "um_id_input", choices = uczestnicy$uczestnik_id)
  }, error = function(e){})
  
  ## modyfikacja klienta
  
  observeEvent(input$uczestnik_mod_id, {
    id <- input$um_id_input
    imie <- input$ud_imie_input
    nazwisko  <- input$ud_nazwisko_input 
    kraj_zamieszkania <- input$ud_kraj_input
    miasto <- input$ud_miasto_input
    kod_pocztowy  <- input$ud_kod_input
    ulica  <- input$ud_ulica_input
    numer_domu  <- input$ud_nr_domu_input
    data_urodzenia  <- input$ud_data_input
    PESEL  <- input$ud_pesel_input
    nr_telefonu  <- input$ud_nr_tel_input
    
    if (kraj_zamieszkania == 'Polska'){
      sql <- paste0("SELECT modyfikuj_klienta(",id, ",'", imie,"','", nazwisko,"','", kraj_zamieszkania,"','", miasto,"','", ulica,"','", numer_domu,"','", kod_pocztowy,"','", nr_telefonu,"','",  data_urodzenia,"','", PESEL, "');")
    }
    else{
      sql <- paste0("SELECT modyfikuj_klienta(",id, ",'", imie,"','", nazwisko,"','", kraj_zamieszkania,"','", miasto,"','", ulica,"','", numer_domu,"','", kod_pocztowy,"','", nr_telefonu,"','",  data_urodzenia,"');")
      
    }
    tryCatch({
      res <-dbSendQuery(con, sql)
      dbFetch(res)
      if(dbHasCompleted(res)){
        showNotification("Pomyślnie zmodyfikowane dane uczestnika",type = "message")
        
      }
      dbClearResult(res)
    },
    error = function(e){
      error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
      if (str_detect(error_to_show, "CONTEXT: ")){
        error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
      }
      if (str_detect(error_to_show, "DETAIL: ")){
        error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
      }
      if (str_detect(error_to_show, "check constraint")){
        # ogolnie to trzeba ogarnąć te case'y błędów które checki mogą zwracać
        switch (str_split(error_to_show, '"')[[1]][4],
                "pesel" = (error_to_show <- "Niepoprawny PESEL"),
                "kraj" = (error_to_show <- "Niepoprawny kraj zamieszkania")
        )
      }
      showModal(modalDialog(title = "Błąd w modyfikacji",error_to_show ,easyClose = TRUE,footer = NULL))
      
      
    })
    
    #update tabeli z uczestnikami
    output$uczestnicy_tbl <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM uczestnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }
    )
    
  }
  )
  
  
  
  
  
  
  #### UCZESTNICY KONIEC
  
  #### OFERTY
  ## najczestsze miejsca docelowe
  output$najczestsze_docelowe_tbl <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con, "SELECT * FROM najczestsze_cele;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX = TRUE))
  
  ## najbardziej oblegane miejsca docelowe
  output$najbardziej_oblegane_tbl <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con, "SELECT * FROM najwiecej_odwiedzane_cele;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX = TRUE))
  
  
  ## statystyki ofert 
  output$statystyki_ofert_tbl<- DT::renderDataTable(
    {tryCatch({dbGetQuery(con, "SELECT * FROM statystyki_ofert;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX = TRUE))
  
  #### OFERTY KONIEC
  
  
  #### PRZEWODNICY
  ## przeglądaj przewodników
  # output$przewodnicy <- DT::renderDataTable(
  #   {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnicy;")},
  #             error = function(e){
  #               return(data.frame())
  #             })
  #     }, options = list(scrollX=TRUE)
  # )
  output$przewodnicy <- DT::renderDataTable({
    if (input$aktywnosc == 1) {
      sql <- "SELECT * FROM przewodnicy WHERE aktywny=TRUE;"
    }else if(input$aktywnosc == 2){
      sql <- "SELECT * FROM przewodnicy WHERE aktywny=FALSE;"
    }else{sql <- "SELECT * FROM przewodnicy;"}
    {tryCatch({dbGetQuery(con,sql)},
                          error = function(e){
  
  
  
  output$doswiadczeni_przewodnicy <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX=TRUE)
  )
  
  output$wycieczki_przewodnikow <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX=TRUE)
  )
  
  # zwolnienie przewodnika
  #informacje o zwalnianym
  output$info_zwolnij <- renderText({ 
    id<-input$zwolnij
    tryCatch({res <- dbGetQuery(con, paste0("SELECT * FROM przewodnicy WHERE przewodnik_id=",id,";"))
    str_c(c("ID:", ", Imię:", ", Nazwisko:", ", Email:", ", Telefon:", ", Status:"),str_replace_all(unname(res), c("TRUE" = "aktywny", "FALSE" = "nieaktywny")), sep = " ", collapse = "")
    
    })
  })
  #zwolnienie
  observeEvent(input$zwolnij_button,{
    id <- input$zwolnij
    sql <- paste0("SELECT zwolnij(",id,");")
    tryCatch({res <-dbGetQuery(con, sql)
    }, error = function(e){
      error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
      if (str_detect(error_to_show, "CONTEXT: ")){
        error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
      }
      if (str_detect(error_to_show, "DETAIL: ")){
        error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
      }
      showModal(modalDialog(title = "Nie można zwolnić tego przewodnika", error_to_show, easyClose = TRUE, footer = NULL))
      
    }
    )
    # update wybierania przewodników do zlecania wycieczek
    przewodnicy_aktywni <- dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE ORDER BY przewodnik_id ASC;")$przewodnik_id
    updateSelectInput(session, "p_zlec_wycieczke_select", choices = przewodnicy_aktywni )
    #update przewodników do zwolnienia
    updateSelectInput(session, "zwolnij", choices = przewodnicy_aktywni )
    # update przewodników do wyboru do aktualizowania ich info
    updateSelectInput(session, "przewodnik_do_akt_select", choices = przewodnicy_aktywni)
    # update tabeli z przewodnikami 
    output$przewodnicy <- DT::renderDataTable(DT::datatable({
      if (input$aktywnosc == 1) {
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=TRUE;"
      }else if(input$aktywnosc == 2){
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=FALSE;"
      }else{sql <- "SELECT * FROM przewodnicy;"}
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }
    }))
    # update doświadczonych przewodników
    output$doswiadczeni_przewodnicy <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    # update wycieczek przewodników 
    output$wycieczki_przewodnikow <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    
  }
  )
  
  observeEvent(input$zatrudnij, {
    imie <- input$p_imie_input
    nazwisko  <- input$p_nazwisko_input 
    nr_telefonu  <- input$p_telefon_input
    sql <- paste0("SELECT zatrudnij('",imie,"','",nazwisko,"','",nr_telefonu,"');")
    tryCatch({res <-dbSendQuery(con, sql)
    dbFetch(res)
    if(dbHasCompleted(res)){
      showNotification("Pomyslnie zatrudniono nowego przewodnika", type = "message")
    }
    dbClearResult(res)
    # },
    # error = function(e){
    #   error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
    #   if (str_detect(error_to_show, "CONTEXT: ")){
    #     error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
    #   }
    #   if (str_detect(error_to_show, "DETAIL: ")){
    #     error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
    #   }
    #   if (str_detect(error_to_show, "check constraint")){
    #     # ogolnie to trzeba ogarnąć te case'y błędów które checki mogą zwracać
    #     switch (str_split(error_to_show, '"')[[1]][4],
    #             "pesel" = (error_to_show <- "Niepoprawny PESEL"),
    #             "kraj" = (error_to_show <- "Niepoprawny kraj zamieszkania")
    #     )
    #   }
    #   showNotification(paste0(error_to_show), type = "error")
    #   
    # }
    })
    # update wybierania przewodników do zlecania wycieczek
    przewodnicy_aktywni <- dbGetQuery(con,"SELECT przewodnik_id FROM przewodnicy WHERE aktywny=TRUE ORDER BY przewodnik_id ASC;")$przewodnik_id
    updateSelectInput(session, "p_zlec_wycieczke_select", choices = przewodnicy_aktywni )
    #update przewodników do zwolnienia
    updateSelectInput(session, "zwolnij", choices = przewodnicy_aktywni )
    # update przewodników do wyboru do aktualizowania ich info
    updateSelectInput(session, "przewodnik_do_akt_select", choices = przewodnicy_aktywni)
    # update tabeli z przewodnikami 
    output$przewodnicy <- DT::renderDataTable(DT::datatable({
      if (input$aktywnosc == 1) {
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=TRUE;"
      }else if(input$aktywnosc == 2){
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=FALSE;"
      }else{sql <- "SELECT * FROM przewodnicy;"}
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }
    }))
    # update doświadczonych przewodników
    output$doswiadczeni_przewodnicy <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    # update wycieczek przewodników 
    output$wycieczki_przewodnikow <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    
  })
  
  
  observeEvent(input$p_aktualizuj_id, {
    imie <- input$p_akt_imie_input
    nazwisko  <- input$p_akt_nazwisko_input 
    nr_telefonu  <- input$p_akt_telefon_input
    id <- input$przewodnik_do_akt_select
    sql <- paste0("UPDATE przewodnicy SET imie='",imie,"',nazwisko='",nazwisko,"',nr_telefonu='",nr_telefonu,"' WHERE przewodnik_id=",id,";")
    tryCatch({res <-dbSendQuery(con, sql)
    if(dbHasCompleted(res)){
      showNotification("Zaktualizowano informacje o przewodniku", type = "message")
    }
    dbClearResult(res)
    }
    )
    
    # update tabeli z przewodnikami 
    output$przewodnicy <- DT::renderDataTable(DT::datatable({
      if (input$aktywnosc == 1) {
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=TRUE;"
      }else if(input$aktywnosc == 2){
        sql <- "SELECT * FROM przewodnicy WHERE aktywny=FALSE;"
      }else{sql <- "SELECT * FROM przewodnicy;"}
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }
    }))
    # update doświadczonych przewodników
    output$doswiadczeni_przewodnicy <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    
  })
  
  ## odświeża wycieczki do wyboru dla danego przewodnika po jego wyborze
  observeEvent(input$p_zlec_wycieczke_select, {
    wycieczki_do_zlecania <- tryCatch({dbGetQuery(con, paste0("SELECT wycieczka_id FROM wycieczki EXCEPT
                                     (SELECT wycieczka_z_kolizja FROM kolidujace_wycieczki_przewodnikow WHERE przewodnik_id=",input$p_zlec_wycieczke_select,") ORDER BY wycieczka_id ASC;"))
    },error = function(e){
      return(data.frame(wycieczka_id = c(1)))
    })
    updateSelectInput(session, "w_zlec_wycieczke_select", choices = wycieczki_do_zlecania$wycieczka_id)
  })
  
  
  
  
  # output$kolidujace_wycieczki <- DT::renderDataTable(
  #   tryCatch({dbGetQuery(con, paste0("SELECT * FROM kolidujace_wycieczki_przewodnikow WHERE przewodnik_id=",input$p_zlec_wycieczke_select,";"))
  #   },error = function(e){
  #     return(data.frame())
  #   }), options = list(scrollX=TRUE)
  # )
  
  
  observeEvent(input$p_zlec_wycieczke_button, {
    id_p <- input$p_zlec_wycieczke_select
    id_w <- input$w_zlec_wycieczke_select
    sql <- paste0("SELECT dodaj_przewodnika(",id_p,",",id_w,");")
    tryCatch({res <-dbSendQuery(con, sql)
    dbFetch(res)
    if (dbHasCompleted(res)){
      showNotification("Zlecono przewodnikowi nową wycieczkę")
    }
    dbClearResult(res)
    })
    # odświeżenie listy kolidujących wycieczek po zleceniu wycieczki
    # output$kolidujace_wycieczki <- DT::renderDataTable(
    #   tryCatch({dbGetQuery(con, paste0("SELECT * FROM kolidujace_wycieczki_przewodnikow WHERE przewodnik_id=",input$p_zlec_wycieczke_select,";"))
    #   },error = function(e){
    #     return(data.frame())
    #   }), options = list(scrollX=TRUE)
    # )
    # odświeża wybór wycieczek mozliwych do zlecania po zleceniu wycieczki
    wycieczki_do_zlecania <- tryCatch({dbGetQuery(con, paste0("SELECT wycieczka_id FROM wycieczki EXCEPT
                                     (SELECT wycieczka_z_kolizja FROM kolidujace_wycieczki_przewodnikow WHERE przewodnik_id=",input$p_zlec_wycieczke_select,") ORDER BY wycieczka_id ASC;"))
    },error = function(e){
      return(data.frame(wycieczka_id = c(1)))
    })
    updateSelectInput(session, "w_zlec_wycieczke_select", choices = wycieczki_do_zlecania$wycieczka_id)
    # update doświadczonych przewodników
    output$doswiadczeni_przewodnicy <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    # update wycieczek przewodników 
    output$wycieczki_przewodnikow <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
                error = function(e){
                  return(data.frame())
                })
      }
    )
    
    
  })
  
  #### PRZEWODNICY KONIEC
  
  #### WYCIECZKI POCZATEK
  
  output$przegladaj_wycieczki_tbl <- DT::renderDataTable(
    tryCatch({dbGetQuery(con, "SELECT * FROM wycieczki;")},
             error = function(e){
               return(data.frame())
             }), options = list(scrollX = TRUE))#,editable=list(target='row',disable=list(columns=c(1,2)))
  
  
  
  output$sprawdz_przewodnictwa_wycieczek_tbl <- DT::renderDataTable(
    tryCatch({dbGetQuery(con, "SELECT wycieczka_id,przewodnik_id FROM przewodnictwa;")},
             error = function(e){
               return(data.frame())
             }), options = list(scrollX = TRUE))
  
  output$zblizajace_sie_wycieczki_tbl <- DT::renderDataTable(
    tryCatch({dbGetQuery(con, "SELECT * FROM zblizajace_sie_wycieczki(30);")},
             error = function(e){
               return(data.frame())
             }))
  
  observeEvent(input$zbw_dni_input, {
    output$zblizajace_sie_wycieczki_tbl <- DT::renderDataTable(
      tryCatch({
        dbGetQuery(con, paste0("SELECT * FROM zblizajace_sie_wycieczki(",as.integer(input$zbw_dni_input), ");"))},
        error = function(e){
          return(data.frame())
        })
    )
  })
  
  #### WYCIECZKI KONIEC
  
  #### START
  
  output$start <- renderPlot({plot(c(0,0,1,0,1,0,2,2.5,3,3.5,2.5,3,3.5,4,5,7,5,7,5,9,9,8,9,10,9,9),c(0,2,1.5,1,0.5,0,0,1,2,1,1,2,1,0,0,2,2,2,0,0,1,2,1,2,1,0),type="l",col='blue',xaxt='n',yaxt='n',ann=FALSE)})
  
}
