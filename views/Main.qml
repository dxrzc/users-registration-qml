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

    function scrollToLastRow()
    {
        let contentHeight = userstable_tableview.contentHeight;
        let height = userstable_tableview.height;
        if(contentHeight> height)
            userstable_tableview.contentY = contentHeight - height;
    }

    Timer {
        id: scrollToLastTimer
        interval: 100
        onTriggered: scrollToLastRow();
    }

    function reloadTable()
    {
        userstable_tableview.model = "";
        userstable_tableview.model = usersTable;
    }

    function create_user()
    {
        if (input_username.good_data && input_phonenumber.good_data && input_email.good_data && selection_birthdate.good_data) {
            const birthdate = selection_birthdate.year +"-"+selection_birthdate.month+"-" +selection_birthdate.day;
            QmlDto.createUser(input_username.text,input_email.text,input_phonenumber.text,birthdate);
            scrollToLastTimer.running = true;
        }
    }

    function resetTableView()
    {
        reloadTable();
        userstable_tableview.positionViewAtRow(0,TableView.AlignTop);
    }

    function clear_fields()
    {
        input_phonenumber.clearField();
        input_email.clearField();
        input_username.clearField();
        selection_birthdate.clearFields();
    }

    function enableFilter(text){
        QmlDto.enableFilter(text);
        resetTableView();
    }

    function disableFilter(){
        QmlDto.disableFilter();
        resetTableView();
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

    Rectangle{
        id: components_container
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
                    text: 'Register in database'
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

                    Rectangle{
                        id: inputs_container
                        color: "#00000000"
                        width:(parent.width)/2
                        height:parent.height

                        Column{
                            id: inputs_column
                            width:parent.width
                            height:parent.height
                            spacing:height*0.01

                            Rectangle{
                                id: input_username_container
                                color: "#00000000"
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width/2)-width/2
                                width: inputs_container.width*0.75
                                height: inputs_container.height*0.20

                                InputComponent{
                                    id: input_username
                                    anchors.fill: parent
                                    label: 'Username'
                                    usernameInput: true
                                }
                            }
                            Rectangle{
                                id: selection_birthdate_container
                                color: "#00000000"
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width/2)-width/2
                                width: inputs_container.width*0.75
                                height: inputs_container.height*0.20

                                SelectBirthdate{
                                    id: selection_birthdate
                                    anchors.fill: parent
                                }
                            }

                            Rectangle{
                                id: input_email_container
                                color: "#00000000"
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width/2)-width/2
                                width: inputs_container.width*0.75
                                height: inputs_container.height*0.20

                                InputComponent{
                                    id: input_email
                                    anchors.fill: parent
                                    label: 'Email'
                                    placeholder: 'someone@gmail.com'
                                    emailInput: true
                                }
                            }

                            Rectangle{
                                id: input_phonenumber_container
                                color: "#00000000"
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width/2)-width/2
                                width: inputs_container.width*0.75
                                height: inputs_container.height*0.20

                                InputComponent{
                                    id: input_phonenumber
                                    anchors.fill: parent
                                    label: 'Phone number'
                                    phonenumberInput: true
                                    placeholder: '987654321'
                                }
                            }

                            Rectangle{
                                color: "#00000000"
                                anchors.left: parent.left
                                anchors.leftMargin: (parent.width/2)-width/2
                                width: inputs_container.width*0.75
                                height:parent.height*0.16

                                MyButton{
                                    id: login_button
                                    property bool allFieldsOk : (input_phonenumber.good_data && input_email.good_data && selection_birthdate.good_data && input_username.good_data);
                                    anchors.top: parent.top
                                    anchors.topMargin: parent.height*0.3
                                    width:parent.width
                                    height:parent.height*0.7
                                    textColor: 'white'
                                    buttonColor:  allFieldsOk ? '#009999': 'gray';
                                    buttonHoveredColor: allFieldsOk ? '#008080' : 'gray'
                                    buttonText: 'Register'
                                    buttonTextSize: Math.min(parent.width,parent.height)/3
                                    onClickbutton: if(allFieldsOk) {
                                                       create_user();
                                                       clear_fields();
                                                   }
                                    pointingHandCursor: allFieldsOk;
                                }
                            }
                        }
                    }

                    Rectangle{
                        id: userstable_container
                        color: 'white'
                        width:(parent.width)/2
                        height:parent.height
                        clip:true
                        border.width: 1
                        radius:7

                        Column {
                            Rectangle{
                                id: searchUserContainer
                                width:userstable_container.width
                                height:userstable_container.height*0.1
                                color:'transparent'

                                Row{
                                    ActionButton{
                                        id: searchButton
                                        width:searchUserContainer.width*0.1
                                        height:searchUserContainer.height
                                        color: 'transparent'
                                        antialiasing: true
                                        imagepath: "imgs/svg/search.svg"
                                        onClickButton: enableFilter(searchText.text)
                                    }

                                    Rectangle{
                                        width:searchUserContainer.width*0.8
                                        height:searchUserContainer.height
                                        color:'transparent'

                                        TextField{
                                            id: searchText
                                            width: parent.width
                                            height:parent.height*0.9
                                            anchors.verticalCenter: parent.verticalCenter
                                            placeholderText: 'Search by username'
                                            color:'black'

                                            background: Rectangle{
                                                color :'lightgray'
                                                radius:5
                                            }

                                            onAccepted: enableFilter(text);
                                        }
                                    }

                                    ActionButton{
                                        id: reloadButton
                                        width:searchUserContainer.width*0.1
                                        height:searchUserContainer.height
                                        color: 'transparent'
                                        antialiasing: true
                                        imagepath: "imgs/svg/reload.svg"
                                        onClickButton: {
                                            disableFilter();
                                            searchText.text = "";
                                        }
                                    }
                                }
                            }

                            Rectangle{
                                width:userstable_container.width
                                height:userstable_container.height*0.9
                                color:'transparent'

                                Rectangle{
                                    id: cellsContainer
                                    width: parent.width*0.98
                                    height:parent.height*0.98
                                    anchors.centerIn: parent
                                    color: 'white'

                                    TableView {
                                        clip: true
                                        id: userstable_tableview
                                        visible:true
                                        anchors.fill: parent
                                        model: usersTable // C++
                                        columnSpacing: Math.min(parent.width,parent.height)*0.003
                                        rowSpacing: Math.min(parent.width,parent.height)*0.003

                                        delegate: Rectangle {
                                            clip:true
                                            implicitWidth : (cellsContainer.width - (userstable_tableview.columnSpacing*(userstable_tableview.columns-1)))/4
                                            implicitHeight:(cellsContainer.height - userstable_tableview.rowSpacing*(userstable_tableview.rows-1))/8
                                            color: 'lightgray'

                                            TextEdit {
                                                id: textFromSearching
                                                readOnly: true
                                                font.pixelSize: Math.min(parent.width,parent.height)/4
                                                color: 'black'
                                                text: display
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.left: parent.left
                                                anchors.leftMargin: parent.width/25
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
