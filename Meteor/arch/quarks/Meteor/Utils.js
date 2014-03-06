function getTemperatureString (temperature, temperatureUnit)
{
	var temp = parseFloat (temperature);
	if (temperatureUnit === "Celsius")
	{
		temp = Math.round (temp - 273.15);
		temp = String (temp) + "\u00B0"+ "C";
	}
	else if (temperatureUnit === "Fahrenheit")
	{
		temp = Math.round (temp - 458.87);
		temp = String (temp) + "\u00B0"+ "F";
	}
	else if (temperatureUnit === "Kelvin")
		temp = String (temp) + "K";

	return temp;
}

function getPressureString (pressure, pressureUnit)
{
	var temp = parseFloat (pressure);
	if (pressureUnit === "HectoPascal")
		temp = String (temp) + " hPa";
	else if (pressureUnit === "MiliBar")
		temp = String (temp) + " mbar";
	else if (pressureUnit === "KiloPascal")
	{
		temp *= 10;
		temp = String (temp) + " kPa";
	}
	else if (pressureUnit === "InchesOfMercury")
	{
		temp = (temp / 100 * 3386.389).toFixed (2);
		temp = String (temp) + " inHg";
	}
	return temp;
}

function getWindSpeed (speed, windSpeedUnit)
{
	var temp = parseFloat (speed);
	if (windSpeedUnit === "KilometerPerHour")
		temp = String ((temp * 3.6).toFixed (2)) + " km/h";
	else if (windSpeedUnit === "MeterPerSecond")
		temp = String (temp) + " m/s";
	else if (windSpeedUnit === "MilesPerHour")
		temp = String ((temp * 2.236936).toFixed (2)) + " pmph";
	else if (windSpeedUnit === "Knot")
		temp = String ((temp * 1.943844).toFixed (2)) + " knots";
	else if (windSpeedUnit === "BeaufortScale")
	{
		if (temp < 0.3)
			return "0 bft";
		else if (temp < 1.5)
			return "1 bft";
		else if (temp < 3.4)
			return "2 bft";
		else if (temp < 5.4)
			return "3 bft";
		else if (temp < 7.9)
			return "4 bft";
		else if (temp < 10.7)
			return "5 bft";
		else if (temp < 13.8)
			return "6 bft";
		else if (temp < 17.1)
			return "7 bft";
		else if (temp < 20.7)
			return "8 bft";
		else if (temp < 24.4)
			return "9 bft";
		else if (temp < 28.4)
			return "10 bft";
		else if (temp < 32.6)
			return "11 bft";
		else
			return "12 bft";
	}
	return temp;
}

function getImage (iconId, useSystemIconSet)
{
	var image;
	switch (iconId)
	{
	case "01d":
		image = "weather-clear";
		break;
	case "01n":
		image = "weather-clear-night";
		break;
	case "02d":
		image = "weather-few-clouds";
		break;
	case "02n":
		image = "weather-few-clouds-night";
		break;
	case "03d":
		image = "weather-clouds";
		break;
	case "03n":
		image = "weather-clouds-night";
		break;
	case "04d":
		image = "weather-many-clouds";
		break;
	case "04n":
		image = useSystemIconSet ? "weather-many-clouds" : "weather-many-clouds-night";
		break;
	case "09d":
	case "09n":
		image = "weather-showers";
		break;
	case "10d":
		image = "weather-showers-scattered-day";
		break;
	case "10n":
		image = "weather-showers-scattered-night";
		break;
	case "11d":
	case "11n":
		image = "weather-storm";
		break;
	case "13d":
		image = "weather-snow-scattered-day";
		break;
	case "13n":
		image = "weather-snow-scattered-night";
		break;
	case "50d":
	case "50n":
		image = "weather-mist";
		break;
	default:
		image = "weather-none-available";
	}

	if (useSystemIconSet)
		image = "image://ThemeIcons/" + image;
	else
		image = Qt.resolvedUrl ("images/" + image + ".png");

	return image;
}
