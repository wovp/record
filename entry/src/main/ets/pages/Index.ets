import relationalStore from '@ohos.data.relationalStore'
import router from '@ohos.router'
import CommonConstants from '../constants/CommonConstants'
import dbCreater from '../dbManage/dbCreater'
import dbManager from '../dbManage/dbManager'
import { ImageList } from '../model/AccountList'
import Record from '../model/record'
import showService from '../services/showServices'
import manageService from '../services/manageService';
import { DialogComponent } from '../view/DialogComponent'
import { DataAnlyseOutCome } from '../view/DataAnlyseOutCome'
import DateToStr from '../utils/DateToStr'
@Entry
@Component
struct Index {
  context = getContext()
  public store: relationalStore.RdbStore  // 用于初始化数据库
  @State showService: showService = null         // 用于展示数据的服务接口
  public manage_service: manageService = null       // 用于处理数据的服务接口
  @State list_records: Record[] = []                // 查询到的所有记录
  @State isSelected: boolean = false;
  tSearchController: SearchController = new SearchController()
  @State isSearch: boolean = false;
  @State isDateRange: boolean = false;
  @State searchIsDate: boolean = false;     // 搜索框是否是搜索分类
  @State searchText: string = '';
  seStartDate: Date = new Date("2010-1-1");
  seEndDate: Date = new Date("2010-1-1");
  @State showStartDate: string = '请选择开始时间';
  @State showEndDate: string = '请选择结束时间';
  @State selected_records: Record[] = []            // 选中分类的记录列表，只在isSelected为True时有用
  // 用于传递参数，包括详情弹窗 和 添加
  @State newAccount: Record = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '00', purpose: '00', date: '00'};
  // 用于分时间展示数据
  @State ca_list_records: any[] = []

  dialogController: CustomDialogController = new CustomDialogController( {
    builder: DialogComponent({
      newAccount: $newAccount,
      confirm: (newAccount: Record) => this.accept(newAccount)
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom
  });
  accept(b){

  }

  dcOutCome: CustomDialogController = new CustomDialogController({
    builder: DataAnlyseOutCome({
      newAccount: $list_records,
      shm : $showService,
      confirm: () => this.accept(this.isSelected)
    }),
    alignment: DialogAlignment.Bottom
  })

  @Builder itemEnd(index: number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.app_delete'))
        .width(30)
        .height(30)
        .backgroundColor(Color.White)
    }
    .onClick(async () => {
      let de = await this.manage_service.deleteRecord(index)
      this.list_records = await this.showService.showAllRecord()
      this.mk_date_list_records_init()
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
    // 初始化数据库
    let dbc = new dbCreater()
    await dbc.initialize(this.context)
    // 传递数据库操作对象
    this.store = dbc.store
    // 初始化数据库展示对象
    this.showService = new showService(this.store)
    // 初始化数据库操作对象
    let mm = new manageService()
    await mm.init()
    this.manage_service = mm

    // 获得所有记录
    this.list_records = await this.showService.showAllRecord()
    // 记录按时间分类
    this.mk_date_list_records_init()

  }
  async onPageShow(){
    // 每次页面切换的时候，都要重新刷新列表
    // 从添加页面转回来，需要重新刷新，显示新增数据，也需要重新分类
    this.list_records = await this.showService.showAllRecord()
    this.mk_date_list_records_init()
    console.info('onPageShow');
  }

  build() {

    Column() {
      Column() {
        Row(){
          Select([{ value: '支出'},
            { value: '收入' },
            {value: '所有'}
          ])
            .selected(2)
            .value('TTTTT')
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => {
              console.info('Select:' + index)
              if(index === 2){
                this.isSelected = false;
                this.mk_date_list_records_init()
              }
              else {
                this.selected_show(index)
                this.mk_date_list_records_init()
              }
            })
          Button('支出分析')
            .onClick(()=>{
              this.dcOutCome.open()
            })
        }

        Row(){
          Select([{ value: '时间'},
            { value: '分类' }
          ])
            .selected(1)
            .value('分类')
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => {
              console.info('Select:' + index)
              if(index === 0){
                this.searchIsDate = true;
              }
              else {
                this.searchIsDate = false;
                this.isDateRange = false;
                this.mk_date_list_records_init();
              }
            })
          if (this.searchIsDate){
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
                    onAccept: (value: DatePickerResult) => {
                      this.seEndDate.setFullYear(value.year, value.month, value.day)
                      this.showEndDate = DateToStr(this.seEndDate)
                    },
                    onCancel: () => {},
                    onChange: async (value: DatePickerResult) => {
                      this.seEndDate.setFullYear(value.year, value.month, value.day)
                      this.showEndDate = DateToStr(this.seEndDate)
                      if (this.entureDateRight(this.seStartDate, this.seEndDate)) {

                      }
                      this.selected_records = await this.showService.getRecordsByTimeRange(this.showStartDate, this.showEndDate);
                      this.isDateRange = true;
                      this.mk_date_list_records_init()
                    }
                  })
                })
            }
            .width(200)
            .height(100)
          }
          else{
            Search({ value: this.searchText, placeholder: 'Type to search...', controller: this.tSearchController })
              .searchButton('SEARCH')
              .backgroundColor('#F5F5F5')
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: 14, weight: 400 })
              .textFont({ size: 14, weight: 400 })
              .onSubmit((value: string) => {
                this.searchText = value
                if (this.searchText === '') {
                  this.isSearch = false
                  this.mk_date_list_records_init()
                }
                else{
                  this.isSearch = true
                  this.searchShow()
                  this.mk_date_list_records_init()
                }
              })
              .margin(20)
          }

        }
      }
      .backgroundColor(Color.Red)
      .width('100%')
      .height(200)

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
              .onClick(()=>{
                this.newAccount = item;
                this.dialogController.open()
              })

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
        this.newAccount = { id: 0, accountType: 0, typeText: '', amount: 0 , notes: '', purpose: '', date: ''};
        onJumpClick()
      })
    }
    .width('100%')
    .height('100%')
    // .justifyContent(FlexAlign.SpaceBetween)

  }

  mk_date_list_records_init(){
    // 根据不同的时间，分类记录
    // 分类列表的元素是json数据
    // 其中第一项date是时间
    // 第二项list_records 是一个数组，存的是同一时间的记录
    const date_set = new Set<String>()
    this.ca_list_records = []
    // 根据分类选择
    const nn = (this.isSelected || this.isSearch || this.isDateRange) ? this.selected_records: this.list_records;

    for (let i = 0; i < nn.length; i++){
      const record = nn[i];
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
        date_set.add(nn[i].date)
        this.ca_list_records.push({
          date: nn[i].date,
          list_records: [nn[i]]
        })
      }
    }
    console.info('这是' + this.ca_list_records)
  }

  selected_show(ii: number){
    const mm = (this.isSelected || this.isDateRange) ? this.selected_records : this.list_records
    this.selected_records = []
    for (let index = 0; index < mm.length; index++) {
      const element = mm[index];
      if(element.accountType == ii){
        this.selected_records.push(element)
      }
    }
    this.isSelected = true
  }
  searchShow(){
    if (!this.isSearch) {
      return;
    }
    const mm = (this.isSelected || this.isDateRange) ? this.selected_records : this.list_records
    this.selected_records = []
    for (let index = 0; index < mm.length; index++) {
      const element = mm[index];
      if (element.typeText === this.searchText) {
        this.selected_records.push(element)
      }
    }
    this.isSearch = true
  }

  entureDateRight(st: Date, end: Date){
    if(st > end){
      return false
    }
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