# ETH-Brownie console patterns

## Cheat list:
https://manojpramesh.github.io/solidity-cheatsheet/#fallback-function

## Code samples:

```    
Transaction sent: 0xf993f98e009cfc98527e7519f2d2b2211d7d2d30ccdb986a351324a918f95df3
    Gas price: 0.0 gwei Gas limit: 12000000 Nonce: 3
    MultiSigWallet.constructor confirmed - Block: 12121446 Gas used: 1381027 (11.51%)
    MultiSigWallet deployed at: 0x6951b5Bd815043E3F842c1b026b0Fa888Cc2DD85
```

```
t = MultiSigWallet.deploy(acc, 2, {'from':"0x66aB6D9362d4F35596279692F0251Db635165871"}) 
```

```
t.submitTransaction("0x66aB6D9362d4F35596279692F0251Db635165871", 1, 4)    accounts[0].transfer("0x6951b5Bd815043E3F842c1b026b0Fa888Cc2DD85", "1 ether")
```

```
t.submitTransaction(accounts[3],"1 ether",50)
```

## Group purchase 

```
t.testf("name 2", {'from':accounts[0],'value':4})
t = GroupPurchase[0]
t = GroupPurchase.deploy("name1",{'from':accounts[0]})
t.initPurchase(3, 433,accounts[5],{'from':accounts[1]})
t.getFreeId()
t.purchases(1)
(432, 0, "0x21b42413bA931038f35e7A5224FaDb065d297Ba3", True)
 t.investTipOwner(3,{'from':accounts[2],'value':400})
accounts[1].balance()
```

