
@Component
struct DatePickerDialogExample {
  @State selectedDate: Date = new Date("2010-1-1");

  build() {
    Column() {
      Button("DatePickerDialog")
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
            },
            onCancel: () => {
              console.info("DatePickerDialog:onCancel()")
            },
            onChange: (value: DatePickerResult) => {
              console.info("DatePickerDialog:onChange()" + JSON.stringify(value))
            }
          })
        })
    }.width('100%')
  }
}
export default DatePickerDialogExample