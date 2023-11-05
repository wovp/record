import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  dbstore
  context = getContext()
  public store
  async aboutToAppear() {
    console.info('这是出现Index')
    let dbc = new dbCreater()
    this.dbstore = await dbc.initialize(this.context)
    console.info('这是赋值store')
    this.store = dbc.store
    let dbm = new dbManager(this.store)
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}