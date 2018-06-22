pragma solidity ^0.4.22;


contract HelloWorld {

  function sayHello() public pure  returns (string) {
    return ("hey world");
  }

  function echo(string name) public pure  returns (string) {
    return name;
  }
}
