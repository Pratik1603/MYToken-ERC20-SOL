// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyToken{

    string public name="MyToken";
    string public symbol="MT";
    string public standard="MyTokn v.0.1";
    uint public totalSply;
    uint public user_id;
    
    address public owner;
    address[] public tokenHolder;

    event Transfer(address indexed _from,address indexed _to,uint _value);
   
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint _value
    );
    
    mapping (address=>mapping(address=>uint))public allowance;
    mapping (address =>TokenHolderInfo) public tokenHolderInfos;

    struct TokenHolderInfo {
        uint _tokenid;
        address _from;
        address _to;
        uint _totalToken;
        bool _tokenHolder;
    }

    mapping (address=>uint) public balanceOf;

    constructor(uint _initialSply){
        owner=msg.sender;
        balanceOf[msg.sender]=_initialSply;
        totalSply=_initialSply;
    }
    function inc()internal{
        ++user_id;
    }
    function transfer(address _to,uint _value) public returns(bool success){

        require(balanceOf[msg.sender]>=_value);
        inc();

        balanceOf[msg.sender]-=_value;
        balanceOf[_to]+=_value;
        TokenHolderInfo storage tokenHolderInfo=tokenHolderInfos[_to];
        tokenHolderInfo._to=_to;
        tokenHolderInfo._from=msg.sender;
        tokenHolderInfo._totalToken=_value;
        tokenHolderInfo._tokenid=user_id;
        tokenHolder.push(_to);
        emit Transfer(msg.sender,_to,_value);
        return true;
    }
    function approve(address _spender,uint _value)public returns(bool success){
       allowance[msg.sender][_spender]=_value;
       emit Approval(msg.sender,_spender,_value);
       return true;
    }
    function transferFrom(address _from,address _to,uint _value)public returns(bool success){
        balanceOf[_from]-=_value;
        balanceOf[_to]+=_value;
        allowance[_from][msg.sender]-=_value;
        emit Transfer(_from,_to,_value);
        return true;
    }
    function getTokenHolderData(address _address)public view returns (uint,address,address,uint,bool){
        return(tokenHolderInfos[_address]._tokenid,
               tokenHolderInfos[_address]._to,
               tokenHolderInfos[_address]._from,
               tokenHolderInfos[_address]._totalToken,
               tokenHolderInfos[_address]._tokenHolder
        );
    }
    function getTokenHolder()public view returns(address[] memory){
        return tokenHolder;
    }
}
