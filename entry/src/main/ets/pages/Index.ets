import relationalStore from '@ohos.data.relationalStore'
import router from '@ohos.router'
import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
import Record from '../model/record'
import showService from '../services/showServices'
import { DialogComponent } from '../view/DialogComponent'
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  public dbstore
  context = getContext()
  public store: relationalStore.RdbStore
  public showService: showService
  @State list_records: any[] = []
  @State isEdit: boolean = false;
  @State isInsert: boolean = false;
  @State newAccount: Record = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '', purpose: '', date: ''};

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogComponent({
      isInsert: $isInsert,
      newAccount: $newAccount,
      confirm: (isInsert: boolean, newAccount: Record) => this.accept(isInsert, newAccount)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  });
  accept(a, b){

  }
  async aboutToAppear() {
    let dbc = new dbCreater()
    this.dbstore = await dbc.initialize(this.context)
    this.store = dbc.store
    this.showService = new showService(this.store)
    const valueBucket1 = {
      "AMOUNT": 50.0,
      "NOTES": '00',
      "TYPE": '00',
      "PURPOSE": '00',
      "DATE": '00'
    };
    let tt = await this.store.insert("EXPENSES", valueBucket1);
    console.info('这是初始化成功, 行数为:' + tt);
    this.list_records = await this.showService.showAllRecord()
    console.info('这是showAllRecord后');
    console.info('这是list: ' + this.list_records[0].AMOUNT)
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('ces')

        }
        .backgroundColor(Color.Red)
        .width('100%')
        .height(100)

        List() {
          ForEach(this.list_records, (item) => {
            ListItem() {
              Row() {
                Row() {
                  Text("颜色")
                }
                .backgroundColor(Color.Black)

                Column() {
                  Column() {
                    Text('分类')
                  }
                  .backgroundColor(Color.Yellow)

                  Column() {
                    Text('金额')
                  }
                  .backgroundColor(Color.Blue)
                }
                .justifyContent(FlexAlign.Center)

                Row() {
                  Text('时间')
                }
                .backgroundColor(Color.Gray)
              }
              // .backgroundColor(Color.Red)
              .width('100%')
              .justifyContent(FlexAlign.SpaceEvenly)

            }
            .height(100)
            .backgroundColor(Color.Green)

          }, item => item.ID)
        }
        .alignListItem(ListItemAlign.Center)
        .width('100%')

        Button() {
          Image($rawfile('add.png'))
        }
        .width('48vp')
        .height('48vp')
        .position({ x: '75%', y: '75%' })
        .onClick(() => {
          this.isInsert = true;
          this.newAccount = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '', purpose: '', date: ''};
          this.dialogController.open();
        })

        Row() {
          Text('ces')
          Button('添加记录')
            .onClick(() => {
              this.isInsert = true;
              this.newAccount = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '', purpose: '', date: ''};
              this.dialogController.open();
            })
          Text('ces')
        }
        .width('100%')
        .height(100)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
  }
}