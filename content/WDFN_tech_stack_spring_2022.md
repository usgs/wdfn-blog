---

author: Jim Kreft, Andrew Yan, and Mary Bucknell

date: 2022-04-14

slug: WDFN-tech-stack-spring-2022

draft: False

type: post

title: The WDFN tech stack

toc: false

categories:
- water-information
- web-communication

tags:
- water data
- Water Data for the Nation
- public communication
- technology
- NextGen
- monitoring location pages

image: 

description: A medium depth dive into the Water Data for the Nation team's tech stacks

keywords: water data

author_staff:

author_email: <wdfn@usgs.gov>

---


The goal of this post is to give a technical reader an idea of what technologies the Water Data for the Nation (WDFN) team uses, because it is both varied and ever changing. There are three areas that the WDFN team focuses on, and each have their own unique tech stacks. These areas are: the Front End, for user interfaces; the Back End, for databases and APIs; and Data Engineering, where we transform the data from upstream systems and prepare it for the APIs and ultimately display.

## Front end
The WDFN team's basic ethos is to generate semantic HTML pages. We use our own APIs to generate the information on our pages thus ensuring that the information that you see on a page has been generated from publicly available APIs. Care is taken to ensure that our pages have a common look and feel. We start with the [United States Web Design System](https://designsystem.digital.gov/) as the basis for styling our pages allowing our pages to be mobile friendly and meet accessibility requirements. On top of that, we have developed a npm installable package, [wdfn-viz](https://code.usgs.gov/wma/iow/wdfn-viz), which includes USGS visual ID components.

### Web server technology stacks
The tech stack selected for the web server depends on the needs of the specific applications. We have converged on three different tech stacks.

#### Flask
For a number of years, we have found that the [Flask](https://flask.palletsprojects.com) microframework gives us the flexibility to build the applications that we need, while allowing us to pull in other components (such as authorization) as needed.  This flexibility allows us to decide whether the client or server side is the appropriate place to render html and retrieve data. 

Examples of Flask-based applications include:
* [WaterdataUI](https://code.usgs.gov/wma/iow/waterdataui), which, among other things, generate the next generation monitoring location pages
* [WQP_UI](https://github.com/NWQMC/WQP_UI/), the front end for the [Water Quality Portal](https://www.waterqualitydata.us) an interagency tool for accessing water quality data.

#### Django
For the most part, the WDFN team runs in a read-only world.  We transform data for public consumption (more about that later), but we don't manage much additional data.  There are, a few exceptions, where we do need to manage transactions and store data.  The scale on these systems is not large, and the overall complexity is low.  After some past experimentation with low-code frameworks, we have instead found that the batteries-included nature of [Django](https://www.djangoproject.com/) works well for our needs.  If it isn't built into Django itself, there is generally a community plugin that fits our basic needs, so we can focus on the important parts- making systems that work for our users.

WDFN applications that use Django include:
* WDFN-Accounts, the transactional system behind the [next generation Water Alert System](https://waterdata.usgs.gov/blog/wateralert-transition/). _The code for this application is not yet public_
* [Well registry Manager](https://github.com/ACWI-SOGW/well_registry_management) A tool for cooperators to manage well metatdata for the [National Groundwater Monitoring Network Data Portal](https://cida.usgs.gov/ngwmn/)
* [The National Environmental Methods Index (NEMI)](https://github.com/NWQMC/nemi_dj_webapp) a cross agency application for storing and managing environmental methods, which is available at [nemi.gov](https://www.nemi.gov).

#### Hugo
At times, we just need to generate static content, where the underlying data is not changing. An example of this type of system is this very blog, which is generated from markdown documents stored in a git repository.  There are many static site generators, and we have landed on [Hugo](https://gohugo.io/). The build process pulls in the same [WDFN-viz package](https://code.usgs.gov/wma/iow/wdfn-viz) as our other user interfaces, for a consistent look and feel.

Example Hugo-based pages
* [WDFN Blog](https://github.com/usgs/wdfn-blog/) The content for this blog
* [WDFN Labs](https://github.com/usgs/waterdata_labs) Static Content for [labs.waterdata.usgs.gov](https://labs.waterdata.usgs.gov/index.html)

### Browser technology stack
As with many modern websites, we use client side JavaScript to provide an interactive browsing experience allowing the user to customize the information that they are viewing and to easily provide additional information and context. Along with using USWDS to provide common design elements such as form fields, navigations elements, and alerts, we use open source libraries as needed to provide interactive elements. Examples include using [Leaflet](https://leafletjs.com/) for interactive maps and [D3](https://d3js.org/) for graphs, charts, and other visualizations.

We have started using the [Vue](https://vuejs.org/) Framework which aids our ability to develop our applications as a set of components that we can use to build our interactive elements. By using a framework, we have better state management, a more consistent look and feel, and better tested code. We use modern build tools such as rollup and vite to produce our javascript assets, which minifies our assets decreasing the load that a user needs to load in order to use our pages.

For styling, we use [Sass](https://sass-lang.com/) along with mixins provided by USWDS to generate any custom style sheets needed. For our interactive pages, we keep styling (inluding making the page responsive) out of the HTML markup and within the style sheets as much as possible. We find that this makes it easier to work on both the markup and the styling be keeping a clear demarcation line between the two. By keeping style in style sheets, we can more easily generate smaller browser payloads by compressing our static assets.

## Back end - APIs, Databases, and data processing
### Spring Boot for Java-based Application Programming Interfaces (APIs)
APIs are a crucial component of Water Data for the Nation. Many users of USGS water data never see the user interfaces that we build on the WDFN team.  Instead, they interact with our data via systems built on top of the APIs that we build. One of the core architectures that we use to build these APIs is a to use the Java [Spring Boot Framework](https://spring.io/projects/spring-boot), with OpenAPI documents generated from annotations in the code using [Springdoc](https://springdoc.org/).  When we need a high performance streaming API, this framework has served us well.  These applications are typically deployed as serverless containerized applications using [AWS Fargate](https://aws.amazon.com/fargate/).

Example Spring Boot APIs
* Observations service (labs)
    * [Swagger docs](https://labs.waterdata.usgs.gov/api/observations/swagger-ui/index.html?url=/api/observations/v3/api-docs)
    * [Archived source code](https://github.com/usgs/time-series-services) _We are working toward open sourcing this repository on code.usgs.gov_
* Water Quality Portal data services
    * [Swagger docs](https://www.waterqualitydata.us/data/swagger-ui/index.html?docExpansion=none&url=/data/v3/api-docs)
    * [Web services Guide](https://www.waterqualitydata.us/webservices_documentation/)
    * [Archived source code](https://github.com/NWQMC/WQP-WQX-Services) _We are working toward open sourcing this repository on code.usgs.gov_
* FROST Server for the Sensorthings Standard
    * While the WDFN team does not actively develop the FROST Server, our familiarity with Spring Boot based applications helped us
    * [FROST-Server source code](https://github.com/FraunhoferIOSB/FROST-Server)
    * [Service Root](https://labs.waterdata.usgs.gov/sta/v1.1/)
    * [Seminar on Sensorthings](https://waterdata.usgs.gov/blog/api-webinar-sensorthings/)

### Databases and datastores
#### Postgres
The WDFN team has settled on [Postgres](https://www.postgresql.org/) and its associated [PostGIS](https://postgis.net/) extension for most database tasks. It works well in the AWS RDS system, and for the most part we can just leave it alone.  There is certainly more that we could do with our database layer with a dedicated database manager, but we appreciate the general simplicity of the system.  Within Postgres, we use [Liquibase](https://www.liquibase.org/) to manage our database structure, which allows for very low risk database changes- by automating the database management, we know that we will be able to apply exactly the same changes that we tested out on lower tiers (say, changes to partitioning or indexing) on the production tiers.

#### NoSQL datastore
There are a few places where we are using document databases instead of traditional RDBMS systems, in spaces where the data structure is rapidly evolving, we don't expect to need to do complex queries, and don't anticipate a need for complex analytics or reporting.  When we are working in the NoSQL space, we use AWS DynamoDB  

#### S3 + Athena
Sometimes, we need to query a whole bunch of stuff such as log information or other metrics, but just for a weekly or quarterly report.  This where tools like AWS Athena really shine.  We can store static data in an AWS S3 bucket (cheap) but run queries on it as if it were a database.  We take approaches like this for log analysis and metrics.

### Data Engineering
A very large percent of the WDFN's development time is actually focused on preparing data for access by the public.  For various reasons, the data and API structures used by upstream data management applications do not lend themselves to effective data access.  For example, if one were to want to query the Aquarius Time Series System for the latest data for all of our time series, it would be on the order of 100,000 individual web service calls!  While we have been pulling data from Aquarius Time Series for quite some time, the legacy system depended heavily on data structures that simply don't meet our current needs.  Hence, we are putting serious effort into building cloud-native, event-driven, serverless data processing pipelines.

Since we started building this tooling in 2019, we have learned a LOT about scaling, cost management, repository structure, and more.  There is plenty more that we can do.  Tools that we use to build our data processing pipelines include:
* [AWS Lambda functions](https://aws.amazon.com/lambda/), mostly written in Python, but with a few in Java
* [AWS SQS](https://aws.amazon.com/sqs/) and [AWS SNS](https://aws.amazon.com/sns/) for managing events  
* [AWS Step Functions](https://aws.amazon.com/step-functions/) for orchestrating workflows
* [AWS Elasticache](https://aws.amazon.com/elasticache/) for short-lived caches that soften dependencies and decrease runtimes
* [AWS Cloudwatch](https://aws.amazon.com/cloudwatch/) for dashboards, alerting, and cloud monitoring
* [pandas](https://pandas.pydata.org/), the Python data processing library for munching data into the form that we need it

We do our best to limit tool creep- there are many, many different ways to do things in the cloud, but we have found that to have sustainable development and operations with a small team, it is important to be deliberate about choices.  If adding a new tool nets a small gain with a significant increase in cognitive overhead, it is probably not worth it.

### Infrastructure as code
#### Cloud
In the cloud, the WDFN team has found that there is significant overhead to running servers, especially in a federal environment.  For example, we have to allocate significant space to running antivirus software, even for Linux instances that are only serving as docker hosts.  As such, we have leaned hard into the serverless space, and we primarily define and provision our cloud assets using the [Serverless Framework](https://www.serverless.com/). Where we can't use the serverless paradigm or the Serverless Framework, we generally use [AWS Cloudformation](https://aws.amazon.com/cloudformation/) templates. We also make heavy use of [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html) to programatically interact with AWS resources.

#### On Premise
On premise, server configuration is managed in a variety of ways, but application configuration is mostly managed using [Ansible](https://www.ansible.com/) and [Jenkins](https://www.jenkins.io/).

### Monitoring

Monitoring is an area that we are rapidly learning about.  For our modernized, cloud native tools, we currently rely heavily on dynamically created Cloudwatch dashboards, but know that we have a lot more work to do as we work toward building resiliant, observable systems.  Watch for future posts about more changes as we move forward.

* "Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government." *
