import requests
chat_id = "-822881670"
token = "5944295646:AAE5cDzaSa6KM7oxB-OJ2Ide4XQtulcOCv8"
url = f"https://api.telegram.org/bot{token}/sendMessage"
def notify_telegram(log_message):
    res = requests.post(url, json = {'chat_id': chat_id, 'text': log_message, "parse_mode": "Markdown"})
    print(res.json())

if __name__ == "__main__":
    txid = "0x80cf098b89fc0f0c60bf117b9aed8ee9f995be5683833174865891ab28ff1898"
    message = f"DollarCostAverageBot\n[Etherscan Tx](https://etherscan.io/tx/{txid})\nBought 5.1650 WETH\nAverageCost 1548.89\n\nTotalEthPurchased 5.1650\n# purchases 1\nAverageCost 1548.89\n"
    notify_telegram(message)
