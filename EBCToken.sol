// SPDX-License-Identifier: MIT
/**
 * Endless Battlefield Coin
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

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
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
 
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20Basic {
    
    function totalSupply() external virtual view returns (uint256);
    function balanceOf(address who) external virtual view returns (uint256);
    function transfer(address to, uint value) external virtual returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
}
 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) external virtual view returns (uint256);
    function transferFrom(address from, address to, uint value) external virtual returns (bool);
    function approve(address spender, uint value) external virtual returns (bool);
    event Approval(address indexed owner, address indexed spender, uint value);
}
 
/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
abstract contract BasicToken is Ownable, ERC20Basic {
    using SafeMath for uint;
   
    uint public _totalSupply;
    
    mapping(address => uint) public balances;
 
    
    /**
    * @dev Fix for the ERC20 short address attack.
    */
    modifier onlyPayloadSize(uint size) {
        require(!(msg.data.length < size + 4));
        _;
    }
 
    
    function transfer(address _to, uint _value) public virtual override onlyPayloadSize(2 * 32) returns (bool){
        require(_to != address(0),"ERC20: transfer from the zero address");
        balances[msg.sender] = balances[msg.sender].sub(_value,"ERC20: transfer amount exceeds balance");
        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }
 
   
    function balanceOf(address _owner) public virtual override view returns (uint256 balance) {
        return balances[_owner];
    }
 
}
 
/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev 
 */
abstract contract StandardToken is BasicToken, ERC20 {
 
    mapping (address => mapping (address => uint)) public allowed;
 
    uint public constant MAX_UINT = 2**256 - 1;
 
    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint _value) public virtual override onlyPayloadSize(3 * 32) returns (bool){
        uint256 _allowance = allowed[_from][msg.sender];
 
        if (_allowance < MAX_UINT) {
            allowed[_from][msg.sender] = _allowance.sub(_value);
        }
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
 
        emit Transfer(_from, _to, _value);
        return true;
    }
 
    
    function approve(address _spender, uint _value) public virtual override onlyPayloadSize(2 * 32) returns (bool){
 
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
 
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
 
   
    function allowance(address _owner, address _spender) public virtual override view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    
   
}
 
 
/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();
 
  bool public paused = false;
 
 
  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused,"Pausable: paused");
    _;
  }
 
  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused,"Pausable: not paused");
    _;
  }
 
  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }
 
  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}
 
abstract contract BlackList is Ownable, BasicToken {
 
    /// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///
    function getBlackListStatus(address _maker) external view returns (bool) {
        return isBlackListed[_maker];
    }
 
    function getOwner() external view returns (address) {
        return owner;
    }
 
    mapping (address => bool) public isBlackListed;
    
    function addBlackList (address _evilUser) public onlyOwner {
        isBlackListed[_evilUser] = true;
        emit AddedBlackList(_evilUser);
    }
 
    function removeBlackList (address _clearedUser) public onlyOwner {
        isBlackListed[_clearedUser] = false;
        emit RemovedBlackList(_clearedUser);
    }
 
    function destroyBlackFunds (address _blackListedUser) public onlyOwner {
        require(isBlackListed[_blackListedUser]);
        uint dirtyFunds = balanceOf(_blackListedUser);
        balances[_blackListedUser] = 0;
        _totalSupply -= dirtyFunds;
        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
    }
 
    event DestroyedBlackFunds(address _blackListedUser, uint _balance);
 
    event AddedBlackList(address _user);
 
    event RemovedBlackList(address _user);
 
}

abstract contract Roles is Ownable,Context{
    
    mapping (address => bool) private minterUser;
    
    
    modifier onlyMinter() {
        require(isMinter(_msgSender()) || owner == _msgSender(), "MinterRole: caller does not have the Minter role or above");
        _;
    }
  
    
    function isMinter(address account) public view returns (bool) {
        return minterUser[account];
    }

    function addMinter(address account) public onlyOwner{
        minterUser[account] = true;
    }

    function removeMinter(address account) public onlyOwner{
        minterUser[account] = false;
    }
    
    
}
 

contract EBCToken is Pausable, StandardToken, BlackList,Roles {
 
    string public name;
    string public symbol;
    uint public decimals;
   
    constructor() public {
        
        name = "Endless Battlefield Coin";
        symbol = "EBC";
        decimals = 18;
        _totalSupply = 100000 * 10 ** uint256(decimals);
        balances[owner] = _totalSupply;
        
    }
  
    function transfer(address _to, uint _value) public override whenNotPaused returns (bool){
        require(!isBlackListed[msg.sender],"Address locked");
        
        require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
            
        return super.transfer(_to, _value);
        
    }
 
    function transferFrom(address _from, address _to, uint _value) public override whenNotPaused returns (bool){
        require(!isBlackListed[_from],"Address locked");
        
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
            
        return super.transferFrom(_from, _to, _value);
        
    }
 
    function balanceOf(address who) public view override returns (uint256) {
        
        return super.balanceOf(who);
        
    }
 
    function approve(address _spender, uint _value) public override whenNotPaused returns (bool) {
        
        return super.approve(_spender, _value);
    
    }
 
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
        
        return super.allowance(_owner, _spender);
        
    }

 
    function totalSupply() public view override returns (uint256) {
        
        return _totalSupply;
        
    }
    
    function mint(address account, uint256 amount) public onlyMinter{
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        balances[account] = balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    
    function batchMint(address[] memory accounts,uint256[] memory amounts) public onlyMinter{
        
        require(accounts.length == amounts.length , "ERC20: accounts and amounts length mismatch");
        
        for(uint i = 0; i < accounts.length; i++){
             require(accounts[i] != address(0), "ERC20: mint to the zero address");
             
            _totalSupply = _totalSupply.add(amounts[i]);
            balances[accounts[i]] = balances[accounts[i]].add(amounts[i]);
            emit Transfer(address(0), accounts[i], amounts[i]);
        }
        
    }

    
    function burn(address account, uint256 amount) public onlyMinter{
        require(account != address(0), "ERC20: burn from the zero address");

        balances[account] = balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
 
    function batchBurn(address[] memory accounts,uint256[] memory amounts) public onlyMinter{
        
        require(accounts.length == amounts.length , "ERC20: accounts and amounts length mismatch");
        
        for(uint i = 0; i < accounts.length; i++){
             require(accounts[i] != address(0), "ERC20: mint to the zero address");
             
            balances[accounts[i]] = balances[accounts[i]].sub(amounts[i], "ERC20: burn amount exceeds balance");
            _totalSupply = _totalSupply.sub(amounts[i]);
            emit Transfer(accounts[i], address(0), amounts[i]);
            
        }
        
    }
    
 
}
