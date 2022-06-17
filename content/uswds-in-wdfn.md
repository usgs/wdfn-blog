---
author: Mary Bucknell

date: 2022-06-17

slug: uswds-in-wdfn

draft: False

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

image: /static/uswds-in-wdfn/uswds_in_wdfn.png

description: How WDFN is using USWDS to produce mobile friendly and accessible websites

keywords:
    - water data
    - mobile friendly
    - accessible

author_staff: 

author_email: <mbucknell@usgs.gov>

---
From the beginning of the work on the NextGen Monitoring Location pages through today, the Water Data for the Nation (WDFN) team has used the [US Web Design System (USWDS)](https://designsystem.digital.gov/) to provide guidance, style sheets, and components for our websites to make them mobile friendly and accessible. Four years ago, we started with USWDS version 1.x on the Beta version of our monitoring location pages. Since then, we have continued to use it in our new products while also introducing it to other projects within USGS such as [USGS Publications Warehouse](https://pubs.er.usgs.gov/]) and interagency projects such as [Water Quality Portal (WQP)](https://www.waterqualitydata.us/).

The latest version of USWDS (3.0.x) has already been incorporated into our blog (this website), our NextGen Monitoring Location pages, [example page](https://waterdata.usgs.gov/monitoring-location/09380000/), and our newest product, WaterAlert, which will be made public in the summer of 2022. This post describes how we use USWDS within our tech stacks, including creating a set of USWDS [Vue](https://vuejs.org/) components and using USWDS mixins within custom Vue Components style markup. 

## Visual Identification package for WDFN sites
Early in our work with USWDS, we realized that it would be an advantage to have a npm installable package that contained templating guidance and stylesheets for the USGS visual identification required for webpage header and footers. We developed [wdfn-viz](https://code.usgs.gov/wma/iow/wdfn-viz) which we publish to npm. This allows us to create the custom style for our header and footers in one place and then install that package into the projects where we want to have the USGS visual identification. When changes are needed, such as occurred when we added social media icons in the footer, we can make style sheet and template guidance changes in a single location.

The project's README gives guidance on installing the package and how to use it within a project. When installing wdfn-viz, the user does not need to install USWDS separately. A project can choose to use the prebuilt CSS style sheets or build customized stylesheets from Sass by importing the wdfn-viz Sass style sheet.

The prebuilt CSS style sheets come in two flavors. The first and recommended choice is the wdfnviz-all.css. This style sheet includes all USWDS which allows the project to use USWDS markup and USWDS utility classes without creating additional style sheets. The disadvantage is that the asset size reflects that it contains all of USWDS. But it allows projects to quickly get started using USWDS which is very valuable particularly when prototyping when you don't necessarily want to deal with building stylesheets. 

The second choice for prebuilt style sheets is to use wdfnviz.css which includes only the parts of USWDS that style the header, navigation, and footer. The advantage to this asset is that is smaller. However, you will not be able to use other parts of USWDS in the rest of your web page. This is recommended only if you are not going to use USWDS to style your site except for the header, navigation, and footer. This is discouraged for most public government sites but there is a use case for internal sites which want the visual identification but are using a different design system to style the rest of the page.

If you are building custom stylesheets for your project, and we strongly encourage this, we provide a Sass style sheet to import as well as guidance on how to include the [USWDS packages](https://designsystem.digital.gov/components/packages/) that your application will use as well as the ability to set USWDS theme variables [USWDS Settings](https://designsystem.digital.gov/documentation/settings/). We provide guidance on how to build the stylesheets using npm scripts. We encourage you to explore other ways of building the style sheets such as using gulp as recommended by USWDS.

The advantages to creating your own custom stylesheets are numerous. USWDS provides design tokens for things like color, spacing, fonts, and layout that can be used along with USWDS mixins. Using these design tokens, you can be assured that your color selections meet accessibility requirements and that your project maintains a more consistent style. By creating your own custom style sheets you can avoid cluttering up your markup with USWDS utility classes and decrease the size of your bundled css asset.

We keep the repo up-to-date with the latest versions of USWDS as much as practical. The [CHANGELOG.md](https://code.usgs.gov/wma/iow/wdfn-viz/-/blob/main/CHANGELOG.md) tracks version changes including what version of USWDS is used. The version number of this package will always be updated when a new version of USWDS is installed. We recommend that users of this package pin the version number in their package.json so that they are using a known version of USWDS. The package uses semantic versioning so patch releases should just be fixes whereas minor versions can also contain changes to templating guidance and minor version updates to USWDS. When using a new version of wdfn-viz, the release notes of USWDS should always be consulted to see what changed.

The techniques and patterns used in this repo could be adapted for other government agencies and pages.

## How we use USWDS in the NextGen Monitoring Location pages
Development on the Next Generation Monitoring Location pages started back in early 2018 as a pilot project for the eventual deprecation of the NWISWeb current conditions pages ([example site page](https://waterdata.usgs.gov/nwis/uv?site_no=09380000)). From the beginning, we had a goal of making the pages accessible and mobile friendly in order to be more useful for all users. 

We chose to use USWDS back when it was on version 1. Back then, the number of components was limited and the documentation sparse especially in terms of using mixins, building your own Sass style sheets and how to use the design system in dynamic javascript. And yet, there was a lot of value in using the design system. The developers of USWDS had already done the hard work of coming up with fonts, color guidance, and implementation guidance to enhance the accessibility and mobile friendliness of web pages. And it was being actively developed and improved. In fact, very early on we opened issues in the GitHub repo when we found a problem and in most cases, received a response promptly with fixes or workarounds.

Although the component set was much more limited than it is today, the design system already included many of the basic components needed for our page, including the grid, header, navigation, alerts, accordions, tables, and form components.  Over the years we gained more experience with the design system on this and other projects and continued to keep our versions up to date. The update from version 1.x to version 2.x was a heavy lift due to many breaking changes, but the changes moved the design system in a much improved direction and made it easier for new USWDS customers to start using the design system incrementally.

As USWDS 2.x matured, more components were added that were useful for this page including date pickers, icons, tooltips, and stacked and scrollable tables. We were having some trouble using components such as the date pickers and tooltips in markup that was dynamically rendered due to the requirements to initialize via Javascript after the page was initially loaded. By asking questions on the USWDS Slack channel and digging into the USWDS code, we were able to figure out how to use these within dynamically rendered markup. Because we had started the project back before the development of design tokens, our style sheets contained custom colors and spacing. Over time, we converted our custom style sheets to use design tokens for things like colors and spacing as practical.

Recently, USWDS released their next major version, 3.0. Unlike the update from version 1 to version 2, we had very few changes. The changes centered around our build processes and how the code was organized within USWDS which affected the way the USWDS style sheet was included in our custom style sheets. Version 3.0 made using components that required javascript initialization easier with a new way to initialize the components. But the biggest change was around style sheet optimization. The USWDS migration guide clearly described the steps needed to optimize a project's custom stylesheet which allows users to configure which parts of the USWDS style sheets are used thereby decreasing the size of the style sheet assets. In our case, these steps decreased it by over 50% and were completed very quickly.

## How we use USWDS in WaterAlert subscription management system
In the summer of 2021, the WDFN Team began replacing the USGS WaterAlert product. This included a complete reimagining of the front end creating a subscription management system which makes it easy to create new alert subscriptions and manage existing ones. We choose to use Django to manage the subscription data as well as render both static pages for things like FAQs and user guides, as well as pages that use APIs within the browser to fetch alert subscriptions and information about site metadata.  

We chose to use the Vue Javascript framework to implement the dynamic javascript required for the user subscription management page. Vue is lightweight, easy to learn, and can easily be integrated into part of a page. By using Vue, we can break down our application into reusable components which can easily be updated, maintained, and tested. Vue is a mature framework with a large user community and wide selection of plugins. 

### Custom Vue components
We used the [Single-File Component (SFC)](https://vuejs.org/guide/scaling-up/sfc.html) feature of Vue to build up a set of components to use in our application. One very nice feature of this is the single file contains the markup, the javascript, and optionally the style. In our initial development, version 3 of USWDS was not yet available and what we found is that we could not use USWDS mixins within these style sheets with our existing build system of using rollup without including all of USWDS for each component that used a mixin. As a result, during initial development we used separate style sheets.

By the time USWDS 3 was released, we had changed our build system to use [Vite](https://vitejs.dev/) which uses rollup but generates modular bundled css and javascript files. With the change to the organization of USWDS, we were able to only include the mixins within a Vue component without bringing in all of USWDS. That along with using Vite allowed us to decrease our uncompressed asset size for the subscription management page from 451 KB to 163 KB. This is significant in that many of our potentially users will access Water Alert on mobile devices using cellular data. This change decreases the time and cellular data needed to load the page.

Here is a small example of how we are using USWDS with a Vue SFC.

```vue
<template>
  <div class="vue-example-div">
    {{ message }}
  </div>
</template>

<script>
export default {
  name: 'MyExample',
  props: {
    message: {
      type: String,
      required: true
    }
  }
}
</script>

<style lang="scss">
@use 'uswds-core' as uswds;

.vue-example-div {
  @include uswds.u-color('accent-cool-light');
}

</style>
```

## Looking to the future: develop a USWDS/WDFN library of Vue components
Although we don't have a separate project with USWDS Vue components yet, we have started creating SFCs that represent USWDS components within project repos. In some cases, like with the USWDS alert where we added a close button to the alert, we have enhanced the components for our use.

We have found some challenges working with some javascript intensive components such as Modals and Date Picker. In those cases, we have to defer rendering until after a user takes an action or detect that a component has been initialized before attempting the USWDS initialization in order to prevent double initialization. The Modal component has special considerations as the modal markup is not created within the same div as the button which triggers showing the modal. We have had to manage the initial rendering, showing and hiding within the Vue component

_Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government._