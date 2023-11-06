import relationalStore from '@ohos.data.relationalStore'
import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
import showService from '../services/showServices'
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  public dbstore
  context = getContext()
  public store: relationalStore.RdbStore
  public showService: showService
  @State list_records: any[] = []

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
    Column() {
      Row(){
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
      Row(){
        Text('ces')
        Button('添加记录')
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