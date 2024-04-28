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

    Image{
        id: background_image
        anchors.fill: parent
        source: "imgs/background.jpg" // TODO
    }

    MultiEffect{
        id: background_blur
        source: background_image
        width: components_container.width
        height: components_container.height
        anchors.centerIn: parent
        blurEnabled: false
        blurMax: 32
        blur: 1.0
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


                        }
                    }
                }
            }
        }
    }

    Rectangle{
        color: "#00000000"
        id: error_view_container
        visible:false
        width:parent.width*0.25
        height:parent.height*0.5
        anchors.centerIn: parent

        Column{
            id: error_view_column
            anchors.fill: parent

            Rectangle{ // 65%
                id: error_image_container
                antialiasing: true
                color: "#00000000"
                width:error_view_container.width
                height:error_view_container.height*0.65

                Image{
                    source: 'imgs/svg/criticalError.svg'
                    height:parent.height
                    fillMode:Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
            }

            Rectangle{ // 20%
                id: error_text_container
                color: "#00000000"
                width:error_view_container.width
                height:error_view_container.height*0.2

                Text {
                    anchors.centerIn: parent
                    color:'white'
                    font.pixelSize: Math.min(parent.width,parent.height)*0.3
                    text: qsTr("Failed to connect to database")
                }
            }

            Rectangle{ // 15%
                id: error_retrybutton_container
                color: "#00000000"
                width:error_view_container.width
                height:error_view_container.height*0.15

                MyButton{
                    id:retrybutton
                    anchors.fill: parent
                    buttonColor: 'gray'
                    buttonHoveredColor: '#6c6c6c'
                    textColor: 'white'
                    buttonText: 'Retry'
                    buttonTextSize: Math.min(parent.width,parent.height)*0.4
                    onClickbutton: function(){
                        console.log('RetryClicked');
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if(!QmlDto.databaseIsOpen()){
            error_view_container.visible = true;
            componets_column.visible = false;
            background_blur.blurEnabled=true;
        }
    }
}
