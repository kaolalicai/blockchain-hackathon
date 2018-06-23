pragma solidity ^0.4.17;

contract SimpleStorage {
    
    struct UserStruct {
        //address provider
        //user
        string name;
        string bankcardNo;//md5
        string idCardNo;//md5
        string phone;//md5
        //loan
        uint amount;
        string loanTime;//client convert it
    }
    mapping(uint => UserStruct) private UserStructs;
    uint[] private IdList;
    //存入
    //return 0/1
    function set(string name, string idCardNo, string barnkcardNo, string phone, uint amount) public returns (uint uid) {
        uint length = IdList.length;
        uint id;
        if ( length == 0 ) {
            id = 1;
        } else {
            id = IdList[length-1]+1;
        }
        IdList.push(id);
        uid = IdList.length;
        UserStructs[id].name = name;
        UserStructs[id].amount = amount;
        return 0;
    }
    //获取通过 idCardNo 获取借款信息 
    //todo: 要改address type ？
    //return 完整的结构体
    function get(uint uid) public view returns(uint retUid,string retName, uint retAmount) {
        // require(isExist(uid) > -1);
        return (uid, UserStructs[uid].name, UserStructs[uid].amount);
    }
    //是否在黑名单
    //return true/false
    function isInBlackList(string idCardNo) public pure returns (bool isIn) {
        return true;
    }
}