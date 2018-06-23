pragma solidity ^0.4.17;

contract SimpleStorage {
    
    struct UserStruct {
        //address provider
        //user
        string name;
        string bankCardNo;//md5
        string idCardNo;//md5
        string phone;//md5
        //loan
        uint amount;
        string loanTime;//client convert it
        string repayStatus;//enum repaying/overdue/done
    }
    mapping(string => UserStruct) private UserStructs;
    // string[] private IdList;
    //存入
    //return 0/1
    function set(string idCardNo, string name, string bankCardNo, string phone, uint amount, string repayStatus) public returns (bool) {
        // uint length = IdList.length;        
        // IdList.push(id);
        UserStructs[idCardNo].name = name;
        UserStructs[idCardNo].idCardNo = idCardNo;
        UserStructs[idCardNo].bankCardNo = bankCardNo;
        UserStructs[idCardNo].phone = phone;
        UserStructs[idCardNo].amount = amount;
        UserStructs[idCardNo].repayStatus = repayStatus;
        return true;
    }
    //获取通过 idCardNo 获取借款信息 
    //todo: 要改address type ？
    //return 完整的结构体
    function get(string idCardNo) public view returns(string retIdCardNo, string retName, uint retAmount) {
        // require(isExist(uid) > -1);
        return (idCardNo, UserStructs[idCardNo].name, UserStructs[idCardNo].amount);
    }
    //是否在黑名单 string idCardNo
    //return true/false
    function isInBlackList(string idCardNo) public pure returns (bool isIn) {
        // require(isExist(idCardNo) > -1);
        return true;
    }
}