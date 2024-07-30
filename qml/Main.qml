import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import "js/global/settings.js" as GlobalSettings
import "js/global/backend.js" as Backend
import "views"
import "components"
import "sections"

Window {        

    id:main_window
    color: "#43bfbd"
    visible: true
    width: 1200
    height: 700
    title: "RegistrationApp"
    minimumWidth: 1200
    minimumHeight: 700

    function retryDbConnection(){
        Backend.retryDbConnection();
        if(Backend.databaseIsOpen()){
            errorView.visible = false;
            components_container.visible = true;
            GlobalSettings.Backend.reloadTableData();
            userstable.reloadTableSection();
        }
    }

    function setErrorView(message){
        errorView.message = message;
        errorView.visible = true;
        components_container.visible = false;
    }

    Connections{
        target: errorhandler

        function onErrorFromDataBase(message){
            setErrorView(message);
        }

        function onInternalError(message){
            setErrorView(message);
        }
    }

    Timer {
        id: scrollToLastTimer
        interval: 100
        onTriggered: userstable.scrollToLastRow();
    }

    Image{
        id: background_image
        anchors.fill: parent
        source: "imgs/background.jpg"
    }

    MultiEffect{
        id: background_blur
        source: background_image
        anchors.fill: components_container
        blurEnabled: true
        blurMax: 10
        blur: 1.0
    }

    InsertUrlView{
        id: insertUrlView
        anchors.centerIn: parent
        width:parent.width*0.3
        height: parent.height*0.6
        onConnect: function(options){
            Backend.connectDb(options[0],options[1],options[2],options[3],options[4]);
            insertUrlView.visible = false;
            if(Backend.databaseIsOpen()){
                components_container.visible = true;
                userstable.reloadTableSection()
            }
        }
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
                        onTimerScrollToLast: {
                            scrollToLastTimer.running = true;
                        }
                        onReloadTable: {
                            userstable.reloadTableSection();
                        }
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
                                onEnableTableFilter: function(text){
                                    Backend.enableFilter(text);
                                    userstable.resetTableSection();
                                }

                                onDisableTableFilter: {
                                    Backend.disableFilter();
                                    userstable.resetTableSection();
                                }
                            }

                            Rectangle{
                                id: spacingrec
                                color:'transparent'
                                width: parent.width
                                height: parent.height*0.05
                            }

                            TableSection{
                                id: userstable
                                color: 'white'
                                width:parent.width
                                height: parent.height*0.85
                                radius: 7
                            }
                        }
                    }
                }
            }
        }
    }

    ErrorView{
        id: errorView
        width:parent.width*0.25
        height:parent.height*0.5
        anchors.centerIn: parent
        message: "Failed to connect to database";
        visible: false
        onRetryClicked: retryDbConnection();
        onSetInsertDbUrlView: {
            errorView.visible = false;
            components_container.visible = false;
            insertUrlView.visible = true;
        }
    }
}
