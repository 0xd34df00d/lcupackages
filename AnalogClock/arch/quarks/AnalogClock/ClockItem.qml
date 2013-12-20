import QtQuick 1.1
import org.LC.common 1.0

Rectangle {
    id: clock

    color: "transparent"

    property date date: new Date()
    property int hours: date.getHours()
    property int minutes: date.getMinutes()
    property int seconds: date.getSeconds()
    property string prefix: (hours < 7 || hours >= 19) ? "night" : "day"

    function timeChanged() {
        date = new Date();
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
        sourceSize.width: clock.width
        sourceSize.height: clock.height
    }

    Image {
        source: "images/" + prefix + "/hour.svg"
        anchors.fill: clock
        sourceSize.width: clock.width
        sourceSize.height: clock.height
        smooth: true

        transform: Rotation {
            origin.x: clock.width / 2
            origin.y: clock.height / 2
            angle: (clock.hours * 30) + (clock.minutes * 0.5)
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        source: "images/" + prefix + "/minute.svg"
        anchors.fill: clock
        sourceSize.width: clock.width
        sourceSize.height: clock.height
        smooth: true

        transform: Rotation {
            origin.x: clock.width / 2
            origin.y: clock.height / 2
            angle: clock.minutes * 6
            Behavior on angle {
                SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
            }
        }
    }

    Image {
        source: "images/" + prefix + "/second.svg"
        anchors.fill: clock
        sourceSize.width: clock.width
        sourceSize.height: clock.height
        smooth: true

        transform: Rotation {
            origin.x: clock.width / 2
            origin.y: clock.height / 2
            angle: clock.seconds * 6
            Behavior on angle {
                SpringAnimation { spring: 3; damping: 0.2; modulus: 360 }
            }
        }
    }
}
