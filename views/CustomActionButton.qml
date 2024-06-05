import QtQuick

Rectangle
{
    property string imagepath;
    signal clickButton;

    Image{
        fillMode: Image.PreserveAspectFit;
        anchors.fill: parent;
        source: imagepath;
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent;
        hoverEnabled: true;
        cursorShape: Qt.PointingHandCursor;
        onClicked: clickButton();
    }
}
