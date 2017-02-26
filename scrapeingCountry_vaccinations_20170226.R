# scrape the list of countries from TravelPro Home page
# scrap the page.
# this is the URL
url <- c("http://travelhealthpro.org.uk/countries")

# this readLines() function is a base R function which allows reading webpages
data <- readLines(url)
print(paste(url, "has just been scraped"))

# identify where the proteins names are on the scraped data
country_numbers <- grep("travelhealthpro.org.uk/country/", data)
# 317 long... sounds like a good length

# based on http://stackoverflow.com/questions/17227294/removing-html-tags-from-a-string-in-r
extractCountry <- function(htmlString) {
  htmlString <- gsub("<.*?>", "", htmlString)
  htmlString <- gsub("\t", "", htmlString)
  return(htmlString)
}
extractCountry(data[380])

extractCountryUrl <- function(htmlString) {
  htmlString <- gsub("\\t<li><a href=", "", htmlString)
  htmlString <- gsub("</a></li>", "", htmlString)
  htmlString <- gsub("\"", "", htmlString)
  htmlString <- gsub(">.*", "", htmlString)
  return(htmlString)
}
# test the function
extractCountryUrl(data[380])

country_list <- NULL
country_urls <- NULL
for(i in 1:length(country_numbers)){
  reqd_url <- extractCountryUrl(data[country_numbers[i]])
  country <- extractCountry(data[country_numbers[i]])
  country_list <- c(country_list, country)
  country_urls <- c(country_urls, reqd_url)
}

# I want a list of countries
# and a list of URLs

i <- 1

# one to 276 look fine but after that there is some rubbish. 

# truncate both at 276
countrylist <- country_list[1:276]
countryUrls <- country_urls[1:276]



# with this list of countries, apply the extraction of vaccinations... 

# I am attempting to scrape vaccinations recommendations
# from a Travel Health Pro website on a particular country.
# the example here is travel health pro page about afghanistan
# this is the page
# http://travelhealthpro.org.uk/country/1/afghanistan#Vaccine_recommendations

# install.packages("rvest")
library("rvest")
library(curl)


extractVacs <- function(x){
# scrape the page  
  web_content <- read_html(curl(x, handle = new_handle("useragent" = "Chrome")))
# handle is required as extra data and curl package is required too 
  print(paste(x, "has just been scraped"))
  
# extracting the data using pipes 
  vac_list <- web_content %>% 
    html_nodes(".accordion") %>%
    html_nodes(".accordion-item")  %>%
    html_nodes("p") %>%
    html_text(trim = FALSE)

# using gsub to remove the spaces and the line brake symbol
  vac_list <- gsub("\n", "", vac_list)
  vac_list <- gsub("  ", "", vac_list)
  vac_list
  
# this works and returns a list. 
  return(vac_list)
}

# test the code
extractVacs(countryUrls[2])
# works

output <- lapply(countryUrls, extractVacs)
# returns a list of 276 with all the vaccinations in...
# and looks good. 
# setwd("/Users/paulbrennan/Dropbox/R for Biochemists/webScraping2017_CardiffUsersGroup")
# save(output, file = "vaccinationList_20170226")
# saved. 
# save(country_list, file = "countryList_20170226")

# next step - turn these two objects into something to do a visualiation. 


