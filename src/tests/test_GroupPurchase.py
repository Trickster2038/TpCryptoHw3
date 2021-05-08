from brownie import accounts
from brownie import GroupPurchase
from brownie import reverts
import pytest

# fixture deploys Contract
@pytest.fixture(scope="function", autouse=True)
def init_fixture(fn_isolation):
    GroupPurchase.deploy("purchaseContract",{'from':accounts[0]})
    GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})

# test of recieving money by saler
# if enougth money was earned
def test_saler_got_money():
    balance = accounts[2].balance()
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert balance + 400 == accounts[2].balance()  

# test of recieving extra money back by sender
def test_extra_money_back():
    balance = accounts[3].balance()
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert balance == accounts[3].balance() + 400 

# existing Purchase can't be cleared
def test_no_reinit():
    with reverts():
        GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})

# user can't send money to non-existent Purchase
def test_only_exist_investment():
    t = GroupPurchase[0]
    with reverts():
        t.investTipBack(5, {'from':accounts[3],'value':415})

# owner can be changed
def test_change_owner():
    t = GroupPurchase[0]
    t.changeOwner(accounts[1], {'from':accounts[0]})
    assert t.owner() == accounts[1]

# ONLY owner can transfer his rights
def test_protect_change_owner():
    t = GroupPurchase[0]
    with reverts():
        t.changeOwner(accounts[1], {'from':accounts[1]})

# Purchase expires, if enougth money earned
def test_expire_purchase():
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415})
    assert t.purchases(3)[3] == False

# ==================== more optional tests ===========================

# ID can be reused, when Purchase expired
def test_reinit_after_expire():
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':415}) # cost = 400, so Purchase expires 
    GroupPurchase[0].initPurchase(3, 400 , accounts[2] , {'from':accounts[1]})
    assert True

# test of recieving extra money by owner
def test_extra_money_to_owner():
    balance = accounts[0].balance()
    t = GroupPurchase[0]
    t.investTipOwner(3, {'from':accounts[3],'value':415})
    assert balance + 415 - 400 == accounts[0].balance()

# test of recieving extra money by saler
def test_extra_money_to_saler():
    balance = accounts[2].balance()
    t = GroupPurchase[0]
    t.investTipSaler(3, {'from':accounts[3],'value':415})
    assert balance + 415 == accounts[2].balance()

# test of getting free ID function
def test_free_ids():
    t = GroupPurchase[0]
    t.initPurchase(1, 400 , accounts[2] , {'from':accounts[1]})
    t.initPurchase(2, 400 , accounts[2] , {'from':accounts[1]})
    assert t.getFreeId() == 4

# saler don't get money, until all amount was earned
def test_saler_didnt_get_money():
    balance = accounts[2].balance()
    t = GroupPurchase[0]
    t.investTipBack(3, {'from':accounts[3],'value':300})
    assert balance + 400 == accounts[2].balance()