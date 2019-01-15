import QtQuick 2.10
import QtQuick.Window 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3
import QtQuick.Controls 1.4 as Controls_1_4
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.1 as Controls_1_1

import "../app_items"
import "../app_dialogs"

Controls_1_4.Tab {

    Rectangle {
        anchors.fill:parent

        radius: 0
        color: "#FAFAFA"

        Connections
        {
            target:walletModel.recentRequestsFilterProxy

            onSendCoinsRecipientReady:
            {
                clear_all_btn.clicked()
                requestPaymentDialog.info = info
                requestPaymentDialog.tag = label
                requestPaymentDialog.address = address
                requestPaymentDialog.qRImg.source = "image://ReQuestURI?" + Math.random()
                requestPaymentDialog.show()
            }
        }


        Label {
            id:header_label
            font.weight: Font.Medium
            font.pixelSize:11
            font.letterSpacing: 0.355
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 94
            color: "#333333"
            text:"Use this from to request payments. ALL fields are optional"
        }


        Label {
            id:tag_label
            font.weight: Font.Medium
            font.pixelSize:13
            anchors.top:header_label.bottom
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.topMargin: 18
            color: "#333333"
            text:"标签"
        }


        CommonTextField
        {
            id:tag_textFiled
            font.weight: Font.Light
            font.pixelSize:16
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: tag_label.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 90

        }

        Label {
            id:total_label
            font.weight: Font.Medium
            font.pixelSize:13
            anchors.top:tag_label.bottom
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.topMargin: 28
            color: "#333333"
            text:"总计"
        }


        AmountField
        {
            id:amountField
            width: 300
            height: 32
            anchors.verticalCenter: total_label.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 90
        }


        Label {
            id:info_label
            font.weight: Font.Medium
            font.pixelSize:13
            anchors.top:total_label.bottom
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.topMargin: 28
            color: "#333333"
            text:"消息"
        }


        CommonTextField
        {
            id:info_textFiled
            font.weight: Font.Light
            font.pixelSize:16
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: info_label.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 90

        }

        CommonCheckBox
        {
            id:reuseAddress
            font.weight: Font.Light
            font.pixelSize: 11
            font.letterSpacing: 0.5
            anchors.left: info_textFiled.left
            anchors.top:info_label.bottom
            anchors.topMargin: 1

            checked: false
            text: "R使用现有的地址接收(不推荐)"
        }

        CommonButton
        {
            id:asking_btn
            color: "#469AAC"
            anchors.left: reuseAddress.left
            anchors.leftMargin: 2
            anchors.top: reuseAddress.bottom
            anchors.topMargin: 4
            width: 83
            height: 32
            radius: 3
            text:"请求支付"
            textSize:12
            letterSpacing:0

            onClicked:
            {
                if(reuseAddress.checked)
                    receiveAddressDialog.show()
                else
                {
                    walletModel.recentRequestsFilterProxy.newRequest(tag_textFiled.text,"",info_textFiled.text,amountField.amountField.text)
                }

            }

        }


        RequestPaymentDialog
        {
            id:requestPaymentDialog
            modality: Qt.ApplicationModal
        }

        ReceiveAddressDialog
        {
            id:receiveAddressDialog
            forPicking: true
            modality: Qt.ApplicationModal

            onPickAddress:
            {
                var tag
                if(tag_textFiled.text === "")
                    tag = walletModel.sendingAddressProxyModel.updateLabel(address)
                else
                    tag = tag_textFiled.text

                receiveAddressDialog.close()

                walletModel.recentRequestsFilterProxy.newRequest(tag,address,info_textFiled.text,amountField.amountField.text)
            }

        }

        CommonButton
        {
            id:clear_all_btn
            color: "#EE637F"
            anchors.left: asking_btn.right
            anchors.leftMargin: 20
            anchors.verticalCenter: asking_btn.verticalCenter
            width: 83
            height: 32
            radius: 3
            text:"清除全部"
            textSize:12
            letterSpacing:0

            onClicked:
            {
                tag_textFiled.text = ""
                amountField.amountField.text = ""
                info_textFiled.text = ""
            }
        }

        Label
        {
            id:requested_payments_history_label
            font.weight: Font.Normal
            font.pixelSize:15
            anchors.left: parent.left
            anchors.leftMargin: 30

            anchors.top: asking_btn.bottom
            anchors.topMargin: 30
            color: "#1E5569"
            text:"Requested payments history"

        }

        CommonTableView
        {
            id:receiveAddressTable
            anchors.top:requested_payments_history_label.bottom
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom:show_btn.top
            anchors.bottomMargin: 10
            property string amountTitle: root_window.unitName
            roles:  ["date","label","message","amount"]
            titles: ["时间","标签","消息","Amount(" + amountTitle.trim() +")"]
            widths: [120,200,width-470,110]
            selectionMode: Controls_1_1.SelectionMode.ContiguousSelection

            model: walletModel.recentRequestsFilterProxy

            onDoubleClicked:
            {
                walletModel.recentRequestsFilterProxy.showAddress(receiveAddressTable.currentRow)
            }

            onAmountTitleChanged:
            {
                for(var i =0;i<receiveAddressTable.columnCount;i++)
                {
                    if(receiveAddressTable.getColumn(i).role === "amount")
                    {
                        receiveAddressTable.getColumn(i).title = "Amount(" + amountTitle.trim() +")"
                    }

                }


            }

        }


        CommonButton
        {
            id:show_btn
            color: "#718BBC"
            anchors.right: remove_btn.left
            anchors.verticalCenter: remove_btn.verticalCenter

            anchors.rightMargin: 20
            width: 83
            height: 32
            radius: 3
            text:"Show"
            textSize:12
            letterSpacing:0
            enabled: receiveAddressTable.selection.count>0?true:false
            onClicked:
            {
                walletModel.recentRequestsFilterProxy.showAddress(receiveAddressTable.currentRow)
            }

        }

        CommonButton
        {
            id:remove_btn
            color: "#1E5569"
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            width: 83
            height: 32
            radius: 3
            text:"Remove"
            textSize:12
            letterSpacing:0
            enabled: receiveAddressTable.selection.count>0

            onClicked:
            {
                var rows_arry = new Array
                receiveAddressTable.selection.forEach( function(rowIndex) {
                    rows_arry.push(rowIndex);
                } )

                walletModel.recentRequestsFilterProxy.removeAddress(rows_arry)

                receiveAddressTable.selection.clear()
            }
        }



    }



}