import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
import showService from '../services/showServices'
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  public dbstore
  context = getContext()
  public store
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
    this.store.insert("EXPENSES", valueBucket1);
    console.info('这是初始化成功:');
    this.list_records = await this.showService.showAllRecord()
    console.info('这是list: ' + JSON.stringify(this.list_records))
  }

  build() {
    List() {
      ForEach(this.list_records, (item) => {
        ListItem() {
          Row() {
            Text(item.AMOUNT).fontSize(50)
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
      }, item => item.key)
    }
    .width('100%')
    .height('100%')
  }
}