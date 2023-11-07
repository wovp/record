import relationalStore from '@ohos.data.relationalStore';
import Record from '../model/record'
import STORE_CONFIG from '../STORE_CONFIG'
class manageService {
  public store: relationalStore.RdbStore = null
  async init() {
    let store = await relationalStore.getRdbStore(getContext(), STORE_CONFIG)
    this.store = store
    console.log('这是传递store');
  }

  public async addRecord(record: Record){
    const updatedValues = { amount: record.amount, notes: record.notes, mytype: record.typeText, purpose: record.purpose, date: record.date }
    let tt = await this.store.insert('EXPENSES', updatedValues)
    console.info('成功插入')
    console.log('这是' + updatedValues.amount.toString())
    return tt;
  }

}

export default manageService