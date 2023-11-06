import relationalStore from '@ohos.data.relationalStore'; // 导入模块
import STORE_CONFIG from '../STORE_CONFIG'
class dbManager {
  public store: relationalStore.RdbStore = null
  constructor(store: relationalStore.RdbStore) {
    this.store = store
    console.log('这是传递store');
  }
  public async insertRecord(updatedValues: { amount?: number, notes?: string, type?: string, purpose?: string, date?: string }): Promise<number>{
    let tt = await this.store.insert('EXPENSES', updatedValues)
    return tt;
  }

  public async selectAllRecord(){
    let resultSet = await this.store.querySql("SELECT * FROM EXPENSES");
    return resultSet
  }

  public async updateRecord(recordId: number, updatedValues: { amount?: number, notes?: string, type?: string, purpose?: string, date?: string }): Promise<boolean> {

    let predicates = new relationalStore.RdbPredicates("EXPENSES");
    predicates.equalTo("id", recordId);
    // 执行更新操作
    const tt = await this.store.update(updatedValues, predicates);
    // 返回更新是否成功
    return tt > 0; // 如果更新的行数大于0，表示更新成功
  }

  public async deleteRecord(recordId: number): Promise<boolean> {
    // 构建删除条件
    let predicates = new relationalStore.RdbPredicates("EMPLOYEE");
    predicates.equalTo("id", recordId);

    // 执行删除操作
    const deleteResult = await this.store.delete(predicates);

    // 返回删除是否成功
    return deleteResult > 0; // 如果删除的行数大于0，表示删除成功
  }

  public async selectBySql(sql: string){
    let resultSet = await this.store.querySql(sql);
    return resultSet
  }



}
export default dbManager;
