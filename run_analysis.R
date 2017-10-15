## Atachar o pacote dplyr (attach the dplyr package in R environment)
library(dplyr)
##------------------------------------------------------------------------------------------------
## Busca e gravação do arquivo  (found and store file)
## Definir pasta de trabalho (Set workbook)
setwd("C:/amarante/Coursera/Cursando/Getting_and_Cleaning_Data/ExercicioFinal/PastaTrabalho")
##-------------------------------------------------------------------------------------------------
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl, destfile = "./ProjetoSemana4getCleaningData.zip")
##------------------------------------------------------------------------------------------------
## Descompactar o arquivo (unzip file)
arqdescomp <- unzip("./ProjetoSemana4getCleaningData.zip")
##------------------------------------------------------------------------------------------------
## Carregar os dados no R (store data in R environment)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
##-----------------------------------------------------------------------------------------------
## Juntar os conjuntos TRAINING e TEST em um único conjunto de dados.
## QUESTION-01 <--> Merges the training and the test sets to create one data set.
##- Dados TRAIN
dadosTrain <- cbind(subject_train, y_train, X_train) 
##- Dados TEST
dadosTest <- cbind(subject_test, y_test, X_test) 
##- Junção dos dados TRAIN e dados TEST
todosDados <- rbind(dadosTrain, dadosTest)
##---------------------------------------------------------------------------------------------------------
## Extrair somente as medidas que representam média e desvio padrão das medidas.
## QUESTION-02 <--> Extracts only the measurements on the mean and standard deviation for each measurement.
##- Carregando os nomes das caracteristicas no ambiente R
nomesCaracteristica <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
##- Fazendo o processamento
indices_mean_std <- grep(("mean\\(\\)|std\\(\\)"), nomesCaracteristica) 
dadosBusca <- todosDados[, c(1, 2, indices_mean_std+2)] 
colnames(dadosBusca) <- c("subject", "activity", nomesCaracteristica[indices_mean_std]) 
##---------------------------------------------------------------------------------------------------------
## Usar nomes descritivos para nomear as atividades no conjunto de dados
## QUESTION-03 <--> Uses descriptive activity names to name the activities in the data set
##- Carregando os dados no ambiente R 
nomeAtividade <- read.table("./UCI HAR Dataset/activity_labels.txt") 
##- Processamento
dadosBusca$activity <- factor(dadosBusca$activity, levels = nomeAtividade[,1], labels = nomeAtividade[,2])
##---------------------------------------------------------------------------------------------------------
## Colocar etiquetas apropriadas para o conjunto de dados com nomes descritivos nas variáveis
## QUESTION-04 <--> Appropriately labels the data set with descriptive variable names.
names(dadosBusca) <- gsub("\\()", "", names(dadosBusca)) 
names(dadosBusca) <- gsub("^t", "time", names(dadosBusca)) 
names(dadosBusca) <- gsub("^f", "frequence", names(dadosBusca)) 
names(dadosBusca) <- gsub("-mean", "Mean", names(dadosBusca)) 
names(dadosBusca) <- gsub("-std", "Std", names(dadosBusca))
##---------------------------------------------------------------------------------------------------------
## Para o conjunto de dados da QUESTÃO-04,criar um segundo, um conjunto independente de dados
## de armazenamento com a média de cada variável para cada atividade e cada asunto.
## QUESTION-05 <--> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
dadosAgrupados <- dadosBusca %>% group_by(subject, activity) %>%   summarise_each(funs(mean))
##---------------------------------------------------------------------------------------------------------
## Gravar o arquivo final como arquivo texto
write.table(dadosAgrupados, "./Amarante_tidydata.txt", row.names=FALSE, quote=FALSE)
##---------------------------------------------------------------------------------------------------------









