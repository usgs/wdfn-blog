In August 2020, the Hydro Network Linked Data Index (NLDI) was updated
with some new functionality and some changes to the existing Web
Application Programming Interface (API). This post summarizes these
changes and demonstrates Python and R clients available to work with the
functionality.

If you are new to the NLDI, visit the
[nldi-intro](https://waterdata.usgs.gov/blog/nldi-intro/) blog to get up
to speed. This post assumes a basic understanding of the API.

Summary
-------

The new functionality added to the NLDI is the ability to retrieve local
or accumulated catchment characteristics for any `featureSource`
available from the system. A selection of characteristics from [this
data
release](https://www.sciencebase.gov/catalog/item/5669a79ee4b08895842a1d470)
are included. This is detailed further down in this post.

API changes are backward compatible but fairly significant. - If using a
web-browser, `?f=json` needs to be appended to requests to see JSON
content. - The `navigate` endpoint is deprecated in favor of a
`navigation` end point with slightly different behavior. -- previously,
a `navigate/{navigationMode}` request would return flowlines. The
`navigation/{navigationMode}` endpoint now returns available
`dataSources`, treating flowlines as a data source. -- The upstream with
tributaries `navigationMode` now requires the `distance` query
parameter. Unconstrained upstream with tributaries queries (the default
from the `navigate` endpoint) were causing system performance problems.
Client applications must now explicitly request very large upstream with
tributaries queries to avoid performance issues due to naive client
requests. - All features in a `featureSource` can now be accessed at the
`featureSource` endpoint. This will allow clients to easily create
map-based selection interfaces. - A `featureSource` can now be queried
with a lat/lon point encoded in `WKT` format.

API Updates Detail
------------------

lorum ipsum

New Catchment Characteristics
-----------------------------

lorum ipsum

Python Client Application
-------------------------

lorum ipsum

R client Application
--------------------

lorum ipsum
