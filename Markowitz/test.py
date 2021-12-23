

from web3 import Web3


url = 'https://kovan.infura.io/v3/e4c8c57b51614df287fd439462678176'

w3 = Web3(Web3.HTTPProvider(url))
res = w3.isConnected()
print(res)


is_address_valid = w3.isAddress('0xAdDe5b9AaC6Dcd62d42748c7A21eA64e45Ad5924')

print(f'Is valid address {is_address_valid}')

address = '0xAdDe5b9AaC6Dcd62d42748c7A21eA64e45Ad5924'
abi = '''[
	{
		"inputs": [
			{
				"internalType": "uint256[]",
				"name": "_tokens",
				"type": "uint256[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "checkBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "depositBalance",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPortfolio",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getTickers",
		"outputs": [
			{
				"internalType": "string[]",
				"name": "",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "python_request_body",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "updatePortfolio",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "contract IERC20",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "withdrawERC20",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]'''
contract_instance = w3.eth.contract(address=address, abi=abi)
res = contract_instance.functions.getTickers().call()
print(f'Call to the contracts function is {res}')
