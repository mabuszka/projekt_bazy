library(RPostgres)
library(shiny)
library(DT)
library(stringi)
library(stringr)
library(purrr)


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
  
  #### OFERTY --------------------------------------------------------------------------------------------------------
  
  ## przyciski do wybierania czy najczestszce cele czy najbardziej oblegane miejsca
  observeEvent(input$najczestsze_sele_tab_select,{
    updateTabsetPanel(session, "najczestsze_cele_tabs", selected = input$najczestsze_sele_tab_select)
  })
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
  
  
  ## wyszukiwanie i wyświetlanie ofert
  output$wyszukane_oferty <- DT::renderDataTable(tryCatch({
    dbGetQuery(con, "SELECT * from oferty;")
  }, error = function(e){
    return(data.frame())
  }), options = list(pageLength = 5))

  ## zapełnienie wybierania tagów
  tryCatch({
    tagi <- dbGetQuery(con, "SELECT tag FROM tagi;")$tag
    updateSelectInput(session, "tagi_ofert_input", choices = tagi )
  }, error = function(e){}
  )
  
  ## zapełnienie wybierania atrakcji
  tryCatch({
    atrakcje <- dbGetQuery(con, "SELECT atrakcja FROM atrakcje;;")$atrakcja
    updateSelectInput(session, "atrakcje_ofert_input", choices = atrakcje )
  }, error = function(e){}
  )
  
  # wyszukiwanie ofert
  observeEvent(input$wyszukaj_oferte,{
    tryCatch({
      atrakcje <- str_c("'",input$atrakcje_ofert_input, "'", collapse = ",")
      tagi <- str_c("'",input$tagi_ofert_input, "'", collapse = ",")
      output$test <- renderText(tagi)
      if (input$tagi_czy_wszystkie){
        fcja_tagi <- "oferty_z_tagami"
      }
      else{
        fcja_tagi <- "oferty_ze_wszystkimi_tagami"
      }
      if (input$atrakcje_czy_wszystkie){
        fcja_atrakcje <- "oferty_z_atrakcjami"
      }
      else {
        fcja_atrakcje <- "oferty_ze_wszystkimi_atrakcjami"
      }
      sql <- paste0("SELECT o.oferta_id, o.miejsce_wyjazdu,a.atrakcje, t.tagi, o.dlugosc_wyjazdu,o.limit_uczestnikow, o.cena_podstawowa FROM oferty o JOIN (SELECT * FROM ",
                    fcja_atrakcje ,"(", atrakcje,")) AS a ON (a.oferta_id = o.oferta_id) JOIN (SELECT * FROM ",
                    fcja_tagi, "(", tagi,")) AS t ON (o.oferta_id = t.oferta_id)", "WHERE o.dlugosc_wyjazdu BETWEEN ",
                    input$zakres_dni_ofert_input[1], " AND ", input$zakres_dni_ofert_input[2],";")
      output$wyszukane_oferty <- renderDataTable({
        dbGetQuery(con, sql)
      })
    })
  })
  
  # select o.oferta_id, o.miejsce_wyjazdu,a.atrakcje , t.tagi,o.limit_uczestnikow, o.dlugosc_wyjazdu, o.cena_podstawowa from oferty o join (SELECT * FROM oferty_ze_wszystkimi_atrakcjami('kregle')) as a on (a.oferta_id = o.oferta_id) join (SELECT * FROM oferty_ze_wszystkimi_tagami('morze')) as t on (o.oferta_id = t.oferta_id);
    
  #zarządzanie
  
  # observeEvent("o_utworz_button", {
  #   miejsce<-input$o_utworz_miasto
  #   limit<-input$o_utworz_limit
  #   dni<-input$o_utworz_dni
  #   cena<-input$o_utworz_cena
  #   opis<-input$o_utworz_opis
  #   foto<-input$o_utworz_foto
  #   sql <- paste0("INSERT INTO oferty(miejsce_wyjazdu,limit_uczestnikow,dlugosc_wyjazdu,cena_podstawowa,opis_oferty,zdjecie) VALUES('",miejsce,"'",limit,dni,cena,"'",opis,"'",foto,");")
  #   tryCatch({res <-dbGetQuery(con, sql)
  #   }, error = function(e){
  #     error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
  #     if (str_detect(error_to_show, "CONTEXT: ")){
  #       error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "DETAIL: ")){
  #       error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "constraint")){
  #       error_to_show <- "Błędne dane"
  #     }
  #     showModal(modalDialog(title = "Nie można utworzyć takiej oferty", error_to_show, easyClose = TRUE, footer = NULL))
  # 
  #   }
  #   )
  # })
  
  # 
  # tryCatch({
  #   oferty_do_edycji <- dbGetQuery(con, "SELECT oferta_id FROM oferty ORDER BY oferta_id ASC;")
  #   updateSelectInput(session, inputId = "o_modyfikuj_select",
  #                     choices = oferty_do_edycji$oferty_id)
  # 
  # }, error = function(e){return(data.frame(oferta_id = c(1)))}
  # 
  # observeEvent("o_modyfikuj_button",{
  #   id<-input$o_modyfikuj_select
  #   opis<-input$o_modyfikuj_opis
  #   foto<-input$o_modyfikuj_foto
  #   sql <- paste0("UPDATE oferty SET opis_oferty='",opis,"',zdjecie=",foto," WHERE oferta_id=",id,");")
  #   tryCatch({res <-dbGetQuery(con, sql)
  #   }, error = function(e){
  #     error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
  #     if (str_detect(error_to_show, "CONTEXT: ")){
  #       error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "DETAIL: ")){
  #       error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "constraint")){
  #       error_to_show <- "Błędne dane"
  #     }
  #     showModal(modalDialog(title = "Nie można edytować oferty", error_to_show, easyClose = TRUE, footer = NULL))
  # 
  #   }
  #   )
  # })
  # 
  # )
  # tryCatch({
  #   oferty_do_usuniecia <- dbGetQuery(con, "SELECT oferta_id FROM oferty ORDER BY oferta_id ASC;")
  #   updateSelectInput(session, inputId = "o_usun_select",
  #                     choices = oferty_do_usuniecia$oferty_id)
  # }, error = function(e){return(data.frame(oferta_id = c(1)))}
  # )
  # 
  # output$o_usun_text <- renderText({
  #   id<-input$o_usun_select
  #   tryCatch({res <- dbGetQuery(con, paste0("SELECT oferta_id,miejsce_wyjazdu,limit_uczestnikow,dlugosc_wyjazdu,cena_podstawowa FROM oferty WHERE oferta_id=",id,";"))
  #   str_c(c("ID:", ", Miejsce wyjazdu:", ", Limit uczestników:", ", Długość wyjazdu:", ", Cena podstawowa:"),unname(res), sep = " ", collapse = "")
  # 
  #   })
  # })
  # 
  # 
  # observeEvent("o_usun_button",{
  #   id<-input$o_usun_select
  #   sql <- paste0("DELETE FROM oferty WHERE oferta_id=",id,";")
  #   tryCatch({res <-dbGetQuery(con, sql)
  #   }, error = function(e){
  #     error_to_show <- str_split(e, pattern = "ERROR: ")[[1]][2]
  #     if (str_detect(error_to_show, "CONTEXT: ")){
  #       error_to_show <- str_split(error_to_show, "CONTEXT: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "DETAIL: ")){
  #       error_to_show <- str_split(error_to_show, "DETAIL: ")[[1]][1]
  #     }
  #     if (str_detect(error_to_show, "constraint")){
  #       error_to_show <- "Błędne dane"
  #     }
  #     showModal(modalDialog(title = "Nie można usunąć tej oferty", error_to_show, easyClose = TRUE, footer = NULL))
  # 
  #   }
  #   )
  # })

  #### OFERTY KONIEC
  
  
  #### PRZEWODNICY --------------------------------------------------------------------------------------
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
                return(data.frame())
              })
    }}
  )
  
  
  
  output$doswiadczeni_przewodnicy <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM najbardziej_doswiadczeni_przewodnicy;")},
              error = function(e){
                return(data.frame())
              })
    }
  )
  
  output$wycieczki_przewodnikow <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
              error = function(e){
                return(data.frame())
              })
    }
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
      if (str_detect(error_to_show, "constraint")){
        error_to_show <- "Błędne dane"
      }
      showModal(modalDialog(title = "Nie można zwolnić tego przewodnika", error_to_show, easyClose = TRUE, footer = NULL))
      
    }
    )
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    # update wybierania przewodników do zlecania wycieczek
    przewodnicy_aktywni <- dbGetQuery(con,paste0("SELECT przewodnik_id FROM przewodnicy EXCEPT
                                     (SELECT przewodnik_id FROM kolidujace_wycieczki_przewodnikow WHERE wycieczka_z_kolizja=",input$w_zlec_wycieczke_select,") ORDER BY przewodnik_id ASC;"))$przewodnik_id
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
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    # update wybierania przewodników do zlecania wycieczek
    przewodnicy_aktywni <- dbGetQuery(con,paste0("SELECT przewodnik_id FROM przewodnicy EXCEPT
                                     (SELECT przewodnik_id FROM kolidujace_wycieczki_przewodnikow WHERE wycieczka_z_kolizja=",input$w_zlec_wycieczke_select,") ORDER BY przewodnik_id ASC;"))$przewodnik_id
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
  
  #### PRZEWODNICY KONIEC
  
  
  #### WYCIECZKI POCZATEK ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  #SELECTY
  tryCatch({
    wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
    updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                      choices = wycieczki_do_zlecania$wycieczka_id)
    
  }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
  )
  tryCatch({
    wycieczki_do_modyfikacji <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
    updateSelectInput(session, inputId = "w_modyfikuj_select",
                      choices = wycieczki_do_modyfikacji$wycieczka_id)
    
  }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
  )
  tryCatch({
    wycieczki_do_usuniecia <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
    updateSelectInput(session, inputId = "w_usun_select",
                      choices = wycieczki_do_usuniecia$wycieczka_id)
    
  }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
  )
  
  
  #6
  output$przegladaj_wycieczki_tbl <- DT::renderDataTable({
    sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE AND oferta_id=",input$wyc_oferta_select,";")
    {tryCatch({dbGetQuery(con,sql)},
              error = function(e){
                return(data.frame())
              })
    }}, options = list(scrollX=TRUE)
  )
  
  #7
  output$sprawdz_przewodnictwa_wycieczek_tbl <- DT::renderDataTable(
    tryCatch({dbGetQuery(con, "SELECT wycieczka_id,przewodnik_id FROM przewodnictwa;")},
             error = function(e){
               return(data.frame())
             }), options = list(scrollX = TRUE))
  
  #8
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
  
  #3
  output$w_info_oferta <- renderText({ 
    id<-input$w_stworz_oferta_input
    tryCatch({res <- dbGetQuery(con, paste0("SELECT oferta_id,miejsce_wyjazdu,limit_uczestnikow,dlugosc_wyjazdu,cena_podstawowa FROM oferty WHERE oferta_id=",id,";"))
    str_c(c("ID:", ", Miejsce wyjazdu:", ", Limit uczestników:", ", Dlługość wyjazdu:", ", Cena podstawowa:"),as.character(unname(res)), sep = " ", collapse = "")
    
    })
  })
  
  observeEvent(input$w_utworz, {
    data <- input$w_stworz_data_input
    id_o <- input$w_stworz_oferta_input
    sql <- paste0("SELECT dodaj_wycieczke('",id_o,"','",data,"');")
    tryCatch({res <-dbSendQuery(con, sql)
    dbFetch(res)
    if (dbHasCompleted(res)){
      showNotification("Utworzono nową wycieczkę")
    }
    dbClearResult(res)
    })
    #updateSelectInput(session, "w_zlec_wycieczke_select", choices = wycieczki_do_zlecania$wycieczka_id)
    # update tabeli z wycieczkami
    output$przegladaj_wycieczki_tbl <- DT::renderDataTable({
      sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE;")
      if (input$wyc_oferta_select != 'all'){
        sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE AND oferta_id=",input$wyc_oferta_select,";")}
      
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }}, options = list(scrollX=TRUE)
    )
    #update zbliżających się wycieczek
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
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    #update wycieczek do modyfikacji
    tryCatch({
      wycieczki_do_modyfikacji <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "w_modyfikuj_select",
                        choices = wycieczki_do_modyfikacji$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    # update wycieczek do usunięcia
    tryCatch({
      wycieczki_do_usuniecia <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "w_usun_select",
                        choices = wycieczki_do_usuniecia$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    
    
  })
  
  #1
  output$w_info_modyfikuj <- renderText({ 
    id<-input$w_modyfikuj_select
    tryCatch({res <- dbGetQuery(con, paste0("SELECT wycieczka_id, liczba_uczestnikow, data_rozpoczecia::TEXT, data_zakonczenia::TEXT, oferta_id FROM wycieczki WHERE wycieczka_id=",id,";"))
    #res<-unname(res)
    str_c(c("ID:", ", Liczba uczestnków:", ", Data rozpoczęcia:", ", Data zakończenia:", ", Numer oferty:"),res, sep = " ", collapse = "")
    
    })
  })
  
  observeEvent(input$w_modyfikuj, {
    data <- input$w_modyfikuj_data_input
    id_w <- input$w_modyfikuj_select
    sql <- paste0("SELECT modyfikuj_wycieczke('",id_w,"','",data,"');")
    tryCatch({res <-dbSendQuery(con, sql)
    dbFetch(res)
    if (dbHasCompleted(res)){
      showNotification("Zmodyfikowano wycieczkę")
    }
    dbClearResult(res)
    })
    # update tabeli z wycieczkami
    output$przegladaj_wycieczki_tbl <- DT::renderDataTable({
      sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE;")
      if (input$wyc_oferta_select != 'all'){
        sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE AND oferta_id=",input$wyc_oferta_select,";")}
      
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }}, options = list(scrollX=TRUE)
    )
    #update zbliżających się wycieczek
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
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )

    
  })
  
  #2
  output$w_info_usun <- renderText({ 
    id<-input$w_usun_select
    tryCatch({res <- dbGetQuery(con, paste0("SELECT wycieczka_id, liczba_uczestnikow, data_rozpoczecia::TEXT, data_zakonczenia::TEXT, oferta_id FROM wycieczki WHERE wycieczka_id=",id,";"))
    str_c(c("ID:", ", Liczba uczestnków:", ", Data rozpoczęcia:", ", Data zakończenia:", ", Numer oferty:"),as.character(unname(res)), sep = " ", collapse = "")
    
    })
  })
  
  observeEvent(input$w_usun, {
    id_w <- input$w_usun_select
    sql <- paste0("DELETE FROM wycieczki WHERE wycieczka_id=",id_w,";")
    tryCatch({res <-dbSendQuery(con, sql)
    dbFetch(res)
    if (dbHasCompleted(res)){
      showNotification("Usunięto wycieczkę")
    }
    dbClearResult(res)
    })
    # update tabeli z wycieczkami
    output$przegladaj_wycieczki_tbl <- DT::renderDataTable({
      sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE;")
      if (input$wyc_oferta_select != 'all'){
        sql<-paste0("SELECT * FROM wycieczki WHERE data_rozpoczecia>='",input$wyc_data_input[1],"'::DATE AND data_zakonczenia<='",input$wyc_data_input[2],"'::DATE AND oferta_id=",input$wyc_oferta_select,";")}
      
      {tryCatch({dbGetQuery(con,sql)},
                error = function(e){
                  return(data.frame())
                })
      }}, options = list(scrollX=TRUE)
    )
    #update zbliżających się wycieczek
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
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    # update wycieczek do modyfikacji 
    tryCatch({
      wycieczki_do_modyfikacji <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "w_modyfikuj_select",
                        choices = wycieczki_do_modyfikacji$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    
  })
  
  ## 5
  observeEvent(input$ww_zlec_wycieczke_select, {
    przewodnicy_do_zlecania <- tryCatch({dbGetQuery(con, paste0("SELECT przewodnik_id FROM przewodnicy EXCEPT
                                     (SELECT przewodnik_id FROM kolidujace_wycieczki_przewodnikow WHERE wycieczka_z_kolizja=",input$ww_zlec_wycieczke_select,") ORDER BY przewodnik_id ASC;"))
    },error = function(e){
      return(data.frame(wycieczka_id = c(1)))
    })
    updateSelectInput(session, "wp_zlec_wycieczke_select", choices = przewodnicy_do_zlecania$przewodnik_id)
  })
  
  observeEvent(input$p_zlec_wycieczke_button, {
    id_p <- input$wp_zlec_wycieczke_select
    id_w <- input$ww_zlec_wycieczke_select
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
    przewodnicy_do_zlecania <- tryCatch({dbGetQuery(con, paste0("SELECT przewodnik_id FROM przewodnicy EXCEPT
                                     (SELECT przewodnik_id FROM kolidujace_wycieczki_przewodnikow WHERE wycieczka_id=",input$ww_zlec_wycieczke_select,") ORDER BY wycieczka_id ASC;"))
    },error = function(e){
      return(data.frame(wycieczka_id = c(1)))
    })
    updateSelectInput(session, "wp_zlec_wycieczke_select", choices = przewodnicy_do_zlecania$przewodnik_id)
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
    output$w_odwolaj_tbl <- DT::renderDataTable(
      {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
                error = function(e){
                  return(data.frame())
                })
      }, options = list(scrollX=TRUE)
    )
    #update do przewodnictw
    output$sprawdz_przewodnictwa_wycieczek_tbl <- DT::renderDataTable(
      tryCatch({dbGetQuery(con, "SELECT wycieczka_id,przewodnik_id FROM przewodnictwa;")},
               error = function(e){
                 return(data.frame())
               }), options = list(scrollX = TRUE))
  })

  
  #4
  output$w_odwolaj_tbl <- DT::renderDataTable(
    {tryCatch({dbGetQuery(con,"SELECT * FROM przewodnictwa;")},
              error = function(e){
                return(data.frame())
              })
    }, options = list(scrollX=TRUE)
  )
  
  output$selectedrow <- DT::renderDataTable({
    selectedrowindex <- input$w_odwolaj_tbl_rows_selected[length(input$w_odwolaj_tbl_rows_selected)]
    selectedrowindex <- as.numeric(selectedrowindex)
    selectedrow <- (w_odwolaj_tbl[selectedrowindex,])
    selectedrow
  })
  
  observeEvent(input$w_odwolaj, {
    row <- selectedrow
    if (length(row)) {
      tryCatch({res <-dbSendQuery(con, paste0("SELECT usun_przewodnika(",w_odwolaj_tbl[row,],");"))
      dbFetch(res)
      if (dbHasCompleted(res)){
        showNotification("Usunięto przewodnika z wycieczki")
      }
      dbClearResult(res)
      })
    }
    # update wyboru wycieczek do zlecenia przewodnikowi
    tryCatch({
      wycieczki_do_zlecania <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki ORDER BY wycieczka_id ASC;")
      updateSelectInput(session, inputId = "ww_zlec_wycieczke_select",
                        choices = wycieczki_do_zlecania$wycieczka_id)
      
    }, error = function(e){return(data.frame(wycieczka_id = c(1)))}
    )
    #update do przewodnictw
    output$sprawdz_przewodnictwa_wycieczek_tbl <- DT::renderDataTable(
      tryCatch({dbGetQuery(con, "SELECT wycieczka_id,przewodnik_id FROM przewodnictwa;")},
               error = function(e){
                 return(data.frame())
               }), options = list(scrollX = TRUE))
  })
  
  #### WYCIECZKI KONIEC
  
  #### ZAMOWIENIA START
  ## update jakie wycieczki można wybrać
  tryCatch({
    wycieczki <- dbGetQuery(con, "SELECT wycieczka_id FROM wycieczki WHERE data_rozpoczecia > CURRENT_DATE ORDER BY wycieczka_id ASC;")
    updateSelectInput(session, inputId = 'zamowienie_wycieczka',
                      choices = wycieczki$wycieczka_id)
    
  }, error = function(e){}
  )
  ## update jakie są klasy zamowień
  tryCatch({
    klasy <- dbGetQuery(con, "SELECT klasa FROM klasy_ofert ORDER BY klasa ASC;")
    updateSelectInput(session, inputId = 'zamowienie_klasa',
                      choices = klasy$klasa)
    
  }, error = function(e){}
  )
  
  
  dane_ludzi_template <- reactive(c(t(sapply(c("Imię uczestnika ","Nazwisko uczestnika ", "Kraj zamieszkania uczestnika ", "Miasto zamieszkania uczestnika ", "Kod pocztowy uczestnika ", "Ulica zamieszkania uczestnika ", "Numer domu uczestnika ", "Data urodzenia uczestnika ", "PESEL uczestnika ", "Telefon uczestnika "),
                                             function(x){ paste0(x,seq_len(input$ile_w_zamowieniu))} ))))
  output$ludzie_w_zamowieniu <- renderUI({
    map(dane_ludzi_template(), ~ textInput(.x, label = .x, value = isolate(input[[.x]])) %||% "")
  })
  
  observeEvent(input$zatwierdz_dane,{
    text <- list()
    for (i in seq_len(input$ile_w_zamowieniu)){
      if (!isTruthy(input[[paste("PESEL uczestnika", i)]])){
        pesel <- "NULL"
      }
      else{
        pesel <-paste0("\"",input[[paste("PESEL uczestnika", i)]], "\"")
      }
      text[i] <- paste0(paste0('{"',input[[paste("Imię uczestnika", i)]], '","',
                               input[[paste("Nazwisko uczestnika", i)]],
                               '","',input[[paste("Kraj zamieszkania uczestnika", i)]],
                               '","',input[[paste("Miasto zamieszkania uczestnika", i)]],
                               '","',input[[paste("Kod pocztowy uczestnika", i)]],
                               '","',input[[paste("Ulica zamieszkania uczestnika", i)]],
                               '","',input[[paste("Numer domu uczestnika", i)]],
                               '","',input[[paste("Data urodzenia uczestnika", i)]],
                               '",',pesel,
                               ',"',input[[paste("Telefon uczestnika", i)]],
                               '"}' ))
      
    }
    # output$dane_ludzi <- renderText(str_c("'",unlist(text),"'", collapse = "' , '"))
    # 
    # output$dane_ludzi_w_zamowieniu <- renderUI({
    #   textOutput("dane_ludzi") 
    # })
    
    tryCatch({
      sql <- paste0("SELECT dodaj_zamowienie_z_klientami (",input$zamowienie_wycieczka,",",input$zamowienie_klasa,",'",input$zamowienie_platnosc ,"',",str_c("'",unlist(text),"'", collapse = " , ") ,");" )
      res <- dbSendQuery(con, sql)
      dbFetch(res)
      if (dbHasCompleted(res)){
        showNotification("Pomyślnie złożono zamówienie",type = "message")
      }
      dbClearResult(res)
    },
    error = function(e){
      showModal(modalDialog(title = "Błąd dodawania", e ,easyClose = TRUE,footer = NULL))
    })
    ## update tabeli z uczestnikami
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
  
  
  
  
  #### ZAMOWIENIA KONIEC
  
  
  #### START
  
  output$start <- renderPlot({plot(c(0,0,1,0,1,0,2,2.5,3,3.5,2.5,3,3.5,4,5,7,5,7,5,9,9,8,9,10,9,9),c(0,2,1.5,1,0.5,0,0,1,2,1,1,2,1,0,0,2,2,2,0,0,1,2,1,2,1,0),type="l",col='blue',xaxt='n',yaxt='n',ann=FALSE)})
  
}
