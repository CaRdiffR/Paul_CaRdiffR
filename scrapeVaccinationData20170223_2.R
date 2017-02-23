# I am attempting to scrape vaccinations recommendations
# from a Travel Health Pro website on a particular country.
# the example here is travel health pro page about afghanistan
# this is the page
# http://travelhealthpro.org.uk/country/1/afghanistan#Vaccine_recommendations

# install.packages("rvest")
library("rvest")
library(curl)

# step 1 scrap the page. 
web_content <- read_html(curl('http://travelhealthpro.org.uk/country/1/afghanistan#Vaccine_recommendations', handle = new_handle("useragent" = "Chrome")))
# handle is required as extra data and curl package is required too 

# extracting the data using pipes 
vac_list <- web_content %>% 
  html_nodes(".accordion") %>%
  html_nodes(".accordion-item")  %>%
  html_nodes("p") %>%
  html_text(trim = FALSE)

# using gsub to remove the spaces and the line brake symbol
vac_list <- gsub("\n", "", vac_list)
vac_list <- gsub("  ", "", vac_list)

# this works and returns a list. 

# check with albania
web_content <- read_html(curl('http://travelhealthpro.org.uk/country/2/albania#Vaccine_recommendations', handle = new_handle("useragent" = "Chrome")))
