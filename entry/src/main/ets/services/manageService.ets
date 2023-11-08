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
    const updatedValues = { amount: record.amount, notes: record.notes, mytype: record.typeText, purpose: record.purpose, date: record.date, accountType: record.accountType }
    let tt = await this.store.insert('EXPENSES', updatedValues)
    console.info('成功插入')
    console.log('这是' + updatedValues.amount.toString())
    return tt;
  }

  public async deleteRecord(recordId: number): Promise<boolean> {
    // 构建删除条件
    let predicates = new relationalStore.RdbPredicates("EXPENSES");
    predicates.equalTo("ID", recordId);

    // 执行删除操作
    const deleteResult = await this.store.delete(predicates);
    // 返回删除是否成功
    return deleteResult > 0; // 如果删除的行数大于0，表示删除成功
  }

}

export default manageService