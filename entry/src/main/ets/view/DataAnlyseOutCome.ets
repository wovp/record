import { PayList } from '../model/AccountList';
import recordItem from '../model/recordItem';
import Record from '../model/record'
@CustomDialog
export struct DataAnlyseOutCome {
    controller?: CustomDialogController;
    public valueArr: number[] = [10, 10, 10, 10, 10, 10, 10, 10, 10]
    @Link newAccount: Record[];
    confirm?: () => void;
    @State payList: Array<recordItem> = PayList;
    @State show_nums: number[] = []
    initt(){
        let pl = PayList.length
        let num_type: number[] = []
        let all_sum = 0;
        // 遍历类型
        for (let index = 0; index < PayList.length; index++) {
            const element = PayList[index];
            let one_type_ssum = 0;
            // 遍历记录
            for (let jdex = 0; jdex < this.newAccount.length; jdex++) {
                const record = this.newAccount[jdex];
                // 类型相同
                if (record.typeText === element.typeText) {
                    one_type_ssum += record.amount
                }
            }
            // 总和
            all_sum += one_type_ssum
            num_type.push(one_type_ssum)
        }
        this.show_nums = num_type

    }
    aboutToAppear(){
        this.initt()
    }

    build() {
        Stack() {
            Column() {
                Column() {
                    Text('我是内容')
                        .fontSize(20)
                        .margin({ top: 10, bottom: 10 })
                }

                DataPanel({ values: this.show_nums, max: 0, type: DataPanelType.Circle }).width(300).height(300)
                DataPanel({ values: this.valueArr, max: 100, type: DataPanelType.Line }).width(300).height(20)
                List(){
                    ForEach(this.payList, (item: recordItem) => {
                        ListItem(){
                            Column(){
                                Text(item.typeText)
                                    .fontSize(18)
                                    .width(30)
                            }
                        }
                    })
                }
                .listDirection(Axis.Horizontal)
                .width(290)
            }
        }
        .margin({ bottom: 59 })

    }
}