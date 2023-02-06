# Assignment 2: Custom Widgets, Interactive Data Querying
## **Noah Hendrickson**

## Part A:
Pretty easy. Stroke is slightly dark green and thick. <br>
In general, I reused some colors from the previous assignment, <br>
mainly because I think they look good, I just changed the <br>
color of the text in order to possibly stand out more.

## Part B:
This was also pretty easy. <br>
Stroke width is set as 0.01 + numTies * 0.1 <br>
I think this results in a good looking thick line for those <br>
with many ties and a nice thin line that blends into the background <br>
for those municipalities that don't. <br>
Only issue I ran into was when I was almost done I realize I drew <br>
the lines wrong lol but it worked out. <br>
I did add a little extra functionality here of being able to <br>
deselect the municipality by selecting it again. <br>
When deselected, no directions show up.

## Part C:
I really tried to overengineer this one at first. <br>
I really wanted to make a pie slice that did not go out <br>
to infinity. I though it looked a bit weird when shown off <br>
in class so I wanted to do it different. My very first thought <br>
was to find the intersection of the pie slice lines and the <br>
sides of the map/screen and then loop through the pixels near the <br>
slice and color them a color if they were in the triangle. <br>
This led to a really long intersection function and didn't work in <br>
the end. I also realized that processing has a really useful "triangle()" <br>
function and that I could use that along with redrawing the outside rects <br>
in order to kinda hack it. So that was like an hour of work wasted lol. <br>
In the end though, it turned out looking good, with only a slight <br>
weirdness around the edges of the map every so often. 

## Part D:
Really easy, just went by 3's. Not much to say.