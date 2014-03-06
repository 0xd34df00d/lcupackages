import QtQuick 1.1
import org.LC.common 1.0
import "Utils.js" as Utils

Rectangle
{
	id: rootRect

	property int sideMargin: 5
	property alias location: locationText.text
	property alias weatherTemperature: weatherTempText.text
	property alias description: descriptionText.text
	property alias temeperatureLimits: temperatureLimitsText.text
	property url weatherIcon

	signal showDetailedInfo (bool show);

	function getWidth ()
	{
		var topTextWidth = locationText.paintedWidth + rootRect.sideMargin + weatherTempText.paintedWidth;
		var bottomTextWidth = descriptionText.paintedWidth + rootRect.sideMargin + temperatureLimitsText.paintedWidth;
		var maxWidth = Math.max (topTextWidth, bottomTextWidth);
		return rootRect.sideMargin + weatherImage.width + rootRect.sideMargin +
				maxWidth + rootRect.sideMargin + configureImage.width +
				rootRect.sideMargin;
	}

	gradient: Gradient
	{
		GradientStop
		{
			position: 0
			color: colorProxy.color_TextBox_TopColor
		}
		GradientStop
		{
			position: 1
			color: colorProxy.color_TextBox_BottomColor
		}
	}


	property bool isHovered: frontRectMouseArea.containsMouse ||
			weatherImageMouseArea.containsMouse ||
			locationTextMouseArea.containsMouse ||
			weatherTempMouseArea.containsMouse ||
			configureImage.isHovered ||
			moreInfo.isHovered ||
			descriptionTextMouseArea.containsMouse ||
			temperatureLimitsTextMouseArea.containsMouse

	Image
	{
		id: weatherImage

		width: 64
		anchors.left: parent.left
		anchors.leftMargin: rootRect.sideMargin
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 3
		anchors.top: parent.top
		anchors.topMargin: 3

		fillMode: Image.PreserveAspectFit

		smooth: true
		source: scaleImage ? (weatherIcon + '/' + width) : icon

		MouseArea
		{
			id: weatherImageMouseArea
			anchors.fill: parent
			hoverEnabled: true
		}
	}

	Text
	{
		id: locationText

		anchors.left: weatherImage.right
		anchors.leftMargin: rootRect.sideMargin
		anchors.top: parent.top
		anchors.topMargin: 3

		font.pixelSize: 22
		font.bold: true
		horizontalAlignment: Text.AlignLeft | Text.AlignVCenter

		color: colorProxy.color_TextBox_TitleTextColor


		MouseArea
		{
			id: locationTextMouseArea
			anchors.fill: parent
			hoverEnabled: true

			ToolTip
			{
				anchors.fill: parent
				text: qsTr ("Location")
			}
		}
	}

	Text
	{
		id: weatherTempText

		anchors.top: parent.top
		anchors.topMargin: 3
		anchors.right: rootRect.isHovered ? configureImage.left : parent.right
		anchors.rightMargin: rootRect.sideMargin

		font.pixelSize: 22
		font.bold: true
		horizontalAlignment: Text.AlignRight | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor

		MouseArea
		{
			id: weatherTempMouseArea
			anchors.fill: parent
			hoverEnabled: true

			ToolTip
			{
				anchors.fill: parent
				text: qsTr ("Temperature")
			}
		}
	}

	ActionButton
	{
		id: configureImage

		anchors.top: parent.top
		anchors.topMargin: 3
		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin

		visible: rootRect.isHovered

		width: 24
		height: width

		actionIconURL: "image://ThemeIcons/configure"
		textTooltip: qsTr ("Configure location")

		onTriggered: flipped = !flipped
	}

	ActionButton
	{
		id: moreInfo

		anchors.top: configureImage.bottom
		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin

		width: 24
		height: width

		actionIconURL: moreInfoShown ?
				"image://ThemeIcons/arrow-up-double" :
				"image://ThemeIcons/arrow-down-double"
		textTooltip: moreInfoShown ?
				qsTr ("Show weather forecast") :
				qsTr ("Show more info...")

		visible: rootRect.isHovered

		onTriggered:
		{
			rootRect.showDetailedInfo (!moreInfoShown)
			moreInfoShown = !moreInfoShown
		}
	}

	Text
	{
		id: descriptionText

		anchors.left: weatherImage.right
		anchors.leftMargin: rootRect.sideMargin
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 3
		horizontalAlignment: Text.AlignLeft | Text.AlignVCenter
		elide: Text.ElideRight

		color: colorProxy.color_TextBox_TextColor

		MouseArea
		{
			id: descriptionTextMouseArea
			anchors.fill: parent
			hoverEnabled: true

			ToolTip
			{
				anchors.fill: parent
				text: qsTr ("Description")
			}
		}
	}

	Text
	{
		id: temperatureLimitsText

		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 3
		horizontalAlignment: Text.AlignRight | Text.AlignVCenter

		color: colorProxy.color_TextBox_TextColor

		MouseArea
		{
			id: temperatureLimitsTextMouseArea
			anchors.fill: parent
			hoverEnabled: true
			ToolTip
			{
				anchors.fill: parent
				text: qsTr ("Highest and lowest temperature of the day")
			}
		}
	}

	MouseArea
	{
		id: frontRectMouseArea
		anchors.fill: parent
		hoverEnabled: true
		z: -2
	}
}
