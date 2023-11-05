import relationalStore from '@ohos.data.relationalStore'; // 导入模块
import STORE_CONFIG from '../STORE_CONFIG'
class dbCreater  {
  public store: relationalStore.RdbStore = null
  async initialize(context: Context) {
    const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB)';
    try {
      this.store = await new Promise((resolve, reject) => {
        relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
          if (err) {
            console.error(`Get RdbStore failed, code is ${err.code}, message is ${err.message}`);
            reject(err);
          } else {
            console.info(`这是创建数据库`);
            store.executeSql(SQL_CREATE_TABLE); // 创建数据表
            this.store = store
            resolve(store);
          }
        });
      });
    } catch (err) {
      console.error('初始化失败:', err);
      throw err;
    }
  }
}
export default dbCreater