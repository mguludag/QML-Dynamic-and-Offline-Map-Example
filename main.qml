import QtQuick 2.12
import QtQuick.Window 2.12
import QtLocation 5.12
import QtQuick.Controls 2.12
import QtPositioning 5.12
import QtQml 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Offline Map Example")

    Plugin {
        id: esriplugin
        name: "esri"
        PluginParameter {
            name: "esri.mapping.providersrepository.disabled"
            value: true
        }
        PluginParameter {
            name: "esri.mapping.cache.directory"
            value: "cache"
        }
        PluginParameter {
            name: "esri.mapping.cache.disk.size"
            value: 9999999999
        }
        //            PluginParameter {
        //                name: 'esri.mapping.offline.directory'
        //                value: ':/offline_tiles/'
        //            }
    }

    Plugin {
        id: osmplugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
        PluginParameter {
            name: "osm.mapping.cache.directory"
            value: "cache"
        }
        PluginParameter {
            name: "osm.mapping.cache.disk.size"
            value: 9999999999
        }
        //            PluginParameter {
        //                name: 'esri.mapping.offline.directory'
        //                value: ':/offline_tiles/'
        //            }
    }

    Loader{
        id: loader
        anchors.fill: parent
        onStatusChanged: if (loader.status === Loader.Ready) console.log('Loaded')
    }



    ComboBox{
        id: maptype
        x: 20
        y: 20
        model: ["esriplugin", "osmplugin"]
        currentIndex: 0
        onCurrentIndexChanged: {
            changemapbtn.index = 0
            loader.setSource("Map_Custom.qml", {
                    "plugin" : (currentText !== "esriplugin" ? esriplugin : osmplugin)
                   })
        }
    }

    Button{
        id: changemapbtn
        anchors.left: maptype.right
        anchors.verticalCenter: maptype.verticalCenter
        anchors.leftMargin: 10
        text: "Change Map Type"
        property int index: 0
        onClicked: {
            index = index < (maptype.currentIndex === 0 ? 12 : 5) ? index+1 : 0
            var map = loader.item
            map.setActiveMapType(index)
        }
    }

    Button{
        id: centerbtn
        anchors.left: changemapbtn.right
        anchors.verticalCenter: maptype.verticalCenter
        anchors.leftMargin: 10
        text: "Center to your Location"
        onClicked: {
            var map = loader.item
            map.gotoCenter()
        }
    }

    Component.onCompleted:{
        loader.setSource("Map_Custom.qml", {
                "plugin" :  esriplugin
               })
    }
}
