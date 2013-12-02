import QtQuick 1.1
import org.LC.common 1.0

Rectangle {
    id: rootRect

    property int sideMargin: 5
    width: Math.max(numbersView.width, todayLabel.width) + sideMargin * 2
    height: childrenRect.height

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

    function fixSunday(num) { return num ? num : 7 }

    signal closeRequested()

    property variant today: new Date()
    property int firstDay: fixSunday(new Date(today.getFullYear(), today.getMonth(), 1).getDay()) - 1
    property int lastDay: 32 - new Date(today.getFullYear(), today.getMonth(), 32).getDate()

    function fixDay(index) {
        var num = index + 1 - firstDay;
        return num > 0 && num <= lastDay ? num : 0;
    }

    Text {
        id: todayLabel

        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter

        color: colorProxy.color_TextView_TitleTextColor
        text: Qt.formatDate(today, Qt.DefaultLocaleLongDate)
        font.underline: true
    }

    ListView {
        id: dayNamesView

        anchors.top: todayLabel.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: rootRect.sideMargin

        width: numbersView.width
        height: numbersView.cellHeight

        orientation: ListView.Horizontal
        model: 7
        delegate: Rectangle {
            width: numbersView.cellWidth
            height: numbersView.cellHeight

            color: "transparent"

            Text {
                anchors.fill: parent
                color: colorProxy.color_TextView_Aux2TextColor
                text: Qt.formatDate(new Date(2012, 9, index + 1), "ddd")
            }
        }
    }

    GridView {
        id: numbersView

        property int numDays: 7
        property int numWeeks: 6
        width: numDays * cellWidth
        height: numWeeks * cellHeight
        cellWidth: 30
        cellHeight: 20
        anchors.top: dayNamesView.bottom
        anchors.left: parent.left
        anchors.leftMargin: rootRect.sideMargin
        boundsBehavior: Flickable.StopAtBounds

        model: numDays * numWeeks

        delegate: Rectangle {
            width: numbersView.cellWidth
            height: numbersView.cellHeight

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: dayNum > 0 ? colorProxy.setAlpha(isToday ? colorProxy.color_TextBox_HighlightTopColor : colorProxy.color_TextBox_TopColor, 0.3) : "transparent"
                }
                GradientStop {
                    position: 1
                    color: dayNum > 0 ? colorProxy.setAlpha(isToday ? colorProxy.color_TextBox_HighlightBottomColor : colorProxy.color_TextBox_BottomColor, 0.3) : "transparent"
                }
            }

            border.width: dayNum > 0 ? 1 : 0
            border.color: isToday ? colorProxy.color_TextBox_HighlightBorderColor : colorProxy.color_TextBox_BorderColor

            property int dayNum: fixDay(index)
            property bool isToday: dayNum == today.getDate()

            Text {
                anchors.fill: parent
                anchors.rightMargin: 3
                color: colorProxy.color_TextBox_TextColor
                text: dayNum > 0 ? dayNum : "";
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
