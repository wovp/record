/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import prompt from '@ohos.promptAction';
import recordItem from '../model/recordItem';
import CommonConstants from '../constants/CommonConstants'
import Record from '../model/record'
import { PayList, EarnList } from '../model/AccountList';
import router from '@ohos.router';
import manageService from '../services/manageService';
import DateToStr from '../utils/DateToStr';
@Entry
@Component
struct addComponent {
  isInsert: boolean;
  newAccount: Record;
  private scroller: Scroller = new Scroller();
  private inputAmount = '';
  public manage_service: manageService = null
  @State payList: Array<recordItem> = PayList;
  @State earnList: Array<recordItem> = EarnList;
  @State curIndex: number = 0;
  @State curType: string = '';
  selectedDate: Date = new Date("2010-1-1");
  @State showDate: string = ''; // 这个是因为日期选择按钮的传入的日期不能为State修饰的变量
  @State inputNotes: string = '';



  @Builder
  TabBuilder(index: number) {
    Column() {
      Text(index === 0 ? '支出' : '收入')
        .fontSize('16vp')
        .fontColor(this.curIndex === index ? ('#FF007DFF') : Color.Gray)
    }
    .width('48vp')
    .padding({ top: ('17vp'), bottom: ('8vp') })
    .margin({ bottom: ('8vp') })
    .border(this.curIndex === index ? {
                                        width: { bottom: ('2vp') },
                                        color: ('#FF007DFF')
                                      } : { color: Color.White })
  }

  async aboutToAppear() {
    let ss = router.getParams()
    this.newAccount = {
      id: ss['id'],
      accountType: ss['accountType'],
      typeText: ss['typeText'],
      notes: ss['notes'],
      purpose: ss['purpose'],
      amount: ss['amount'],
      date: ss['date']
    };
    this.showDate = this.selectedDate.toDateString()
    this.inputAmount = this.newAccount.amount.toString();
    this.curIndex = this.newAccount.accountType;
    this.curType = this.newAccount.typeText;
    let mm = new manageService()
    await mm.init()
    this.manage_service = mm
  }

  selectAccount(item: recordItem) {
    this.newAccount.accountType = item.accountType;
    this.newAccount.typeText = item.typeText;
    this.curType = item.typeText;
  }

  build() {
    Column() {

      Tabs({ barPosition: BarPosition.Start, index: this.curIndex }) {

        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(this.payList, (item: recordItem) => {
                Column() {
                  Image(this.curType === item.typeText ? item.iconSelected : item.icon)
                    .width('40vp')
                    .aspectRatio(CommonConstants.FULL_SIZE)

                  Text(item.typeText)
                    .fontSize('12vp')
                    .fontColor(this.curType === item.typeText ? Color.White : '#FF007DFF')
                    .margin({ top: ('8vp') })
                }
                .width('86vp')
                .aspectRatio(CommonConstants.FULL_SIZE)
                .padding({ top: ('12vp') })
                .margin({ top: ('16vp'), left: ('12vp') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? '#FF007DFF' : '#FFF1F3F5')
                .borderRadius('16vp')
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .tabBar(this.TabBuilder(0))
        .margin({ bottom: ('36vp') })

        TabContent() {
          Scroll(this.scroller) {
            Row() {
              ForEach(this.earnList, (item: recordItem) => {
                Column() {
                  Image(this.curType === item.typeText ? item.iconSelected : item.icon)
                    .width('40vp')
                    .aspectRatio(CommonConstants.FULL_SIZE)

                  Text(item.typeText)
                    .fontSize('12vp')
                    .fontColor(this.curType === item.typeText ? Color.White : '#FF007DFF')
                    .margin({ top: ('8vp') })
                }
                .width('86vp')
                .aspectRatio(CommonConstants.FULL_SIZE)
                .padding({ top: ('12vp') })
                .margin({ top: ('16vp'), left: ('12vp') })
                .align(Alignment.TopStart)
                .backgroundColor(this.curType === item.typeText ? '#FF007DFF' : '#FFF1F3F5')
                .borderRadius('16vp')
                .onClick(() => {
                  this.selectAccount(item);
                })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .tabBar(this.TabBuilder(1))
        .margin({ bottom: ('36vp') })
      }

      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.TABS_HEIGHT)
      .vertical(false)
      .barMode(BarMode.Fixed)
      .onChange((index) => {
        this.curIndex = index;
      })

      Column() {
        Text(this.showDate)
          .fontSize(20)
          .backgroundColor('#fff1f3f5')
          .width('100%')
          .padding(5)
        Button("选择日期")
          .margin(20)
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date("2000-1-1"),
              end: new Date("2100-12-31"),
              selected: this.selectedDate,
              onAccept: (value: DatePickerResult) => {
                // 通过Date的setFullYear方法设置按下确定按钮时的日期，这样当弹窗再次弹出时显示选中的是上一次确定的日期
                this.selectedDate.setFullYear(value.year, value.month, value.day)
                console.info("DatePickerDialog:onAccept()" + JSON.stringify(value))
                this.showDate = DateToStr(this.selectedDate)
                console.info(this.showDate)
              },
              onCancel: () => {
                console.info("DatePickerDialog:onCancel()")
              },
              onChange: (value: DatePickerResult) => {
                console.info("DatePickerDialog:onChange()" + JSON.stringify(value))
              }
            })
          })
      }
      .width(CommonConstants.FULL_WIDTH)
      .padding({ left: ('12vp'), right: ('12vp') })
        Text('金额')
          .width(CommonConstants.FULL_WIDTH)
          .fontSize('30vp')
          .fontColor(Color.Black)

        Column() {
          TextInput({
            placeholder: ('请输入金额'),
            text: this.newAccount.amount === 0 ? this.inputAmount : this.newAccount.amount.toString()
          })
            .padding({ left: CommonConstants.MINIMUM_SIZE })
            .borderRadius(CommonConstants.MINIMUM_SIZE)
            .backgroundColor(Color.White)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.inputAmount = value;
            })
        }
        .height('48vp')
        .padding({ top: ('15vp'), bottom: ('11vp') })
        .borderWidth({ bottom: CommonConstants.FULL_SIZE })
        .borderColor('#33182431')

        Text('备注')
          .width(CommonConstants.FULL_WIDTH)
          .fontSize('30vp')
          .fontColor(Color.Black)

        Column() {
          TextInput({
            placeholder: ('请输入备注'),
            text: this.newAccount.notes == '' ? this.inputNotes : this.newAccount.notes.toString()
          })
            .padding({ left: CommonConstants.MINIMUM_SIZE })
            .borderRadius(CommonConstants.MINIMUM_SIZE)
            .backgroundColor(Color.White)
            .type(InputType.Normal)
            .onChange((value: string) => {
              this.inputNotes = value;
            })
        }
        .height('48vp')
        .padding({ top: ('15vp'), bottom: ('11vp') })
        .borderWidth({ bottom: CommonConstants.FULL_SIZE })
        .borderColor('#33182431')


      Column() {
        Button() {
          Text('确定')
            .fontSize('16vp')
            .fontColor(Color.White)
        }
        .width(CommonConstants.FULL_WIDTH)
        .height('40vp')
        .onClick(async () => {
          if (this.newAccount.typeText === '' || this.curIndex !== this.newAccount.accountType) {
            prompt.showToast({ message: CommonConstants.TOAST_TEXT_1, bottom: CommonConstants.PROMPT_BOTTOM });
          } else {
            let regex: RegExp = new RegExp('[1-9][0-9]*');
            let matchValue: Array<string> | null = this.inputAmount.match(regex);
            if (matchValue !== null && matchValue[0] === this.inputAmount) {
              this.newAccount.amount = Number(this.inputAmount);
            } else {
              prompt.showToast({ message: CommonConstants.TOAST_TEXT_2, bottom: CommonConstants.PROMPT_BOTTOM });
            }
            this.newAccount.notes = this.inputNotes

            let ttt = DateToStr(this.selectedDate)

            this.newAccount.date = ttt
            await this.manage_service.addRecord(this.newAccount)

          }
          router.back()
        })
      }
      .layoutWeight(CommonConstants.FULL_SIZE)
      .padding({
        bottom: ('24vp'),
        left: ('24vp'),
        right: ('24vp')
      })
      .justifyContent(FlexAlign.End)
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.DIALOG_HEIGHT)
    .borderRadius({ topLeft: ('24vp'), topRight: ('24vp') })
    .backgroundColor(Color.White)
    .align(Alignment.BottomEnd)
  }
}