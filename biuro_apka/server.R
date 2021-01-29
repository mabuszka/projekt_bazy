source("db_con.R")
library(shiny)
library(DT)
library(stringi)

shinyServer<- function(input, output){
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
    tryCatch({dbSendQuery(con, sql)}, error = function(e){
      error_to_show <- str_split(str_split(e, pattern = "ERROR: ")[[1]][2], "CONTEXT: ")[[1]][1]
      showNotification(paste0(error_to_show), type = "error")
    })
  })
  
  
}
