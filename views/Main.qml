import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Window {

    id:main_window
    color: "#43bfbd"
    visible: true
    width: 1200
    height: 700
    title: "RegistrationApp"
    minimumWidth: 1200
    minimumHeight: 700

    signal reloadTable;
    signal resetTableView;
    signal scrollToLastTableViewRow;

    function setErrorView(message)
    {
        error_view_container.message = message;
        error_view_container.visible = true;
        componets_column.visible = false;
    }

    Connections{
        target: errorhandler
        function onErrorFromDataBase(message)
        {
            setErrorView(message);
        }

        function onInternalError(message)
        {
            setErrorView(message);
        }
    }

    Timer {
        id: scrollToLastTimer
        interval: 100
        onTriggered: scrollToLastTableViewRow();
    }

    Image{
        id: background_image
        anchors.fill: parent
        source: "imgs/background.jpg" // TODO
    }

    MultiEffect{
        id: background_blur
        source: background_image
        anchors.fill: components_container
        blurEnabled: true
        blurMax: 10
        blur: 1.0
    }

    MongoUrlMenu{
        anchors.centerIn: parent
        width:parent.width*0.3
        height: parent.height*0.6
    }

    Rectangle{
        id: components_container
        visible: false
        color: "#50000000"
        width: parent.width*0.85
        height:parent.height*0.90
        anchors.centerIn: parent
        radius:10

        Column{
            id: componets_column
            anchors.left: parent.left
            anchors.leftMargin:(parent.width/2)-(width/2)
            width:parent.width*0.95
            height:parent.height

            Rectangle{
                id: title_container
                color: "#00000000"
                width:parent.width
                height:parent.height* 0.2

                Text{
                    id: title_text
                    color:'white'
                    text: 'Register users'
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Math.min(parent.width,parent.height)/3
                    anchors.centerIn: parent
                }
            }

            Rectangle{
                id: inputs_and_table_container
                color: "#00000000"
                width:parent.width*0.95
                height: parent.height*0.65
                anchors.left: parent.left
                anchors.leftMargin: (parent.width/2)-(width/2)

                Row{
                    id: inputs_and_table_row
                    anchors.fill: parent

                    UserInputSection{
                        id: inputsSection
                        width:(parent.width)/2
                        height:parent.height
                    }

                    Rectangle{
                        id: userstable_container
                        width:(parent.width)/2
                        height:parent.height
                        color:'transparent'
                        clip:true

                        Column{
                            anchors.fill: parent

                            SearchUserSection{
                                color: 'white'
                                id: searchuserSection
                                width: parent.width
                                height: parent.height*0.1
                                radius: 7
                            }

                            Rectangle{
                                id: spacingrec
                                color:'transparent'
                                width: parent.width
                                height: parent.height*0.05
                            }

                            Rectangle{
                                color: 'white'
                                width:parent.width
                                height: parent.height*0.85
                                radius: 7

                                Column{
                                    anchors.fill:parent

                                    Item{
                                        width:parent.width
                                        height: parent.height*0.01
                                    }

                                    TableHeaderSection{
                                        clip:true
                                        id: tableHeaderSection
                                        width: parent.width*0.98
                                        height: parent.height*0.09
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    TableSection{
                                        id: tableSection
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width
                                        height: parent.height*0.9

                                        Connections {
                                            target: main_window
                                            function onReloadTable(){tableSection.reload();}
                                            function onResetTableView(){tableSection.reset();}
                                            function onScrollToLastTableViewRow(){tableSection.scrollToLastRow();}
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        color: "#00000000"
        id: error_view_container
        property string message: "Failed to connect to database";
        visible:false
        width:parent.width*0.25
        height:parent.height*0.5
        anchors.centerIn: parent

        Column{
            id: error_view_column
            anchors.fill: parent

            Rectangle{ // 65%
                id: error_image_container
                antialiasing: true
                color: "#00000000"
                width:error_view_container.width
                height:error_view_container.height*0.65

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
                width:error_view_container.width
                height:error_view_container.height*0.2

                Text {
                    anchors.centerIn: parent
                    color:'white'
                    font.pixelSize: Math.min(parent.width,parent.height)*0.3
                    text: error_view_container.message
                }
            }

            Rectangle{ // 15%
                id: error_retrybutton_container
                color: "#00000000"
                width:error_view_container.width
                height:error_view_container.height*0.15

                MyButton{
                    id:retrybutton
                    anchors.fill: parent
                    buttonColor: 'gray'
                    buttonHoveredColor: '#6c6c6c'
                    textColor: 'white'
                    buttonText: 'Retry connection'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.4
                    pointingHandCursor: true
                    onClickbutton: function(){
                        errorhandler.retryDBConnection();
                        if(QmlDto.databaseIsOpen()){
                            error_view_container.visible = false;
                            componets_column.visible = true;
                            QmlDto.reloadTableData();
                            reloadTable();
                        } else
                        {
                            reconnect_text_container.opacity = 100
                            reconnect_text_container.visible = true;
                            timer_show_reconnect_message.running = true;
                        }
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
                width: error_view_container.width
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

    Component.onCompleted: {
        if(!QmlDto.databaseIsOpen()){
            error_view_container.visible = true;
            componets_column.visible = false;
        }
    }
}
