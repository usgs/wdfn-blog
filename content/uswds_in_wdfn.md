---
author: Mary Bucknell

date: 2022-05-19

slug: uswds-in-wdfn

draft: True

type: post

title: Using US Web Design System in WDFN

toc: false

categories: 
  - software-development

tags:
  - water-data-for-the-nation
  - US Web Design System
  - Vue
  - Sass

image: 

description: How WDFN is using USWDS to produce mobile friendly and accessible web sites

keywords:
    - water data
    - mobile friendly
    - accessible

author_staff: 

author_email: <mbucknell@usgs.gov>

 ---
Since the very first work on the WDFN monitoring location pages through today we have used the US Web Design System (USWDS) to provide guidance, style sheets, and components for our web sites to make them mobile friendly and accessible. Four years ago, we started with USWDS version 1.x on the Beta version of our monitoring location pages. Over the next four years, we have continued to use it in our new WDFN products while also introducing it to other projects within USGS such as [USGS Publications Warehouse](https://pubs.er.usgs.gov/]) and interagency projects such as [Water Quality Portal (WQP)](https://www.waterqualitydata.us/).

The latest version of USWDS (3.0.x) has already been incorporated into our WDFN blog (this web site), our NextGen Monitoring location pages, [example page](https://waterdata.usgs.gov/monitoring-location/09380000/), and our newest product WaterAlert which will be made public in July 2022. This post will describe how we use USWDS within our tech stacks including creating a set of USWDS Vue components and using USWDS mixins within custom Vue Components style markup. 

## Visual Identification package for WDFN sites
Early in our work with USWDS we quickly realized that it would be an advantage to have an npm installable package that contained templating guidance and stylesheets for the USGS visual identification required for the header and footer. We developed [wdfn-viz](https://code.usgs.gov/wma/iow/wdfn-viz) which we publish to npm. This allows us to create the custom style for our header and footers in one place and then install that package into the projects where we want to have the USGS visual identification. When changes are needed, such as occurred when we added social media icons in the footer, we could make the style sheet and template guidance changes here.

The project's README gives guidance on installing the package and how to use it within a project. When  installing wdfnviz, the user does not need to install @uswds/uswds separately. The user can choose to use the prebuilt CSS style sheets or if they choose to build customized stylesheets from Sass by importing the wdfnviz Sass style sheet.

The prebuilt CSS style sheets come in two flavors. The first and recommended choice is the wdfnviz-all.css. This style sheet includes all USWDS which allows the project to use USWDS markup and USWDS utility classes without creating their own style sheets. The disadvantage is that the asset size reflects that it contains all of USWDS. But it allows projects to quickly get started using USWDS which is very valuable particularly when prototyping and you don't necessarily want to deal with building stylesheets. 

The second choice would be to use wdfnviz.css which includes only the parts of USWDS that style the header, navigation, and footer. The advantage to this asset is that is smaller but you will not be able to use other parts of USWDS in the rest of your web page. This is recommended only if you are not going to USWDS to style your sight except for the header, navigation, and footer. This is discouraged for most public government sites but there is a use case for internal sites which want the visual identification but are using a different design system to style the rest of the page.

If you are building custom stylesheets for your project and we strongly encourage this, we provide a Sass style sheet to import as well as guidance on how to include the [USWDS packages](https://designsystem.digital.gov/components/packages/) that your application will use as well as the ability to set USWDS theme variables [USWDS Settings](https://designsystem.digital.gov/documentation/settings/). We provide guidance on how to build the stylesheets using npm scripts. We also encourage you to consider other ways such as using gulp as recommended by USWDS.

The advantage to creating your own custom stylesheets are numerous. USWDS provides design tokens for things like color, spacing, fonts, and layout that can be used along with USWDS mixins

We keep the repo up-to-date with the latest versions of USWDS as much as practical. The CHANGELOG.md notes changes including what version of USWDS is used for a particular version. The version number of this package will always be updated when we use a new version of USWDS. We recommend that users of this package pin the version number in their package.json so that they are using a known version of USWDS. We use semantic versioning so patch releases should just be fixes whereas minor versions will contain fixes and perhaps changes to templating guidance. When using a new version of wdfnviz, the release notes of USWDS should always be consulted to see what changed.

The techniques and patterns used in this repo could be adapted for other government agencies and pages.

## USWDS use in this blog site

## USWDS use in the NextGen Monitoring Location pages

## USWDS use in a Vue project

### USWDS Vue components

### Custom Vue components
