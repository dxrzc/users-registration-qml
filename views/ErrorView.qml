import QtQuick

Item{
    id: base
    property string message;

    function retryConnectionFailed(){
        reconnect_text_container.opacity = 100
        reconnect_text_container.visible = true;
        timer_show_reconnect_message.running = true;
    }

    signal retryClicked;

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
                source: 'imgs/error.png'
                height:parent.height
                fillMode:Image.PreserveAspectFit
                anchors.centerIn: parent
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
                font.pixelSize: Math.min(parent.width,parent.height)*0.3
                text: base.message
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

                CustomButton{
                    id: retrybutton
                    width:parent.width*0.49
                    height: parent.height
                    buttonColor: 'gray'
                    buttonHoveredColor: '#6c6c6c'
                    textColor: 'white'
                    buttonText: 'Retry connection'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    onClickbutton: retryClicked();
                }

                CustomButton{
                    width:parent.width*0.49
                    height: parent.height
                    mouseAreaEnabled: true
                    buttonColor: globalButtonColor
                    buttonHoveredColor: globalHoveredButtonColor
                    textColor: 'white'
                    buttonText: 'Insert a new URL'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.3
                    onClickbutton: setInsertDbUrlView();
                }
            }
        }

        Timer{
            id: timer_show_reconnect_message
            interval: 500
            running: false;
            onTriggered: {
                reconnect_text_container.visible= false;
            }
        }

        Rectangle{
            id: reconnect_text_container
            width: base.width
            height: error_image_container.height*0.2
            visible: false
            color: "#00000000"

            PropertyAnimation {
                id: reconnect_text_container_animation
                duration: 300
                target: reconnect_text_container;
                property: "opacity";
                to: 0
            }

            onVisibleChanged: reconnect_text_container_animation.running = true;

            Text {
                id: reconnect_text
                anchors.centerIn: parent
                color: 'white'
                text: qsTr("Unable to connect")
                font.pixelSize: Math.min(parent.width,parent.height)*0.3
            }
        }
    }
}
