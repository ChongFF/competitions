library(data.table)
train_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/train_weighted.csv"
train = read.csv(train_path, stringsAsFactors= T, na.strings=".")
valid_path <- "S:/ACTUARY3/Advanced Analytics/Private/Staff/Chong, Fan Fei/arch_kaggle_data/out/valid_weighted.csv"
valid = read.csv(valid_path, stringsAsFactors= T, na.strings=".")

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

string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + rcs(EXT_SOURCE_1, 3) + rcs(EXT_SOURCE_2, 3) + rcs(EXT_SOURCE_3, 3)
requested_formula = as.formula(string_formula)
a_model = lrm(data=M, formula = requested_formula, weight=weight, x=TRUE, y=TRUE)
plot(anova(a_model))

string_formula <- TARGET ~ NAME_CONTRACT_TYPE + CODE_GENDER + FLAG_OWN_CAR + rcs(EXT_SOURCE_1, 3) + rcs(EXT_SOURCE_2, 3) + rcs(EXT_SOURCE_3, 3)+ 
  rcs(AMT_CREDIT, 3)
requested_formula = as.formula(string_formula)
a_model = lrm(data=M, formula = requested_formula, weight=weight)
plot(anova(a_model))

b <- validate(a_model, B=100)
plot(calibrate(a_model, B=100))