# owi-blog
*Blog posts from the USGS Office of Water Information*

[**Download/installation instructions**](https://gohugo.io/overview/installing/)

Essentially, the Hugo executable just needs to sit in a directory referenced in the shell $PATH variable

[**Quick start guide for Hugo**](https://gohugo.io/overview/quickstart/)

Shows how to build a simple example Hugo site.  On the left sidebar there are links to more in-depth documentation.

[**Templates for R markdowns**](https://github.com/hrbrmstr/markdowntemplates)

With these installed, you can select the 'Hugo Blog Post' template when you create a new R markdown in R studio.  The R markdown will then knit to a .md file, which you should save to the 'content' directory of the Hugo site.  Hugo handles it from there.

NOTE: `markdowntemplates` by default adds `status: draft` to the markdown header. It is up to you to change that to `type: post` for the post to be published.

**Content for blog posts** 
The necessary pieces for a post are the resulting .md file that is knit from Rstudio, which forms the main body of the post, and then any images that should be associated with the post.  The actual layout of the pages is handled in the Hugo 'theme'.

Current theme development based off:
```
git clone https://github.com/jpescador/hugo-future-imperfect.git
```


