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

    readonly property color globalButtonColor: '#009999';
    readonly property color globalHoveredButtonColor: '#008080';

    // TableView config
    readonly property int tableColumns: 5;
    readonly property real usernameSizePercentage: 0.25;
    readonly property real emailSizePercentage: 0.3;
    readonly property real phoneNumberSizePercentage: 0.2;
    readonly property real birthdateSizePercentage: 0.2;
    readonly property real editUserSizePercentage: 0.05;

    signal reloadTable;
    signal resetTableView;
    signal scrollToLastTableViewRow;

    Connections {
        target: main_window
        function onReloadTable(){userstable.reloadTableSection();}
        function onResetTableView(){userstable.resetTableSection();}
        function onScrollToLastTableViewRow(){userstable.scrollToLastRow();}
    }

    // If backend functions change, only make changes to the following functions

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

    function backend_deleteUser(username){
        QmlDto.deleteUser(username);
    }

    /*
      If some Qml file needs to make changes to any component outside its file
      create a function here and call it from wherever you need it
    */

    // QML Functions

    function setErrorView(message){
        errorView.message = message;
        errorView.visible = true;
        components_container.visible = false;
    }

    function setInsertDbUrlView()
    {
        errorView.visible = false;
        components_container.visible = false;
        insertUrlView.visible = true;
    }

    function enableScrollToLastTimer(){
        scrollToLastTimer.running = true;
    }

    // QML-CXX Functions

    function retryDbConnection(){
        backend_retryDbConnection();
        if(backend_databaseIsOpen()){
            errorView.visible = false;
            components_container.visible = true;
            backend_reloadTableData();
            reloadTable();
        }
    }

    // options: Array
    function connect(options){
        backend_connectDb(options[0],options[1],options[2],options[3],options[4]);
        insertUrlView.visible = false;
        if(backend_databaseIsOpen()){
            components_container.visible = true;
            main_window.reloadTable();
        }
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
        id: insertUrlView
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

                            UsersTable{
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
    }
}
