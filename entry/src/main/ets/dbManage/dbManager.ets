import relationalStore from '@ohos.data.relationalStore'; // 导入模块
import STORE_CONFIG from '../STORE_CONFIG'
class dbManager {
  public store: relationalStore.RdbStore = null
  constructor(store: relationalStore.RdbStore) {
    this.store = store
    console.log('这是传递store');
  }
  public insertRecord(amount: number, notes: string, type: string, purpose: string, date: string){
    const valueBucket = {
      "amount": amount,
      "notes": notes,
      "type": type,
      "purpose": purpose,
      "date": date,
    };
    this.store.insert('EXPENSES', valueBucket, function (err, rowId) {
      if (err) {
        console.error(`Insert is failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info(`Insert is successful, rowId = ${rowId}`);
    })
  }

  public async selectAllRecord(){
    let resultSet = await this.store.querySql("SELECT * FROM EXPENSES");
    return resultSet
    // promise.then((resultSet) => {
    //   console.info(`ResultSet column names: ${resultSet.columnNames}`);
    //   console.info(`ResultSet column count: ${resultSet.columnCount}`);
    //   return resultSet
    // }).catch((err) => {
    //   console.error(`Query failed, code is ${err.code},message is ${err.message}`);
    // })
  }
}
export default dbManager;
