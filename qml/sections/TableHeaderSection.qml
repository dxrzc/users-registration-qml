import QtQuick

import "../js/globals.js" as Globals

Rectangle{
    id: headerContainer

    Row{
        anchors.fill: parent
        property color firstcolor : '#bfbfbf';
        property color secondcolor: '#b3b3b3'

        Rectangle{
            width:parent.width*Globals.usernameSizePercentage
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Username'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*Globals.emailSizePercentage
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Email'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*Globals.phoneNumberSizePercentage
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Phone number'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*Globals.birthdateSizePercentage
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Birth date'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*Globals.editUserSizePercentage
            height: parent.height
            color: parent.firstcolor

            Text {
                text: '..'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }
    }

}
