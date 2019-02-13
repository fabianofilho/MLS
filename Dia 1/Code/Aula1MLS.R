# Baixar pacote tidyverse
install.packages("tidyverse")

# Ver todos chamados
.packages()

# Criar objeto
a <- 4
a*10

# R grava por cima sem reclamar
a <- a + 10

# Criar Variável
b <- c (3,4,5)

# Média da variável
mean(b)

# Criar Banco de Dados
pesquisa <- data.frame(filhos= c(1,0,0,0,0,0,0,2,1,0,0), 
                       altura= c(1.73,1.64,1.58,1.72,1.70,1.72,1.84,1.69,1.64,1.90,1.75))

# Pedir média da variável dentro do banco de dados
mean(pesquisa$filhos)

# Resumo do Banco de Dados
summary(pesquisa)

# Visualizar o banco
View(pesquisa)
