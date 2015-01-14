# jQuery Lighter

Lighter is a jQuery plugin created to provide zoomable content like other lightbox plugins.

## Installation

To install copy the *javascripts* and *stylesheets* directories into your project and add the following snippet to the header:

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js" type="text/javascript"></script>
    <script src="javascripts/jquery.lighter.js" type="text/javascript"></script>
    <link href="stylesheets/jquery.lighter.css" rel="stylesheet" type="text/css" />

This plugin is also registered under http://bower.io/ to simplify integration. Try:

    npm install -g bower
    bower install lighter

Lastly this plugin is registered as a https://rails-assets.org/ to simplify integration with Ruby on Rails applications:

**Gemfile**

    + source 'https://rails-assets.org'
    ...
    + gem 'rails-assets-lighter'

**application.css**

    /*
     ...
     *= require lighter
     ...
    */

**application.js**

    //= require jquery
    ...
    //= require lighter


## Examples

Setting up a lighter is easy. The following snippet is a good start:

    <a href="samples/sample-01.png" data-lighter>
      <img src="samples/preview-01.png" />
    </a>
    <a href="samples/sample-02.png" data-lighter>
      <img src="samples/preview-02.png" />
    </a>
    <a href="samples/sample-03.png" data-lighter>
      <img src="samples/preview-03.png" />
    </a>
    <a href="samples/sample-04.png" data-lighter>
      <img src="samples/preview-04.png" />
    </a>
    <a href="samples/sample-05.png" data-lighter>
      <img src="samples/preview-05.png" />
    </a>
    <a href="samples/sample-06.png" data-lighter>
      <img src="samples/preview-06.png" />
    </a>

## Status

[![Status](https://travis-ci.org/ksylvest/jquery-lighter.png)](https://travis-ci.org/ksylvest/jquery-lighter)

## Copyright

Copyright (c) 2010 - 2015 Kevin Sylvestre. See LICENSE for details.
