import QtQuick
import QtQuick.Controls

Rectangle {

    id: base
    color:'#40000000'
    radius:5

    Item{
        width:parent.width*0.9
        height:parent.height*0.35
        anchors.centerIn: parent

        Column{
            anchors.fill: parent

            Item{
                width:parent.width
                height:parent.height*0.2

                Text {
                    id: name
                    text: qsTr("Insert your PostgresURL")
                    color:'white'
                    anchors.centerIn: parent
                    font.pixelSize: Math.min(parent.width,parent.height)*0.6
                }
            }

            Item{
                width:parent.width
                height:parent.height*0.4

                TextField{
                    id: textField
                    width:parent.width*0.9
                    height:parent.height*0.7
                    anchors.centerIn: parent
                    font.pixelSize: Math.min(parent.width,parent.height)*0.18
                    color: 'black'
                    background: Rectangle{
                        color:'white'
                        border.width: 1
                        radius:5
                    }
                }
            }

            Item{
                width:parent.width
                height:parent.height*0.4

                MyButton{
                    anchors.centerIn: parent
                    width:parent.width*0.9
                    height:parent.height*0.7
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    buttonColor: '#1FAB89'
                    buttonHoveredColor: '#57CC99'
                    textColor: 'black'
                    buttonText: 'Connect'
                    pointingHandCursor: true
                    onClickbutton: function(){
                        console.log(textField.text);
                    }
                }
            }
        }
    }
}
