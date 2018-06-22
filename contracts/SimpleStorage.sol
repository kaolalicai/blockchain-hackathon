pragma solidity ^0.4.17;

contract SimpleStorage {
    struct UserStruct {
        string name;
        uint age;
    }
    mapping(uint => UserStruct) private UserStructs;
    uint[] private IdList;

    function set(string name, uint age) public returns (uint uid) {
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
        UserStructs[id].age = age;
        return uid;
    }

    function get(uint uid) public view returns(uint retUid,string retName, uint retAge){
        // require(isExist(uid) > -1);
        return (uid,UserStructs[uid].name, UserStructs[uid].age);
    }
}