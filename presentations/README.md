# Google Slides is my Top Choice

I use Google Slides for my presentations. I tend to keep my slides simple and unadorned, so I don't need many frills. Google Slides has more than enough functionality to make a professional presentation with a clean look. I also choose Google Slides over a programmatic approach, such as with reveal.js, because I find the WYSIWYG gui faster to iterate the position, size, and arrangement of images. Also, the collaboration tools in Google Slides are phenomenal.

## Pros of Google Slides
* It is free!
* It has all the essential features needed to make a professional and clean looking presentation.
* Collaborating on a slide deck is silly-simple.
* Files are automatically backed up to the cloud.
* Sharing slides with others is as simple as sharing a link.
* Linked slides is very handy for reusing slides across several presentations.

## Cons of Google Slides
* It doesn't expose fine control over slide elements through the gui.
   * For instance, resizing images can only be done by click-and-drag with the mouse and sometimes I'd prefer specifying a size with a number.
   * As another example, distributing items across the slide would be nice, but Google slides only distributes groups of 3 elements or more.
* If large files are added to the presentation then Google Slides can become laggy or unresponsive.
* Documentation could be better, but then again this can be said about a lot of software.

When adding images to Google Slides, to keep the file sizes small, I often use a screen capture tool such as SnagIt. I work the image in FIJI or GIMP to a satisfactory appearance and then screen grab the image. For example, I may adjust the brightness and contrast, etc., of an image.

# nbconvert is Nifty
If I have a Jupyter notebook that I want share or present, nbconvert is an excellent tool that can be used to create slides from a notebook. In the notebook each cell will have a slide drop down menu. In a straightforward scenario, each cell in a notebook can be thought of as one slide. As a I create a notebook I am sure to assign a slide type to each cell, which makes creating a few slides from a jupyter notebook a cinch. nbconvert can export the slides as PDF, markdown, and reveal.js.

## reveal.js
Writing slides programmatically has an appeal because it is exact and self-documenting. Reveal.js is a great library for creating slides with code, and the presentation can hosted online at a website. nbconvert has the option of exporting a reveal.js document that can be added to websites
