dir.create("raw_data")
dir.create("clean_data")
dir.create("scripts")
dir.create("results")
dir.create("plots")
raw_data<-read.csv(file.choose())
View(raw_data)
str(raw_data)
raw_data$gender_fac<-as.factor(raw_data$gender)
str(raw_data)
class(raw_data$gender_fac)
raw_data$gender_fac
raw_data$diagnosis_fac<-as.factor(raw_data$diagnosis)
str(raw_data)
class(raw_data$diagnosis_fac)
raw_data$diagnosis_fac
raw_data$diagnosis_fac<- factor(raw_data$diagnosis,
                               levels = c("Normal","Cancer"))
raw_data$diagnosis_fac
raw_data$smoker_binary<-ifelse(raw_data$smoker=="Yes",1,0)
class(raw_data$smoker_binary)
raw_data$smoker_binary<-as.factor(raw_data$smoker_binary)
str(raw_data)
class(raw_data$smoker_binary)
raw_data$smoker_binary
write.csv(raw_data,file = "clean_data/patient_info_clean.csv",row.names=FALSE )
