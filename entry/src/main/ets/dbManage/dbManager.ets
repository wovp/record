import relationalStore from '@ohos.data.relationalStore'; // 导入模块
import STORE_CONFIG from '../STORE_CONFIG'
class dbManager {
  public store: relationalStore.RdbStore = null
  constructor(store: relationalStore.RdbStore) {
    // 传递store
    this.store = store
    console.log('这是传递store');
  }
}
export default dbManager