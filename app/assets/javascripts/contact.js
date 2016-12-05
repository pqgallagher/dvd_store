//Displays the google map based on the LatLng value.
function myMap()
{
  //Gets the div object to display the map.
  var mapCanvas = document.getElementById("map");
  //Creates a new google map object,
  var myCenter = new google.maps.LatLng(49.9002628,-97.1412676);
  //Sets the location and zoom.
  var mapOptions = {center: myCenter, zoom: 18};
  //Sets the map buttons and display options.
  var map = new google.maps.Map(mapCanvas,mapOptions);
  //Centers the map.
  var marker = new google.maps.Marker({position: myCenter});
  //Sets the marker for the location.
  marker.setMap(map);
}
