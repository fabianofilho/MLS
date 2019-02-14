#Pacotes
library(tidyverse)
library(caret)
library(hydroGOF)


#Importar banco de dados e transformar todas as variáveis em numéricas
banco <- read.table ("dados_expecvida2.csv", header = T ,sep=';', dec='.',colClass=c(rep("numeric",24)))

#Selecao de municipios com mais de 10.000 habitantes
#filtrar mun > 10.000 habitantes
banco_filtrado <- banco %>% 
  filter(PopResid > 10000) %>% 
  select(-PopResid)

#Separar conjunto de dados em treinamento e teste
#Divisao aleatoria do conjunto de dados original
set.seed(1)
train_obs <- sample(nrow(banco_filtrado), 0.7*nrow(banco_filtrado))

#*********************************************************************
#Preditores conjunto de treinamento
X <- banco_filtrado[train_obs, ]
X <- X[,-which(names(X) %in% (c("ExpecVida")))]

#Resposta do conjunto de treinamento
Y <- banco_filtrado$ExpecVida[train_obs]

#Banco treino
data_train <- cbind(Y,X)

#*********************************************************************
#Preditores conjunto de teste
X_holdout <- banco_filtrado[-train_obs, ]
X_holdout <- X_holdout[,-which(names(X_holdout) %in% (c("ExpecVida")))]

#Resposta do conjunto de teste
Y_holdout <- banco_filtrado$ExpecVida[-train_obs]

#Banco teste
data_test <- cbind(Y_holdout,X_holdout)

#Pre-processamento dos dados de treinamento
#Padronizar variaveis quantitativas
quantis_filter <- select(data_train, -c(cod_municipio)) 
scale_variables <- preProcess(quantis_filter, method = c("center", "scale"))

#Banco final
data_train_final<-predict(scale_variables,quantis_filter)

#Aplicar alteracoes do banco treino no banco teste
#Padronizar dados de teste com base nos parametros estimados nos dados de treinamento
quantis_filter_test <- select(data_test, -c(cod_municipio))
names(quantis_filter_test)[1]<-"Y"

#Banco final
data_test_final<-predict(scale_variables, quantis_filter_test)
names(data_test_final)[1]<-"Y_holdout"

#Treinamento de modelos preditivos
#Definir a recnica de reamostragem (validação cruzada)
control <- trainControl(method="cv",
                        number=10, 
                        savePredictions=TRUE)

##Escolha de hiperparametros

#PLS
plsGrid <- data.frame(.ncomp = c(1:10))

set.seed(2712)
plsFit<-train(Y~., data = data_train_final,
              method="pls",
              tuneGrid = plsGrid,
              trControl=control)
plsFit
aPLS<-plsFit$results
plot(aPLS$ncomp,aPLS$RMSE)
plsFit$bestTune

predicaoPLS<-predict(plsFit,select(data_test_final,-Y_holdout))
rmsePLS<-rmse(data_test_final$Y_holdout,predicaoPLS)
rmsePLS
