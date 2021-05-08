pragma solidity ^0.8.0;

contract GroupPurchase {

    string private _name;
    address payable private _owner;

    struct Purchase {
        uint256 cost;
        uint256 invested;
        address payable saler;
        bool isActive;
    }

    // id of purchase
    mapping (uint8 => Purchase) public purchases;

    constructor (string memory name_) {
        _name = name_;
        _owner = payable(msg.sender);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function owner() public view virtual returns (address payable) {
        return _owner;
    }

    function changeOwner(address payable owner_) public {
        require(payable(msg.sender) == _owner);
        _owner = owner_;
    }

    function getFreeId() public view returns(uint8 i){
        i = 0;
        for (i = 1; i != 0; i++) {
            if(purchases[i].isActive == false) {
                break;
            }
        }
        require(purchases[i].isActive == false);
        return i;
    }

    function initPurchase(uint8 id_, uint256 cost_, address payable sailer_) public {
        require(purchases[id_].isActive == false);
        purchases[id_] = Purchase(cost_, 0, sailer_, true);
    }

    // allows to transfer extra money to saler
    function investTipSaler(uint8 id_) public payable {
        require(purchases[id_].isActive == true);
        purchases[id_].invested += msg.value;       
        if(purchases[id_].invested >= purchases[id_].cost){
            purchases[id_].saler.transfer(purchases[id_].invested);
            delete purchases[id_];
        }
    }

    // allows to transfer extra money to owner
    function investTipOwner(uint8 id_) public payable {
        require(purchases[id_].isActive == true);
        purchases[id_].invested += msg.value;       
        if(purchases[id_].invested >= purchases[id_].cost){
            uint256 tipping;
            tipping = purchases[id_].invested - purchases[id_].cost;
            purchases[id_].saler.transfer(purchases[id_].cost);
            _owner.transfer(tipping);
            delete purchases[id_];
        }
    }

    // allows to transfer extra money back
    function investTipBack(uint8 id_) public payable {
        require(purchases[id_].isActive == true);
        purchases[id_].invested += msg.value;       
        if(purchases[id_].invested >= purchases[id_].cost){
            uint256 tipping;
            tipping = purchases[id_].invested - purchases[id_].cost;
            purchases[id_].saler.transfer(purchases[id_].cost);
            payable(msg.sender).transfer(tipping);
            delete purchases[id_];
        }
    }
}


