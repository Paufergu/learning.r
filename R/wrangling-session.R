# load packages from the "package loading
source(here::here("R/package-loading.R"))

glimpse(NHANES)

NHANES <- NHANES
View(NHANES)


# exercise 1 --------------------------------------------------------------
usethis::use_r("exercises-wrangling")

colnames(NHANES)

NHANES %>% colnames()

# Standard R way of "chaining" functions together

glimpse(head(NHANES))
 glimpse(NHANES)

 NHANES %>%
    head() %>%
    glimpse()

# mutate() function -------------------------------------------------------

NHANES_changed <- NHANES %>%
   mutate(Height_meters = Height/100)

# create a new variable based on a condition
NHANES_changed <- NHANES_changed %>%
  mutate(HighlyActive = if_else(PhysActiveDays >= 5, | PhysActiveDays < 3, "yes", "no"))

# create or replace multiple variables at the same time by using ","

NHANES_changed <- NHANES_changed %>%
  mutate(new_column = "only one variable",
         Height = Height/100,
         UrineVolAverage = (UrineVol1 + UrineVol2)/2)


# Selec specif data by the variable ---------------------------------------

# Select columns/ variables by name without quotes
NHANES_characteristics <- NHANES %>%
  select(Age, Gender, BMI)

# T not select a variable, use minus (-)

NHANES %>%
  select(-HeadCirc)


# To select similar names, use "matching" functions
NHANES %>%
  select(starts_with("BP"), contains("Vol"))



# rename specific columns -------------------------------------------------

#rename using the form: "newname = oldname"
NHANES %>%
  rename(NumberBabies = nBabies,
         Sex = Gender)


# Filtering/subsetting the data by row ------------------------------------

# when gender is equal to
NHANES %>%
  filter(Gender == "female")

# when BMI is equal to
NHANES %>%
  filter(BMI == 25)

# when BMI is 25 and gender is female
NHANES %>%
  filter(BMI == 25 & Gender == "female")


# sort/rearrange your data by colummns ------------------------------------

# ascending order
NHANES %>%
  arrange(Age) %>%
  select(Age)

#descending order
NHANES %>%
  arrange(desc(Age)) %>%
  select(Age)

#order by Age and Gender
NHANES %>%
  arrange (Age, Gender) %>%
  select(Age, Gender)


#summarise () by itself
NHANES %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))

#combine summarise with group_by
NHANES %>%
  group_by(Gender) %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))

NHANES %>%
  group_by(Gender, Diabetes) %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE))


# From wide to long -------------------------------------------------------

table4b

table4b %>%
  gather(key = year, value = population, -country)

table4b %>%
  gather(key = year, value = population, "1999", "2000")


# keep only varibles of interest
NHANES_char <- NHANES %>%
  select(SurveyYr, Gender, Age, Weight, Height, BMI, BPSysAve)
NHANES_char

#convert to long form, excluding year gender
nhanes_long <- NHANES_char %>%
  gather(Mesure, Value, -SurveyYr, -Gender)
nhanes_long

# calculate mean on each measure, by gender and survey year
nhanes_long %>%
  group_by(SurveyYr, Gender, Mesure) %>%
  summarise(MeanValues = mean(Value, na.rm = TRUE))
