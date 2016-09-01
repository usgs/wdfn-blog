owi-blog
----------

*Blog posts from the USGS Office of Water Information*

# Submitting blog post

1. Fork repo
2. Create a markdown file (.md)
3. Add to `content` folder
4. Include static images in `static\name-of-blog`. Images *must* include alt and title text
5. Add a header similar to:

  ```
  ---
  author: Laura DeCicco
  date: 2016-06-16
  slug: plotFlowConc
  draft: True
  type: post
  title: EGRET plotFlowConc using ggplot2
  categories: Data Science
  tags: 
    - EGRET
    - R
  image: static/plotFlowConc/unnamed-chunk-4-1.png
  ---
  ```

  Important notes about header:
  
  * Date format has to be "YYYY-MM-DD" for the blogs to be organized properly.
  
  * Initial submission **must** include `draft: True`
  
  * `slug` slug will be the name of your url after owi.usgs.gov\blog\xxx
  
  * `image` is not required, but will improve the look of the main "blog" page. Without an image, a generic OWI image will be included.
  
  * `categories` is a small list of approved options. The current list is `Data Science`, `OWI Applications`, and `Software Development`. For each category, there is a designated list of people that have the authority to approve posts.
  
  * `tags` are more specific words, and do not need to be on a pre-approved list.
  
  * It's a good idea to direct people to github issues, emails, or other ways to communicate if they have questions/comments/etc.

6. Submit a pull request
8. Submitter is responsible for getting 1 internal peer-review of content (interal reviews can be done on a Google Form)
9. A designated approver must sign off on content based on review response
10. A designated web content manager will sign off on if the page is generally fit to be published on a government website (verify the header follows the "Important notes" above, images contain alt tags)
11. Once the content is approved, the draft status can be removed, and the content will appear on the QA site.
12. Assuming all looks good, push to prod


## Hugo Installation

[**Download/installation instructions**](https://gohugo.io/overview/installing/)

Essentially, the Hugo executable just needs to sit in a directory referenced in the shell $PATH variable

[**Quick start guide for Hugo**](https://gohugo.io/overview/quickstart/)

Shows how to build a simple example Hugo site.  On the left sidebar there are links to more in-depth documentation.

To test locally, run:

```
export HUGO_BASEURL="blog/"
hugo server --theme=hugo_theme_robust --buildDrafts
```

# Instructions for R users

[**Templates for R markdowns**](https://github.com/USGS-R/USGSmarkdowntemplates)

```
devtools::install_github("USGS-R/USGSmarkdowntemplates")
```

This will add `draft: True` to the markdown header (not rmarkdown file). It is up to you to remove that AFTER the content has been reviewed.

To add 2 figures side by side, add `class="sideBySide"`, for example:

```
<img class="sideBySide" src='/fig1.png'/ alt='/ggplot2'/>
<img class="sideBySide" src='/fig2.png'/ alt='/EGRET'/>
```


Disclaimer
----------
This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey  (USGS), an agency of the United States Department of Interior. For more information, see the official USGS copyright policy at [http://www.usgs.gov/visual-id/credit_usgs.html#copyright](http://www.usgs.gov/visual-id/credit_usgs.html#copyright)

Although this software program has been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided "AS IS."
