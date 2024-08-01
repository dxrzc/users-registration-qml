import QtQuick 2.15
import QtTest 1.0
import "../../components"

Row {
    width: 900
    height: 600

    Item{
        width:10
        height:10

        BirthdateSelection{
            anchors.fill: parent

            TestCase {
                name: "fieldsProperties"

                function test_mustBeFalseByDefault() {
                    verify(!parent.monthOk);
                    verify(!parent.dayOk);
                    verify(!parent.yearOkOk)
                }
            }
        }
    }

    Item{
        width:10
        height:10

        BirthdateSelection{
            anchors.fill: parent

            TestCase {
                name: "clearFieldsFunction"

                function test_fieldsMustBeCleared() {
                    parent.monthOk = true;
                    parent.dayOk = true;
                    parent.yearOk = true;

                    parent.clearFields();

                    verify(!parent.monthOk);
                    verify(!parent.dayOk);
                    verify(!parent.yearOkOk);
                }
            }
        }
    }

    Item{
        width:10
        height:10

        BirthdateSelection{
            anchors.fill: parent

            TestCase{
                name: "goodDataProperty"

                function test_goodDataMustBeTrueIfAllFieldsAreOk(){
                    parent.monthOk = true;
                    parent.dayOk = true;
                    parent.yearOk = true;
                    verify(parent.good_data);
                }
            }
        }
    }
}
