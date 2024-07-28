import QtQuick
import QtQuick.Controls
import "../js/global/settings.js" as GlobalSettings
import "../js/helpers/get-data-from-url.helper.js" as UrlData
import "../components"

Rectangle {
    id: base
    color:'#40000000'
    radius:5

    function defaultButtonStyle(){
        connectButton.mouseAreaEnabled = false;
        connectButton.buttonColor= 'gray';
        connectButton.buttonText = 'Connect';
    }

    function invalidUrlButtonStyle(){
        connectButton.mouseAreaEnabled= false;
        connectButton.buttonText = 'Invalid URL';
        connectButton.buttonColor= '#EE4E4E';
    }

    function validUrlButtonStyle(){
        connectButton.mouseAreaEnabled = true;
        connectButton.buttonHoveredColor= GlobalSettings.globalHoveredButtonColor;
        connectButton.buttonColor= GlobalSettings.globalButtonColor;
        connectButton.buttonText = 'Connect';
    }

    function validateUrl(){
        if(textField.text === '')
            defaultButtonStyle();
        else
            if(UrlData.validateUrl(textField.text))
                validUrlButtonStyle()
            else invalidUrlButtonStyle();
    }

    function connectIfButtonIsAvailable()
    {
        if(connectButton.mouseAreaEnabled)
            connect(UrlData.getOptions(textField.text));
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

                    onTextChanged: validateUrl();
                    onAccepted: connectIfButtonIsAvailable();
                }
            }

            Item{
                width:parent.width
                height:parent.height*0.4

                Button{
                    id: connectButton
                    anchors.centerIn: parent
                    width:parent.width*0.9
                    height:parent.height*0.7
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    textColor: 'white'
                    Component.onCompleted: defaultButtonStyle();
                    onClickbutton: connect(UrlData.getOptions(textField.text));
                }
            }
        }
    }
}
