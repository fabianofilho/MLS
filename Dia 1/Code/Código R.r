# Calcular o IMC de uma pessoa com 89kg e 1m76
89/1.76^2

# Baixar pacote tidyverse
install.packages("tidyverse")

# criar objeto
a <- 4
a*10

# R grava por cima sem reclamar
a <- a + 10
a
# criar vari�vel
b <- c(3,4,5)

#M�dia da vari�vel
mean(b)

# criar um banco de dados
pesquisa <- data.frame(filhos = c(1,0,0,0,0,0,0,2,
                                  1,0,0,0), altura = c(1.73,1.64,1.58,
                                  1.71,1.70,1.72,1.84,1.69,1.64,1.90,1.75,1.52))

# pedir m�dia de vari�vel em banco de dados
mean(pesquisa$filhos)

mean(pesquisa$altura)

####resumo do banco
summary(pesquisa)

####Visualizar o banco

View(pesquisa)
