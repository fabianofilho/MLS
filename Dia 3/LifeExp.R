#Install packages
install.packages(c("tidyverse","caret","hydroGOF",
                   "lattice","psych","reshape","reshape2",
                   "e1071","corrplot"))

#Pacotes
library(tidyverse)
library(caret)
library(hydroGOF)
library(lattice)
library(psych)
library(reshape)
library(reshape2)
library(e1071)
library(corrplot)

#Importar banco de dados
banco <- read.table ("dados_expecvida2.csv", header = T ,sep=';', 
                     dec='.',colClass=c(rep("numeric",24)))

#Selecao de municipios com mais de 10.000 habitantes (varia ano/ano)
#Filtrar mun > 10.000 habitantes
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
##Tecnica de reamostragem (para evitar sobreajuste)
control <- trainControl(method="cv",
                        number=10, 
                        savePredictions=TRUE)

##Escolha de hiperparametros
#Modelos lineares

#Regressao Rigde
ridgeGrid <- data.frame(.lambda = seq(0, .015, length = 10))

set.seed(2712)
ridgeRegFit <- train(Y~., data = data_train_final,
                     method = "ridge",
                     tuneGrid = ridgeGrid,
                     trControl = control)
ridgeRegFit
aRIDGE<-ridgeRegFit$results
plot(aRIDGE$lambda,aRIDGE$RMSE)
ridgeRegFit$bestTune

predicaoRIDGE<-predict(ridgeRegFit,
                       select(data_test_final,-Y_holdout))

rmseRIDGE<-rmse(data_test_final$Y_holdout,predicaoRIDGE)
rmseRIDGE

#Lasso
LassoGrid <- expand.grid(.fraction = seq(.5, 1, length = 10))

set.seed(2712)
LassoFit <- train(Y~., data = data_train_final,
                  method = "lasso",
                  tuneGrid = LassoGrid,
                  trControl = control)
LassoFit
aLASSO<-LassoFit$results
plot(aLASSO$fraction,aLASSO$RMSE)
LassoFit$bestTune

predicaoLASSO<-predict(LassoFit,select(data_test_final,-Y_holdout))
rmseLASSO<-rmse(data_test_final$Y_holdout,predicaoLASSO)
rmseLASSO
