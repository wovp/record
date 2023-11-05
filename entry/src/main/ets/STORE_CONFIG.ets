import relationalStore from '@ohos.data.relationalStore';
const STORE_CONFIG = {
  name: 'RdbTest.db', // 数据库文件名
  securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
};

export default STORE_CONFIG;