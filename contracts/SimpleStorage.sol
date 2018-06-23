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
    /* address BloggerCoinAddress; */
    string public name = "BloggerCoin";
    string public symbol = "BLC";
    uint8 public decimals = 4;
    uint256 public INITIAL_SUPPLY = 1000000;
    function SimpleStorage(){
      balances[msg.sender] = INITIAL_SUPPLY;
      /* BloggerCoinAddress = _bloggerCoinAddress; */
    }
    // string[] private IdList;
    //存入
    //return 0/1
    function set(address provider, string idCardNo, string name, string bankCardNo, string phone, string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus) public returns (bool) {
        /* BloggerCoin bCoin = BloggerCoin(BloggerCoinAddress); */
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
    returns(string loanid, uint amount, string loanTime, uint peroidDay, string repayStatus) {
        // require(isExist(uid) > -1);
        /* balanceOf(userAddr); */
        /* return balanceOf(userAddr); */
        return (idCardNo,  UserStructs[idCardNo].amount, UserStructs[idCardNo].loan[index].loanTime, UserStructs[idCardNo].loan[index].peroidDay, UserStructs[idCardNo].loan[index].repayStatus);
    }
    //是否在黑名单 string idCardNo
    //return true/false
    function isInBlackList(string idCardNo) public pure returns (bool isIn) {
        //todo: query then return
        return true;
    }
    //添加黑名单
    //参数可以为空，但不全为空
    function setBlackList(string idCardNo, string bankCardNo, string phone) public returns(bool) {
        //todo: query then return
        return true;
    }
    //client confirm all loanorder
    function loanAllConfirm(string idCardNo) public returns(bool) {
        UserStructs[idCardNo].isLoansConfirmedByClient = true;
        return true;
    }

}
