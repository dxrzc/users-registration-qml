import QtQuick

Item
{
    id: base
    property string imagepath;
    property bool resizeable: false;
    signal clickButton;

    property bool entered;

    Image{
        fillMode: Image.PreserveAspectFit;
        anchors.centerIn: parent
        source: imagepath;

        width: {
            if(resizeable)
                if(entered)
                    parent.width;
                else
                    parent.width*0.9;
            else
                parent.width;
        }

        height: {
            if(resizeable)
                if(entered)
                    parent.height;
                else
                    parent.height*0.9;
            else
                parent.height;
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent;
        hoverEnabled: true;
        cursorShape: Qt.PointingHandCursor;
        onClicked: clickButton();
        onEntered: base.entered = true;
        onExited: base.entered = false;
    }
}
