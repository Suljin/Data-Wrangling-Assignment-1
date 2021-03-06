#Jason Wilcox Data wrangling exercise 1: basic data manipulation

library(dplyr)
library(tidyr)
library(magrittr)
library(tidyverse)
library(psych)

refine_original <- read.csv("C:/Users/jason/OneDrive/Desktop/Capstone/refine_original.csv")

brands <- refine_original

#----------Cleaning up brand names----------
#1 making names uniform (standardize names & spelling)

names <- c("phillips", "akzo", "unilever", "van_houten")

namediff <- adist(brands$company, names)
colnames(namediff) <- names
rownames(namediff) <- brands$company
namediff

i <- apply(namediff, 1, which.min)
brands$company <- names[i]
brands

#2 Separate product code and number (separate into two columns)

brands <- brands %>%
  separate(Product.code...number, into = c("product_code", "product_number"), sep = "-")

#3 Add product categories (change letters into the product type)

brands$product_code <- gsub("p", "Smartphone", brands$product_code)
brands$product_code <- gsub("v", "TV", brands$product_code)
brands$product_code <- gsub("x", "Laptop", brands$product_code)
brands$product_code <- gsub("q", "Tablet", brands$product_code)

#4 Add full address for geocoding (combine 3 columns into 1 for full address)

brands <- unite(brands, address, address:country, sep = ", ", remove = TRUE)

#5 Create dummy variables for company and product category
#company
tempDummy = dummy.code(brands[,1])
brands = cbind(brands, tempDummy)

brands <- rename(brands, company_akzo = akzo)
brands <- rename(brands, company_phillips = phillips)
brands <- rename(brands, company_unilever = unilever)
brands <- rename(brands, company_van_houten = van_houten)

#products

tempDummy = dummy.code(brands[, 2])
brands = cbind(brands, tempDummy)

brands <- rename(brands, product_smartphone = Smartphone)
brands <- rename(brands, product_tv = TV)
brands <- rename(brands, product_laptop = Laptop)
brands <- rename(brands, product_tablet = Tablet)

refine_clean <- brands

refine_clean
