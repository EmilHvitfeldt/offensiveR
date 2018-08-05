
<!-- README.md is generated from README.Rmd. Please edit that file -->
offensiveR
==========

[![Travis build status](https://travis-ci.org/EmilHvitfeldt/offensiveR.svg?branch=master)](https://travis-ci.org/EmilHvitfeldt/offensiveR)

The goal of **offensiveR** is to help check for misspelled that are not caught with normal spells checking because they are misspelled to an offensive word.

Examples include:

-   mass - ass
-   but - butt
-   assess - asses

This package crosscheck with a quite large list of words, many of which will not be found offensive to most, but it deemed a good starting point.

Installation
------------

You can install **offensiveR** from github with:

``` r
# install.packages("offensiveR")
devtools::install_github("EmilHvitfeldt/offensiveR")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
library(offensiveR)
```

The package consists of two major functions. `offensive_check_files()` and `offensive_check_string()`. `offensive_check_files()` takes a vector of paths to files, and returns the possible offensive words and their location.

``` r
offensive_check_files(c("README.Rmd"))
#>   WORD    FOUND IN
#> ass     README.Rmd:23
#> asses   README.Rmd:25
#> butt    README.Rmd:24
```

`offensive_check_string()` takes a character string as input, and can be quite handy if you need to check an email you are about to send.

``` r
text <- "Dear Jones
         
         The task you ask me will we hard to do since the ass is hard to 
         measure in motion. It will be hard to asses, butt I think we will 
         manage.

         Regards Tom"


offensive_check_string(text)
#> since the ass is hard 
#> hard to asses butt i 
#> to asses butt i think
```

All functions comes with the two arguments `words_add` and `words_ignore` to add words to look for, and words to ignore respectively.

As of version 0.1.0 also include addin support for `offensive_check_string`.

![](man/figures/Jan-16-2018-21-15-34.gif)

Thanks
------

This package would not have been made have I not gotten the Idea from this tweet

<blockquote class="twitter-tweet" data-lang="da">
<p lang="en" dir="ltr">
Despite having sent out emails and surveys to 20K+ people countless times before, I still get nervous each time I have to do it 😂
</p>
— Jesse Maegan (@kierisi) <a href="https://twitter.com/kierisi/status/924292995435978752?ref_src=twsrc%5Etfw">28. oktober 2017</a>
</blockquote>
&lt; Ad the [spelling](https://github.com/ropensci/spelling) package which much of the package is based on.
