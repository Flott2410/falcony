import mapboxgl from 'mapbox-gl';

const buildMap = () => {
  const mapElement = document.getElementById('map');
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/flott2410/ckesquj8h0r0d19p94eoymic9',
    minZoom: 2
  });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  if (mapElement) {
    console.log('blah map');
    const map = buildMap();
    map.on('load', function() { //On map load, we want to do some stuff
      map.addLayer({ //here we are adding a layer containing the tileset we just uploaded
        'id': 'countries',//this is the name of our layer, which we will need later
        'source': {
          'type': 'vector',
          'url': 'mapbox://flott2410.132n7hem' // <--- Add the Map ID you copied here
        },
        'source-layer': 'ne_10m_admin_0_countries-c5jx4l', // <--- Add the source layer name you copied here
        'type': 'fill',
        'paint': {
          'fill-color': '#173B63', //this is the color you want your tileset to have (I used a nice purple color)
          'fill-outline-color': '#F2F2F2' //this helps us distinguish individual countries a bit better by giving them an outline
        }
      });
      map.setFilter('countries', ['in', 'ADM0_A3_IS'].concat(['AUT', "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN", "ISL", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD", "NOR", "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE", "CHE"])); // This line lets us filter by country codes.

      map.on('click', 'countries', function (mapElement) {
      const countryCode = mapElement.features[0].properties.ADM0_A3_IS; // Grab the country code from the map properties.

      fetch(`https://restcountries.eu/rest/v2/alpha/${countryCode}`) // Using template tags to create the API request
        .then((data) => data.json()) //fetch returns an object with a .json() method, which returns a promise
        .then((country) => { //country contains the data from the API request
          // Let's build our HTML in a template tag
          const html = `
            <ul>
              <li><h3>${country.name.link("countries/" + gon.country_ids[country.alpha3Code])}<img src='${country.flag}'/></h3></li>
              <li><strong>Population: </strong> ${(country.population / 1000000).toLocaleString('en')} mio.</li>
              <!-- with iso code (country.alpha3Code) access gon.total_cases and get right value from Object} -->
              <li><strong>Total cases: </strong> ${(gon.total_cases[country.alpha3Code]).toLocaleString('en')}</li>
              <li><strong>New cases (last day): </strong> ${(gon.new_cases[country.alpha3Code]).toLocaleString('en')}</li>
              <li><strong>Death rate: </strong> ${(gon.total_deaths[country.alpha3Code] / country.population * 100).toFixed(4)} %</li>
            </ul>
          `; // Now we have a good looking popup HTML segment.
          new mapboxgl.Popup() //Create a new popup
          .setLngLat(mapElement.lngLat) // Set where we want it to appear (where we clicked)
          .setHTML(html) // Add the HTML we just made to the popup
          .addTo(map); // Add the popup to the map
        });
      });
    });
    // const markers = JSON.parse(mapElement.dataset.markers);
    // addMarkersToMap(map, markers);
    // fitMapToMarkers(map, markers);
  };
};


export { initMapbox };
