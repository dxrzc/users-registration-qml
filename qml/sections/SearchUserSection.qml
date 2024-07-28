import QtQuick
import QtQuick.Controls
import "../components"

Rectangle{
    id: searchUserContainer    

    Row{
        ActionIcon{
            id: searchButton
            width:searchUserContainer.width*0.1
            height:searchUserContainer.height            
            antialiasing: true
            imagepath: "../imgs/svg/search.svg"
            onClickButton: enableTableFilter(searchText.text)
        }

        Rectangle{
            width:searchUserContainer.width*0.8
            height:searchUserContainer.height
            color:'transparent'

            TextField{
                id: searchText
                width: parent.width
                height:parent.height*0.8
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: 'Search by username, email or phone number'
                color:'black'
                onAccepted: enableTableFilter(text);
                background: Rectangle{
                    color :'lightgray'
                    radius:5
                }
            }
        }

        ActionIcon{
            id: reloadButton
            width:searchUserContainer.width*0.1
            height:searchUserContainer.height            
            antialiasing: true
            imagepath: "../imgs/svg/reload.svg"
            onClickButton: {
                disableTableFilter();
                searchText.text = "";
            }
        }
    }

}
