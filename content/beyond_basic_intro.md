---
author: Lindsay R Carr
date: 2018-07-30
slug: intro-best-practices
title: Beyond Basic R - Introduction and Best Practices
type: post
categories: Data Science
image: static/beyond-basic-intro/usgs-r-logo.png
author_twitter: LindsayRCarr
author_github: lindsaycarr
author_staff: lindsay-r-carr
author_email: <lcarr@usgs.gov>
tags: 
  - R
  - Beyond Basic R
description: Brief introduction to the series of blog posts about next steps after learning basic R, plus some tips on best practices for scripting in R.
keywords:
  - R
  - Beyond Basic R
---
We queried more than 60 people who have taken the [USGS Introduction to R](http://owi.usgs.gov/R/training-curriculum/intro-curriculum) class over the last two years to understand what other skills and techniques are desired, but not covered in the course. Though many people have asked for an intermediate level class, we believe that many of the skills could be best taught through existing online materials. Instead of creating a stand-alone course, we invested our time into compiling the results of the survey, creating short examples, and linking to the necessary resources within a series of blog posts. This is the first in a series of 5 posts called [***Beyond basic R***](http://owi.usgs.gov/blog/tags/beyond-basic-r/).

Other posts that will be released during the next month include:

-   Data munging
-   Plotting with ggplot2 and setting custom themes
-   Mapping
-   Version control via Git

You can see all blogs in this series by clicking the tag “Beyond basic R” or follow [this link](http://owi.usgs.gov/blog/tags/beyond-basic-r/).

Best practices for writing reproducible R scripts
=================================================

Scripting can significantly increase your ability to create reproducible results, figures, or reports so that both your collaborators and future self can successfully rerun code and get the same results. However, just because you’ve put code into a script doesn’t make it reproducible. There are some general organization and code writing tips that can elevate your scripts into reproducible code.

Code organization
-----------------

-   **Put all `library()` calls and any hard-coded variables at the top of the script.** This makes package dependencies and variables that need to be changed very apparent.
-   **Use RStudio projects to organize your scripts, data, and output.** Add scripts to your RStudio project inside a subfolder called `R`, `src`, or something similar. Make sure you have separate folders for data inputs, data outputs, plots, and reports (e.g. R Markdown). All of these folders help keep content in a project organized so that others can find what they need. When you share an RStudio project or go between computers, R knows to interpret file paths relative to the project folder -- no more changing working directories! However, having all your RMarkdown files in a different subfolder from data means you might need to use `..` in your file path to go “up” a level, e.g. `../input/mydata.csv`. Learn more about RStudio projects [here](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects) and see an example of an RStudio project setup [here](https://github.com/USGS-R/exampleRproj).
-   **Modularize your code.** One script that has hundreds of lines of code can be challenging to maintain and troubleshoot. Instead, you should separate your analysis into multiple “modules” at logical points. Then, you can use `source` to execute the contents of each module. When you separate your workflow into multiple scripts, it is useful to name them in ways that indicate the order in which they should be used, e.g. `1_fetch_data.R`, `7_plot_data.R`, etc. Modules are useful as actual scripts, but modularized workflows could also be a collection of user-defined functions (or a mixture of both). You can learn the basics about functions in the [USGS Introduction to R material](https://owi.usgs.gov/R/training-curriculum/intro-curriculum/Reproduce/#functions-in-r) and find advanced information about functions in [Hadley Wickham’s Advanced R tutorial](http://adv-r.had.co.nz/Functions.html).
-   **Do not save your working directory.** When you exit R/RStudio, you probably get a prompt about saving your workspace image - don’t do this! The very nature of reproducible workflows is that you can reproduce your results by re-running your scripts. For this reason, there is no need to save your working directory - you can get all of your variables back by re-running your code the next time you open R. You can learn more about why this is not a great practice from a [lesson by Jenny Bryan](http://stat545.com/block002_hello-r-workspace-wd-project.html#workspace-.rdata) and a [post by Martin Johnsson](https://onunicornsandgenes.blog/2017/04/02/using-r-dont-save-your-workspace/). You can turn off this prompt so that you are not tempted by going to Tools &gt; Global Options and clicking “Never” in the dropdown next to “Save workspace to .RData on exit”.

Code itself
-----------

-   **Use `library()` NOT `require()` when loading packages in scripts.** `library` will throw an error if it the library is not already installed, but `require` will silently fail. This means you get a mysterious failure later on when functions within a package are not available and you thought they were. Learn more about this in [Yihui Xie’s blog post](https://yihui.name/en/2014/07/library-vs-require/).
-   **Do not use functions that change someone’s computer** (e.g. install.packages, or setwd). [Jenny Bryan has a great blog](https://www.tidyverse.org/articles/2017/12/workflow-vs-script/) about the pitfalls of creating code that is not self-contained.
-   **Comment incessantly.** Comments should not take the place of clean and clear code, but can help explain why you might have done certain steps or used certain functions. Commenting is just as important for you as it is for any one else reading your code - as they say, your worst collaborator is you from 6 months ago. Learn a few more tricks with commenting and organizing code that RStudio offers [here](https://support.rstudio.com/hc/en-us/articles/200484568-Code-Folding-and-Sections).
-   **Follow a style and be consistent.** There is no single correct way to style your code, but the important part is that you are consistent. Consistent style makes your code more readable, which makes collaboration with others and the future you much easier. When we talk about style, we are talking about how you name variables, functions, or files (camelCase, under\_scores, etc) and how your code is visually organized (e.g. how long a single line can span, where you indent, etc). You can choose your own style guide, but [this style guide from Google](https://google.github.io/styleguide/Rguide.xml) and [this one from tidyverse](http://style.tidyverse.org/) are good places to start. When it comes to visual organization, RStudio has autoindent features that help make it easier for you to put your code in the right place, and you can always force the RStudio indent by highlighting code and using `CTRL + I`.
-   As you are writing your code, **take advantage of RStudio’s autocomplete features** (and/or copy/paste). Typing mistakes are often a reason that code doesn’t work (e.g. a lowercase letter that really should have been uppercase), and using autocomplete or copy/paste reduces the prevalence of these mistakes. To use autocomplete, start typing something and hit the `Tab` button on your keyboard. You should see options start to pop up. More about auto-complete features [here](https://support.rstudio.com/hc/en-us/articles/205273297-Code-Completion).
-   **Learn to use loops or functions when you find yourself copying and pasting** chunks of code with only minor changes. More code means more to maintain and troubleshoot, so try to reuse code via loops and functions when possible. Consider [this tutorial from Nice R Code](https://nicercode.github.io/guides/repeating-things/), the USGS Introduction to R [lesson on R programming structures](https://owi.usgs.gov/R/training-curriculum/intro-curriculum/Reproduce/), or the [Software Carpentry loop tutorial](https://swcarpentry.github.io/r-novice-inflammation/15-supp-loops-in-depth/) to learn more.

------------------------------------------------------------------------

This is a brief list of good practices to consider when writing R code, and there are lots of other resources to reference when it comes to “best practices”. You should take a look at other posts to get an idea of what the R community thinks more broadly. To start, you could reference [Best Practices for Writing R](https://swcarpentry.github.io/r-novice-inflammation/06-best-practices-R/) by Software Carpentry or [Efficient R programming](https://csgillespie.github.io/efficientR/coding-style.html) by Colin Gillespie and Robin Lovelace. As you explore suggested practices online, keep in mind that R is open-source software and is constantly evolving which means best practices will evolve, too.
