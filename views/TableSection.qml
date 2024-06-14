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

                id: cellRectangle
                property real totalWidthWithoutSpacing: (cellsContainer.width - (userstable_tableview.columnSpacing*(userstable_tableview.columns-1)));
                clip:true

                implicitWidth : {
                    switch(column){
                    case 0: return totalWidthWithoutSpacing*usernameSizePercentage;
                    case 1: return totalWidthWithoutSpacing*emailSizePercentage;
                    case 2: return totalWidthWithoutSpacing*phoneNumberSizePercentage;
                    case 3: return totalWidthWithoutSpacing*birthdateSizePercentage;
                    case 4: return totalWidthWithoutSpacing*editUserSizePercentage;
                    }
                }

                implicitHeight:(cellsContainer.height - userstable_tableview.rowSpacing*(userstable_tableview.rows-1))/7
                color: (column === 4)? 'transparent' :'lightgray'

                TextEdit {
                    id: textFromSearching
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

                            CustomActionButton {
                                resizeable: true
                                width:parent.width
                                height: parent.height/2
                                imagepath: 'imgs/svg/edit.svg'
                            }

                            CustomActionButton {
                                resizeable: true
                                width:parent.width
                                height: parent.height/2
                                imagepath: 'imgs/svg/delete.svg';
                            }
                        }
                    }
                }
            }
        }
    }
}
