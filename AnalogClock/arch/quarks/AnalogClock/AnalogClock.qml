import QtQuick 1.1
import org.LC.common 1.0

Rectangle {
    id: clock

    implicitWidth: parent.quarkBaseSize
    implicitHeight: parent.quarkBaseSize

    color: "transparent"

    property int hours: new Date().getHours()
    property int minutes: new Date().getMinutes()
    property int seconds: new Date().getSeconds()
    property string prefix: (hours < 7 || hours >= 19) ? "night" : "day"

    function timeChanged() {
        var date = new Date
        hours = date.getHours()
        minutes = date.getMinutes()
        seconds = date.getSeconds()
    }

    Common { id: commonJS }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: clock.timeChanged()
    }

    Image {
        source: "images/" + prefix + "/background.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    Image {
        source: "images/" + prefix + "/hour.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        smooth: true

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: (clock.hours * 30) + (clock.minutes * 0.5)
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        source: "images/" + prefix + "/minute.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        smooth: true

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: clock.minutes * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        source: "images/" + prefix + "/second.svg"
        anchors.fill: parent
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        smooth: true

        transform: Rotation {
            origin.x: parent.width / 2
            origin.y: parent.height / 2
            angle: clock.seconds * 6
            Behavior on angle {
                SpringAnimation { spring: 3; damping: 0.2; modulus: 360 }
            }
        }
    }


    MouseArea {
        anchors.fill: parent
        onReleased: {
            var global = commonJS.getTooltipPos(clock);
            var params = {
                x: global.x,
                y: global.y,
                existing: "toggle"
            };
            quarkProxy.openWindow(sourceURL, "CalendarWindow.qml", params);
        }
    }
}
