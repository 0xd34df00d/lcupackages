import QtQuick 1.1
import "Utils.js" as Utils

Rectangle
{
	id: rootRect

	property variant weatherInfo;

	property alias movementToValue: animateMovement.to
	property alias movementDuration: animateMovement.duration

	property alias opacityFromValue: animateOpacity.from
	property alias opacityToValue: animateOpacity.to
	property alias opacityDuration: animateOpacity.duration

	opacity: 0.0

	function show ()
	{
		animateMovement.start ()
		animateOpacity.start ()
	}

	function hide ()
	{
		animateMovement.start ()
		animateOpacity.start ()
	}

	gradient: Gradient
	{
		GradientStop
		{
			position: 0
			color: colorProxy.color_TextView_TopColor
		}
		GradientStop
		{
			position: 1
			color: colorProxy.color_TextView_BottomColor
		}
	}

	Text
	{
		id: pressureText
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.margins: 5
		horizontalAlignment: Text.AlignHCenter | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor
		text:
			  ((typeof (weatherInfo) == "undefined") || isNaN (weatherInfo ["main"]["pressure"])) ?
				qsTr ("Pressure: N/A") :
				qsTr ("Pressure: ") + Utils.getPressureString (weatherInfo ["main"]["pressure"], PressureUnit)
	}

	Text
	{
		id: humidityText
		anchors.left: parent.left
		anchors.leftMargin: 5
		anchors.right: parent.right
		anchors.rightMargin: 5
		anchors.top: pressureText.bottom
		anchors.topMargin: 10
		horizontalAlignment: Text.AlignHCenter | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor
		text:
			((typeof (weatherInfo) == "undefined") || isNaN (weatherInfo["main"]["humidity"])) ?
				qsTr ("Humidity: N/A") :
				qsTr ("Humidity: ") + weatherInfo ["main"]["humidity"] + "%"
	}

	Text
	{
		id: windText
		anchors.left: parent.left
		anchors.leftMargin: 5
		anchors.right: parent.right
		anchors.rightMargin: 5
		anchors.top: humidityText.bottom
		anchors.topMargin: 10
		horizontalAlignment: Text.AlignHCenter | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor
		wrapMode: Text.WordWrap

		property bool isGustExists: (typeof (weatherInfo) != undefined) &&
				!isNaN (weatherInfo ["wind"]["gust"]) && (weatherInfo ["wind"]["gust"] !== 0)

		text:
			((typeof (weatherInfo) == "undefined") || isNaN (weatherInfo ["wind"]["speed"])) ?
				qsTr ("N/A") :
				qsTr ("Wind speed: ") + Utils.getWindSpeed (weatherInfo ["wind"]["speed"], WindSpeedUnit) +
					(isGustExists ?
							qsTr (" with wind gusts up to ") +
									Utils.getWindSpeed (weatherInfo ["wind"]["gust"], WindSpeedUnit) :
							"")
	}

	Text
	{
		id: sunriseText
		anchors.left: parent.left
		anchors.leftMargin: 5
		anchors.right: parent.right
		anchors.rightMargin: 5
		anchors.top: windText.bottom
		anchors.topMargin: 10
		horizontalAlignment: Text.AlignHCenter | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor
		wrapMode: Text.WordWrap

		text:
			((typeof (weatherInfo) == "undefined") ||
					isNaN (weatherInfo ["sys"]["sunrise"])) ?
				qsTr ("Sunrise: N/A") :
				qsTr ("Sunrise: ") + new Date (weatherInfo ["sys"]["sunrise"] * 1000).toLocaleTimeString ();
	}

	Text
	{
		id: sunsetText
		anchors.left: parent.left
		anchors.leftMargin: 5
		anchors.right: parent.right
		anchors.rightMargin: 5
		anchors.top: sunriseText.bottom
		anchors.topMargin: 10
		horizontalAlignment: Text.AlignHCenter | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor
		wrapMode: Text.WordWrap

		text:
			((typeof (weatherInfo) == "undefined") ||
					isNaN (weatherInfo ["sys"]["sunset"])) ?
				qsTr ("Sunset: N/A") :
				qsTr ("Sunset: ") + new Date (weatherInfo ["sys"]["sunset"] * 1000).toLocaleTimeString ();
	}


	PropertyAnimation
	{
		id: animateMovement;
		target: detailedInfoRect;
		properties: "y";
	}

	NumberAnimation
	{
		id: animateOpacity
		target: detailedInfoRect
		properties: "opacity"
	}
}

