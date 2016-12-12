library(RPostgreSQL)

cadb.connection  <- NULL
cadb.drv <- NULL

cadb.getConnection <- function() {
 
  if (!is.null(cadb.connection)) {
    return(cadb.connection)
  }   
  
  # create a connection
  # loads the PostgreSQL driver
  drv <<- dbDriver("PostgreSQL")
  # creates a connection to the postgres database
  # note that "con" will be used later in each connection to the database
  cadb.connection <<- dbConnect(drv, dbname = "bridge",
                   host = "bigdata-rds-ro.contaazul.com", port = 5432,
                   user = "marcus", password = "GfVCoKM3rold")

  postgresqlpqExec(cadb.connection, "SET client_encoding = 'windows-1252'");
  
  # return the conncetion 
  cadb.connection
}

cadb.executeQuery <- function(sql) {
  
  dbExecute(cadb.getConnection(), sql);
}

cadb.query <- function(sql) {
  
  df_postgres <- dbGetQuery(cadb.getConnection(), sql)
  return (df_postgres)
}


cadb.testDb <- function() {
  baseActiveClientsSQL <- "select 10";
  return(dbGetQuery(cadb.getConnection(), baseActiveClientsSQL))
}


cadb.freeDb <- function() {
  dbDisconnect(connection)
  dbUnloadDriver(drv)
}













