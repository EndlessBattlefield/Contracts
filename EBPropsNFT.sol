// SPDX-License-Identifier: MIT
/**
 * Endless Battlefield Metaverse 
 * https://twitter.com/EBMetaverse
 * https://www.youtube.com/c/ebmetaverse
 */
pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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

library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


library Address {
    
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

   
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}



abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () public{
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

   
    function owner() public view returns (address) {
        return _owner;
    }

  
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

 
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }


    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


abstract contract Roles is Ownable{
    
    mapping (address => bool) private minterUser;
    mapping(address => bool) private burnUser;
    
    modifier onlyMinter() {
        require(isMinter(_msgSender()) || owner() == _msgSender(), "MinterRole: caller does not have the Minter role or above");
        _;
    }
    modifier onlyBurn() {
        require(isBurn(_msgSender()) || owner() == _msgSender(), "MinterRole: caller does not have the Burn role or above");
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
    
    function isBurn(address account) public view returns (bool) {
        return burnUser[account];
    }

    function addBurn(address account) public onlyOwner{
        burnUser[account] = true;
    }

    function removeBurn(address account) public onlyOwner{
        burnUser[account] = false;
    }

}



abstract contract Pausable is Context {
    
    event Paused(address account);

    
    event Unpaused(address account);

    bool private _paused;

    
    constructor () public {
        _paused = false;
    }

    
    function paused() public view returns (bool) {
        return _paused;
    }

    
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}



contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
 
    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;
 
    constructor () public {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }
 
    
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }
 
    
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}


interface IERC1155Receiver is IERC165 {
 
    
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external
        returns(bytes4);
 
    
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external
        returns(bytes4);
}


interface IERC1155 is IERC165 {
    
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
 
    
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
 
    
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
 
    
    event URI(string value, uint256 indexed id);
 
    
    function balanceOf(address account, uint256 id) external view returns (uint256);
 
    
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
 
    
    function setApprovalForAll(address operator, bool approved) external;
 
    
    function isApprovedForAll(address account, address operator) external view returns (bool);
 
    
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
 
    
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}


interface IERC1155MetadataURI is IERC1155 {
    
    function uri(uint256 id) external view returns (string memory);
}


contract EBCN is Context, ERC165, IERC1155, IERC1155MetadataURI,Pausable {
    using SafeMath for uint256;
    using Address for address;
    
    // ID => token cap, if a token cap is set to zero, then there is no token cap
    mapping (uint256 => uint256) private caps;
    
     // ID => uri
    mapping (uint256 => string) private uris;
    
    
    uint256 private _currentTokenID = 0;
    
    struct AddressSet {
        // Storage of set values
        address[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (address => uint256) _indexes;
    }
    
    struct Uint256Set {
        // Storage of set values
        uint256[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (uint256 => uint256) _indexes;
    }
    

    // holder address => their (enumerable) set of owned tokens
    mapping (address => Uint256Set) private holderTokens;
    mapping (uint256 => AddressSet) private owners;
    
    
    // Mapping from token ID to account balances
    mapping (uint256 => mapping(address => uint256)) private _balances;
 
    // Mapping from account to operator approvals
    mapping (address => mapping(address => bool)) private _operatorApprovals;
 
    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;
    
    /*
     *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
     *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
     *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
     *
     *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
     *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
     */
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
 
    /*
     *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
     */
    bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
 
    /**
     * @dev See {_setURI}.
     */
    constructor (string memory _uris) public{
        _setURI(_uris);
 
        // register the supported interfaces to conform to ERC1155 via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155);
 
        // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
        _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
    }
    
    
    function tokensOf(address owner) public view returns (uint256[] memory) {
        return holderTokens[owner]._values;
    }

    function getNextTokenID() public view returns (uint256) {
        return _currentTokenID.add(1);
    }
    function _getNextTokenID() private view returns (uint256) {
        return _currentTokenID.add(1);
    }
    function _incrementTokenTypeId() private  {
        _currentTokenID ++;
    }
  
 
    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
 
    function uri(uint256 _id) external view override returns (string memory) {
        return uris[_id];
    }
    
    function categoryOf(uint256 _id) public view returns (uint256 categoryId) {
        
        return caps[_id];
    }
    
    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }
 
    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    )
        public
        view
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
 
        uint256[] memory batchBalances = new uint256[](accounts.length);
 
        for (uint256 i = 0; i < accounts.length; ++i) {
            require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
            batchBalances[i] = _balances[ids[i]][accounts[i]];
        }
 
        return batchBalances;
    }
    
 

    function ownerOf(uint256 _id) public view returns (address[] memory) {
        return owners[_id]._values;
    }
 
    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(_msgSender() != operator, "ERC1155: setting approval status for self");
 
        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }
 
    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view override returns (bool) {
        return _operatorApprovals[account][operator];
    }
 
    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    )
        public
        virtual
        override
        whenNotPaused
    {
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
 
        _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
        _balances[id][to] = _balances[id][to].add(amount);
 
        emit TransferSingle(operator, from, to, id, amount);
 
        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
        
        
        if (balanceOf(from, id) == 0) {
            setRemove(from, id);
        }

        setAdd(to, id);
            
    }
 
    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        public
        virtual
        override
        whenNotPaused
    {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, from, to, ids, amounts, data);
 
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];
 
            _balances[id][from] = _balances[id][from].sub(
                amount,
                "ERC1155: insufficient balance for transfer"
            );
            _balances[id][to] = _balances[id][to].add(amount);
            
        }
 
        emit TransferBatch(operator, from, to, ids, amounts);
 
        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
        
        
        for (uint256 i = 0; i < ids.length; i++) {
            if (balanceOf(from, ids[i]) == 0) {
                setRemove(from, ids[i]);
            }

            setAdd(to, ids[i]);
        }
    }
 
    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }
 
    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
        require(account != address(0), "ERC1155: mint to the zero address");
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
 
        _balances[id][account] = _balances[id][account].add(amount);
        emit TransferSingle(operator, address(0), account, id, amount);
 
        _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
    }
 
    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
 
        for (uint i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
        }
 
        emit TransferBatch(operator, address(0), to, ids, amounts);
 
        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }
    
    
    function _mintAddressBatch(address[] memory accounts, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
        
        require(ids.length == amounts.length && ids.length == accounts.length, "ERC1155: ids and amounts and accounts length mismatch");
 
        address operator = _msgSender();
 
        for (uint i = 0; i < ids.length; i++) {
            require(accounts[i] != address(0), "ERC1155: mint to the zero address");
            
             _beforeTokenTransfer(operator, address(0), accounts[i], _asSingletonArray(ids[i]), _asSingletonArray(amounts[i]), data);
             
            _balances[ids[i]][accounts[i]] = amounts[i].add(_balances[ids[i]][accounts[i]]);
            
            emit TransferSingle(operator, address(0), accounts[i], ids[i], amounts[i]);
 
            _doSafeBatchTransferAcceptanceCheck(operator, address(0), accounts[i], _asSingletonArray(ids[i]), _asSingletonArray(amounts[i]), data);
        
        }
    }
    
    
    function _create(address account, uint256 _cap,string memory _uris, bytes memory data) internal returns (uint256) {
        uint256 _id = _getNextTokenID();
        _incrementTokenTypeId();
        setAdd(account, _id);
        
        if(bytes(_uris).length > 0)
            uris[_id] = _uris;
            
        _mint(account,_id,1,data);
        caps[_id] = _cap;
        
        return _id;
    }
 
    
    function _createBatch(address account, uint256[] memory _caps,string[] memory _uris, bytes memory data) internal returns(uint256[] memory){
        
        require(_caps.length == _uris.length , "ERC1155: cap and uris length mismatch");
        
        uint256[] memory reIDs =new uint256[](_caps.length);
        for (uint i = 0; i < _caps.length; i++) {
            
            uint256 _id = _getNextTokenID();
            _incrementTokenTypeId();
            
            setAdd(account, _id);
        
            if(bytes(_uris[i]).length > 0)
                uris[_id] = _uris[i];
            
            _mint(account,_id,1,data);
            caps[_id] = _caps[i];
            
            reIDs[i] = _id;
        }
        
        return reIDs;
       
    }
    
    function _createAddressBatch(address[] memory accounts, uint256[] memory _caps,string[] memory _uris, bytes memory data) internal returns(uint256[] memory){
        
        require(_caps.length == _uris.length && accounts.length == _caps.length, "ERC1155: accounts and cap and uris length mismatch");
        
         uint256[] memory reIDs =new uint256[](_caps.length);
         
        for (uint i = 0; i < _caps.length; i++) {
            
            uint256 _id = _getNextTokenID();
            _incrementTokenTypeId();
            
            setAdd(accounts[i], _id);
        
            if(bytes(_uris[i]).length > 0)
                uris[_id] = _uris[i];
            
            _mint(accounts[i],_id,1,data);
            caps[_id] = _caps[i];
            
            reIDs[i] = _id;
        }
        
        return reIDs;
        
    }
    
  
 
    /**
     * @dev Destroys `amount` tokens of token type `id` from `account`
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens of token type `id`.
     */
    function _burn(address account, uint256 id, uint256 amount) internal virtual {
        require(account != address(0), "ERC1155: burn from the zero address");
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
 
        _balances[id][account] = _balances[id][account].sub(
            amount,
            "ERC1155: burn amount exceeds balance"
        );
 
        emit TransferSingle(operator, account, address(0), id, amount);
        
        
        if (balanceOf(account, id) == 0) {
                setRemove(account, id);
        }
            
    }
 
    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
        require(account != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
 
        address operator = _msgSender();
 
        _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
 
        for (uint i = 0; i < ids.length; i++) {
            _balances[ids[i]][account] = _balances[ids[i]][account].sub(
                amounts[i],
                "ERC1155: burn amount exceeds balance"
            );
        }
 
        emit TransferBatch(operator, account, address(0), ids, amounts);
        
        
        for (uint i = 0; i < ids.length; i++) {
            if (balanceOf(account, ids[i]) == 0) {
                setRemove(account, ids[i]);
        }
        }
    }
 
    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal virtual
    { }
 
    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    )
        private
    {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver(to).onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
 
    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        private
    {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
                if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
 
    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;
 
        return array;
    }
    
    // ------------------ SET FUNCTIONS --------------------
    
    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function setAdd(address owner, uint256 value) internal returns (bool) {
        if (!setContains(owner, value)) {
            holderTokens[owner]._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            holderTokens[owner]._indexes[value] = holderTokens[owner]._values.length;

            owners[value]._values.push(owner);
            owners[value]._indexes[owner] = owners[value]._values.length;

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function setRemove(address owner, uint256 value) internal returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = holderTokens[owner]._indexes[value];
        uint256 ownerIndex = owners[value]._indexes[owner];

        if (valueIndex != 0) {
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteValueIndex = valueIndex - 1;
            uint256 lastIndex = holderTokens[owner]._values.length - 1;
            uint256 lastValue = holderTokens[owner]._values[lastIndex];
            holderTokens[owner]._values[toDeleteValueIndex] = lastValue;
            holderTokens[owner]._indexes[lastValue] = toDeleteValueIndex + 1; // All indexes are 1-based
            holderTokens[owner]._values.pop();
            delete holderTokens[owner]._indexes[value];

            uint256 toDeleteOwnerIndex = ownerIndex - 1;
            lastIndex = owners[value]._values.length - 1;
            address lastAddress = owners[value]._values[lastIndex];
            owners[value]._values[toDeleteOwnerIndex] = lastAddress;
            owners[value]._indexes[lastAddress] = toDeleteOwnerIndex + 1; // All indexes are 1-based
            owners[value]._values.pop();
            delete owners[value]._indexes[owner];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function setContains(address owner, uint256 value) public view returns (bool) {
        return holderTokens[owner]._indexes[value] != 0;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(address owner, uint256 index) public view returns (uint256) {
        Uint256Set memory set = holderTokens[owner];
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }
    
    
}

contract EBPropsNFT is EBCN,Roles{
    
    
    // Contract name
    string public name;
    // Contract symbol
    string public symbol;
   
    
    constructor() public
    EBCN("EB Props NFT") 
    {
        name = "EB Props NFT";
        symbol = "EBPN";
        
    } 
    
    
    function create(address account, uint256 _cap,string memory _uri, bytes memory data) public onlyMinter returns (uint256) {
        return _create(account,_cap,_uri,data);
    }
 
    
    function createBatch(address account, uint256[] memory _caps,string[] memory _uris, bytes memory data) public onlyMinter returns(uint256[] memory){
        
        return _createBatch(account,_caps,_uris,data);
       
    }
    
    function createAddressBatch(address[] memory accounts, uint256[] memory _caps,string[] memory _uris, bytes memory data) public onlyMinter returns(uint256[] memory){
        
        
        return _createAddressBatch(accounts,_caps,_uris,data);
    }
 
    
    function burn(address account, uint256 id) public onlyBurn{
        _burn(account,id,1);
    }
 
    
    function burnBatch(address account, uint256[] memory ids) public onlyBurn{
        uint256[] memory amounts = new uint256[](ids.length);
        for (uint i = 0; i < ids.length; i++) {
            amounts[i] = 1;
        }
        _burnBatch(account,ids,amounts);
    }
    
    
    function pause() public whenNotPaused onlyOwner{
        _pause();
    }

    
    function unpause() public whenPaused onlyOwner{
        _unpause();
    }
    
}
