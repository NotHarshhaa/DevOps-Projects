const error = document.getElementById('error')
const weatherIcon = document.getElementById('weatherIcon')
const locationSpan = document.getElementById('location')
const weatherList = document.getElementById('weather-list')

// Try to geolocate the user and call getWeather with result
if (navigator.geolocation) {
  error.classList.add('hide')
  // Note getWeather is the callback which is passed a coords object
  navigator.geolocation.getCurrentPosition(getWeather, (err) => {
    let errMessage = err.message
    // API only allowed on localhost and HTTPS domains
    if (err.message.startsWith('Only secure origins are allowed')) {
      errMessage = 'getCurrentPosition API only works on secure (HTTPS) domains'
    }
    error.classList.add('show')
    error.textContent = errMessage + '. Will fall back to showing weather for London'

    getWeather({ coords: { latitude: 51.40329, longitude: 0.05619 } })
  })
} else {
  // Handle older browsers without geolocation API
  error.classList.add('show')
  error.textContent = "Geolocation is not supported by this browser. Maybe it's time to upgrade!"

  getWeather({ coords: { latitude: 51.40329, longitude: 0.05619 } })
  console.err('Geolocation is not supported by this browser.')
}

// Call our weather API with the given position
async function getWeather(pos) {
  const lat = pos.coords.latitude
  const long = pos.coords.longitude
  try {
    const resp = await fetch(`/api/weather/${lat}/${long}`)
    if (!resp.ok) throw `Fetch /api/weather/${lat}/${long} failed with ${resp.statusText}`
    const data = await resp.json()

    weatherIcon.classList.add(`owi-${data.weather[0].icon}`)
    locationSpan.textContent = ` - ${data.name}`
    addWeatherDetails(`The weather currently is: &nbsp; ${data.weather[0].description}`)
    addWeatherDetails(`Current temperature: &nbsp; ${data.main.temp}°C`)
    addWeatherDetails(`Temperature feels like: &nbsp; ${data.main.feels_like}°C`)
    addWeatherDetails(`Cloud cover: &nbsp; ${data.clouds.all}%`)
    addWeatherDetails(`Volume of rain in last hour: &nbsp; ${data.rain ? data.rain['1h'] : 0}mm`)
    addWeatherDetails(`Wind speed: &nbsp; ${(data.wind.speed * 2.24).toFixed(1)} mph`)
  } catch (err) {
    error.classList.add('show')
    error.textContent = err
  }
}

function addWeatherDetails(details) {
  const li = document.createElement('li')
  li.innerHTML = details
  weatherList.appendChild(li)
}
