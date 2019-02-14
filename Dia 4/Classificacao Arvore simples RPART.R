#Pacotes
library(cvdRiskData)
library(caret)
library(tidyverse)
library(data.table)
library(pROC)
library(ROCR)
library(dummies)


#Importar banco de dados
#full patient data
# cvd_patient <- load("cvd_patient.rda")
data(cvd_patient)
cvd_patient_c <- cvd_patient

#Selecionar só pessoas acima de 55 anos
cvd_patient_r <- cvd_patient_c %>% 
  filter(numAge>55) %>% 
  select(-c(patientID,age,treat))

#criar dummies para variavel "race"
race_dummies <- dummy.data.frame(select(cvd_patient_r,race), names=names(select(cvd_patient_r,race)), sep="_")
names(race_dummies)
names(race_dummies)[2]<-"race_Asian_PI"
names(race_dummies)[3]<-"race_Black_AfAm"
banco_final<-cbind(cvd_patient_r,race_dummies)
banco_final_r<-select(banco_final,-c(race,race_White))
banco_final_r$race_AmInd<-as.factor(banco_final_r$race_AmInd)
banco_final_r$race_Asian_PI<-as.factor(banco_final_r$race_Asian_PI)
banco_final_r$race_Black_AfAm<-as.factor(banco_final_r$race_Black_AfAm)

#Divisao do banco de dados completo em treinamento e teste
#stratified random sampling
set.seed(1)
split1 <- createDataPartition(banco_final_r$cvd, p=.85)[[1]]
trainData <- banco_final_r[split1,]
testData <- banco_final_r[-split1,]
prop.table(table(trainData$cvd))
prop.table(table(testData$cvd))

#Treinamento de modelos preditivos
#Para obter as diferentes medidas de performance (accuracy, Kappa, area under ROC curve, sensitivity, specificity)
fiveStats <- function(...)c(twoClassSummary(...),defaultSummary(...))

#control function
set.seed(1)
ctrl <- trainControl(method = "LGOCV", #leave-group out cross-validation
                     number = 1, #number of folds or number of resampling iterations
                     p = 0.85, #training percentage
                     savePredictions = TRUE, # save "all" hold-out predictions for each resample
                     classProbs = TRUE,# compute class probabilities for classification models 
                     summaryFunction = fiveStats,
                     verboseIter = TRUE) #Acompanhar a situação do treino

#Arvore simples
set.seed(1)
rpartCVD <- train(cvd ~ ., data=trainData,
                  method="rpart",
                  tuneLength=5,
                  #tuneGrid=rpartgrid,
                  trControl=ctrl,
                  metric="ROC")

rpartCVD

#***Predicoes Arvore de classificacao***
#Aplique o modelo ajustado ao banco de teste

classPredRPART <- predict(rpartCVD, newdata=dplyr::select(testData,-cvd))

#Calcular medidas de performance
confMatRPART <- confusionMatrix(classPredRPART,testData$cvd)
confMatRPART

#Area under the ROC curve
predicao_probRPART <- predict(rpartCVD,dplyr::select(testData,-cvd),type="prob")
p_YesRPART <- predicao_probRPART[,"Y"]
rocCurveRPART <- roc(response = testData$cvd, 
                     predictor = p_YesRPART, 
                     levels = rev(levels(testData$cvd)))

AUC_rpart<-pROC::auc(rocCurveRPART)
AUC_rpart
IC_AUC_rpart<-pROC::ci.auc(rocCurveRPART)
IC_AUC_rpart
plot(rocCurveRPART)

#Curva ROC melhor
results_df_roc<-data_frame(TVP = rocCurveRPART$sensitivities,
                           TFP = 1 - rocCurveRPART$specificities,
                           Modelo = "Arvore Simples")

# Plot ROC curve
custom_col <- c("#D55E00")

ggplot(aes(x = TFP,  y = TVP, group = Modelo), data = results_df_roc) +
  geom_line(aes(color = Modelo), size = 1) +
  scale_color_manual(values = custom_col) +
  geom_abline(intercept = 0, slope = 1, color = "gray", size = 1) +
  theme_bw(base_size = 18)

