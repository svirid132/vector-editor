// First, define your QML singleton type which provides the functionality.
pragma Singleton
import QtQuick 2.0
Item {
    property int testProp1: 125

    Component.onCompleted: {
        testProp1 = 1000
    }
}
