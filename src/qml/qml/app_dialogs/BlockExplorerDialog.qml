import QtQuick 2.10
import QtQuick.Window 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3
import QtQuick.Controls 1.4 as Controls_1_4
import QtQuick.Controls.Styles 1.4 as Controls_1_4_style
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.3
import TrafficGraphWidget 1.0



import "../app_pages"
import "../app_items"
import "../base_items"


CommonDialog
{
    id:root
    title: "Blockchain Explorer"

    confrim_btn_visible:false
    cancel_btn_visible:false
    width:900
    height:900
    property bool fisrt_run: true

    background_rec.color: "#FFFFFF"


    Item{
        parent:root.background_rec
        anchors.fill: parent
        anchors.topMargin: 25



        CommonButton
        {
            id:back_btn
            color: "#469AAC"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            text:"Back"
            width: 100
            height: 28
            textSize:11
            onClicked:
            {
                blockExplorer.back()
            }

            Connections
            {
                target:blockExplorer

                onSetBackButton:
                {
                    if(enable)
                        back_btn.enabled = true
                    else
                        back_btn.enabled = false
                }

            }
        }


        CommonButton
        {
            id:forward_btn
            color: "#469AAC"
            anchors.left: back_btn.right
            anchors.top: parent.top
            anchors.margins: 10
            text:"Forward"
            width: 100
            height: 28
            textSize:11
            onClicked:
            {
                blockExplorer.forward()
            }

            Connections
            {
                target:blockExplorer

                onSetBackButton:
                {
                    if(enable)
                        forward_btn.enabled = true
                    else
                        forward_btn.enabled = false
                }

            }


        }


        CommonTextField
        {
            id:input_filed
            font.weight: Font.Light
            font.pixelSize:16
            anchors.left: forward_btn.right
            anchors.right: search_btn.left
            anchors.verticalCenter: search_btn.verticalCenter
            anchors.margins: 10

            backgroundColor:"#F0F0F0"
            backgroundFocusColor:"#FFFFFF"


            onAccepted:
            {
                blockExplorer.onSearch(text)
            }

            Connections
            {
                target:blockExplorer

                onNewSearch:
                {
                    input_filed.text = query
                }

            }
        }


        CommonButton
        {
            id:search_btn
            color: "#469AAC"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            text:"Search"
            width: 100
            height: 28
            textSize:11
            onClicked:
            {
                blockExplorer.onSearch(input_filed.text)
            }
        }






        CommonTextArea
        {
            id:explorer
            anchors.left: parent.left
            anchors.top:input_filed.bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10
            readOnly: true
            font.pixelSize:18

            linkSignalBlocked:true
            textFormat: TextEdit.RichText


            backgroundColor:"#5F9EA0"

            //TODO:here is a bug display html document and mouse shape see QTBUG-34219 and QTBUG-39845
            //Rich text display
            //,which works pretty fine in QLable see comment part in blockExplorer.cpp

            borderVisible: false
            //                background: Rectangle {
            //                    opacity: 1
            //                    color: "#EFEBE7"
            //                }


            Connections
            {
                target:blockExplorer

                onNewContent:
                {
                    explorer.text = newContent
                   //explorer.text = newContent.replace("\\\"","")

                }

            }

            Component.onCompleted:
            {
                blockExplorer.startUpPage()


            }

            onLinkActivated: blockExplorer.goTo(link)

            onLinkHovered:
            {
            }



        }




    }

}