import QtQuick 1.1
import org.LC.common 1.0
import "."

Rectangle {
    id: rootRect

    property int sideMargin: 5

    width: childrenRect.width + 2 * sideMargin
    height: childrenRect.height + 2 * sideMargin

    smooth: true
    radius: 5
    signal closeRequested()

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

    ClockItem {
        id: clockItem

        anchors.top: parent.top
        anchors.topMargin: rootRect.sideMargin
        anchors.left: parent.left
        anchors.leftMargin: rootRect.sideMargin

        width: 192
        height: 192
    }

    Text {
        id: formattedDate

        anchors.top: clockItem.bottom
        anchors.horizontalCenter: clockItem.horizontalCenter

        color: colorProxy.color_TextView_TitleTextColor

        text: Qt.formatTime(clockItem.date, "hh:mm:ss")
    }
}
