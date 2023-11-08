import relationalStore from '@ohos.data.relationalStore'
import router from '@ohos.router'
import CommonConstants from '../constants/CommonConstants'
import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
import { ImageList } from '../model/AccountList'
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
  @State list_records: Record[] = []
  @State isEdit: boolean = false;
  @State isInsert: boolean = false;
  @State newAccount: Record = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '00', purpose: '00', date: '00'};
  @State ca_list_records: any[] = []

  @Builder itemEnd(index: number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.app_delete'))
        .width(30)
        .height(30)
        .backgroundColor(Color.White)
    }
    .onClick(() => {

    })

  }

  @Builder itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }

  async aboutToAppear() {
    let dbc = new dbCreater()
    this.dbstore = await dbc.initialize(this.context)
    this.store = dbc.store
    this.showService = new showService(this.store)

    this.list_records = await this.showService.showAllRecord()
    this.mk_date_list_records_init()
    console.info('这是showAllRecord后');
  }
  async onPageShow(){
    this.list_records = await this.showService.showAllRecord()
    this.mk_date_list_records_init()
    console.info('onPageShow');
  }

  build() {

    Column() {
      Row() {
        Text('ces')

      }
      .backgroundColor(Color.Red)
      .width('100%')
      .height(100)

      List() {
        ForEach(this.ca_list_records, li =>{
          ListItemGroup({ header: this.itemHead(li.date) }){
            ForEach(li.list_records, (item: Record) => {
              ListItem() {
                Row() {
                  Image(ImageList[item.typeText])
                    .width('40vp')
                    .aspectRatio(CommonConstants.FULL_SIZE)
                    .margin({ right: '16vp' })

                  Text(item.typeText)
                    .height('22vp')
                    .fontSize('16vp')

                  Blank()
                    .layoutWeight(1)
                  Text(item.accountType === 0 ? '-' + item.amount.toString() : '+' + item.amount.toString())
                    .fontSize('16vp')
                    .fontColor(item.accountType === 0 ? '#FFE84826' : '#FF007DFF')
                    .align(Alignment.End)
                    .flexGrow(CommonConstants.FULL_SIZE)
                }

              }
              .swipeAction({ end: this.itemEnd.bind(this, item.id) }) // 设置侧滑属性
              .height(100)

            }, item => item.id)
          }
        })

      }
      .alignListItem(ListItemAlign.Start)
      .width('100%')
      Button(){
        Image($rawfile('add.png'))
      }
      .width('48vp')
      .height('48vp')
      .position({ x: CommonConstants.EDIT_POSITION_X, y: CommonConstants.EDIT_POSITION_Y })
      .onClick(() => {
        this.isInsert = true;
        this.newAccount = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '', purpose: '', date: ''};
        onJumpClick()
      })
    }
    .width('100%')
    .height('100%')
    // .justifyContent(FlexAlign.SpaceBetween)

  }

  mk_date_list_records_init(){
    const date_set = new Set<String>()
    this.ca_list_records = []

    for (let i = 0; i < this.list_records.length; i++){
      const record = this.list_records[i];
      if(date_set.has(record.date)){

        for (let index = 0; index < this.ca_list_records.length; index++) {
          const element = this.ca_list_records[index];
          if (element.date === record.date) {
            this.ca_list_records[index].list_records.push(record)
            break;
          }
        }

      }

      else{
        date_set.add(this.list_records[i].date)
        this.ca_list_records.push({
          date: this.list_records[i].date,
          list_records: [this.list_records[i]]
        })
      }
    }
    console.info('这是' + this.ca_list_records)
  }

}

// 在Home页面中
function onJumpClick(): void {
  const valueBucket1: Record =  {
    id: -1,
    amount: 50.0,
    notes: '00',
    typeText: '00',
    date: '00',
    accountType: 0,
    purpose: '00'
  };
  router.pushUrl({
    url: 'pages/add', // 目标url
    params: valueBucket1
  }, router.RouterMode.Standard, (err) => {
    if (err) {
      console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    console.info('Invoke pushUrl succeeded.');
  });
}