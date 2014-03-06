import QtQuick 1.1
import org.LC.common 1.0
import "Utils.js" as Utils

Item
{
	id: rootRect

	implicitWidth: parent.quarkBaseSize
	implicitHeight: parent.quarkBaseSize

	property string timePrefix;
	property string themePrefix: "colorful";

	property bool showToolTip: false;
	property bool showForecastWindow: false;
	property variant forecastWindow;

	property bool useSystemIconSet: UseSystemIconSet
	property string location: typeof (Location) == "undefined" ? "undefined" : Location
	property int forecastDaysCount: ForecastDaysCount

	property string iconID;
	property variant weatherData;
	property variant weatherForecastData;

	function requestNewWeather ()
	{
		if (typeof (rootRect.location) == "undefined" || rootRect.location == "" ||
				rootRect.location == "undefined")
			return;

		var request = new XMLHttpRequest ();
		request.onreadystatechange = function ()
		{
			if (request.readyState == XMLHttpRequest.DONE)
				if (request.status == 200)
				{
					rootRect.weatherData = JSON.parse (request.responseText);
					rootRect.iconID = rootRect.weatherData ["weather"][0]["icon"];
				}
				else
					console.log ("HTTP request failed", request.status);
		}

		request.open ("GET", "http://api.openweathermap.org/data/2.5/weather?q=" + rootRect.location);
		request.send ();
	}

	function requestWeatherForecast ()
	{
		if (typeof (rootRect.location) == "undefined" || rootRect.location == "" ||
				rootRect.location == "undefined")
			return;

		var request = new XMLHttpRequest ();
		request.onreadystatechange = function ()
		{
			if (request.readyState == XMLHttpRequest.DONE)
				if (request.status == 200)
					rootRect.weatherForecastData = JSON.parse (request.responseText);
				else
					console.log ("HTTP request failed", request.status);
		}

		request.open ("GET", "http://api.openweathermap.org/data/2.5/forecast/daily?q=" +
				rootRect.location + "&cnt=" + ForecastDaysCount);
		request.send ();
	}

	Timer
	{
		id: updateTimer
		interval: UpdateTemperatureInterval * 60 * 1000
		repeat: true
		running: true
		triggeredOnStart: true
		onTriggered:
		{
			requestNewWeather ();
			requestWeatherForecast ();
		}
	}

	Timer
	{
		id: toolTipShowTimer
		interval: 1000
		repeat: false
		running: false
		onTriggered: showWeatherToolTip ()
	}

	Timer
	{
		id: toolTipHideTimer
		interval: 1000
		repeat: false
		running: false
		onTriggered: hideWeatherToolTip ()
	}

	Common { id: commonJS }

	function showWeatherToolTip ()
	{
		var global = commonJS.getTooltipPos (rootRect);
		var params = {
			x: global.x,
			y: global.y,
			existing: "toggle",
			weatherIcon: weatherButton.actionIconURL,
			weatherLocation: rootRect.weatherData ["name"] + ", " +
					rootRect.weatherData ["sys"]["country"],
			weatherInfo: rootRect.weatherData ["weather"][0]["description"] +
					", " + Utils.getTemperatureString (weatherData ["main"]["temp"],
							TemperatureUnit),
			weatherScaleImage: useSystemIconSet
		};

		quarkProxy.openWindow(sourceURL, "MeteorToolTip.qml", params);

		toolTipHideTimer.interval = 3000
		toolTipHideTimer.running = true
		showToolTip = true;
	}

	function hideWeatherToolTip ()
	{
		if (!showToolTip)
			return;
		if (showForecastWindow)
			return;
		var params = { existing: "toggle" };
		quarkProxy.openWindow(sourceURL, "MeteorToolTip.qml", params);
		showToolTip = false;
	}

	ActionButton
	{
		id: weatherButton

		anchors.fill: parent
		actionIconURL: Utils.getImage (iconID, useSystemIconSet)
		actionIconScales: false

		onHovered:
		{
			if (toolTipShowTimer.running)
				return;
			if (showForecastWindow)
				return;
			toolTipShowTimer.start ();

		}

		onHoverLeft:
		{
			toolTipShowTimer.stop ();
			if (showForecastWindow)
				return;
			toolTipHideTimer.interval = 500;
			toolTipHideTimer.restart ();
		}

		onTriggered:
		{
			var global = commonJS.getTooltipPos (rootRect);
			var params = {
				x: global.x,
				y: global.y,
				existing: "toggle",
				weatherIcon: weatherButton.actionIconURL,
				weatherScaleImage: useSystemIconSet,
				weatherInfo: rootRect.weatherData,
				forecastInfo: rootRect.weatherForecastData,
				TemperatureUnit: TemperatureUnit,
				PressureUnit: PressureUnit,
				WindSpeedUnit: WindSpeedUnit,
				UseSystemIconSet: UseSystemIconSet,
				ForecastDaysCount: ForecastDaysCount,
				Meteor_Settings: Meteor_Settings
			};
			showForecastWindow = !showForecastWindow;
			rootRect.forecastWindow = quarkProxy.openWindow(sourceURL,
					"MeteorForecastWindow.qml", params);

		}
		onActionIconURLChanged: actionIconScales = useSystemIconSet;
	}

	onShowForecastWindowChanged:
	{
		if (showToolTip)
			hideWeatherToolTip ();
		toolTipShowTimer.stop ()
	}

	onLocationChanged:
	{
		requestNewWeather ();
		requestWeatherForecast ();
	}

	onForecastDaysCountChanged: requestWeatherForecast ();

	onWeatherDataChanged:
		if (showForecastWindow)
			forecastWindow.weatherData = rootRect.weatherData
	onWeatherForecastDataChanged:
		if (showForecastWindow)
			forecastWindow.weatherForecastData = rootRect.weatherForecastData
	onIconIDChanged:
		if (showForecastWindow)
			forecastWindow.icon = Utils.getImage (rootRect.iconID, useSystemIconSet)

	Connections
	{
		id: closeRequestConnnection;
		ignoreUnknownSignals: true
		onForecastWindowClosed: showForecastWindow = !showForecastWindow
	}
	onForecastWindowChanged:
		if (showForecastWindow && rootRect.forecastWindow)
			closeRequestConnnection.target = rootRect.forecastWindow

}
