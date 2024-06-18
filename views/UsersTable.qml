import QtQuick

Rectangle {

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
        }
    }
}
