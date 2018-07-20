library(data.table)
train_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/train_weighted.csv"
train = read.csv(train_path, stringsAsFactors= T, na.strings=".")
valid_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/valid_weighted.csv"
valid = read.csv(valid_path, stringsAsFactors= T, na.strings=".")
test_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/in/application_test.csv"
test = read.csv(test_path, stringsAsFactors= T)

library(dplyr)
library(rms)
library(Hmisc)

M = train

col_set = M %>% names()
col_set = col_set[!col_set %in% "TARGET"]

string_formula = "TARGET~"
for(i in col_set){
  if(class(M[[i]]) == "numeric"){
    tmp_component = paste0("+rcs(",i,",3)")
  }
  if(class(M[[i]]) != "numeric"){
    tmp_component = paste0("+",i)
  }
  string_formula = paste0(string_formula, tmp_component)  
}
requested_formula = as.formula(string_formula)
requested_formula

# would work
string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + rcs(EXT_SOURCE_1, 4) + rcs(EXT_SOURCE_2, 4) + rcs(EXT_SOURCE_3, 4)
requested_formula = as.formula(string_formula)
a_model = lrm(data=M, formula = requested_formula, weight=weight, x=TRUE, y=TRUE)

# would not work, probably because of too much deletion 
string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + rcs(EXT_SOURCE_1, 3) + rcs(EXT_SOURCE_2, 3) + rcs(EXT_SOURCE_3, 3)+ 
  rcs(AMT_CREDIT, 3)
requested_formula = as.formula(string_formula)
a_model = lrm(data=M, formula = requested_formula, weight=weight)

# use a fitted model to score a dataset
valid_scored <- cbind(valid, predict(a_model, valid, se.fit=TRUE))
test_scored <- cbind(test, predict(a_model, test, se.fit=TRUE))

# diagnostic plots
## Variable Importance
plot(anova(a_model))

## Partial Effect Plot
dd <- datadist(train); options(datadist='dd')
ggplot(Predict(a_model),sepdiscrete='vertical',vnames='names')#,
       #rdata=train,histSpike.opts=list(frac=function(f) .1*
        #                                 f/max(f)))

## Validation Statistics
validate(a_model, B=100)

## Calibration Curve
plot(calibrate(a_model, B=100))

# Saving out Submission
write.csv(valid_scored, "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/valid_scored.csv")
write.csv(test_scored, "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/test_scored.csv")

# Check out missing patterns
na.patterns <- naclus(train)
require(rpart)
who.na <- rpart(is.na(EXT_SOURCE_1) ~ . - EXT_SOURCE_1, data=train,minbucket=15)
naplot(na.patterns, 'na per var')
plot(who.na, margin = .1); text(who.na)
plot(na.pattterns)