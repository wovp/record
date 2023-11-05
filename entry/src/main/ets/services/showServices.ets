import relationalStore from '@ohos.data.relationalStore';
import dbManager from '../dbManage/dbManager';
class showService{
  public rowName = ['ID', 'AMOUNT', 'NOTES', 'TYPE', 'PURPOSE', 'DATE']
  public store: relationalStore.RdbStore = null
  public dbManage: dbManager
  constructor(store: relationalStore.RdbStore) {
    // 传递store
    this.store = store
    console.log('这是传递store');
    this.dbManage = new dbManager(this.store)
  }
  public async showAllRecord(){
    let resultSet = await this.dbManage.selectAllRecord()
    // 遍历所有的行，取出json数据，放到json数组中
    let list_records: any[] = [];
    for(let i = 0; i < resultSet.rowCount; i++){
      resultSet.goToNextRow()
      let record = {};
      for(let j = 0; j < this.rowName.length; j++){

        let k = resultSet.getColumnIndex(this.rowName[j])
        if (this.rowName[j] == 'ID') {
          record[this.rowName[j]] = resultSet.getLong(k)
        }
        else if (this.rowName[j] == 'AMOUNT') {
          record[this.rowName[j]] = resultSet.getDouble(k)
        }
        else {
          record[this.rowName[j]] = resultSet.getString(k)
        }
      }
      list_records.push(record)
    }
    return list_records
  }
}
export default showService