from web3 import Web3, WebsocketProvider
from ethereum.transactions import Transaction
from ethereum.block import BlockHeader
from ethereum.utils import (
    normalize_address, bytes_to_int
)
import codecs

WS1 = WebsocketProvider('ws://128.235.40.191:8546')
WS2 = WebsocketProvider('ws://128.235.40.169:8546')


def connect_web3():
    w3 = Web3([WS2, WS1])
    if w3.isConnected():
        print("Connected to:" + w3.version.node)
        if w3.eth.syncing:
            print("Warning: ws node is syncing")
        print('Enter the password:')
        pwd = input()
        while not w3.personal.unlockAccount(w3.personal.listAccounts[0], pwd):
            print('Enter the correct password:')
            pwd = input()
        w3.eth.defaultAccount = w3.eth.accounts[0]
        print('Accounts unlocked!')
        return w3, pwd
    else:
        print("Not connected to ws node")
        exit(255)


def to_blockheader(block_attr_dict):
    return BlockHeader(
        bytes(block_attr_dict.parentHash),
        bytes(block_attr_dict.sha3Uncles),
        normalize_address(block_attr_dict.miner),
        bytes(block_attr_dict.stateRoot),
        bytes(block_attr_dict.transactionsRoot),
        bytes(block_attr_dict.receiptsRoot),
        bytes_to_int(bytes(block_attr_dict.logsBloom)),
        block_attr_dict.difficulty,
        block_attr_dict.number,
        block_attr_dict.gasLimit,
        block_attr_dict.gasUsed,
        block_attr_dict.timestamp,
        bytes(block_attr_dict.extraData),
        bytes(block_attr_dict.mixHash),
        bytes(block_attr_dict.nonce)
    )


def to_transaction(tx_attr_dict):
    return Transaction(
        tx_attr_dict.nonce,
        tx_attr_dict.gasPrice,
        tx_attr_dict.gas,
        normalize_address(tx_attr_dict.to),
        tx_attr_dict.value,
        codecs.decode(tx_attr_dict.input.replace("0x", ""), 'hex'),
        tx_attr_dict.v,
        bytes_to_int(tx_attr_dict.r),
        bytes_to_int(tx_attr_dict.s)
    )
