import QtQuick 1.1

Rectangle
{
	id: rootRect

	property int sideMargin: 14
	property url icon: weatherIcon
	property string location: weatherLocation
	property string weather: weatherInfo
	property bool scaleImage: weatherScaleImage

	height: 92
	width: sideMargin + weatherImage.width +
		   sideMargin + Math.max (locationText.paintedWidth, weatherText.paintedWidth) +
		   sideMargin

	smooth: true
	radius: 5

	gradient: Gradient {
		GradientStop {
			position: 0
			color: colorProxy.color_TextView_TopColor
		}
		GradientStop {
			position: 1
			color: colorProxy.color_TextView_BottomColor
		}
	}

	signal closeRequested()

	Image
	{
		id: weatherImage

		width: 64
		anchors.left: parent.left
		anchors.leftMargin: rootRect.sideMargin
		anchors.bottom: parent.bottom
		anchors.bottomMargin: rootRect.sideMargin
		anchors.top: parent.top
		anchors.topMargin: rootRect.sideMargin

		fillMode: Image.PreserveAspectFit

		smooth: true
		source: scaleImage ? (icon + '/' + width) : icon
	}

	Text
	{
		id: locationText

		anchors.left: weatherImage.right
		anchors.leftMargin: rootRect.sideMargin
		anchors.top: parent.top
		anchors.topMargin: 24
		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin

		font.pixelSize: 12
		font.bold: true
		horizontalAlignment: Text.AlignHCenter

		color: colorProxy.color_TextBox_TitleTextColor
		text: location
	}

	Text
	{
		id: weatherText

		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin
		anchors.left: weatherImage.right
		anchors.leftMargin: rootRect.sideMargin
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 24

		font.pixelSize: 12
		horizontalAlignment: Text.AlignHCenter

		color: colorProxy.color_TextBox_TextColor
		text: weather
	}
}
