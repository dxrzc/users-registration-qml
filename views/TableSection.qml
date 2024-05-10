import QtQuick

Rectangle{

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
