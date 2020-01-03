---
author: Laura DeCicco
date: 2016-11-21
slug: gran
draft: True
title: The US Geological Survey R Archive Network - GRAN
type: post
categories: Data Science
image: static/gran/usgs-r-logo.png

tags:
  - R
  - R repository

description: Description of the reason and development of grantools, an R package to help with the updating of GRAN.
keywords:
  - R
  - R repository
  - automated builds of R repository

---
Introduction / Motivation
-------------------------

We created the US Geological Survey R Archive Network, aka: GRAN for a variety of reasons. The main public repository for R packages is CRAN: the Comprehensive R Archive Network. More information on GRAN can be found [here](https://owi.usgs.gov/R/gran.html).

### Policy

There is a requirement that released USGS software that it must be available on a ".gov" server. This post is not about policy...yet...if I find I have a better or stronger understanding of the requirements, I'll update. Here are some links though:

[Federal Source Code Policy](https://sourcecode.cio.gov/)

[USGS Policy](https://www2.usgs.gov/usgs-manual/im/IM-OSQI-2016-01.html)

There are essentially 2 issues. One is that "released" software needs to have a peer-reviewed publication. Historically, this was required to be a USGS Techniques and Measurements publication, which is a huge barrier (both expensive and time consuming). The new software release policy eases that barrier, but there is still (I think) some expectation that a publically-released "interpretive software" package includes a publication.

The other issue is that software needs to be available on a ".gov" server. So, even if a package gets published to CRAN, there needs to be a separate location where people can download the package that we are hosting.

### Training

There has been a 2.5 day Introduction to R course offered to USGS employees dating back many years. Before GRAN, there was *3 hours* scheduled for USGS package installation. These 3 hours were very fustrating for a variety of reasons, and required a lot of individual attention on each computer by the instructor. This was the employee's *first* impression of scripting, and often discouraging.

GRAN has made it possible for complete R novices to set up their workspace with USGS packages before the class even begins. This allows the class to immediately start with basic instructions, and a much less fustrating introduction.

### Collaboration

There are many great reasons to create R packages, for example, a research collaboration. These packages could be invaluable for a research project, but may not be worth the effort to publish to CRAN. It is possible to ship zipped packages via email and install locally. However, things get very tricky very fast when you start having to describe what package dependencies are required. Adding an R package to GRAN allows the installation to be 1 line of simple R code, and that will automatically install all dependencies (and dependencies of dependencies, etc.....).

User Experience
---------------

We have very explicit instruction on how USGS employees should set up their R work enviornment. This is often done by IT staff because it requires admin access ("pr" account). These instructions can be at:

<https://owi.usgs.gov/R/training-curriculum/intro-curriculum/Before/>

These instructions include a way to include GRAN in the user's "Rprofile" file. That only needs to be done once on a computer. The file is independent of the version of R, so even major upgrades to R should retain that information.

To add GRAN to the "Rprofile" file. You can run the following command in the R command line:

``` r
rprofile_path = file.path(Sys.getenv("HOME"), ".Rprofile")
write('\noptions(repos=c(getOption(\'repos\'),
    CRAN=\'https://cloud.r-project.org\',
    USGS=\'https://owi.usgs.gov/R\'))\n',
      rprofile_path,
      append =  TRUE)
```

Then you *must restart R*!

Once GRAN has been added, it's trivial to add and upgrade USGS and non-USGS packages to your R package library. For example, there is a package called `smwrData`. This package is only available on GRAN (the USGS repository). There is also a package called `dplyr` which is available on CRAN (the public repository). To install both of those packages:

``` r
install.packages(c("smwrData","dplyr"))
```

It is also possible to specify the repository within the `install.packages` function:

``` r
install.packages("smwrData", repos=c("https://owi.usgs.gov/R",getOption("repos")))
```

Updating GRAN and CRAN packages is a snap too:

{{< figure src="/static/gran/update.png" title="Update all packages." alt="Update all packages" class="side-by-side" >}}

GRAN Submissions
----------------

GRAN submissions must have a USGS employee as the maintainor. Other requirements for submission can be found at:

<https://owi.usgs.gov/R/gran.html>

GRAN Infrastructure
-------------------

A R repository has a perscribed format. It needs source packages (generally for Unix), Mac binaries, and Windows binaries. Also, each major version of R needs it's own binary folders. So, a typical R archive folder structure will look like:

<pre>
- src
   - contrib
       - packagefoo.tar.gz
       - packagebar.tar.gz
       - PACKAGES
       - PACKAGES.gz
- bin
   - windows
       - contrib
          - 3.3
             - packagefoo.zip
             - packagebar.zip
             - PACKAGES
             - PACKAGES.gz
          - 3.2
             - packagefoo.zip
             - packagebar.zip
             - PACKAGES
             - PACKAGES.gz
   - macosx
      - mavericks
         - contrib
            - 3.3
               - packagefoo.tgz
               - packagebar.tgz
               - PACKAGES
               - PACKAGES.gz
            - 3.2
               - packagefoo.tgz
               - packagebar.tgz
               - PACKAGES
               - PACKAGES.gz
</pre>
What that means is that we need automate builds for both Mac and Windows machines.

Build and Update Automation
---------------------------

There are several tools we use to help automate the building and updating of GRAN:

### Tools

-   We created an R package `grantools` to help automate the process of building and updating GRAN.
-   [Github](https://github.com/) is used to for version control and a collaboration tool on the package development.
-   [TravisCI](https://travis-ci.org/) is used to check that package maintainers are submitting proper information.
-   [Jenkins](https://jenkins.io/) is used to automate the building and updating tasks.
-   Packages are sent to [Amazon S3](https://aws.amazon.com/s3/) with a command line `sync` function.

### Process

1.  Package need to be on github
2.  Package author makes a github release
3.  Package maintainor makes a pull request on our `grantools` repository.
4.  A `grantool` maintainor will make sure that some basic checks are sucessful (via a passed Travis test), and merge the pull request.
5.  A Jenkin's job on a Windows computer will poll for merged pull request.
6.  The job sets the enviornmental PATH for the R version that is 1 less than the current version (GRAN only supports the latest 2 versions of R).
7.  The job creates the source packages for any new or updated package.
8.  The creates the Windows binaries for any new or updated package.
9.  The job then changes the PATH variable so that it now uses the most recent R version.
10. It then repeats the binary build for the current R version.
11. The source and Windows binaries are sent to the Amazon S3 buckets via the command line.
12. There is a check to make sure there are the same number of packages up on the server as in the `grantools` list.
13. A similar process has been developed for the Mac binary builds.
14. The Mac builds are kicked off manually, but otherwise automated as described above.

Lingering Issues
----------------

### Rtools

There are a few packages that require [`Rtools`](https://cran.r-project.org/bin/windows/Rtools/) for the Windows binary builds. There are different versions of `Rtools` for R version 3.3 vs. 3.2. So far, we have not been able to find a way to install the proper version of `Rtools` within the Jenkin's job (that is, via the command line). There are only a few instances where this is a problem, and those are currently installed or updated by hand.

### Package status

We are currently working on a way to clearly define package tiers: Core, Research, and Orphan. The non-core packages will need messages to the users to indicate sunset dates, and expectations of support.

### Package landing pages

We are debating if there should be a landing page for each package on GRAN.

### Tracking Downloads

We have scripts to get the downloads, but it would be great to incorporate those into either the `grantools` package or as part of the Jenkin's job.

Questions
---------

Information on USGS-R packages used in this post:

|                                                                                                                                                 |                                                                                                                                           |
|-------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="https://github.com/USGS-R/grantools" target="_blank"><img src="/img/USGS_R.png" alt="USGS-R image icon" style="width: 75px;" /></a> | <a href="https://github.com/USGS-R/grantools/issues" target="_blank">grantools</a>: An R-package to help automate regular updates to GRAN |
