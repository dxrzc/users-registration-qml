import QtQuick 2.15
import QtTest 1.0
import "../../components"

Row {
    width: 800
    height: 600

    ActionIcon{
        width: 10
        height:10
        onClickButton: {}

        SignalSpy {
            id: spy
            target: parent
            signalName: "clickButton"
        }

        TestCase {
            name: "signalAndClick"
            when: windowShown

            function test_clickToCallSignal() {
                compare(spy.count,0);
                mouseClick(parent);
                compare(spy.count,1);
            }
        }
    }

    ActionIcon {
        width: 10
        height:10

        TestCase{
            name: "sizeAndHover"
            when: windowShown

            function test_enteredMustBeTrueWhenMouseOnComponent(){
                verify(!parent.entered);
                mouseMove(parent);
                verify(parent.entered);
            }
        }
    }
}
