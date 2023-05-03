# Load Libraries -----------------------------------------------------------

# Load libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(readr)
library(janitor)

# Import data set ---------------------------------------------------------
# Load dataset and remove the first column 
chicago <- read_csv(file = "data/chicago.csv") %>% select(-1)
ny <- read_csv(file = "data/new_york_city.csv") %>% select(-1)
washington <- read_csv(file = "data/washington.csv") %>% select(-1)


# Data cleaning -----------------------------------------------------------

# Check tables column names
names(chicago)
names(ny)
names(washington) # This table does not include Gender and Birth.Year


# Clean up the column names 
chicago <- clean_names(chicago)
ny <- clean_names(ny)
washington <- clean_names(washington)

washington$gender <- NA                # Add Gender column to washington
washington$birth_year <- NA            # Add Birth Year column to washington
washington$city <- "washington"        # Add City column to washington
chicago$city <- "chicago"              # Add City column to chicago
ny$city <- "new york"                  # Add City column to new york
bike <- rbind(washington, ny, chicago) # Combine all tables together

# Convert the "city" column to a factor with specified levels
bike$city <- factor(bike$city, levels = c("washington", "chicago", "new york"), ordered = FALSE) 

# Display the structure of the "bike" data frame
gimpse(bike)




# Data summary statistics -------------------------------------------------

# Create summary for month
bike %>% mutate(month = factor(month(start_time, label = TRUE))) %>%
        group_by(month, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>% mutate(max = count == max_value) %>%
        filter(max == TRUE) %>% select(month, city, count) %>% arrange(desc(count))



# Create summary for day
bike %>% mutate(day = factor(wday(start_time, label = TRUE))) %>%
        group_by(day, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>% mutate(max = count == max_value) %>%
        filter(max == TRUE) %>% select(day, city, count) %>% arrange(desc(count))

# Create a new variable "hour" in the bike data frame
bike %>% mutate(hour = factor(hour(start_time))) %>%
        group_by(hour, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>% mutate(max = count == max_value) %>%
        filter(max == TRUE) %>% select(hour, city, count) %>% arrange(desc(count))

# Data visualization -------------------------------------------------------

# Barcharts
# Month
bike %>% mutate(month = factor(month(start_time, label = TRUE))) %>%
        group_by(month, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>%
        ggplot(mapping = aes(x = month, y = count)) +
        geom_bar(aes(fill = ifelse(count == max_value, "seagreen", "red4")),stat = "identity") + 
        facet_wrap(~ city) +
        scale_fill_manual(values = c("seagreen", "red4")) + 
        theme(legend.position = "none") + 
        labs(y = "Count", x = "Month") 

# Day
bike %>% mutate(day = factor(wday(start_time, label = TRUE))) %>%
        group_by(day, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>%
        ggplot(mapping = aes(x = day, y = count)) +
        geom_bar(aes(fill = ifelse(count == max_value, "seagreen", "red4")),stat = "identity") + 
        facet_wrap(~ city) +
        scale_fill_manual(values = c("seagreen", "red4")) + 
        theme(legend.position = "none") + 
        labs(y = "Count", x = "Day")  

# Hour
bike %>% mutate(hour = factor(hour(start_time))) %>%
        group_by(hour, city) %>% summarise(count = n(), .groups = 'drop') %>%
        group_by(city) %>% mutate(max_value = max(count)) %>%
        ggplot(mapping = aes(x = hour, y = count)) +
        geom_bar(aes(fill = ifelse(count == max_value, "seagreen", "red4")), stat = "identity") + 
        facet_wrap(~ city) +
        scale_fill_manual(values = c("seagreen", "red4")) + 
        theme(legend.position = "none") +
        labs(y = "Count", x = "Hour")  

# Functions ---------------------------------------------------------------

# Create a function to get the common stations
common_stations <- function(data, top = 10, type = "start", city = "all"){
        
        # Check if dplyr is loaded in R environment
        if(!("dplyr" %in% (.packages()))) {
                library(dplyr)
        } 
        
        # Check the city condition
        if(city == "all"){
                
                # Run the function: Check the result type
                # Select the most common trip starting point
                if(type == "start") {
                        data %>% group_by(start_station, city, .groups = 'drop') %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Select the most common trip ending point
                } else if(type == "end") {
                        data %>% group_by(end_station, city,, .groups = 'drop') %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Select the most common trips               
                } else if(type == "trip"){
                        data$trip_stations <- paste("from", bike$start_station, 
                                                    "to", bike$end_station)
                        
                        data %>% group_by(trip_stations, city) %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Otherwise show a message              
                } else {
                        print("PLEACE INTRODUCE A VALID RESULT TYPE")
                }
                
        } else {
                
                # Run the function: Check the result type
                # Select the most common trip starting point
                if(type == "start") {
                        data %>% filter(city == city) %>%
                                group_by(start_station) %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Select the most common trip ending point
                } else if(type == "end") {
                        data %>% filter(city == city) %>%
                                group_by(end_station) %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Select the most common trips               
                } else if(type == "trip"){
                        data$trip_stations <- paste("from", bike$start_station, 
                                                    "to", bike$end_station)
                        
                        data %>% filter(city == city) %>%
                                group_by(trip_stations, city) %>% 
                                summarise(trips_count = n(), .groups = 'drop') %>%
                                arrange(desc(trips_count)) %>% head(top)
                        
                        # Otherwise show a message              
                } else {
                        print("PLEACE INTRODUCE A VALID RESULT TYPE")
                }
        }
}

# Check function
common_stations(bike, top = 5, type = "start", "all")
common_stations(bike, top = 6, type = "end", "all")
common_stations(bike, top = 10, type = "trip", "new york")

trip_duration <- function(data) {
        
        # Check if dplyr is loaded in R environment
        if(!("dplyr" %in% (.packages()))) {
                library(dplyr)
        } 
        
        # Transform empty string to NA
        data$user_type <- ifelse(data$user_type == "", NA, data$user_type)
        
        # Calculate the average trip duration per user type and city 
        temp <- data %>% select(user_type, trip_duration, city) %>%
                filter(!is.na(user_type)) %>%
                group_by(city, user_type) %>%
                summarise(trip_ave = mean(trip_duration), .groups = 'drop') %>%
                arrange(city)
        
        # Get a vector of the cities
        user <- unique(temp$user_type)
        cities <- unique(temp$city)
        
        # Print the results
        for(city_name in cities) {
                cat("In ", city_name, " city:\n\n", sep = "")
                users <- unique(subset(temp, city == city_name))$user_type
                
                # Check for the user type
                for(user in users){
                        
                        # Check the average trip length
                        i <- which(users == user)
                        cat("The Average Trip Length for ", 
                            user, "is:", round(subset(temp, city == city_name)$trip_ave[i] / 60, 2), "minutes\n")
                }
                cat("\n")
        }
}