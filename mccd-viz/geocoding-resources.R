# Step 1
# load the ggmap library
library(ggmap)

# Step 2
# import the original data source
resources <- read.csv("C:/Users/gbushman/Downloads/Tableau - Resource Inventory.csv", stringsAsFactors = F)

# Step 3
# geocode addresses in batches until they're all coded, or until no new ones are being coded
num_not_geocoded <- c(0.2, 0.1)
while(nrow(resources[is.na(resources$lon) & !is.na(resources$Address) & resources$Address != "", ]) > 0 & num_not_geocoded[1] != num_not_geocoded[2]) {
  
  ## separate the addresses that have already been geocoded from the ones that haven't been
  old   <- resources[!is.na(resources$lon), ]
  new   <- resources[is.na(resources$lon) & !is.na(resources$Address) & resources$Address != "", ]
  blank <- resources[is.na(resources$Address) | resources$Address == "", ]
  
  ## get lat and lon for the new addresses
  latlon <- geocode(new$Address)
  
  ## combine the lat and lon fields with the original data for the new addresses
  new <- cbind(new[ , colnames(new) != "lon" & colnames(new) != "lat"], latlon)
  
  ## combine the new and the old data, now that everything is geocoded
  resources <- rbind(old, new, blank)
  
  ## track how many new values are being missed each time
  num_not_geocoded <- c(nrow(resources[is.na(resources$lon) & !is.na(resources$Address) & resources$Address != "", ]), num_not_geocoded) 

}

# Step 4
# write the new file back out to the original file location
write.csv(resources, "C:/Users/gbushman/Downloads/Tableau - Resource Inventory.csv", row.names = F)
