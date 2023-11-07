import relationalStore from '@ohos.data.relationalStore';
import Record from '../model/record'
class manageService {
  public store: relationalStore.RdbStore = null
  constructor(store: relationalStore.RdbStore) {
    this.store = store
    console.log('这是传递store');
  }

  public async addRecord(record: Record){
    const updatedValues = { amount: record.amount, notes: record.notes, mytype: record.typeText, purpose: record.purpose, date: record.date }
    let tt = await this.store.insert('EXPENSES', updatedValues)
    return tt;
  }

}

export default manageService