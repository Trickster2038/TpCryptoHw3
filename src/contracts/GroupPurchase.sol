pragma solidity ^0.8.0;

contract GroupPurchase {

    string private _name;

    struct Purchase {
        uint256 cost;
        uint256 invested;
        address saler;
        bool isActive;
    }

    // id of purchase
    mapping (uint8 => Purchase) public purchases;

    constructor (string memory name_) {
        _name = name_;
    }

    /**
     * @dev Returns the name of the contract.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    // function testf(string memory new_name_) public payable {
    //     if(msg.value > 3){
    //         _name = new_name_;
    //     }
    // }

    function initPurchase(uint8 id_, uint256 cost_, address sailer_) public {
        require(purchases[id_].isActive == false);
        purchases[id_] = Purchase(cost_, 0, sailer_, true);
    }

    //function getPurchase(uint8 id_) public returns()
}


