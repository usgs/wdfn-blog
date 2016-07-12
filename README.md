# owi-blog
*Blog posts from the USGS Office of Water Information*

[**Download/installation instructions**](https://gohugo.io/overview/installing/)

Essentially, the Hugo executable just needs to sit in a directory referenced in the shell $PATH variable

[**Quick start guide for Hugo**](https://gohugo.io/overview/quickstart/)

Shows how to build a simple example Hugo site.  On the left sidebar there are links to more in-depth documentation.

[**Templates for R markdowns**](https://github.com/hrbrmstr/markdowntemplates)

With these installed, you can select the 'Hugo Blog Post' template when you create a new R markdown in R studio.  The R markdown will then knit to a .md file, which you should save to the 'content' directory of the Hugo site.  Hugo handles it from there.

NOTE: `markdowntemplates` by default adds `status: draft` to the markdown header (not rmarkdown file). It is up to you to change that to `type: post` for the post AFTER they have been reviewed.

NOTE: Date format has to be "YYYY-MM-DD" for the blogs to be organized properly.

**Content for blog posts** 
The necessary pieces for a post are the resulting .md file that is knit from Rstudio, which forms the main body of the post, and then any images that should be associated with the post.  The actual layout of the pages is handled in the Hugo 'theme'.

To test locally, run:

```
export HUGO_BASEURL="blog/"
hugo server --theme=hugo_theme_robust --buildDrafts
```


Disclaimer
----------
This software is in the public domain because it contains materials that originally came from the U.S. Geological Survey  (USGS), an agency of the United States Department of Interior. For more information, see the official USGS copyright policy at [http://www.usgs.gov/visual-id/credit_usgs.html#copyright](http://www.usgs.gov/visual-id/credit_usgs.html#copyright)

Although this software program has been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S. Government as to the accuracy and functioning of the program and related program material nor shall the fact of distribution constitute any such warranty, and no responsibility is assumed by the USGS in connection therewith.

This software is provided "AS IS."