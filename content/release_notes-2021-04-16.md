---
author: Shawna Gregory
date: 2021-04-16
slug: release-notes-2021-04-16
draft: True
type: post
image: static/release_notes-2021-04-16/image7.jpg
title: "Spring 2021 Water Data for the Nation release notes"
author_email: <srgregory@usgs.gov>
categories:
  - Applications
description: An update of next-gen monitoring location page features released in Spring 2021, including major usability improvements
keywords:
  - water information
tags:
  - Water Data for the Nation 

---


## What have we been up to?

-   Adding temperature in Fahrenheit

-   Updating user feedback options

-   Making WDFN more usable

## New features and tools

### Temperature available in Fahrenheit

Historically, USGS has taken temperature data in degrees Celsius. Users have asked for a way to compare the data to a Fahrenheit scale over the years and for the first time, a new option exists to support that request. Now a separate parameter is available to show a calculated conversion of the temperature data to degrees Fahrenheit on the hydrograph. The underlying data remains the degrees Celsius, with a conversion applied to allow for easy hydrograph analysis in degrees Fahrenheit.

{{< figure src="/static/release_notes-2021-04-16/image1.jpg" caption="Water temperature parameters in the Parameter Selection Table, showing the new option for Temperature, water, degrees Fahrenheit (calculated) at [Little Arkansas River near Sedgewick, KS](https://waterdata.usgs.gov/monitoring-location/07144100)"  alt="Parameter option Temperature, water, degrees Fahrenheit (calculated) selected in a list" >}}

### Updated our user feedback options

As more of our users are utilizing the updated monitoring location pages, we have increasingly been receiving more user questions and comments about the data itself, which we strive to respond to in a timely manner. To that end we have updated the user feedback form to allow the user to specify why they are reaching out to the USGS. If a user is [contacting us](mailto:WDFN@usgs.gov) with questions or concerns about the data at the location, this is forwarded directly to the USGS staff that interacts with the sensor, helping to streamline the USGS response.

{{< figure src="/static/release_notes-2021-04-16/image2.jpg" caption="[Contact USGS form](https://waterdata.usgs.gov/questions-comments/gs-w-ks_NWISWeb_Data_Inquiries%40usgs.gov/?referring_page_type=monitoring), zoomed into the options of type of feedback: data questions, reporting problems, or leaving a comment."  alt="Three options in the questions and comments form to direct the feedback including contacting someone about the data, reporting a problem, and leaving a comment" >}}


### Updating the Parameter Selection Table

As we continue to update the interactive options around parameters, we had hit the limit of what we could associate with Parameter Selection Table. The Parameter Selection Table, used to review and select the data that is shown on the hydrograph, was too wide for mobile without a scrollbar. To address this mobile concern, and allow us for growth in the future, we updated the Parameter Selection Table to be simplified with only the parameter name and period of record shown by default. Each parameter is now able to be expanded using a carrot on the right of the row to view additional information about the parameter. For now, data subscription is the only thing available in the expanded row, but the contents will expand over time, stay tuned for more updates to this feature!

{{< figure src="/static/release_notes-2021-04-16/image3.png" caption="Subset of the Parameter Selection Table on mobile at [Little Arkansas River near Sedgewick, KS](https://waterdata.usgs.gov/monitoring-location/07144100/)"  alt="Parameter option Nitrate plus nitrate, water selected in the mobile version of the Parameter Selection Table. Each parameter includes period of record followed by parameter name with a radio button to select the parameter." >}}


## Striving to make the page more usable

We were excited to have the opportunity to test with our users and better understand how the site is working for their needs. For our first test, we set out to learn the following information from our users:

-   Can users understand the data displayed?

-   Can users download data?

-   Can users find other nearby monitoring locations?

-   Can users provide feedback?

As we watched our users use our page, we identified many places where we could add features to make our interface more intuitive. We are continuing to iterate on these changes and will be checking back in with our users soon, but let's cover some of the major updates to the user interface.

### Clarifying what it means when no data loads on the hydrograph

In many cases, a user will select data to be displayed on the hydrograph and is surprised by a hydrograph that is blank. With no supporting information, the users were not sure whether data existed or whether they had configured the graph incorrectly.

When a longer time frame of data is requested to be displayed on the hydrograph, there can be a noticeable delay before the data is rendered on the graph. A loading indicator is now drawn on the graph while the data is loading to ensure our users know the request is being processed and the hydrograph is not complete yet.

{{< figure src="/static/release_notes-2021-04-16/image4.jpg" caption="Hydrograph loading data with a loading indicator over the top of the page"  alt="Hydrograph with no data line and a partial circle of black dots that are in the center of the graph”" >}}


If there is no data in the given time range, clear messages are now provided on the hydrograph explaining what data was not found. In the case that none of the data requested is available, a clear message of "No data available" is written onto the hydrograph. 

{{< figure src="/static/release_notes-2021-04-16/image5.jpg" caption="Hydrograph with no data available"  alt="Hydrograph with no data line and a blue No data available written in the center of the graph”" >}}



The legend is used to clarify which data is missing when multiple parameters or statistics are simultaneously rendered. In this example, only the median data was found for this sensor, with the legend clarifying that both current and last year's data was not available for this parameter.

{{< figure src="/static/release_notes-2021-04-16/image6.jpg" caption="Hydrograph of water temperature at [Little Arkansas River near Sedgewick, KS](https://waterdata.usgs.gov/monitoring-location/07144100/#parameterCode=00010&timeSeriesId=57474&period=P7D&compare=true) for a sensor that has no data during the selected time frame, but median data is rendered on the hydrograph.  "  alt="Hydrograph legend explains there is no data for both current and last year data. Median data appears in two dotted lines on the hydrograph as well as in the legend where period of record for each median is detailed." >}}


### Retrieving data

Users have asked for clear ways to download the data shown on the hydrograph. The team is working behind the scenes to make an easy to use download for all types of NWIS data but while we have been waiting for that functionality, we provided access to the existing water services tab-separated data to fill the gap. Originally, these links were available in a tab midway down the page, but when we worked with our users, we found that it was confusing and many users start their search for this functionality near the hydrograph.

As a result, we moved and clarified the functionality to be associated in a tab above the hydrograph. When the "Retrieve data" button is pressed, a drop-down menu opens with option to retrieve any data displayed on the hydrograph. The data is opened in a new html tab when the Retrieve button is pressed. We will continue to review whether this interface works for our users and will iterate as we find easier ways to help our users access the data.

{{< figure src="/static/release_notes-2021-04-16/image7.jpg" caption="Retrieve data tab is open showing the available data options and the context of the data service at [Little Arkansas River near Sedgewick, KS](https://waterdata.usgs.gov/monitoring-location/07144100/#parameterCode=99133&period=P7D&compare=true)"  alt="Retrieve data from the grey bar above the hydrograph has been selected and a drop down menu shows current, prior year, and location information options to select. A blue retrieve button is under the options to finish the selection." >}}



### Changing the time span

One of the most popular interactions with the hydrograph is to change the time span. During our testing with users, we found that the custom time span was not as easy or obvious to use as we had intended. Not all our users use this custom feature regularly, as the pre-built 7 days / 30 days / 1 year options fulfils the needs of many of our users. The custom options were moved into a standalone tab (along with the Retrieve data functionality) and simplified to allow users to clearly see either the calendar selection or the days before that could be adjusted manually. When the Change time span button is pressed, a drop-down menu appears with the custom time options. The changes are not applied to the hydrograph until the Change time span button is pressed. As with the Retrieve data, we will continue to review whether this interface works for our users and will iterate as we find easier ways to help our users access the interaction.

{{< figure src="/static/release_notes-2021-04-16/image8.jpg" caption="Change time span tab is open showing options to change time by calendar or by days prior [Little Arkansas River near Sedgewick, KS](https://waterdata.usgs.gov/monitoring-location/07144100/#parameterCode=99133&period=P7D&compare=true)"  alt="Change time span from the grey bar above the hydrograph has been selected and a drop down menu shows either a date range or days before today can be selected. A blue Change time span button is under the options to finish the selection." >}}



### Behind the scenes

-   Increased hydrograph rendering performance

-   For data with multiple methods of measurement, ensured the page automatically selects the method with the most data in the selected time span

-   Camera now uses html5 video when possible

-   Added Beta tags for Groundwater Data and Affiliated Networks sections to indicate the maturity of these features.

## What is coming up for next sprint?

-   Continuing to work on enhancing the usability of the pages,

-   Testing with users to better understand how key features are used

## Disclaimer

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
