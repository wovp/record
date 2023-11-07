import relationalStore from '@ohos.data.relationalStore'; // 导入模块
import STORE_CONFIG from '../STORE_CONFIG'
class dbCreater  {
  public store: relationalStore.RdbStore = null
  async initialize(context: Context) {
    // INSERT INTO YOUR_TABLE_NAME (AMOUNT, NOTES, TYPE, PURPOSE, DATE)
    // VALUES (100.0, 'Some notes', 'Expense', 'Food', '2023-11-05-12:30:00');
    const SQL_CREATE_TABLE = `
      CREATE TABLE IF NOT EXISTS EXPENSES (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        AMOUNT REAL NOT NULL,
        NOTES TEXT,
        accountType REAL,
        MYTYPE TEXT,
        PURPOSE TEXT,
        DATE TEXT
      )
    `;
    try {


      this.store = await new Promise((resolve, reject) => {
        relationalStore.getRdbStore(context, STORE_CONFIG, async (err, store) => {
          if (err) {
            console.error(`Get RdbStore failed, code is ${err.code}, message is ${err.message}`);
            reject(err);
          } else {
            store.executeSql(SQL_CREATE_TABLE); // 创建数据表
            this.store = store;
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