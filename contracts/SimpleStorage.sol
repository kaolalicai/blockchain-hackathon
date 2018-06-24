pragma solidity ^0.4.17;
// pragma experimental ABIEncoderV2;
import "./BloggerCoin.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract SimpleStorage is StandardToken {
    struct LoanStruct {
        address provider;
        string loanid;
        uint amount;
        string loanTime;//client need to convert it
        uint peroidDay;//30 60 90 120
        string repayStatus;//enum repaying/overdue/done
    }
    // LoanStruct[] loans;
    struct UserStruct {
        //user
        string name;
        string bankCardNo;//md5
        string idCardNo;//md5
        string phone;//md5
        uint amount;//totalamount
        LoanStruct[] loan;
        bool isLoansConfirmedByClient;
        // mapping (string => LoanStruct) loan;
    }
    mapping(string => UserStruct) private UserStructs;
    string public name = "BloggerCoin";
    string public symbol = "BLC";
    uint8 public decimals = 4;
    uint256 public INITIAL_SUPPLY = 1000000;
    function SimpleStorage(){
      balances[msg.sender] = INITIAL_SUPPLY;
    }

    struct BlackList {
        address provider;
        string name;
        string bankCardNo;//md5
        string idCardNo;//md5
        string phone;//md5
    }
    mapping(string => BlackList) private BlackLists;    
    function transferF(address _from, address _to, uint256 _value) public returns (bool) {
      require(_to != address(0));
      require(_value <= balances[_from]);

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }    
    function getLoanCount(address userAddr, string idCardNo) public view returns (uint) {
        if(balanceOf(userAddr) > 0)
            return UserStructs[idCardNo].loan.length;
        return uint(-1);
    }
    //存入
    //return 0/1
    function set(address provider, string idCardNo, string name, string bankCardNo, string phone,
     string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus) public returns (bool) {
        //todo : if not md5 return false;
        UserStructs[idCardNo].name = name;
        UserStructs[idCardNo].idCardNo = idCardNo;
        UserStructs[idCardNo].bankCardNo = bankCardNo;
        UserStructs[idCardNo].phone = phone;
        UserStructs[idCardNo].amount = amount;//todo totalamount

        LoanStruct memory lo = LoanStruct(provider, loanid, amount, loanTime, peroidDay, repayStatus);
        UserStructs[idCardNo].loan.push(lo);//todo: bug not just append ,should set to the same id
        
        uploadBonus(provider);
        agreementSettle(idCardNo, provider, repayStatus);
        return true;
    }
    //获取通过 idCardNo 获取借款信息
    //return 完整的结构体
    function get(address userAddr, string idCardNo, uint index) public
    returns(address provider, string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus) {
        transferF(userAddr, UserStructs[idCardNo].loan[index].provider, 10);
        return (UserStructs[idCardNo].loan[index].provider, UserStructs[idCardNo].loan[index].loanid, UserStructs[idCardNo].amount, UserStructs[idCardNo].loan[index].loanTime, UserStructs[idCardNo].loan[index].peroidDay, UserStructs[idCardNo].loan[index].repayStatus);
    }
    // function get(address userAddr, string idCardNo, uint index) 
    // public returns(address provider, string loanid, uint amount, 
    // string loanTime, uint peroidDay, string repayStatus) {
    //     LoanStruct lo = UserStructs[idCardNo].loan[index];
    //     // downloadCost(userAddr, lo.provider);
    //     return (lo.provider, lo.loanid, UserStructs[idCardNo].amount, lo.loanTime, lo.peroidDay, lo.repayStatus);
    // }
    //是否在黑名单 string idCardNo
    //return true/false
    function isInBlackList(string idCardNo) public view returns (bool) {
        if (compareStrings(BlackLists[idCardNo].idCardNo, "")) {
            return false;
        }
        return true;
    }
    function compareStrings (string a, string b) view returns (bool) {
       return keccak256(a) == keccak256(b);
    }
    //添加黑名单
    //参数可以为空，但不全为空
    function setBlackList(address provider, string idCardNo, string name, string bankCardNo, string phone) 
    public returns(bool) {
        //todo : if not md5 return false;
        BlackLists[idCardNo].provider = provider;
        BlackLists[idCardNo].name = name;
        BlackLists[idCardNo].idCardNo = idCardNo;
        BlackLists[idCardNo].bankCardNo = bankCardNo;
        BlackLists[idCardNo].phone = phone;
        return true;
    }  
    function downloadCost(address reader, address provider) returns (bool){
        return transferF(reader, provider, 10);
    } 
    function uploadBonus(address provider) returns (bool){
        return transfer(provider,100);
    }
    // function agreementSettle(UserStruct us) returns (bool) {
    function agreementSettle(string idCardNo, address provider, string repayStatus) returns (bool) {    
        address voter = msg.sender;
        assert(provider != voter); //自己不能disagree & agree自己
        if(compareStrings(repayStatus, "done") && isInBlackList(idCardNo)){
            disagree(provider, voter);
        }
        else if(compareStrings(repayStatus, "overdue") && isInBlackList(idCardNo)) {
            agree(provider, voter);
        }
    } 
    //client confirm all loanorder
    //奖惩策略：provider 平台得到奖励
    function loanAllConfirm(string idCardNo) public returns (bool) {
        UserStructs[idCardNo].isLoansConfirmedByClient = true;
        address voter = msg.sender;
        agree(UserStructs[idCardNo].loan[0].provider, voter); //todo 只处理了第一个loan
        return true;
    }
    //奖惩策略：
    //  A平台贡献case: 已有黑名单，但B平台放款了，借款人逾期不还款。
    //  触发时机：有逾期数据上传时
    //  奖惩罚量: provider + 10, voter + 1
    //todo 逾期不一定坏账
    function agree(address provider, address voter) returns (bool){
        transfer(provider, 10);
        transfer(voter, 1);
    }
    //奖惩策略：A平台(provider)作恶case: 已有黑名单，B平台(voter)放款了，借款人正常还款。
    //  触发时机：有正常还款数据上传时
    //  奖惩罚量: provider - 10 , voter + 10
    function disagree(address provider, address voter) returns (bool){
        transferF(provider, voter, 10);
    }
}
