source("db_con.R")
library(shiny)
library(DT)
library(stringi)

shinyServer<- function(input, output){
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
    
    sql <- paste0("INSERT INTO uczestnicy(imie, nazwisko, kraj_zamieszkania, miasto, kod_pocztowy, ulica, numer_domu, data_urodzenia, PESEL, nr_telefonu) VALUES('", imie, "', '",
                  nazwisko, "','",
                  kraj_zamieszkania, "','",
                  miasto, "','",
                  kod_pocztowy, "','",
                  ulica, "','",
                  numer_domu, "','",
                  data_urodzenia, "','")
    if (is.na(PESEL)){
      sql <- paste0(sql,nr_telefonu ,"');")
      
    }
    else{
      sql <-paste0(sql, PESEL, "','", nr_telefonu, "');")
    }
    tryCatch({res <-dbSendQuery(con, sql)
    dbHasCompleted(res)
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
      showNotification(paste0(error_to_show), type = "error")
      
    })
  }
  )
  ## dodawanie nowego uczestnika koniec
  
  # wyświetlanie tabeli z uczestnikami
  output$uczestnicy_tbl <- DT::renderDataTable({
    return(dbGetQuery(con, "SELECT * FROM uczestnicy;"))
  }, options = list(scrollX = TRUE))
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
  
  
  
}
