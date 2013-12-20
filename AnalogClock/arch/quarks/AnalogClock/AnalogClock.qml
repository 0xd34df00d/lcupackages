import QtQuick 1.1
import org.LC.common 1.0
import "."

ClockItem
{
    id: clock

    implicitWidth: parent.quarkBaseSize
    implicitHeight: parent.quarkBaseSize

    property variant tooltipWindow: null
    property bool isClockItem: false

    TimedHoverArea
    {
        anchors.fill: parent
        hoverEnabled:  true

        hoverInTimeout: commonHoverInTimeout

        onHoverInTimedOut:
        {
            if (tooltipWindow)
                return;

            var global = commonJS.getTooltipPos(clock);
            var params =
            {
                x: global.x,
                y: global.y,
                existing: "toggle"
            };
            tooltipWindow = quarkProxy.openWindow(sourceURL, "ClockWindow.qml", params);
            isClockItem = true;
        }
        onAreaExited:
        {
            if (!tooltipWindow || !isClockItem)
                return;

            tooltipWindow.closeRequested();
            tooltipWindow = null;
            isClockItem = false;
        }

        onReleased: {
            var shouldOpen = isClockItem || !tooltipWindow;
            if (tooltipWindow)
            {
                tooltipWindow.closeRequested();
                tooltipWindow = null;

                isClockItem = false;
            }

            if (shouldOpen)
            {
                {
                    var global = commonJS.getTooltipPos(clock);
                    var params =
                    {
                        x: global.x,
                        y: global.y
                    };
                    tooltipWindow = quarkProxy.openWindow(sourceURL, "CalendarWindow.qml", params);
                }
            }
        }
    }
}
