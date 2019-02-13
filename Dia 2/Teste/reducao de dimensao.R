#Exemplo: reduzir a dimensão de determinantes socioeconômicos da realização
#de 7 ou mais consultas pré-natal nos municípios brasileiros

Municipios <- read.csv("bancoprenatal.csv", sep = ";")

# Comando básico para Análise de Componentes Principais do R
# princomp()

# Usaremos o pacote "psych"
install.packages("psych")
library(psych)

# Escolher o número de componentes principais
fa.parallel (Municipios[,2:8], fa="pc", show.legend=FALSE, main = "Eigenvalues dos componentes 
             principais")

# Análise dos componentes principais
pc2 <- principal(Municipios[,2:8], nfactors = 2)
pc2

# Extrair os dois primeiros componentes principais
pc2 <- principal(Municipios[,2:8], nfactors = 2, score = TRUE) 
View(pc2$scores)

# Correlação entre pré-natal e características socioeconômicas
cor(Municipios$prenatal, pc2$score)

