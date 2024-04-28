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

    function create_user()
    {

    }

    function clear_fields()
    {

    }

    Rectangle{
        id: components_container
        color: "#80000000"
        width: parent.width*0.85
        height:parent.height*0.90
        anchors.centerIn: parent
        radius:10

        Column{
            id: componets_column
            visible:true
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
                    text: 'Register in database'
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

                    Rectangle{
                        id: inputs_container
                        color: "#00000000"
                        width:(parent.width)/2
                        height:parent.height

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

                                InputComponent{
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

                                SelectBirthdate{
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

                                InputComponent{
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

                                InputComponent{
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

                                MyButton{
                                    id: login_button
                                    property bool allFieldsOk : (input_phonenumber.good_data && input_email.good_data && selection_birthdate.good_data && input_username.good_data);
                                    anchors.top: parent.top
                                    anchors.topMargin: parent.height*0.3
                                    width:parent.width
                                    height:parent.height*0.7
                                    textColor: 'white'
                                    buttonColor:  allFieldsOk ? '#50a356': 'gray';
                                    buttonHoveredColor: allFieldsOk ? '#008000' : 'gray'
                                    buttonText: 'Register'
                                    buttonTextSize: Math.min(parent.width,parent.height)/3
                                    onClickbutton: if(allFieldsOk) {
                                                       create_user();
                                                       clear_fields();
                                                   }
                                    pointingHandCursor: allFieldsOk;
                                }
                            }
                        }
                    }

                    Rectangle{
                        id: userstable_container
                        color: 'white'
                        width:(parent.width)/2
                        height:parent.height
                        clip:true
                        border.width: 1
                        radius:7

                        Column {
                            Rectangle{
                                id: searchUserContainer
                                width:userstable_container.width
                                height:userstable_container.height*0.1
                                color:'transparent'
                            }

                            Rectangle{
                                width:userstable_container.width
                                height:userstable_container.height*0.9
                                color:'transparent'
                            }
                        }
                    }
                }
            }
        }
    }
}
