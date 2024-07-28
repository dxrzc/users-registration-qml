import QtQuick
import "../js/global/backend.js" as Backend
import "../js/global/settings.js" as GlobalSettings
import "../components"

Rectangle{
    id: base
    color:'transparent'

    function reload()
    {
        userstable_tableview.model = "";
        userstable_tableview.model = usersTable;
    }

    function reset()
    {
        reload();
        userstable_tableview.positionViewAtRow(0,TableView.AlignTop);
    }

    function scrollToLastRow()
    {
        let contentHeight = userstable_tableview.contentHeight;
        let height = userstable_tableview.height;
        if(contentHeight> height)
            userstable_tableview.contentY = contentHeight - height;
    }

    function getUserNameFromRow(row){
        const index = userstable_tableview.model.index(row,0);
        const username = (userstable_tableview.model.data(index,Qt.DisplayRole));
        return username;
    }

    function getUserEmailFromRow(row){
        const index = userstable_tableview.model.index(row,1);
        const email = (userstable_tableview.model.data(index,Qt.DisplayRole));
        return email;
    }

    function getUserPhoneFromRow(row){
        const index = userstable_tableview.model.index(row,2);
        const phone = (userstable_tableview.model.data(index,Qt.DisplayRole));
        return phone;
    }

    function deleteUser(row){
        const username = getUserNameFromRow(row);
        Backend.deleteUser(username);
        reloadTable();
    }

    function updateUsername(username, newUsername){
        Backend.updateUsername(username,newUsername);
        reloadTable();
    }

    function updateEmail(username,newEmail){
        Backend.updateUserEmail(username,newEmail);
        reloadTable();
    }

    function updateUserPhone(username,newPhone){
        Backend.updateUserPhone(username,newPhone);
        reloadTable();
    }

    signal showPopup(row: int);
    signal showAreYouSureDialog(row:int);

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

                id: cellRectangle
                property real totalWidthWithoutSpacing: (cellsContainer.width - (userstable_tableview.columnSpacing*(userstable_tableview.columns-1)));
                clip:true

                implicitWidth : {
                    switch(column){
                    case 0: return totalWidthWithoutSpacing*GlobalSettings.usernameSizePercentage;
                    case 1: return totalWidthWithoutSpacing*GlobalSettings.emailSizePercentage;
                    case 2: return totalWidthWithoutSpacing*GlobalSettings.phoneNumberSizePercentage;
                    case 3: return totalWidthWithoutSpacing*GlobalSettings.birthdateSizePercentage;
                    case 4: return totalWidthWithoutSpacing*GlobalSettings.editUserSizePercentage;
                    }
                }

                implicitHeight:(cellsContainer.height - userstable_tableview.rowSpacing*(userstable_tableview.rows-1))/7
                color: (column === 4)? 'transparent' :'lightgray'

                TextEdit {
                    readOnly: true
                    font.pixelSize: Math.min(parent.width,parent.height)/4
                    color: 'black'
                    text: (column === 4) ? '': display
                    // text in center for phone-number and birthdate properties
                    anchors.verticalCenter: (column !== 2 || column !== 3)? parent.verticalCenter: undefined
                    anchors.left: (column !== 2 || column !== 3)? parent.left: undefined
                    anchors.leftMargin:(column !== 2 || column !== 3)? parent.width/25: undefined
                    anchors.centerIn: (column === 2 || column === 3)? parent : undefined
                }

                Loader{
                    active: (column === 4)
                    sourceComponent: iconsComponent
                }

                Component {
                    id: iconsComponent

                    Item{
                        width: cellRectangle.width
                        height: cellRectangle.height

                        Column {
                            anchors.fill: parent

                            ActionIcon {
                                resizeable: true
                                width:parent.width
                                height: parent.height/2
                                imagepath: '../imgs/svg/edit.svg'
                                onClickButton: showPopup(row);
                            }

                            ActionIcon {
                                resizeable: true
                                width:parent.width
                                height: parent.height/2
                                imagepath: '../imgs/svg/delete.svg';
                                onClickButton: showAreYouSureDialog(row);
                            }
                        }
                    }
                }
            }
        }
    }
}
