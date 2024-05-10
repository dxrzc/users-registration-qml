import QtQuick

Rectangle{
    id: headerContainer

    Row{
        anchors.fill: parent
        property color firstcolor : '#bfbfbf';
        property color secondcolor: '#b3b3b3'

        Rectangle{
            width:parent.width/4
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Username'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width/4
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Email'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width/4
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Phone number'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width/4
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Birth date'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }
    }

}
