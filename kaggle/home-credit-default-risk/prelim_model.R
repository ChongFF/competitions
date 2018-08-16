set.seed(1234)
library(data.table)
library(dplyr)
library(foreach)
library(caret)
library(rms)
library(Hmisc)
library(PRROC)

train_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/in/train_impute_simple.csv"
train = read.csv(train_path, stringsAsFactors= T)
# train = read.csv(train_path, stringsAsFactors= T, na.strings=".")

weight_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/in/old/train_impute_new_withweight.csv"
weight = read.csv(weight_path, stringsAsFactors= T, na.strings=".")[,c("SK_ID_CURR", "Weights")]
# colnames(weight) can be used to find the columns you need

test_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/in/test_impute_simple.csv"
test = read.csv(test_path, stringsAsFactors= T)

train_weighted = merge(train, weight, by = "SK_ID_CURR")

train_weighted$fold <- caret::createFolds(train_weighted$TARGET, 5, FALSE)

M = train_weighted

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

# would not work, probably because of too much deletion 
string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + rcs(EXT_SOURCE_1_impute_median, 3) + rcs(EXT_SOURCE_2_impute_median, 3)+
  rcs(EXT_SOURCE_3_impute_median, 3)
string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + 
  FLAG_OWN_REALTY + CNT_CHILDREN + rcs(AMT_INCOME_TOTAL, 3) + 
NAME_INCOME_TYPE + NAME_EDUCATION_TYPE + 
  NAME_FAMILY_STATUS + NAME_HOUSING_TYPE + rcs(REGION_POPULATION_RELATIVE, 
                                               3) + DAYS_BIRTH + DAYS_EMPLOYED + rcs(DAYS_REGISTRATION, 
                                                                                     3) + DAYS_ID_PUBLISH + FLAG_MOBIL + FLAG_EMP_PHONE + FLAG_WORK_PHONE + 
  FLAG_CONT_MOBILE + FLAG_PHONE + FLAG_EMAIL + REGION_RATING_CLIENT + 
  REGION_RATING_CLIENT_W_CITY + WEEKDAY_APPR_PROCESS_START + 
  HOUR_APPR_PROCESS_START + REG_REGION_NOT_LIVE_REGION + REG_REGION_NOT_WORK_REGION + 
  LIVE_REGION_NOT_WORK_REGION + REG_CITY_NOT_LIVE_CITY + REG_CITY_NOT_WORK_CITY + 
  LIVE_CITY_NOT_WORK_CITY + ORGANIZATION_TYPE + FLAG_DOCUMENT_2 + 
  FLAG_DOCUMENT_3 + FLAG_DOCUMENT_4 + FLAG_DOCUMENT_5 + FLAG_DOCUMENT_6 + 
  FLAG_DOCUMENT_7 + FLAG_DOCUMENT_8 + FLAG_DOCUMENT_9 + FLAG_DOCUMENT_10 + 
  FLAG_DOCUMENT_11 + FLAG_DOCUMENT_12 + FLAG_DOCUMENT_13 + 
  FLAG_DOCUMENT_14 + FLAG_DOCUMENT_15 + FLAG_DOCUMENT_16 + 
  FLAG_DOCUMENT_17 + FLAG_DOCUMENT_18 + FLAG_DOCUMENT_19 + 
  FLAG_DOCUMENT_20 + FLAG_DOCUMENT_21 + rcs(EXT_SOURCE_1_impute_median, 3) + rcs(EXT_SOURCE_2_impute_median, 3)+
  rcs(EXT_SOURCE_3_impute_median, 3)
requested_formula = as.formula(string_formula)
requested_formula
a_model = lrm(data=M, formula = requested_formula, weight=Weights, x=TRUE,y=TRUE)

# use a fitted model to score a dataset
train_scored <- cbind(M, predict(a_model, M, se.fit=TRUE))
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



#### Still trying to get weighted AUC 
roc <- roc.curve(train_weighted$TARGET, train_weighted$linear.predictors, train_weighted$Weights,
                 train_weighted$Weights, curve = TRUE );
# plot curve
plot(roc);


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