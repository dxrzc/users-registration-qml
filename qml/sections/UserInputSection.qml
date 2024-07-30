import QtQuick
import "../js/global/settings.js" as GlobalSettings
import "../js/global/backend.js" as Backend
import "../components"

Item{
    id: inputs_container
    signal timerScrollToLast;
    signal reloadTable;

    function create_user(){
        if (input_username.good_data && input_phonenumber.good_data && input_email.good_data && selection_birthdate.good_data) {
            const birthdate = selection_birthdate.year +"-"+selection_birthdate.month+"-" +selection_birthdate.day;
            Backend.createUser(input_username.text,input_email.text,input_phonenumber.text,birthdate);
            timerScrollToLast();
        }
    }

    function clear_fields(){
        input_phonenumber.clearField();
        input_email.clearField();
        input_username.clearField();
        selection_birthdate.clearFields();
    }

    function whenRegistButtonIsClicked(){
        if(register_button.allFieldsOk){
            create_user();
            clear_fields();
            reloadTable();
        }
    }

    Column{
        id: inputs_column
        width:parent.width
        height:parent.height
        spacing:height*0.01

        Rectangle{
            id: input_username_container
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: (parent.width/2)-width/2
            width: inputs_container.width*0.75
            height: inputs_container.height*0.20

            Input{
                id: input_username
                anchors.fill: parent
                label: 'Username'
                usernameInput: true
            }
        }
        Rectangle{
            id: selection_birthdate_container
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: (parent.width/2)-width/2
            width: inputs_container.width*0.75
            height: inputs_container.height*0.20

            BirthdateSelection{
                id: selection_birthdate
                anchors.fill: parent
            }
        }

        Rectangle{
            id: input_email_container
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: (parent.width/2)-width/2
            width: inputs_container.width*0.75
            height: inputs_container.height*0.20

            Input{
                id: input_email
                anchors.fill: parent
                label: 'Email'
                placeholder: 'someone@gmail.com'
                emailInput: true
            }
        }

        Rectangle{
            id: input_phonenumber_container
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: (parent.width/2)-width/2
            width: inputs_container.width*0.75
            height: inputs_container.height*0.20

            Input{
                id: input_phonenumber
                anchors.fill: parent
                label: 'Phone number'
                phonenumberInput: true
                placeholder: '987654321'
            }
        }

        Rectangle{
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: (parent.width/2)-width/2
            width: inputs_container.width*0.75
            height:parent.height*0.16

            Button{
                id: register_button
                property bool allFieldsOk : (input_phonenumber.good_data && input_email.good_data && selection_birthdate.good_data && input_username.good_data);
                anchors.top: parent.top
                anchors.topMargin: parent.height*0.3
                width:parent.width
                height:parent.height*0.7
                textColor: 'white'
                buttonColor:  allFieldsOk ? GlobalSettings.globalButtonColor: 'gray';
                buttonHoveredColor: allFieldsOk ? GlobalSettings.globalHoveredButtonColor : 'gray'
                buttonText: 'Register'
                buttonTextSize: Math.min(parent.width,parent.height)/3
                mouseAreaEnabled: allFieldsOk;
                onClickbutton: whenRegistButtonIsClicked();
            }
        }
    }
}
