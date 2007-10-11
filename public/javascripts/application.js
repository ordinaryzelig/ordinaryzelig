// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function switch_time_format(thingy)
{
    var temp = thingy.innerHTML;
    thingy.innerHTML = thingy.title;
    thingy.title = temp;
    thingy.onclick = switch_time_format(thingy);
}
