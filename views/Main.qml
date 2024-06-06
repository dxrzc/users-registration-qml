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

    // If backend functions change, only make changes below

    function backend_retryDbConnection(){
        errorhandler.retryDBConnection();
    }

    function backend_databaseIsOpen(){
        return QmlDto.databaseIsOpen();
    }

    function backend_reloadTableData(){
        QmlDto.reloadTableData();
    }

    function backend_userAlreadyExists(name){
        return QmlDto.userAlreadyExists(name);
    }

    function backend_emailAlreadyExists(email){
        return QmlDto.emailAlreadyExists(email);
    }

    function backend_phoneNumberAlreadyExists(number){
        return QmlDto.phoneNumberAlreadyExists(number);
    }

    function backend_connectDb(hostname, port, user,password,db){
        QmlDto.connectDB(hostname,port,user,password,db);
    }

    function backend_enableFilter(text){
        QmlDto.enableFilter(text);
    }

    function backend_disableFilter(){
        QmlDto.disableFilter();
    }

    function backend_createUser(user,email,phone,birthdate){
        QmlDto.createUser(user,email,phone,birthdate);
    }

    // QML Functions (Instead of acces Main.qml components from another qml-
    // file, create a function here and use it to modify them)

    function setErrorView(message){
        errorView.message = message;
        errorView.visible = true;
        componets_column.visible = false;
    }

    function enableScrollToLastTimer(){
        scrollToLastTimer.running = true;
    }

    // QML-CXX Functions

    function retryDbConnection(){
        backend_retryDbConnection();
        if(backend_databaseIsOpen()){
            errorView.visible = false;
            componets_column.visible = true;
            backend_reloadTableData();
            reloadTable();
        } else {
            errorView.retryConnectionFailed();
        }
    }

    // options: Array
    function connect(options){
        backend_connectDb(options[0],options[1],options[2],options[3],options[4]);
        components_container.visible = true;
        logindb.visible = false;
        main_window.reloadTable();
    }

    function enableTableFilter(text){
        backend_enableFilter(text);
        resetTableView();
    }

    function disableTableFilter(){
        backend_disableFilter();
        resetTableView();
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

    // ..

    Timer {
        id: scrollToLastTimer
        interval: 100
        onTriggered: scrollToLastTableViewRow();
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

    InsertDbUrlView{
        id: logindb
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

    ErrorView{
        id: errorView
        width:parent.width*0.25
        height:parent.height*0.5
        anchors.centerIn: parent
        message: "Failed to connect to database";
        visible: false
        onRetryClicked: retryDbConnection();
    }

}
