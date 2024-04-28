import QtQuick
import QtQuick.Controls

import 'js/generate.js' as ArrayGenerator

Item{
    anchors.fill: parent
    property bool monthOk: false;
    property bool dayOk: false;
    property bool yearOk: false;
    property bool good_data: monthOk && dayOk && yearOk;
    property string month: month_field.currentIndex + 1 ;
    property string day: day_field.currentText
    property string year: year_field.currentText;

    function clearFields(){
        month_field.displayText = "Month";
        monthOk = false;
        day_field.displayText = "Day";
        dayOk = false;
        year_field.displayText = "Year";
        yearOk = false;
    }

    Column{
        id: label_and_selection_column
        anchors.fill: parent

        Rectangle{
            id: label_container
            color: "#00000000"
            width: parent.width
            height:parent.height*0.5

            Text{
                id: label_text
                text:'BirthDate'
                color:'white'
                font.pixelSize: Math.min(parent.height,parent.width)/2
            }
        }

        Rectangle{
            id: selections_container
            color: "#00000000"
            width: parent.width
            height:parent.height*0.5

            Row{
                id: selections_row
                anchors.fill: parent
                spacing:parent.width*0.01 //1% = 2%

                ComboBox {
                    id: month_field
                    width : (selections_container.width-(2*spacing))/3
                    height:parent.height
                    displayText: 'Month'

                    model: ListModel {
                        ListElement { text: "January"}
                        ListElement { text: "February" }
                        ListElement { text: "March" }
                        ListElement { text: "April" }
                        ListElement { text: "May" }
                        ListElement { text: "June" }
                        ListElement { text: "July" }
                        ListElement { text: "August" }
                        ListElement { text: "September" }
                        ListElement { text: "October" }
                        ListElement { text: "November" }
                        ListElement { text: "December" }
                    }

                    onActivated: {
                        monthOk = true
                        displayText = model.get(currentIndex).text
                    }

                    textRole: "text"
                }


                ComboBox {
                    id: day_field
                    width : (selections_container.width-(2*spacing))/3
                    height:parent.height
                    displayText: 'Day'
                    model: ArrayGenerator.selectMonth(month_field.currentText);

                    onActivated: {
                        dayOk = true
                        displayText = model[currentIndex].text
                    }
                }

                ComboBox {
                    id: year_field
                    width : (selections_container.width-(2*spacing))/3
                    height:parent.height
                    model:(ArrayGenerator.generateArray(1960,2011)).reverse();
                    displayText: 'Year'

                    onActivated: {
                        yearOk = true
                        displayText = model[currentIndex].text
                    }
                }
            }
        }
    }
}
