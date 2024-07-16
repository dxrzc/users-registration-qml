import QtQuick

Rectangle{
    property bool mouseAreaEnabled: true;
    property color buttonColor;
    property color buttonHoveredColor;
    property color textColor;
    property color textHoveredColor:textColor;
    property string buttonText;
    property real buttonTextSize;
    property string datafromInput;
    signal clickbutton;

    color: buttonColor;
    radius:10

    ColorAnimation on color {
        id: changeColorAnimation
        running: false;
        to: mouseArea.containsMouse ? buttonColor : buttonHoveredColor;
        duration: 200
    }

    Text{
        anchors.centerIn: parent
        color: parent.textColor
        text: parent.buttonText;
        font.pixelSize: parent.buttonTextSize
    }

    MouseArea{
        id:mouseArea
        hoverEnabled: true
        enabled: parent.mouseAreaEnabled
        anchors.fill: parent
        cursorShape: mouseAreaEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: clickbutton();
        onContainsMouseChanged: changeColorAnimation.running = true;
    }
}


