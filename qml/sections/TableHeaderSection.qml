import QtQuick
import "../js/global/settings.js" as GlobalSettings

Rectangle{
    id: headerContainer

    Row{
        anchors.fill: parent
        property color firstcolor : '#bfbfbf';
        property color secondcolor: '#b3b3b3'

        Rectangle{
            width:parent.width*GlobalSettings.usernameSizePercentage
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Username'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*GlobalSettings.emailSizePercentage
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Email'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*GlobalSettings.phoneNumberSizePercentage
            height: parent.height
            color: parent.firstcolor

            Text {
                text: 'Phone number'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*GlobalSettings.birthdateSizePercentage
            height: parent.height
            color: parent.secondcolor

            Text {
                text: 'Birth date'
                anchors.centerIn: parent
                font.pixelSize: Math.min(parent.width,parent.height)*0.4
            }
        }

        Rectangle{
            width:parent.width*GlobalSettings.editUserSizePercentage
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
