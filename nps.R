#Libraries
#setwd(dir = 'ContaAzul/projetos/nps-text-analysis/')

library(RPostgreSQL)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(biclust)
library(cluster)
library(igraph)
library(fpc)
#source("libs/cabd.R")

getTexts <- function() {
  sql <- "select id,nps_comment as comment from nps.product_nps where nps_comment is not null"
  nps_df <- cadb.query(sql)
  
  for(i in 1:nrow(nps_df)) {
    row <- nps_df[i,]
    
    fileConn<-file( paste( 'texts', row$id,'.txt' , sep = ''))
    writeLines(c(row$comment), fileConn)
    close(fileConn)
  }
  
  cadb.freeDb()
}

#getTexts()
cname <- file.path("C:/Users/Marcus/Documents/ContaAzul/projetos/nps-text-analysis/", "texts")
docs <- Corpus(DirSource(cname, encoding='UTF-8'))

summary(docs)  

#Preprocessing
#remove special chars
for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
  docs[[j]] <- gsub("‘", "", docs[[j]])   
  docs[[j]] <- gsub("’", "", docs[[j]]) 
  docs[[j]] <- gsub("“", "", docs[[j]]) 
  docs[[j]] <- gsub("'", "", docs[[j]])   
}   

#remove  punctuation
docs <- tm_map(docs, removePunctuation) 

#remove number
docs <- tm_map(docs, removeNumbers)  

#to lower
docs <- tm_map(docs, tolower)

# stopwords("portuguese")   
docs <- tm_map(docs, removeWords, stopwords("portuguese"))   

#Removing particular words:
docs <- tm_map(docs, removeWords, c("department", "email"))   

#Combining words that should stay together
#for (j in seq(docs))
#{
#  docs[[j]] <- gsub("qualitative research", "QDA", docs[[j]])
#  docs[[j]] <- gsub("qualitative studies", "QDA", docs[[j]])
#  docs[[j]] <- gsub("qualitative analysis", "QDA", docs[[j]])
#  docs[[j]] <- gsub("research methods", "research_methods", docs[[j]])
#}

#This tells R to treat your preprocessed documents as text documents.
docs <- tm_map(docs, PlainTextDocument) 

#Removing common word endings (e.g., “ing”, “es”, “s”)
#docs <- tm_map(docs, stemDocument, language = "portuguese")

#Stripping unnecesary whitespace from your documents:
#docs <- tm_map(docs, stripWhitespace)  

#Stage the Data
dtm <- DocumentTermMatrix(docs)   
#inspect(dtm[1:5, 1:20])

#transpose of this matrix
tdm <- TermDocumentMatrix(docs) 

#organize terms by their frequency:
freq <- colSums(as.matrix(dtm))   
length(freq)   

#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
inspect(dtms)  



