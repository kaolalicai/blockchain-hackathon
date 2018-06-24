pragma solidity ^0.4.17;
// pragma experimental ABIEncoderV2;
import "./BloggerCoin.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
contract SimpleStorage is StandardToken {
    struct LoanStruct {
        string loanid;
        uint amount;
        string loanTime;//client need to convert it
        uint peroidDay;//30 60 90 120
        string repayStatus;//enum repaying/overdue/done
    }
    // LoanStruct[] loans;
    struct UserStruct {
        address provider;
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
    // string[] private IdList;
    //存入
    //return 0/1
    function transferF(address _from, address _to, uint256 _value) public returns (bool) {
      require(_to != address(0));
      require(_value <= balances[_from]);

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }
    function set(address provider, string idCardNo, string name, string bankCardNo, string phone, string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus) public returns (bool) {
        //todo : if not md5 return false;
        UserStructs[idCardNo].provider = provider;
        UserStructs[idCardNo].name = name;
        UserStructs[idCardNo].idCardNo = idCardNo;
        UserStructs[idCardNo].bankCardNo = bankCardNo;
        UserStructs[idCardNo].phone = phone;
        UserStructs[idCardNo].amount = amount;//todo totalamount

        LoanStruct memory lo = LoanStruct(loanid, amount, loanTime, peroidDay, repayStatus);
        UserStructs[idCardNo].loan.push(lo);//todo: bug not just append ,should set to the same id
        transfer(provider,100);//contract.transfer(web3.eth.accounts[1], 600000)
        /* bCoin.balances[provider] += 100; */
        /* console.log('###########=>',bCoin.balanceOf(provider)); */
        /* bCoin.transfer('0x0ea55A7c5B6D1188890578180b6cF4DbBd322d3b', 100); */
        return true;
    }
    function getLoanCount(address userAddr, string idCardNo) public view returns (uint256) {
      if(balanceOf(userAddr) <= 0) {
        return balanceOf(userAddr);
      }
      return UserStructs[idCardNo].loan.length;
    }
    //获取通过 idCardNo 获取借款信息
    //return 完整的结构体
    function get(address userAddr, string idCardNo, uint index) public view
    returns(string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus, address provider) {
        // require(isExist(uid) > -1);
        /* balanceOf(userAddr); */
        /* return balanceOf(userAddr); */
        transferF(userAddr, UserStructs[idCardNo].loan[index].provider, 10);
        return (idCardNo,  UserStructs[idCardNo].amount, UserStructs[idCardNo].loan[index].loanTime, UserStructs[idCardNo].loan[index].peroidDay, UserStructs[idCardNo].loan[index].repayStatus, UserStructs[idCardNo].loan[index].provider);
    }
    //是否在黑名单 string idCardNo
    //return true/false
    function isInBlackList(string idCardNo) public view returns (bool isIn) {
        //todo: query then return
        if (compareStrings(BlackLists[idCardNo].idCardNo , "")) {
            return false;
        }
        return true;
    }
    function compareStrings (string a, string b) view returns (bool) {
       return keccak256(a) == keccak256(b);
    }
    //添加黑名单
    //参数可以为空，但不全为空
    function setBlackList(address provider, string idCardNo, string name, string bankCardNo, string phone) public returns(bool) {
        //todo : if not md5 return false;
        BlackLists[idCardNo].provider = provider;
        BlackLists[idCardNo].name = name;
        BlackLists[idCardNo].idCardNo = idCardNo;
        BlackLists[idCardNo].bankCardNo = bankCardNo;
        BlackLists[idCardNo].phone = phone;
        return true;
    }
    //client confirm all loanorder
    function loanAllConfirm(string idCardNo) public returns(bool) {
        UserStructs[idCardNo].isLoansConfirmedByClient = true;
        return true;
    }


}
