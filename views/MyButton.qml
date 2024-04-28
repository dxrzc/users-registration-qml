import QtQuick

Rectangle{
    property color buttonColor;
    property color buttonHoveredColor;
    property color textColor;
    property color textHoveredColor:textColor;
    property string buttonText;
    property real buttonTextSize;
    property string datafromInput;
    property bool pointingHandCursor: false;
    signal clickbutton;

    color: mouseArea.containsMouse ? buttonHoveredColor : buttonColor
    radius:10

    Text{
        anchors.centerIn: parent
        color: parent.textColor
        text: parent.buttonText;
        font.pixelSize: parent.buttonTextSize
    }

    MouseArea{
        hoverEnabled: true
        id:mouseArea
        anchors.fill: parent
        cursorShape: pointingHandCursor ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            clickbutton();
        }
    }
}


