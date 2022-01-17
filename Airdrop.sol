// SPDX-License-Identifier: MIT
/**
 * Endless Battlefield Airdrop
 * https://ebgame.io
 * https://github.com/EndlessBattlefield
 * https://twitter.com/EBMetaverse
 * https://www.youtube.com/c/ebmetaverse
 */

pragma solidity >=0.6.0 <0.8.0;


library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
}
library Address {
    
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Airdrop{

    using SafeMath for uint256;
    using Address for address;

    address public owner;


    mapping(address => uint) internal userCount;

    address public rewardToken;// 奖励token

    modifier onlyOwner() {
        require(msg.sender == owner,"Ownable: caller is not the owner");
        _;
    }

    constructor(address _rewardToken) public {
        
        rewardToken = _rewardToken;
        owner = msg.sender;
        
    }

    function setRewardToken(address _newToken) public onlyOwner{

        rewardToken = _newToken;
    }
    

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function rand(uint256 _length) public view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(
                    (block.timestamp) +
                    (block.difficulty) +
                    (block.gaslimit) +
                    (block.number),now
                ))) % 1000000;
                
    return random % _length;

    }
    
    receive() payable external{
        
        uint randValue = rand(5);
        
        require(!address(msg.sender).isContract(), "Address: call to non-contract");
        
        uint _balance = IERC20(rewardToken).balanceOf(address(this));

        if(randValue == 2 && userCount[msg.sender] < 10 && _balance > 1 ether){
        
            IERC20(rewardToken).transfer(msg.sender,1 ether);
            
            userCount[msg.sender] = userCount[msg.sender].add(1);

        }
        
    }

}