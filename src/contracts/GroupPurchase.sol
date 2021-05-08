pragma solidity ^0.8.0;

contract GroupPurchase {
    // client => order num 
    mapping (address => uint256) private _purchases;
    // order num => money 
    mapping (uint256 => uint256) private _donations;
    // order num => saler 
    mapping (uint256 => address) private _salers;
    string private _name;


    constructor (string memory name_) {
        _name = name_;
    }

    /**
     * @dev Returns the name of the contract.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }
}


