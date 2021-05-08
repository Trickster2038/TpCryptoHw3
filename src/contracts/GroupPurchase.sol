pragma solidity ^0.8.0;

contract GroupPurchase {

    string private _name;   // name is "just-for-fun" field
    address payable private _owner; // owner can recieve extra money

    struct Purchase {
        uint256 cost;
        uint256 invested;   // amount of earned money
        address payable saler;
        bool isActive;  // shows, if Purchase was init and is not paid yet
    }

    /* 
    contract works with multiple purchases
    every purchase has id
    */
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

    // only owner can transfer his rights
    function changeOwner(address payable owner_) public {
        require(payable(msg.sender) == _owner);
        _owner = owner_;
    }

    // get the least free ID for Purchase
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

    // inits new Purchase to start earn money for it
    function initPurchase(uint8 id_, uint256 cost_, address payable sailer_) public {
        require(purchases[id_].isActive == false);
        purchases[id_] = Purchase(cost_, 0, sailer_, true);
    }

    // donate money to purchase (allows to transfer extra money to SALER)
    function investTipSaler(uint8 id_) public payable {
        require(purchases[id_].isActive == true);    // checking if Purchase was init
        purchases[id_].invested += msg.value;       
        if(purchases[id_].invested >= purchases[id_].cost){         // if enougth money earned,
            purchases[id_].saler.transfer(purchases[id_].invested); // saler gets his money
            delete purchases[id_];                                  // and Purchase expires from the list
        }                                                           // to free storage
    }

    // donate money to purchase (allows to transfer extra money to OWNER)
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

    // donate money to purchase (allows to transfer extra money back to SENDER)
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


