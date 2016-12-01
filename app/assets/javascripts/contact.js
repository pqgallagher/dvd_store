function myMap()
{
  var mapCanvas = document.getElementById("map");
  var myCenter = new google.maps.LatLng(49.9002628,-97.1412676);
  var mapOptions = {center: myCenter, zoom: 18};
  var map = new google.maps.Map(mapCanvas,mapOptions);
  var marker = new google.maps.Marker({position: myCenter});
  marker.setMap(map);
}
