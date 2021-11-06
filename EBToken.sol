
pragma solidity >=0.6.0 <0.8.0;
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
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
    
    function totalSupply() external virtual view returns (uint);
    function balanceOf(address who) external virtual view returns (uint);
    function transfer(address to, uint value) external virtual;
    event Transfer(address indexed from, address indexed to, uint value);
}
 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) external virtual view returns (uint);
    function transferFrom(address from, address to, uint value) external virtual;
    function approve(address spender, uint value) external virtual;
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
 
    
    function transfer(address _to, uint _value) public virtual override onlyPayloadSize(2 * 32) {
        require(_to != address(0),"ERC20: transfer from the zero address");
        balances[msg.sender] = balances[msg.sender].sub(_value,"ERC20: transfer amount exceeds balance");
        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);
    }
 
   
    function balanceOf(address _owner) public virtual override view returns (uint balance) {
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
    function transferFrom(address _from, address _to, uint _value) public virtual override onlyPayloadSize(3 * 32) {
        uint256 _allowance = allowed[_from][msg.sender];
 
        if (_allowance < MAX_UINT) {
            allowed[_from][msg.sender] = _allowance.sub(_value);
        }
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
 
        emit Transfer(_from, _to, _value);
    }
 
    
    function approve(address _spender, uint _value) public virtual override onlyPayloadSize(2 * 32) {
 
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
 
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
 
   
    function allowance(address _owner, address _spender) public virtual override view returns (uint remaining) {
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
 
abstract contract UpgradedStandardToken is StandardToken{
    // those methods are called by the legacy contract
    // and they must ensure msg.sender to be the contract address
    function transferByLegacy(address from, address to, uint value) public virtual;
    function transferFromByLegacy(address sender, address from, address spender, uint value) public virtual;
    function approveByLegacy(address from, address spender, uint value) public virtual;
}
 
contract EBToken is Pausable, StandardToken, BlackList {
 
    string public name;
    string public symbol;
    uint public decimals;
    address public upgradedAddress;
    bool public deprecated;

    mapping(address => uint256) timestamp;        //Each address corresponds to a timestamp.
    mapping(address => uint256) distBalances;     //list of distributed balance of each address to calculate restricted amount
    uint public baseStartTime;                    //All other time spots are calculated based on this time spot.
    mapping(address => uint256) unlockNum;

    uint256 public total;

   
    constructor() public {
        
        name = "Endless Battlefield Token";
        symbol = "EB";
        decimals = 18;
        _totalSupply = 0;
        total = 1000000000 * (10 ** uint256(decimals));
        deprecated = false;
        baseStartTime = block.timestamp;
    }

    function setStartTime(uint _startTime) public onlyOwner {
            baseStartTime = _startTime;
    }


    function distribute(uint256 _amount, address _to, uint256 _unlockNum, uint256 _startTime) public onlyOwner {
            
        require((_to == owner) || ((_to != owner) && (distBalances[_to] == 0))); //每个账号只能分发一次
 
        require(_totalSupply + _amount >= _totalSupply);
        require(_totalSupply + _amount <= total,"Exceeding the maximum limit");
 
        _totalSupply = _totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        distBalances[_to] = distBalances[_to].add(_amount);
        unlockNum[_to] = unlockNum[_to].add(_unlockNum);
        timestamp[_to] = _startTime > 0 ? _startTime : block.timestamp;                        //分发的时候记录时间戳，用于计算freeAmount
 
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transfer(address _to, uint _value) public override whenNotPaused {
        require(!isBlackListed[msg.sender]);
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
        } else {
            require(now > baseStartTime,"Less than unlock time");
            require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
            uint _freeAmount = freeAmount(msg.sender);
            require(_freeAmount >= _value);
            
            return super.transfer(_to, _value);
        }
    }
 
    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function transferFrom(address _from, address _to, uint _value) public override whenNotPaused {
        require(!isBlackListed[_from]);
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
        } else {
            require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
            uint _freeAmount = freeAmount(msg.sender);
            require(_freeAmount >= _value);
            return super.transferFrom(_from, _to, _value);
        }
    }
 
    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function balanceOf(address who) public view override returns (uint) {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).balanceOf(who);
        } else {
            return super.balanceOf(who);
        }
    }
 
    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function approve(address _spender, uint _value) public override onlyPayloadSize(2 * 32) {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
        } else {
            return super.approve(_spender, _value);
        }
    }
 
    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function allowance(address _owner, address _spender) public view override returns (uint remaining) {
        if (deprecated) {
            return StandardToken(upgradedAddress).allowance(_owner, _spender);
        } else {
            return super.allowance(_owner, _spender);
        }
    }

    function freeAmount(address user) internal view returns (uint256 amount) {
        uint monthDiff;
        uint unrestricted;

        if (user == owner) {
            return balances[user];
        }
        
        if (now < baseStartTime) {
            return 0;
        }
        
        if (now < timestamp[user]) {
            monthDiff = 0;
        }else{
            monthDiff = (now.sub(timestamp[user])) / (30 days);
            
		}
        
        if (monthDiff >= unlockNum[user]) {
            return balances[user];
        }
        
        if (now < timestamp[user]) {
            unrestricted = 0;
        }else{
            unrestricted = distBalances[user].div(unlockNum[user]).mul(monthDiff);
        }

        if (unrestricted > distBalances[user]) {
            unrestricted = distBalances[user];
        }

        if (unrestricted + balances[user] < distBalances[user]) {
            amount = 0;
        } else {
            amount = unrestricted.add(balances[user]).sub(distBalances[user]);
        }
 
        return amount;
    }    

    function getFreeAmount(address user) public view returns (uint256 amount) {
            amount = freeAmount(user);
            return amount;
    }
 
    function getRestrictedAmount(address user) public view returns (uint256 amount) {
            amount = balances[user] - freeAmount(user);
            return amount;
    }
    // deprecate current contract in favour of a new one
    function deprecate(address _upgradedAddress) public onlyOwner {
        deprecated = true;
        upgradedAddress = _upgradedAddress;
        emit Deprecate(_upgradedAddress);
    }
 
    // deprecate current contract if favour of a new one
    function totalSupply() public view override returns (uint) {
        if (deprecated) {
            return StandardToken(upgradedAddress).totalSupply();
        } else {
            return _totalSupply;
        }
    }
 
    // Called when contract is deprecated
    event Deprecate(address newAddress);
 
    // Called if contract ever adds fees
    event Params(uint feeBasisPoints, uint maxFee);
}