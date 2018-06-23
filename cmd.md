step1 编译 : tfc 
step2 migrate/deploy  : tfm /   tfm --reset
step3 tfco console
> SimpleStorage.deployed().then(instance => contract = instance)
> 

contract.set("440184", "Wade", "6227", "186", 1000)
contract.set("440184", "Wade", "6227", "186", 1000, "repaying" )
> contract.get(1)
contract.get("440184")

