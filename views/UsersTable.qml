import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Rectangle {
    id: base

    function reloadTableSection(){
        tableSection.reload();
    }

    function resetTableSection(){
        tableSection.reset();
    }

    function scrollToLastRow(){
        tableSection.scrollToLastRow();
    }

    Column{
        id: column
        anchors.fill: parent

        // Initial spacing
        Item {
            width: parent.width
            height:parent.height*0.01
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

            onShowAreYouSureDialog: function(row){
                baseBlur.visible = true;                                                
                dialog.row = row;
                dialog.username =  tableSection.getUserNameFromRow(row);
                dialog.visible = true;
            }
        }
    }

    Dialog {        
        property int row;
        property string username;
        id: dialog
        title: `Are you sure you want to delete the user: "${username}"`
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            tableSection.deleteUser(row);
            baseBlur.visible = false;
        }

        onRejected: {
            baseBlur.visible = false;
        }
    }

    MultiEffect{
        id: baseBlur
        source: column
        width: column.width
        height: column.height
        blurEnabled: true
        blurMax: 12
        blur: 1
        visible: false
    }
}
