import QtQuick 1.1
import org.LC.common 1.0
import "Utils.js" as Utils

Flipable
{
	id: flipable

	property int sideMargin: 5

	property bool flipped: false
	property url icon
	property bool scaleImage: true
	property bool locationSelected: false
	property bool moreInfoShown: false

	property alias location: frontRectangle.location
	property alias weatherTemperature: frontRectangle.weatherTemperature
	property alias description: frontRectangle.description
	property alias temeperatureLimits: frontRectangle.temeperatureLimits

	width: Math.max (frontRectangle.getWidth (), backRectangle.getWidth ())

	signal showDetailedInfo (bool show)

	front: MainWeatherInfoRectangle
	{
		id: frontRectangle
		anchors.fill: parent
		weatherIcon: icon;

		onShowDetailedInfo: flipable.showDetailedInfo (show)
	}

	back: SearchLocationRectangle
	{
		id: backRectangle
		anchors.fill: parent
	}

	transform: Rotation
	{
		id: rotation
		origin.x: flipable.width / 2
		origin.y: flipable.height / 2
		axis.x: 1;
		axis.y: 0;
		axis.z: 0
		angle: 0
	 }

	states: State
	{
		name: "back"
		PropertyChanges { target: rotation; angle: 180 }
		when: flipable.flipped
	}

	transitions: Transition
	{
		NumberAnimation { target: rotation; property: "angle"; duration: 500 }
	}
}
