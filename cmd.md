### test manual
step1 编译 : tfc 
step2 migrate/deploy  : tfm /   tfm --reset
step3 tfco console
> 
SimpleStorage.deployed().then(instance => contract = instance)
> 

contract.set("440184", "Wade", "6227", "186", 1000)
contract.set("440184", "Wade", "6227", "186", 1000, "repaying" )
contract.set("440184", "Wade", "6227", "186", '5d0', 1000, "repaying" )
contract.set("0x555", "440184", "Wade", "6227", "186", "5d0", 1000, "2018-06-23T09:07:57" , 60, "repaying" )

contract.setBlackList("0x555", "440184", "Wade", "6227", "186")
contract.isInBlackList("440184")
contract.isInBlackList("440185")

> contract.get(1)
contract.get("440184", 1)
contract.getLoanCount("440184")

### FAQ
Error: VM Exception while processing transaction: invalid opcode
-- out of index

Error: Invalid number of arguments to Solidity function
-- 参数不对
