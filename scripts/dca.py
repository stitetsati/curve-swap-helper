from brownie.network import accounts
from brownie import Contract, interface, multicall, network
from brownie.network.gas.strategies import GasNowStrategy

import web3
import requests
import datetime
from .telegram import notify_telegram
from .logger import Logger

gas_strategy = GasNowStrategy("fast")


dca = Contract.from_abi(name="DCA", address="0x562BAf94bE5569a38b0529b1270A29c8ac024207", abi=interface.DCA.abi)
weth = Contract.from_abi(name="WETH", address="0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", abi=interface.ERC20.abi)
quoter = "0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6"
slippage = 0.001
def main():
    dca_executor = accounts.load("dca")
    receiver = dca.receiver()
    initial_weth = weth.balanceOf(receiver)
    min_amount_out = int(dca.getAmountOut.call(quoter, {"from":dca_executor}) * (1-slippage))
    print(min_amount_out)
    tx = dca.execute(min_amount_out, {"from":dca_executor, "required_confs":1})
    received_weth = weth.balanceOf(receiver) - initial_weth
    human_readable_weth = received_weth/1e18
    logger = Logger(tx, human_readable_weth)
    log_message = logger.get_log_message()
    notify_telegram(log_message)
    

