import QtQuick 1.1
import org.LC.common 1.0

Rectangle
{
	id: rootRect

	property int sideMargin: 5

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

	function getWidth ()
	{
		return rootRect.sideMargin + locationInputContainer.width +
				rootRect.sideMargin + searchButton.width + rootRect.sideMargin;
	}

	function parseLocationOutput (output)
	{
		variantsModel.clear ();
		var count = output ["count"];
		for (var i = 0; i < count; ++i)
		{
			var variant = output ["list"][i];
			variantsModel.append ({ "location": variant ["name"] +
					"," + variant ["sys"]["country"] });
		}
		locationInput.text = variantsModel.get (0).location;
		variantsView.visible = true;
		variantsView.forceActiveFocus ()
	}

	function searchLocation (location)
	{
		if (locationInput.text == "")
			return;

		variantsView.visible = false;
		var request = new XMLHttpRequest ();
		request.onreadystatechange = function ()
		{
			if (request.readyState == XMLHttpRequest.DONE)
				if (request.status == 200)
					parseLocationOutput (JSON.parse (request.responseText));
				else
					console.log ("HTTP request failed", request.status);
		}
		request.open ("GET", "http://api.openweathermap.org/data/2.5/find?type=like&q=" + location);
		request.send ();
	}

	Rectangle
	{
		id: locationInputContainer

		anchors.left: parent.left
		anchors.leftMargin: rootRect.sideMargin
		anchors.top: parent.top
		anchors.topMargin: rootRect.sideMargin
		anchors.right: searchButton.left
		anchors.rightMargin: rootRect.sideMargin

		border.width: 1
		height: 22
		radius: 3

		color: colorProxy.color_Panel_TopColor

		TextInput
		{
			id: locationInput
			anchors.left: locationInputContainer.left
			anchors.right: locationInputContainer.right
			anchors.verticalCenter: locationInputContainer.verticalCenter
			anchors.margins: 3
			font.pointSize: 10
			color: colorProxy.color_Panel_TextColor
			focus: true

			selectByMouse: true

			Keys.onReturnPressed: rootRect.searchLocation(text);

			onTextChanged:
			if (text == "")
				locationSelected = false;
		}
	}

	ActionButton
	{
		id: searchButton
		anchors.top: parent.top
		anchors.topMargin: rootRect.sideMargin
		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin

		width: 24
		height: width
		actionIconURL: "image://ThemeIcons/edit-find"
		textTooltip: qsTr ("Search location")

		onTriggered:
		{
			locationSelected = false;
			rootRect.searchLocation(locationInput.text)
		}
	}

	ListModel
	{
		id: variantsModel
	}

	Component
	{
		id: variantDelegate

		Rectangle
		{
			id: wrapper;
			width: locationInputContainer.width;
			height: 20
			radius: 2
			border.width: 1
			border.color: colorProxy.color_ToolButton_BorderColor

			gradient: Gradient
			{
				GradientStop
				{
					position: 0
					color: colorProxy.color_ToolButton_TopColor
				}
				GradientStop
				{
					position: 1
					color: colorProxy.color_ToolButton_BottomColor
				}
			}

			function selectItem (index)
			{
				variantsView.currentIndex = index;
				locationInput.text = variantsModel.get (index).location
				variantsView.visible = false
				locationSelected = true;
			}

			Text
			{
				anchors.left: parent.left
				anchors.leftMargin: 3
				anchors.right: parent.right
				anchors.rightMargin: 3
				anchors.verticalCenter: parent.verticalCenter

				text: location;
				color: colorProxy.color_ToolButton_TextColor
			}

			MouseArea
			{
				id: itemMouseArea
				anchors.fill: parent;
				hoverEnabled: true;

				onEntered: variantsView.currentIndex = index;
				onClicked: selectItem (index)
			}

			Keys.onReturnPressed: selectItem (index)
		}
	}

	Component
	{
		id: highlight

		Rectangle
		{
			gradient: Gradient
			{
				GradientStop
				{
					position: 0
					color: colorProxy.color_ToolButton_HoveredTopColor
				}
				GradientStop
				{
					position: 1
					color: colorProxy.color_ToolButton_HoveredBottomColor
				}
			}

			width: variantsView.width - 1
			height: 20
			border.color: colorProxy.color_ToolButton_HoveredBorderColor
			radius: 2
			opacity: 0.5
			z: 10
		}
	}

	ListView
	{
		id: variantsView

		anchors.left: locationInputContainer.left
		anchors.right: locationInputContainer.right
		anchors.top: locationInputContainer.bottom
		height: (variantsModel.count > 5) ? 100 : (variantsModel.count + 1) * 20
		clip: true
		focus: true
		visible: false

		z: 5

		model: variantsModel
		delegate: variantDelegate
		highlight: highlight

		Keys.onEscapePressed: visible = false

		onVisibleChanged:
			if (!visible)
				locationInput.forceActiveFocus ()
	}


	ActionButton
	{
		id: saveButton
		anchors.bottom: parent.bottom
		anchors.bottomMargin: rootRect.sideMargin
		anchors.right: cancelButton.left
		anchors.rightMargin: rootRect.sideMargin

		width: 24
		height: width
		actionIconURL: "image://ThemeIcons/dialog-ok-apply"
		textTooltip: qsTr ("Save")

		visible: locationSelected
		onTriggered:
		{
			Meteor_Settings.setSettingsValue ("Location", locationInput.text)

			flipped = !flipped
			variantsModel.clear ()
			variantsView.visible = false
			locationInput.text = ""
		}

	}

	ActionButton
	{
		id: cancelButton
		anchors.bottom: parent.bottom
		anchors.bottomMargin: rootRect.sideMargin
		anchors.right: parent.right
		anchors.rightMargin: rootRect.sideMargin

		width: 24
		height: width
		actionIconURL: "image://ThemeIcons/dialog-cancel"
		textTooltip: qsTr ("Cancel")

		onTriggered:
		{
			flipped = !flipped
			variantsModel.clear ()
			variantsView.visible = false
			locationInput.text = ""
		}
	}

	MouseArea
	{
		anchors.fill: parent;
		z: -1
		onClicked:
			if (variantsView.visible)
				variantsView.visible = false;
	}
}
