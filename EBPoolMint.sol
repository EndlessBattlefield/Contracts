// SPDX-License-Identifier: MIT
/**
 * Endless Battlefield Metaverse Pool Mint
 * https://twitter.com/EBMetaverse
 * https://www.youtube.com/c/ebmetaverse
 */
pragma solidity >=0.6.0 <0.8.0;

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
 
    /**
      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
      * account.
      */
    constructor() public {
        owner = msg.sender;
    }
 
    /**
      * @dev Throws if called by any account other than the owner.
      */
    modifier onlyOwner() {
        require(msg.sender == owner,"Ownable: caller is not the owner");
        _;
    }
 
    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
 
}

contract EBPoolMint is Ownable{
    
    address public token;

    constructor (address _token) public {

        token = _token;

    }

    function approvePool(address pool, uint amount) public onlyOwner {
        IERC20(token).approve(pool, amount);
    }
    
}