import QtQuick 2.15
import QtTest 1.0
import "../../components"

Row {
    width: 900
    height: 600

    CustomButton{
        width: 10
        height: 10

        SignalSpy{
            id: spy
            target: parent
            signalName: 'clickbutton'
        }

        TestCase{
            name: 'signalAndClick'
            when: windowShown

            function test_clickToCallSignal(){
                compare(spy.count,0);
                mouseClick(parent);
                compare(spy.count,1);
            }
        }
    }
}
