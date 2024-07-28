import QtQuick
import "../js/global/settings.js" as GlobalSettings
import "../components"

Item{
    id: base
    property string message;
    signal retryClicked;

    function retryButtonClicked(){
        errorImageSequentialAnimation.running = true;
        retryClicked()
    }

    Column{
        id: error_view_column
        anchors.fill: parent

        Rectangle{ // 65%
            id: error_image_container
            antialiasing: true
            color: "#00000000"
            width:base.width
            height:base.height*0.65

            Image{
                id: errorImage
                source: '../imgs/error.png'
                height:parent.height*0.9
                fillMode:Image.PreserveAspectFit
                anchors.centerIn: parent
                SequentialAnimation {
                    id: errorImageSequentialAnimation
                    NumberAnimation { target: errorImage; property: "height"; to: error_image_container.height; duration: 100 }
                    NumberAnimation { target: errorImage; property: "height"; to: error_image_container.height*0.9; duration: 100}
                }
            }
        }

        Rectangle{ // 20%
            id: error_text_container
            color: "#00000000"
            width:base.width
            height:base.height*0.2

            Text {
                anchors.centerIn: parent
                color:'white'
                font.pixelSize: Math.min(parent.width,parent.height)*0.25
                text: base.message.toUpperCase();
            }
        }

        Item{ // 15%
            id: error_retrybutton_container
            width:base.width
            height:base.height*0.15

            MouseArea{
                id: testMouseArea
                anchors.fill: parent
            }

            Row{
                anchors.fill: parent
                spacing:width*0.02

                Button{
                    id: retrybutton
                    width:parent.width*0.49
                    height: parent.height
                    buttonColor: 'gray'
                    buttonHoveredColor: '#6c6c6c'
                    textColor: 'white'
                    buttonText: 'Retry connection'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    onClickbutton: retryButtonClicked();

                }

                Button{
                    width:parent.width*0.49
                    height: parent.height
                    mouseAreaEnabled: true
                    buttonColor: GlobalSettings.globalButtonColor
                    buttonHoveredColor: GlobalSettings.globalHoveredButtonColor
                    textColor: 'white'
                    buttonText: 'Insert a new URL'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    onClickbutton: setInsertDbUrlView();
                }
            }
        }
    }
}
