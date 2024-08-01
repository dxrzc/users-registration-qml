import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import "../js/global/settings.js" as GlobalSettings
import "../components"

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

        TableRenderingSection{
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

            onShowPopup: function(row){
                baseBlur.visible = true;
                popup.username = tableSection.getUserNameFromRow(row);
                popup.email = tableSection.getUserEmailFromRow(row);
                popup.phone = tableSection.getUserPhoneFromRow(row);
                popup.open();
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

    // Edit user mode
    Popup{
        function enableApplyButton(){
            let ok = false;

            if(usernameInput.text)
                if(usernameInput.good_data)
                    ok = true;

            if(emailInput.text)
                if(emailInput.good_data)
                    ok = true;
                else
                    ok = false;

            if(phoneNumberInput.text)
                if(phoneNumberInput.good_data)
                    ok = true;
                else
                    ok = false;

            return ok;
        }

        function clearAllFields(){
            usernameInput.clearField();
            emailInput.clearField();
            phoneNumberInput.clearField()
        }

        function cancelPopup(){
            popup.close();
            baseBlur.visible = false;
            popup.clearAllFields();
        }

        property string username;
        property string email;
        property string phone;

        width: parent.width*0.6
        height: parent.height*0.9
        id: popup
        anchors.centerIn: parent
        modal: true

        closePolicy: Popup.CloseOnEscape

        background: Rectangle{
            color:'#213555'
            radius: 7
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        }

        onClosed: cancelPopup();

        Item {
            width: parent.width*0.9
            height: parent.height*0.9
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                property real titleHeightPercentage: 0.1
                property real inputHeightPercentage: 0.25 // x3
                property real buttonsHeightPercentage: 0.15

                // title

                Item {
                    width: parent.width
                    height: parent.height*parent.titleHeightPercentage*0.75

                    Text {
                        color: 'white'
                        text: `Editing ${popup.username}`
                        anchors.centerIn: parent
                        font.pixelSize: Math.min(parent.width,parent.height)*0.75
                        font.capitalization: Font.AllUppercase
                        font.bold: true
                        font.underline: true
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height*parent.titleHeightPercentage*0.25
                }

                // end title

                Item {
                    width: parent.width
                    height: parent.height*parent.inputHeightPercentage

                    Input{
                        id: usernameInput
                        width: parent.width*0.9
                        height: parent.height*0.8
                        anchors.centerIn: parent
                        placeholder: 'Unmodified'
                        label: 'Username'
                        usernameInput: true                            
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height*parent.inputHeightPercentage

                    Input{
                        id: emailInput
                        width: parent.width*0.9
                        height: parent.height*0.8
                        anchors.centerIn: parent
                        placeholder: 'Unmodified'
                        label: 'Email'
                        emailInput: true
                    }
                }

                Item {
                    width: parent.width
                    height: parent.height*parent.inputHeightPercentage

                    Input{
                        id: phoneNumberInput
                        width: parent.width*0.9
                        height: parent.height*0.8
                        anchors.centerIn: parent
                        placeholder: 'Unmodified'
                        label: 'PhoneNumber'
                        phonenumberInput: true
                    }
                }

                Row {
                    width: parent.width
                    height: parent.height*parent.buttonsHeightPercentage

                    Item {
                        width: parent.width/2
                        height: parent.height

                        CustomButton{
                            anchors.centerIn: parent
                            width: parent.width*0.9
                            height: parent.height*0.6
                            mouseAreaEnabled: popup.enableApplyButton();
                            buttonColor: mouseAreaEnabled ? GlobalSettings.globalButtonColor : 'darkgray'
                            buttonHoveredColor: GlobalSettings.globalHoveredButtonColor
                            buttonText: 'Apply'
                            buttonTextSize: Math.min(parent.width,parent.height)*0.2
                            onClickbutton: {
                                if(usernameInput.text)
                                    tableSection.updateUsername(popup.username,usernameInput.text);
                                if(emailInput.text)
                                    tableSection.updateEmail(popup.email,emailInput.text);
                                if(phoneNumberInput.text)
                                    tableSection.updateUserPhone(popup.phone,phoneNumberInput.text);
                                popup.close();
                                baseBlur.visible = false;
                                popup.clearAllFields();
                            }
                        }
                    }

                    Item {
                        width: parent.width/2
                        height: parent.height

                        CustomButton {
                            anchors.centerIn: parent
                            width: parent.width*0.9
                            height: parent.height*0.6
                            buttonColor: 'darkgray'
                            buttonHoveredColor: 'gray'
                            buttonText: 'Cancel'
                            buttonTextSize: Math.min(parent.width,parent.height)*0.2
                            onClickbutton: popup.cancelPopup();
                        }
                    }
                }
            }

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
