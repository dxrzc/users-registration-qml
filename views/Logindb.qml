import QtQuick
import QtQuick.Controls

import 'js/splitOptions.js' as GetOptions;

Rectangle {
    id: base
    color:'#40000000'
    radius:5

    function defaultButtonStyle(){
        connectButton.mouseAreaEnabled = false;
        connectButton.pointingHandCursor = false;
        connectButton.buttonColor= 'gray';
        connectButton.buttonText = 'Connect';
    }

    function invalidUrlButtonStyle(){
        connectButton.mouseAreaEnabled= false;
        connectButton.pointingHandCursor = false;
        connectButton.buttonText = 'Invalid URL';
        connectButton.buttonColor= '#EE4E4E';
    }

    function validUrlButtonStyle(){
        connectButton.mouseAreaEnabled = true;
        connectButton.pointingHandCursor = true;
        connectButton.buttonHoveredColor= '#57CC99';
        connectButton.buttonColor= '#1FAB89';
        connectButton.buttonText = 'Connect';
    }

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
                    width: parent.width*0.9
                    height:parent.height*0.7
                    anchors.centerIn: parent
                    font.pixelSize: Math.min(parent.width,parent.height)*0.18
                    placeholderText: 'postgresql://user:password@host:port/dbname'
                    placeholderTextColor: 'gray';
                    color: 'black'

                    background: Rectangle{
                        color:'white'
                        border.width: 1
                        radius:5
                    }

                    onTextChanged: {
                        if(textField.text === '')
                            defaultButtonStyle();
                        else
                            (GetOptions.validateUrl(textField.text)) ?  validUrlButtonStyle() : invalidUrlButtonStyle();
                    }
                }
            }

            Item{
                width:parent.width
                height:parent.height*0.4

                MyButton{
                    id: connectButton
                    anchors.centerIn: parent
                    width:parent.width*0.9
                    height:parent.height*0.7
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    textColor: 'black'

                    Component.onCompleted: defaultButtonStyle();

                    onClickbutton: {
                        const options = GetOptions.getOptions(textField.text);
                        QmlDto.connectDB(options[0],options[1],options[2],options[3],options[4]);
                        components_container.visible = true;
                        logindb.visible = false;
                        main_window.reloadTable();
                    }
                }
            }
        }
    }
}
