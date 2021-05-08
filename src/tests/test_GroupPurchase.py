from brownie import accounts
from brownie import GroupPurchase
from brownie import reverts
import pytest

def test_account_balance():
    balance = accounts[0].balance()
    accounts[0].transfer(accounts[1], "10 ether", gas_price=0)

    assert balance - "10 ether" == accounts[0].balance()

@pytest.fixture(scope="function", autouse=True)
def init_fixture(fn_isolation):
    GroupPurchase.deploy("purchaseContract",{'from':accounts[0]})
    GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})

def test_saler_got_money():
    balance = accounts[2].balance()
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert balance + 400 == accounts[2].balance()  

def test_extra_money_back():
    balance = accounts[3].balance()
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert balance == accounts[3].balance() + 400 

def test_no_reinit():
    with reverts():
        GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})

def test_only_exist_investment():
    t = GroupPurchase[0]
    with reverts():
        t.investTipBack(5, {'from':accounts[3],'value':415})

def test_change_owner():
    t = GroupPurchase[0]
    t.changeOwner(accounts[1], {'from':accounts[0]})
    assert t.owner() == accounts[1]

def test_protect_change_owner():
    t = GroupPurchase[0]
    with reverts():
        t.changeOwner(accounts[1], {'from':accounts[1]})

def test_expire_purchase():
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert t.purchases(3)[3] == False

# ==================== more optional tests ===========================

def test_reinit_after_expire():
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})
    assert True

def test_extra_money_to_owner():
    balance = accounts[0].balance()
    t = GroupPurchase[0]
    t.investTipOwner(3, {'from':accounts[3],'value':415})
    assert balance + 415 - 400 == accounts[0].balance()

def test_extra_money_to_saler():
    balance = accounts[2].balance()
    t = GroupPurchase[0]
    t.investTipSaler(3, {'from':accounts[3],'value':415})
    assert balance + 415 == accounts[2].balance()

def test_free_ids():
    t = GroupPurchase[0]
    t.initPurchase(1, 400 , accounts[2] , {'from':accounts[1]})
    t.initPurchase(2, 400 , accounts[2] , {'from':accounts[1]})
    assert t.getFreeId() == 4