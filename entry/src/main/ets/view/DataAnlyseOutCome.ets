import { PayList } from '../model/AccountList';
import recordItem from '../model/recordItem';
import Record from '../model/record'
import showService from '../services/showServices';
import DateToStr from '../utils/DateToStr';
@CustomDialog
export struct DataAnlyseOutCome {
    controller?: CustomDialogController;
    public valueArr: number[] = [10, 10, 10, 10, 10, 10, 10, 10, 10]
    @Link newAccount: Record[];
    confirm?: () => void;
    seStartDate: Date = new Date("2010-1-1");
    seEndDate: Date = new Date("2010-1-1");
    @State showStartDate: string = '请选择开始时间';
    @State showEndDate: string = '请选择结束时间';
    @Link shm: showService;
    @State payList: Array<recordItem> = PayList;
    @State show_nums: number[] = []
    @State all_sum: number = 0;
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
        this.all_sum = all_sum;

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
                Row({space: 5}){
                    Text('从')
                    Text(this.showStartDate)
                        .onClick(()=>{
                            DatePickerDialog.show({
                                start: new Date("2000-1-1"),
                                end: new Date("2100-12-31"),
                                selected: this.seStartDate,
                                onAccept: (value: DatePickerResult) => {
                                    this.seStartDate.setFullYear(value.year, value.month, value.day)
                                    this.showStartDate = DateToStr(this.seStartDate)
                                },
                                onCancel: () => {},
                                onChange: (value: DatePickerResult) => {
                                    this.seStartDate.setFullYear(value.year, value.month, value.day)
                                    this.showStartDate = DateToStr(this.seStartDate)
                                }
                            })
                        })
                    Text('到')
                    Text(this.showEndDate)
                        .onClick(()=>{
                            DatePickerDialog.show({
                                start: new Date("2000-1-1"),
                                end: new Date("2100-12-31"),
                                selected: this.seEndDate,
                                onAccept: async (value: DatePickerResult) => {
                                    this.seEndDate.setFullYear(value.year, value.month, value.day)
                                    this.showEndDate = DateToStr(this.seEndDate)
                                    this.newAccount = await this.shm.getRecordsByTimeRange(this.showStartDate, this.showEndDate);
                                    this.initt();
                                },
                                onCancel: () => {},
                                onChange: async (value: DatePickerResult) => {
                                    this.seEndDate.setFullYear(value.year, value.month, value.day)
                                    this.showEndDate = DateToStr(this.seEndDate)
                                    this.newAccount = await this.shm.getRecordsByTimeRange(this.showStartDate, this.showEndDate);
                                    this.initt();
                                }
                            })
                        })
                }
                .width(200)
                .height(100)

                DataPanel({ values: this.show_nums, max: 0, type: DataPanelType.Circle }).width(300).height(300)
                Column() {
                    Text(this.all_sum.toString()).fontSize(35).fontColor('#182431')

                }
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