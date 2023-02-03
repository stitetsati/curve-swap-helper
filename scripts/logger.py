import datetime
import os
current_date = datetime.date.today()
log_file = "logs.txt"

class Logger:
    def __init__(self, tx, weth_purchased):
        with open(log_file, "a") as f:
            f.write(f"{current_date} {tx.txid} {weth_purchased}\n")
        self.tx = tx
        self.this_batch_eth = weth_purchased

        
    def get_log_message(self):
        lines = []
        with open(log_file, "r") as f:
            lines = f.readlines()

        # holistic view
        total_eth = sum([float(l.split()[-1]) for l in lines])
        total_number_of_time_purchased = len(lines)
        total_average_cost = (total_number_of_time_purchased*8000) / total_eth

        # re. this batch
        this_batch_avg_cost = 8000 / self.this_batch_eth
        return f"DollarCostAverageBot\n[Etherscan Tx](https://etherscan.io/tx/{self.tx.txid})\nBought {self.this_batch_eth:.4f} WETH\nAverageCost {this_batch_avg_cost:.4f}\n\nTotalEthPurchased:{total_eth:.4f}\n# purchases:{total_number_of_time_purchased}\nAverageCost:{total_average_cost:.4f}\n"

