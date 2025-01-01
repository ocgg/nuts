# H1: Test file for check       markdown printing in CLI

## H2: Titles

## H1 & H2 have separator below

#
##

Up there: H1 & H2 with no text should display a separator

###
####
  ######

Up there: H3-6 titles with no text count as blank lines

  ###        H3:       This is indented and should be stripped
#### H4: With no blank line after or before, should print them anyway
#####Forgot the space after the "#####", should not be printed as title.

This is a H1 too
=

And this is a H2
-


##### H5: Many blanklines before or after should print only one


There should be a blankline before & after each titles, regardless of how it is written
###### H6: The last one
There should be a blankline before & after each titles, regardless of how it is written
####### H7: doesn't exist

## H2: Paragraphs

There cannot be # Titles in the ## middle of a paragraph.

This paragraph should display as is

  This indented paragraph should not be indented in output

  Because all lines are stripped           

This line is normal.
This newline without blank line before should print on the same line as the last one, after a space.

If there is many spaces       in a middle or end of a   paragraph, only    one is printed


Many blanklines before or after should print only one.

    lines indented with at least 4 spaces are a code block !!

## H2: Text decorations

**This should be bold**, **This should not but the " ** " should print. **

**Bold styles on
several lines should
print bold on one line**

**But not

if theres a blankline (new paragraph) somewhere**

__Bold also__, __ and not this but "__ " should print.__

*This should be italic*, * This should not but the "* " should print.*

_Italic also_, _ and not this but "_ " should print._

