//
// Weather script used on Weather.cshtml page
//

// DIV to inform users of problems
let errorBox = document.getElementById('errorBox');

// Try to use the browser geolocation API
// This only works on HTTPS (or localhost) and requires users permission
if (navigator.geolocation) {
  errorBox.classList.add('hide');
  navigator.geolocation.getCurrentPosition(getWeather, (err) => {  
    let errMessage = err.message;
    if(err.message.startsWith("Only secure origins are allowed")) {
      errMessage = "getCurrentPosition API only works on secure (HTTPS) domains";
    } 
    errorBox.classList.add('show');
    errorBox.innerHTML = errMessage + ". Will fall back to showing weather for London";
    getWeather({ coords: { latitude: 51.40329, longitude: 0.05619 }})
  });
} else {
  errorBox.classList.add('show');
  errorBox.innerHTML = "Geolocation is not supported by this browser. Maybe it's time to upgrade!";
  getWeather({ coords: { latitude: 51.40329, longitude: 0.05619 }})
}

// Get the weather data from the API
// Of a given position (see https://developer.mozilla.org/en-US/docs/Web/API/GeolocationPosition)
function getWeather(pos) {

  let spinner = document.getElementById('spinner');
  let lat = pos.coords.latitude;    //51.40329 
  let long = pos.coords.longitude;  //0.05619 

  // Call API with fetch
  fetch(`/api/weather/${lat}/${long}`)
  .then((response) => {
    // fetch handles errors strangely, we need to trap non-200 codes here
    if (!response.ok) {
      throw Error(response.statusText + " " + response.status);
    }
    // Convert JSON results
    return response.json();
  })
  .then((weather) => {
    // Got some real data, so...
    spinner.parentNode.removeChild(spinner);
    
    // Set & display skycon icon
    var skycons = new Skycons({ "color": "#3498db" });
    skycons.add("weather_icon", weather.currently.icon);
    skycons.play();

    // Get weather details and show in HTML list
    let wList = document.getElementById('weather-list')
    wList.innerHTML += `<li>The weather currently is: &nbsp; ${weather.currently.summary}</li>`
    wList.innerHTML += `<li>The temperature is: &nbsp; ${weather.currently.temperature}°C</li>`
    wList.innerHTML += `<li>The temperature feels like: &nbsp; ${weather.currently.apparentTemperature}°C</li>`
    wList.innerHTML += `<li>Chance of rain is: &nbsp; ${weather.currently.precipProbability}%</li>`    
    wList.innerHTML += `<li>The humidity is: &nbsp; ${weather.currently.humidity}%</li>`    
    wList.innerHTML += `<li>Wind speed: &nbsp; ${weather.currently.windSpeed}%</li>`    
    wList.innerHTML += `<li>UV index: &nbsp; ${weather.currently.uvIndex}%</li>`    
    wList.innerHTML += `<li>Forecast hour: &nbsp; ${weather.minutely.summary}</li>`    
    wList.innerHTML += `<li>Forecast day: &nbsp; ${weather.hourly.summary}</li>`    
    wList.innerHTML += `<li>Forecast week: &nbsp; ${weather.daily.summary}</li>`    
  })
  .catch(err => {
    // Error trapping
    spinner.parentNode.removeChild(spinner);
    error.classList.add('show');
    error.innerHTML = "Weather API Error - " + err;
  });
}