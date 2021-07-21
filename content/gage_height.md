---

author: Lynne Fahlquist and Candice Hopkins

date: 2021-07-21

slug: gage_height

draft: False

type: post

title: Why We Use Gage Height

categories: water-information, web-communication

tags: water data, stream flow, public communication, stream gage, gage height, river height

image: /static/gage_height/cover.png

description: Gage height is used as a default parameter for water availability at streamgages for better user context. 

keywords: water data

author_staff: candice-hopkins

author_email: \<chopkins@usgs.gov\>

---

## Making Water Data Easier to Understand

On USGS water monitoring location pages, the default parameter that is
displayed for [streamgage](https://pubs.usgs.gov/fs/2011/3001/) sites is
gage height. Other measures like streamflow are still available and
easily accessed with just one click. **Gage height** is the distance (or
height) of the water surface above the streamgage datum reference point.
**Gage datum** is a unique reference point to each gage site and is
generally located underneath the streambed to accommodate for stream
channel changes.

<div>
{{< figure src="/static/gage_height/1.png" caption= "Streamgage 13176400, East Fork Owyhee River at Crutcher Crossing, ID, provides critical data that the U.S. Bureau of Land Management needs to secure water rights to protect the Owyhee Canyonlands wilderness area." alt="A photo of a streamgage on a riverbank in a canyon." >}}

</div>

## Gage Height to describe Water Quantity

*Based on user feedback, we updated our*
*[streamgage](https://www.usgs.gov/mission-areas/water-resources/science/streamgaging-basics?qt-science_center_objects=0#qt-science_center_objects)
monitoring location pages so gage height is the first parameter users
see on hydrographs.*

Users often understand what water height measurements mean to them; they
know how gage height relates to benchmarks and landmarks in their area.
Additional measures of water quantity, such as discharge are still
available on the monitoring location pages. **Discharge**, which is
sometimes called streamflow or water flow, is defined as the rate at
which a volume of water passes by a particular location.

Discharge and gage height are related values. Although discharge values often make news headlines, many users have told us that gage height values are the most useful to them when making decisions (such as for recreational or emergency purposes). As a result of this feedback, we now show gage height as the default display on streamgage monitoring location pages. 


<div class="grid-row">

{{< figure src="/static/gage_height/2.1.png" caption="Discharge and gage height for the same time period at monitoring location [07074420](https://waterdata.usgs.gov/monitoring-location/07074420/#parameterCode=00065), Black River at Elgin Ferry, AR" alt="Two graphs for monitoring location 07074420: the graph on the left shows time versus discharge, and the graph on the right shows time versus gage height." class="side-by-side" >}}
{{< figure src="/static/gage_height/2.2.png" caption="other caption, which can have markdown in it" alt="Description of the image" class="side-by-side" >}}

</div>


## What Exactly is Gage Height?
**Gage height** is the **distance (or height) of the stream (or lake)
water surface above the gage datum** (reference point). Read about [the
history of stream gages in this interactive
post](https://labs.waterdata.usgs.gov/visualizations/gages-through-the-ages/index.html#/).
The **gage datum** is a **uniquely selected reference point for each
gage site.** Most of the time, it is picked to be below the lowest
anticipated depth of a stream or lake because streambeds change over
time. At some locations, particularly those near the ocean, this
arbitrary reference point may be picked to be at sea level.

## Gage Height is also called\...

-   Stage

-   River Height

-   River Level

-   [River
    Stage](https://www.usgs.gov/special-topic/water-science-school/science/water-qa-what-does-term-river-stage-mean?qt-science_center_objects=0#qt-science_center_objects)

-   Stream Height

-   Stream Stage

-   Water Height

<div class="grid-row">

{{< figure src="/static/gage_height/3.png" caption="USGS employee, Russ Buesing uses a cable car to access a gage (05104500) in winter on the Roseau River near Malun, MN." alt="A man hangs from a cable car suspended over a river. He is moving towards a streamgage over the Roseau Rivernear Malun, MN." >}}

</div>

# Why Doesn't USGS Measure Gage Height From the Bottom of the Stream?

## Gage Datum -- The Reference Point

Streams are like living things and are constantly changing. Sometimes
streams erode, becoming deeper while other times streams deposit
sediment, becoming shallower. To understand how those changes can affect
streamflow, we need to measure from a reference point that does not
change over time, which is why gage datums are chosen to be below the
base of a streambed.

<div class="grid-row">

{{< figure src="/static/gage_height/4.png" caption="Gage height and gage datum graphic. Gage height is the measurement from the water surface down to the gage datum." alt="Stream cross section graphic depicting the height from the water surface down to the gage datum -- the gage height." >}}

</div>

## Complex Math to Estimate Discharge

Complex math is used to compute the relation between gage height and
discharge. It is easier to continuously measure the height of water than
a volume of water passing by a point, so gage height is the parameter
that is reported continuously and is used to [compute the related
discharge](https://www.usgs.gov/special-topic/water-science-school/science/how-streamflow-measured?qt-science_center_objects=0#qt-science_center_objects).
Another reason that gage datums are picked to be below streambeds is
related to the mathematical computations that relate gage height to
discharge.

# Why Gage Height Matters

## Faster Insights Into Flooding

Gage height is used in computer models and forecasts, including flood
inundation maps and flood forecasts. [Flood
stage](https://w1.weather.gov/glossary/index.php?word=flood+stage),
officially defined by the [National Weather
Service](https://w1.weather.gov/), can be thought of as the stage (or
gage height) at which overflow of the natural banks of a stream begins
to cause damage in the local area from flooding. The National Weather
Service uses gage height numbers to tell the public about different
levels of flooding hazard. Therefore, gage height values are commonly
understood by water managers, emergency responders, and public citizens.

Where National Weather Service flood stages are available for USGS
sites, we overlay those flood stages as horizontal lines on our gage
height hydrograph, allowing users to instantly see how close the gage
height is compared to known National Weather Service flood stages near
the location of the gage. Where data are available, users can also use
the [Flood Inundation Mapper](https://fim.wim.usgs.gov/fim/) tool or the
[Interagency Flood Risk Managemen](https://webapps.usgs.gov/infrm/)t
tool to visualize what flooding will look like at different gage
heights.

<div class="grid-row">

{{< figure src="/static/gage_height/5.png" 
caption=`A hydrograph of the [Tangipahoa River at Robert,LA](https://waterdata.usgs.gov/monitoring-location/07375500/#parameterCode=00065&startDT=2021-06-06&endDT=2021-06-10) with Flood Stages visible.` 
alt=`A graph showing gage height over time and a varying river
level. Horizontal lines on the graph indicate the National Weather Service flood levels.` >}}

</div>

## Real-time Response to Changing Gage Heights (Stream or Lake Levels)

Users can receive personal
[WaterAlerts](https://water.usgs.gov/wateralert/) if a gage height
exceeds a threshold of their choosing. Users can choose to use a gage
height they are familiar with for their alert so they can respond
quickly to changing water conditions. For example, a rancher may choose
to be notified when the stream by their property exceeds a nearby gage
height of 5.2 feet, so that they know it may be time to move their
livestock farther from the river. A homeowner may choose to be notified
when a gage height exceeds a certain value to be alerted that a nearby
road may become flooded. An emergency responder may wish to receive
alerts to know when to take particular actions such as closing a
roadway. A farmer may want to know when a stream water level drops below
a certain level as it may affect an irrigation intake pump.
