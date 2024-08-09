import QtQuick 2.15
import QtTest 1.0
import '../../components'
import '../helpers/insert-text.helper.js' as TestHelpers
import '../../js/global/backend.js' as Backend

Row{
    width: 1000
    height: 1000

    /* we are testing that validate functions are being
    called to validate the input (validateNumber, validateEmail, etc..) */

    Input{
        width: 10
        height: 10
        usernameInput: true

        TestCase {
            name: 'Input_username_validation'

            function test_good_data_false_if_name_not_valid() {
                parent.forceActiveFocus();
                mouseClick(parent);
                const badUserName= 'abc'; // min lenght is 4
                TestHelpers.insertTextOnComponent(badUserName,this);
                verify(!parent.good_data);
            }

            function test_good_data_true_if_name_valid(){
                parent.forceActiveFocus();
                mouseClick(parent);
                const userName = 'John Wick';
                TestHelpers.insertTextOnComponent(userName,this);
                verify(parent.good_data);
            }
        }
    }

    Input {
        width: 10
        height: 10
        emailInput: true

        TestCase {
            name: 'Input_email_validation'

            function test_good_data_false_if_email_not_valid(){
                parent.forceActiveFocus();
                mouseClick(parent)
                const badEmail = 'badEmail';
                TestHelpers.insertTextOnComponent(badEmail,this);
                verify(!parent.good_data);
            }

            function test_good_data_true_if_email_valid(){
                parent.forceActiveFocus();
                mouseClick(parent)
                const email = 'validEmail@gmail.com';
                TestHelpers.insertTextOnComponent(email,this);
                verify(parent.good_data);
            }
        }
    }

    Input {
        width: 10
        height: 10
        phonenumberInput: true

        TestCase {
            name: 'Input_phone_validation';

            function test_good_data_false_if_phone_not_valid(){
                parent.forceActiveFocus();
                mouseClick(parent)
                const badPhoneNumber = '123'; // too short
                TestHelpers.insertTextOnComponent(badPhoneNumber,this);
                verify(!parent.good_data);
            }

            function test_good_data_true_if_phone_valid(){
                parent.forceActiveFocus();
                mouseClick(parent)
                const badPhoneNumber = '123456789';
                TestHelpers.insertTextOnComponent(badPhoneNumber,this);
                verify(parent.good_data);
            }
        }
    }

    // testing regExps

    Input {
        width: 10
        height: 10
        phonenumberInput: true

        TestCase {
            name: 'Input_phone_regExp'

            function test_unable_to_type_letters(){
                parent.forceActiveFocus();
                mouseClick(parent);
                TestHelpers.insertTextOnComponent('123a',this);
                compare(parent.text,'123');
            }
        }
    }

    // testing validation when input empty

    Input {
        width: 10
        height: 10
        usernameInput: true // it is not relevant

        TestCase {
            name: 'Input_empty'

            function test_good_data_false_if_input_empty(){
                parent.forceActiveFocus();
                mouseClick(parent);
                verify(!parent.good_data);
            }

            function test_good_data_false_if_good_data_removed(){
                parent.forceActiveFocus();
                mouseClick(parent);

                // inserting good data
                const username = 'myusername';
                TestHelpers.insertTextOnComponent(username,this);

                // removing..
                for(let i=0; i< username.length; i++)
                    keyClick(Qt.Key_Backspace)

                verify(!parent.good_data)
            }
        }
    }

    // testing functions

    Input {
        width: 10
        height: 10
        usernameInput: true // it is not relevant

        TestCase {
            name: 'Input_functions'

            function test_clearFieldFunction(){
                parent.forceActiveFocus();
                mouseClick(parent);
                TestHelpers.insertTextOnComponent('Myusername',this);
                parent.clearField();
                compare(parent.text,'');
                compare(parent.icon_path,'');
                verify(!parent.good_data);
            }
        }
    }
}
