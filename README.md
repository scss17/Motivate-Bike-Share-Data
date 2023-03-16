## About the Project

**Business Task**: The aim of this project is to use data provided by Motivate, a bike share system provider for many major cities in the United States, to uncover bike share usage patterns. I will compare the system usage between three large cities: Chicago, New York City, and Washington, DC. The objective is to be able to answer the following business questions. 

1. **Popular times of travel per city (i.e., occurs most often in the start time)**

    -   What is the most common month?
    -   What is the most common day of week?
    -   What is the most common hour of day?


2. **Popular stations and trip**

    -   What is the most common start station?
    -   What is the most common end station?
    -   What is the most common trip from start to end?
    

3. **Trip Duration**

    -   What is the average travel time for different kind of user in different cities?

## Abaut the Company 

Over the past decade, bicycle-sharing systems have been growing in number and popularity in cities across the world. Bicycle-sharing systems allow users to rent bicycles on a very short-term basis for a price. This allows people to borrow a bike from point A and return it at point B, though they can also return it to the same location if they'd like to just go for a ride. Regardless, each bike can serve several users per day.

[Motivate](https://motivateco.com/about) is a company of logistics which supports organization in the micromobility industry. They take a data-driven approach, ensuring that each of their systems delivers a high-quality experience efficiently. Motivate has experience contracting and operating multi-jurisdiction systems. Currently, they operate in the metro areas of Chicago, New York, Washington D.C., Boston, the San Francisco Bay Area, Minneapolis, Columbus, and Portland.

## About the Data

**Data Used**: The original data set consisted of historical trip data available to the public. This data is provided according to the [Divvy Data License Agreement](https://ride.divvybikes.com/data-license-agreement) and released on a monthly schedule. The data has been processed to remove trips that are taken by staff as they service and inspect the system; and any trips that were below 60 seconds in length (potentially false starts or users trying to re-dock a bike to ensure it was secure).

**Data Organization**: The data I will use consisted of randomly selected data for the first six months of 2017 are provided for all three cities. The original files are much larger and messier. These files had more columns and they differed in format in many cases. Some data wrangling has been performed to condense these files to the above core six columns. All three of the data files contain the same core six (6) columns:

-   Start Time (e.g., 2017-01-01 00:07:57)

-   End Time (e.g., 2017-01-01 00:20:53)

-   Trip Duration (in seconds - e.g., 776)

-   Start Station (e.g., Broadway & Barry Ave)

-   End Station (e.g., Sedgwick St & North Ave)

-   User Type (Subscriber or Customer)

The Chicago and New York City files also have the following two columns:

-   Gender

-   Birth Year