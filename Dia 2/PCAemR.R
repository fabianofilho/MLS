#Exemplo: reduzir a dimens?o de determinantes socioecon?micos da realiza??o
#de 7 ou mais consultas pr?-natal nos munic?pios brasileiros

Municipios <- read.csv("bancoprenatal.csv", sep = ";")

View(Municipios)

# Comando b?sico para An?lise de Componentes Principais do R
princomp()

# Usaremos o pacote "psych"
install.packages("psych")
library(psych)

# Escolher o n?mero de componentes principais
fa.parallel (Municipios[,2:8], fa="pc", show.legend=FALSE, main = "Eigenvalues dos componentes 
             principais")

# An?lise dos componentes principais
pc2 <- principal(Municipios[,2:8], nfactors = 2)
pc2

# Extrair os dois primeiros componentes principais
pc2 <- principal(Municipios[,2:8], nfactors = 2, score = TRUE) 
View(pc2$scores)

# Correla??o entre pr?-natal e caracter?sticas socioecon?micas
cor(Municipios$prenatal, pc2$score)

