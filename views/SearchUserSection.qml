import QtQuick
import QtQuick.Controls

Rectangle{
    id: searchUserContainer
    color:'transparent'

    function enableFilter(text){
        QmlDto.enableFilter(text);
        resetTableView();
    }

    function disableFilter(){
        QmlDto.disableFilter();
        resetTableView();
    }

    Row{
        CustomActionButton{
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
                height:parent.height*0.8
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: 'Search by username, email or phone number'
                color:'black'

                background: Rectangle{
                    color :'lightgray'
                    radius:5
                }

                onAccepted: enableFilter(text);
            }
        }

        CustomActionButton{
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
