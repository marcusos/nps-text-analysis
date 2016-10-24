library(tm)
cname <- file.path("C:/Users/Marcus/Documents/ContaAzul/projetos/etl_textanalysis/", "texts")

docs <- Corpus(DirSource(cname))
summary(docs)  