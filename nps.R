#Libraries
library(tm)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(biclust)
library(cluster)
library(igraph)
library(fpc)

cname <- file.path("C:/Users/Marcus/Documents/ContaAzul/projetos/etl_textanalysis/", "texts")

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

# stopwords("english")   
docs <- tm_map(docs, removeWords, stopwords("english"))   

#Removing particular words:
docs <- tm_map(docs, removeWords, c("department", "email"))   

#Combining words that should stay together
for (j in seq(docs))
{
  docs[[j]] <- gsub("qualitative research", "QDA", docs[[j]])
  docs[[j]] <- gsub("qualitative studies", "QDA", docs[[j]])
  docs[[j]] <- gsub("qualitative analysis", "QDA", docs[[j]])
  docs[[j]] <- gsub("research methods", "research_methods", docs[[j]])
}

#Removing common word endings (e.g., “ing”, “es”, “s”)
#docs <- tm_map(docs, stemDocument)

#Stripping unnecesary whitespace from your documents:
docs <- tm_map(docs, stripWhitespace)  

#This tells R to treat your preprocessed documents as text documents.
docs <- tm_map(docs, PlainTextDocument) 


#Stage the Data
dtm <- DocumentTermMatrix(docs)   
#inspect(dtm[1:5, 1:20])

