---
author: Nicole Felts and Jim Kreft
date: 2022-02-23
slug: api-webinar-OGC
draft: false
type: post
title: OGC | API Webinar | Feb 28
toc: false
categories: 
- Water Information
- Web Communication
- Events
tags:
- Water Data
- Water Data for the Nation
- Public Communication
- APIs
image: /static/API_OGC/API OGC Blog1.gif
description: On February 28th, 2022, join our webinar to learn how to use USGS Application Programming Interfaces to serve your unique water data display needs.
keywords: water data, API, webinar, tutorial
author_staff: 
author_email: <wdfn@usgs.gov>
---

<div class="grid-row">
{{< figure src="/static/API_OGC/API_OGC_Banner.gif" caption="On January 31st, we hosted the [first webinar in our API series.](https://www.youtube.com/watch?v=n7TQoJAQ8WI). Join our next API webinar about OGC on 2/28/2022!" alt="Banner image with the following text: Join Our API Webinar Series. USGS. Easily Integrate Real-Time Water Data. SensorThings API on Monday, January 31st, 2022 at 12 pm ET/ 9 am PT. OGC API on Monday, February 28th, 2022 at 12 pm ET/ 9 am PT. What's Next? Monday, April 25th, 2022 at 12 pm ET/ 9 am PT. Water Data for the Nation. Making high-quality water information discoverable, accessible, and usable for everyone. On the right side of the image there is a computer programming screen with the text 'API.' Next to that, two gears working together continually turn, making this a gif." >}}
</div>

## ❔ What is the Application Programming Interface (API) Series?
🙌 At the United States Geological Survey, we're making high-quality water information discoverable, accessible, and usable for everyone.

Water data should be usable 🦾! Our modernized APIs provide a way for you to display our water data in the format that works best for you. Learn more about how & why to use USGS modernized APIs to integrate our water data in your applications.

In this API webinar series, we'll touch on what USGS water data is, then we'll discuss the API formats that have been used in the past and why the new API formats are better for you.

### Upcoming Webinars in API Series
| Title | Date | Time |
|------|----------|-------|
OGC | Monday, February 28th, 2022 | 12 pm ET / 9 am PT
What's Next? | Monday, April 25th, 2022 | 12 pm ET / 9 am PT

## ❔ What is the OGC Webinar?
In this webinar on our Open Geospatial Consortium ([OGC](https://ogcapi.ogc.org/)) API, we'll give you a brief background on APIs, then we'll dive into a live demo of our [modernized OGC API](https://labs.waterdata.usgs.gov/api/observations/swagger-ui/index.html?url=/api/observations/v3/api-docs#/Observations%20-%20OGC%20api). Check out the [features](https://ogcapi.ogc.org/features/) of OGC.

## 🕛 When is the OGC Webinar?
On Monday, February 28th, 2022 at 12 pm ET/ 9 am PT.


## 👩‍💻 Who is the OGC Webinar For?
- [Operationalized Pull Water Data for the Nation users](https://waterdata.usgs.gov/blog/user_operational_pull/)

- Programmers interested in improving their workflow with USGS water data

- Anyone who wants to learn more about the power of APIs!


## 📆 How Can I Register/ Sign Up / Add to My Calendar?
Conveniently add this event to your calendar by visting the event on [Eventbrite](https://www.eventbrite.com/e/ogc-apis-easily-integrate-real-time-water-data-tickets-252218772137?aff=ebdsoporgprofile). <b>You do not have to provide any personal information, and you do not have to register for the event on Eventbrite in order to attend</b> (we've provided this option because many users requested a way to register for the event so they could get automatic reminders).
  
We will be providing a new way to register for events soon!

## 📞 Where's the link to join the live call?
Join the [Teams Live event](https://teams.microsoft.com/l/meetup-join/19%3ameeting_NDQ5NzE2ZTYtNDg0ZS00MjI2LWFhMDAtYWU1YzIxYzE3OTA0%40thread.v2/0?context=%7b%22Tid%22%3a%220693b5ba-4b18-4d7b-9341-f32f400a5494%22%2c%22Oid%22%3a%2274c01c76-7d2c-4555-94ec-9e22ecb44037%22%2c%22IsBroadcastMeeting%22%3atrue%7d&btype=a&role=a) at 12 pm ET/ 9 am PT on Monday, February 28th, 2022!

## OGC API - Features Example

✍ Here is an example [Leaflet](https://leafletjs.com/) webmap that is making a live call to the USGS Implementation of OGC API - Features, and below it is the minimal code needed to build your own map! We will talk in more detail about the structure of the [USGS implementation of OGC API - Features](https://labs.waterdata.usgs.gov/api/observations/swagger-ui/index.html?url=/api/observations/v3/api-docs#/Observations%20-%20OGC%20api) during the seminar.

{{< rawhtml >}}
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>
<div id='map'></div>
<script> 

    var map = L.map("map").setView([45, -90], 6);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:
        'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, '
    }).addTo(map);

    (async () => {
      const monitoringLocations = await fetch(
        "https://labs.waterdata.usgs.gov/api/observations/collections/RTS/items?stateFIPS=US%3A55&monitoringLocationType=Stream&active=true&f=json&limit=1000",
        {}
      ).then((response) => response.json());
      L.geoJSON(monitoringLocations, {
        pointToLayer: function (feature, latlng) {
          return L.marker(latlng, {});
        },
        onEachFeature: onEachFeature
      }).addTo(map);
    })();

    function onEachFeature(feature, layer) {
      var popupContent =
        "<a href='" +
        feature.properties.monitoringLocationUrl +
        "' target='_blank'>" +
        feature.properties.monitoringLocationName +
        "</a>";
      if (feature.properties && feature.properties.popupContent) {
        popupContent += feature.properties.popupContent;
      }
      layer.bindPopup(popupContent);
    }
</script>
{{< /rawhtml >}}

Here is the same code in a single html view that you can edit in any text editor.

```html
<html>
    <head>
      <title>Stream gages with real time data in Wisconsin</title>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
      <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>
        <style>
            html, body {
              height: 100%;
              margin: 0;
            }
            #map {
              width: 100%;
              height: 100%;
            }
        </style>
    </head>
    <body>
        <div id='map'></div>
        <script>
            var map = L.map("map").setView([45, -90], 6);
        
            L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
              attribution:
                'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, '
            }).addTo(map);
        
            (async () => {
              const monitoringLocations = await fetch(
                "https://labs.waterdata.usgs.gov/api/observations/collections/RTS/items?stateFIPS=US%3A55&monitoringLocationType=Stream&active=true&f=json&limit=1000",
                {}
              ).then((response) => response.json());
              L.geoJSON(monitoringLocations, {
                pointToLayer: function (feature, latlng) {
                  return L.marker(latlng, {});
                },
                onEachFeature: onEachFeature
              }).addTo(map);
            })();
        
            function onEachFeature(feature, layer) {
              var popupContent =
                "<a href='" +
                feature.properties.monitoringLocationUrl +
                "' target='_blank'>" +
                feature.properties.monitoringLocationName +
                "</a>";
              if (feature.properties && feature.properties.popupContent) {
                popupContent += feature.properties.popupContent;
              }
              layer.bindPopup(popupContent);
            }
        </script>
    </body>
</html>
```
### Resources

- OGC API - Processes
    - [OGC API - Processes details from the Open Geospatial Consortium](https://ogcapi.ogc.org/processes/)
    - [USGS OGC-API Processes Endpoint](https://labs.waterdata.usgs.gov/api/nldi/pygeoapi/processes?f=html)
    - [hyriver Python client](https://hyriver.readthedocs.io/en/latest/notebooks/pygeoapi.html)
    - [R NHDPLus tools](https://usgs-r.github.io/nhdplusTools/)
        - [Split Catchment](https://usgs-r.github.io/nhdplusTools/reference/get_split_catchment.html)
        - [Cross Section](https://usgs-r.github.io/nhdplusTools/reference/get_xs_points.html)

