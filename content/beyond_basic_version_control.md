---
author: Lindsay R Carr
date: 2018-08-24
slug: beyond-basic-git
title: Beyond Basic R - Version Control with Git
type: post
categories: Data Science
image: static/beyond-basic-version-control/github-workflow-basic.png
author_twitter: LindsayRCarr
author_github: lindsaycarr
 
 
author_staff: lindsay-r-carr
author_email: <lcarr@usgs.gov>

tags: 
  - R
  - Beyond Basic R
 
description: Brief introduction to version control, Git, and GitHub; plus, resources for learning more.
keywords:
  - R
  - Beyond Basic R
 
  - git
 
---
Depending on how new you are to software development and/or R programming, you may have heard people mention version control, Git, or GitHub. Version control refers to the idea of tracking changes to files through time and various contributors. Git is an example of a version control programming language, and GitHub is a popular web interface for Git. That’s it. Easy!

***But wait, I would need to learn an additional programming language?***

Yes, kind of. Git is a language you use to perform various commands that help you track your changes. Luckily, you don’t need to know too many commands in Git to use the basic functionality. As an added bonus, using Git with RStudio takes away some of the burden of knowing Git commands by including buttons for common actions.

As with any tool that you pick up to help your scientific workflows, there is some upfront work before you can start seeing the benefits. Don’t let that deter you. Git can be very easy once you get the gist. Think about the benefits of being able to track changes: you can make some changes, have a record of that change and who made it, and you can tie that change to a specific problem that was reported or feature request that was noted.

Tracking changes are not the only benefit of using Git and GitHub. If you work on your code with other than just yourself, Git and GitHub is a great way to facilitate collaboration and simultaneous code development. Multiple people can work on the same body of code at one time and request to combine their edits/additions/deletions into the main code along with a peer review. You can “freeze” your body of code at a specific version so that you can reference it at that state in the future (perfect for referencing your scripts in a paper). You can also work on separate features at one time without one depending on the other, so you can easily keep one but discard the other.

Need more convincing? Check these out:

-   First three sections of [An introduction to Git and how to use it with RStudio](http://r-bio.github.io/intro-git-rstudio/) - What is version control?, What is Git?, and What is GitHub? (François Michonneau)
-   [Excuse me, do you have a moment to talk about version control?](https://peerj.com/preprints/3159.pdf) (Jenny Bryan)

***Let’s try it! Where do I start?***

Ease into using Git and GitHub. There is no need need to jump into the deep end with a full blown Git project to start learning about Git. We suggest you start by creating an account and following a repository for a package or project available on USGS-R. You’ll start to get notifications for the repository and can check in periodically to see how others are using Git and GitHub to track their code changes, manage project features and bugs, and collaborate effectively as a team. It will also make you feel more comfortable with the terminology.

If you’d rather start by getting a project setup in Git and GitHub, you can follow our [lesson on version control in the R Package Development](https://owi.usgs.gov/R/training-curriculum/r-package-dev/git/) curriculum. Please note that you don’t need to be creating an R package to use Git or GitHub. Here is [an example of a basic R project](https://github.com/USGS-R/exampleRproj) that has R code, is not a package, and uses Git and GitHub.

There are many existing blogs and websites that dive into how to use these tools. There are also many different ways to use apply Git and GitHub to create an effective workflow. We suggest you follow the typical workflow used by the community at USGS-R; see our [lesson on version control from the R Package Development](https://owi.usgs.gov/R/training-curriculum/r-package-dev/git/#our-recommended-workflow) course. Here are some other resources for mastering Git and GitHub:

-   [Happy Git and GitHub for the useR](http://happygitwithr.com/) (Jenny Bryan)
-   [Git guides](https://maraaverick.rbind.io/2017/12/git-guides/) (Mara Averick)
-   [Git and GitHub](http://r-pkgs.had.co.nz/git.html) from R Packages (Hadley Wickham)
-   [Version control with Git](https://rmhogervorst.nl/cleancode/blog/2016/03/01/content/post/2016-03-01-version-control-start/) (Roel M. Hogervorst)

------------------------------------------------------------------------

*Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.*
