# jQuery Lightbox

Lightbox is a jQuery plugin designed to provide a zoom. Lightbox supports basic animations.

## Installation

To install copy the *images*, *javascripts*, and *stylesheets* directories into your project and add the following snippet to the header:

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js" type="text/javascript"></script>
    <script src="javascripts/jquery.lightbox.js" type="text/javascript"></script>
    <link href="stylesheets/jquery.lightbox.css" rel="stylesheet" type="text/css" />
  
## Examples

Setting up a gallery is easy. The following snippet is a good start:
    
    <a href="samples/sample-01.png" data-lightbox>
      <img src="samples/preview-01.png" />
    </a>

    <a href="samples/sample-02.png" data-lightbox>
      <img src="samples/preview-02.png" />
    </a>

    <a href="samples/sample-03.png" data-lightbox>
      <img src="samples/preview-03.png" />
    </a>

    <a href="samples/sample-04.png" data-lightbox>
      <img src="samples/preview-04.png" />
    </a>

    <a href="samples/sample-05.png" data-lightbox>
      <img src="samples/preview-05.png" />
    </a>

    <a href="samples/sample-06.png" data-lightbox>
      <img src="samples/preview-06.png" />
    </a>
  
    <script type="text/javascript">
      $('.lightbox').lightbox();
    </script>

## Copyright

Copyright (c) 2010 - 2012 Kevin Sylvestre. See LICENSE for details.
