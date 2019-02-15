install.packages("devtools")
library(tidyverse)
library(caret)

# Instalar Keras
devtools::install_github("rstudio/keras")

# Carregar o Keras
library(keras)

# Instalar o TensorFlow e todo ambiente necessário para utilizar o Keras.
install_keras()

#library(corrplot)
banco <- read.table ("dados_expecvida2.csv", header = T ,sep=';', dec='.',colClass=c(rep("numeric",24)))

summary(banco)

#filtrar mun > 10.000 habitantes
banco_filtrado <- banco %>% 
  filter(PopResid > 10000) %>% 
  select(-PopResid)
summary(banco_filtrado)

#Separar conjunto de dados em treinamento e teste
#DivisÃ£o aleatÃ³ria do conjunto de dados original
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

#PrÃ©-processamento dos dados de treinamento
# Variaveis quantitativas
#Padronizar variÃ¡veis quantitativas
nums <- sapply(data_train, is.numeric)
quantis<-data_train[,nums]
quantis_filter <- select(quantis, -c(cod_municipio)) 
scale_variables <- preProcess(quantis_filter, method = c("center", "scale"))
quantis_train_scale<-predict(scale_variables,quantis_filter)

data_train_final<-quantis_train_scale
summary(data_train_final)

#Aplicar alteraÃ§Ãµes do banco treino no banco teste
#Padronizar dados de teste com base nos parÃ¢metros estimados nos dados de treinamento
nums_t <- sapply(data_test, is.numeric)
quanti_t<-data_test[,nums]
quantis_filter_test <- select(quanti_t, -c(cod_municipio))
names(quantis_filter_test)[1]<-"Y"
quantis_test_scale<-predict(scale_variables, quantis_filter_test)

#Banco final
data_test_final<-quantis_test_scale
names(data_test_final)[1]<-"Y_holdout"
summary(data_test_final)

# Turn `iris` into a matrix

x_final <- select(data_train_final, -c(Y)) 

y_final <- select(data_train_final, c(Y)) 

x_final <- as.matrix(x_final)

y_final <- as.matrix(y_final)

x_holdout_final <- select(data_test_final, -c(Y_holdout)) 

y_holdout_final <- select(data_test_final, c(Y_holdout)) 

x_holdout_final <- as.matrix(x_holdout_final)

y_holdout_final <- as.matrix(y_holdout_final)


str(x_final)

model <- keras_model_sequential() 

# Adiciona as camadas
set.seed(1)
model %>% 
  layer_dense(units = 128, activation = 'relu', input_shape = c(21)) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 1)

# Resumo do modelo
summary(model)

# Compila o modelo
set.seed(1)
model %>% compile(
  loss = 'mean_squared_error',
  optimizer ='adam',
  metrics = 'mae'
)

# Ajusta o modelo 
set.seed(1)
history <-model %>% fit(
 x_final, 
  y_final, 
  epochs = 20, 
  batch_size = 32, 
  validation_split = 0.2
)

#plot(history)

# Predição das classes para os dados de teste
classes <- model %>% predict_classes(x_holdout_final, batch_size = 32)

# Avaliando rótulos dos testes
score <- model %>% evaluate(x_holdout_final, y_holdout_final, batch_size = 32)

# Performance
print(score)


