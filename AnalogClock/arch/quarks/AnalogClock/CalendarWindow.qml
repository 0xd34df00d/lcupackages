import QtQuick 1.1
import org.LC.common 1.0
import "."

Rectangle {
    id: rootRect

    property int sideMargin: 5
    width: childrenRect.width + sideMargin
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

    ClockItem {
        id: clockItem

        anchors.top: parent.top
        anchors.topMargin: rootRect.sideMargin
        anchors.left: parent.left
        anchors.leftMargin: rootRect.sideMargin

        width: 192
        height: 192
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

    Rectangle {
        id: calendarRect

        width: Math.max(numbersView.width, todayLabel.width) + sideMargin * 4 + 2 * prevMonthButton.width
        height: childrenRect.height

        color: "transparent"

        anchors.top: parent.top
        anchors.left: clockItem.right
        anchors.leftMargin: rootRect.sideMargin

        ActionButton {
            id: prevMonthButton

            width: 24
            height: 24

            actionIconURL: "image://ThemeIcons/go-previous"

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            onTriggered: {
                var date = new Date(today);
                date.setMonth(date.getMonth() - 1);
                today = date;
            }
        }

        ActionButton {
            id: nextMonthButton

            width: 24
            height: 24

            actionIconURL: "image://ThemeIcons/go-previous"

            anchors.left: mainCalendarColumn.right
            anchors.leftMargin: rootRect.sideMargin
            anchors.verticalCenter: parent.verticalCenter

            onTriggered: {
                var date = new Date(today);
                date.setMonth(date.getMonth() + 1);
                today = date;
            }
        }

        Column {
            id: mainCalendarColumn
            anchors.left: prevMonthButton.right
            anchors.leftMargin: rootRect.sideMargin

            Text {
                id: todayLabel

                anchors.horizontalCenter: parent.horizontalCenter

                color: colorProxy.color_TextView_TitleTextColor
                text: Qt.formatDate(today, Qt.DefaultLocaleLongDate) == Qt.formatDate(new Date(), Qt.DefaultLocaleLongDate) ?
                        Qt.formatDate(today, Qt.DefaultLocaleLongDate) :
                        Qt.formatDate(today, "MMMM yyyy")
                font.underline: true
            }

            ListView {
                id: dayNamesView

                width: numbersView.width
                height: numbersView.cellHeight
                anchors.horizontalCenter: parent.horizontalCenter

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

                anchors.horizontalCenter: parent.horizontalCenter
                width: numDays * cellWidth
                height: numWeeks * cellHeight

                cellWidth: 30
                cellHeight: 20
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
    }
}
