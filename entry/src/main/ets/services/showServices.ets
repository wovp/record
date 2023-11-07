import relationalStore from '@ohos.data.relationalStore';
import dbManager from '../dbManage/dbManager';
import Record from '../model/record';
class showService{
  public rowName = ['ID', 'AMOUNT', 'NOTES', 'MYTYPE', 'PURPOSE', 'DATE', 'ACCOUNTTYPE']
  public store: relationalStore.RdbStore = null
  public dbManage: dbManager
  constructor(store: relationalStore.RdbStore) {
    this.store = store
    this.dbManage = new dbManager(this.store)
  }

  public async showAllRecord(): Promise<any[]> {
    let resultSet = await this.dbManage.selectAllRecord()
    // 遍历所有的行，取出json数据，放到json数组中
    let list_records: Record[] = [];
    for(let i = 0; i < resultSet.rowCount; i++){
      if(!resultSet.isEnded){
        resultSet.goToNextRow()
      }
      let record = {};
      for(let j = 0; j < this.rowName.length; j++){

        let k = resultSet.getColumnIndex(this.rowName[j])
        if (this.rowName[j] == 'ID' || this.rowName[j] == 'ACCOUNTTYPE') {
          record[this.rowName[j]] = resultSet.getLong(k)
        }
        else if (this.rowName[j] == 'AMOUNT') {
          record[this.rowName[j]] = resultSet.getDouble(k)
        }
        else {
          record[this.rowName[j]] = resultSet.getString(k)
        }
      }
      let re: Record = new Record()
      re.id = record['ID']
      re.amount = record['AMOUNT']
      re.notes = record['NOTES']
      re.typeText = record['MYTYPE']
      re.purpose = record['PURPOSE']
      re.date = record['DATE']
      re.accountType = record['ACCOUNTTYPE']
      list_records.push(re)
    }
    return list_records
  }
  // const startTime = '2023-11-01 00:00:00';
  // const endTime = '2023-11-05 23:59:59';
  public async getRecordsByTimeRange(startTime: string, endTime: string): Promise<any[]> {
    // 构建查询条件
    const condition = `DATE BETWEEN '${startTime}' AND '${endTime}'`;

    // 执行查询操作
    const resultSet = await this.store.querySql(`SELECT * FROM EXPENSES WHERE ${condition}`);

    // 处理查询结果，转换为数组格式
    const records: any[] = [];
    for(let i = 0; i < resultSet.rowCount; i++){
      if(!resultSet.isEnded){
        resultSet.goToNextRow()
      }
      let record = {};
      for (let j = 0; j < this.rowName.length; j++) {
        let k = resultSet.getColumnIndex(this.rowName[j]);
        if (this.rowName[j] == 'ID') {
          record[this.rowName[j]] = resultSet.getLong(k);
        } else if (this.rowName[j] == 'AMOUNT') {
          record[this.rowName[j]] = resultSet.getDouble(k);
        } else {
          record[this.rowName[j]] = resultSet.getString(k);
        }
      }
      records.push(record);
    }
    return records;
  }

  public async getRecordsByCategory(category: string): Promise<any[]> {
    // 构建查询条件
    const condition = `TYPE = '${category}'`;

    // 执行查询操作
    const resultSet = await this.store.querySql(`SELECT * FROM EXPENSES WHERE ${condition}`);

    // 处理查询结果，转换为数组格式
    const records: any[] = [];
    for(let i = 0; i < resultSet.rowCount; i++){
      if(!resultSet.isEnded){
        resultSet.goToNextRow()
      }
      let record = {};
      for (let j = 0; j < this.rowName.length; j++) {
        let k = resultSet.getColumnIndex(this.rowName[j]);
        if (this.rowName[j] == 'ID') {
          record[this.rowName[j]] = resultSet.getLong(k);
        } else if (this.rowName[j] == 'AMOUNT') {
          record[this.rowName[j]] = resultSet.getDouble(k);
        } else {
          record[this.rowName[j]] = resultSet.getString(k);
        }
      }
      records.push(record);
    }

    return records;
  }

  public async getRecordsByAmountRange(minAmount: number, maxAmount: number): Promise<any[]> {
    // 构建查询条件
    const condition = `AMOUNT >= ${minAmount} AND AMOUNT <= ${maxAmount}`;

    // 执行查询操作
    const resultSet = await this.store.querySql(`SELECT * FROM EXPENSES WHERE ${condition}`);

    // 处理查询结果，转换为数组格式
    const records: any[] = [];
    for(let i = 0; i < resultSet.rowCount; i++){
      if(!resultSet.isEnded){
        resultSet.goToNextRow()
      }
      let record = {};
      for (let j = 0; j < this.rowName.length; j++) {
        let k = resultSet.getColumnIndex(this.rowName[j]);
        if (this.rowName[j] == 'ID') {
          record[this.rowName[j]] = resultSet.getLong(k);
        } else if (this.rowName[j] == 'AMOUNT') {
          record[this.rowName[j]] = resultSet.getDouble(k);
        } else {
          record[this.rowName[j]] = resultSet.getString(k);
        }
      }
      records.push(record);
    }

    return records;
  }


}
export default showService