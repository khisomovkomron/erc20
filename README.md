## How to run contract 
$ forge script script/mytoken.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast


<your_rpc_url> - an address at the end of anvil - http://127.0.0.1:8545
<your_private_key> - your private key, do not add anywhere your private_key, keep it safe


## How to interract with deployed contract from terminal 

$ cast call $CONTRACT_ADDRESS "balanceOf(address)(uint256)" 0xYourAddress 

$ cast send $CONTRACT_ADDRESS "mint(address,uint256)" 0xRecipientAddress 1000000000000000000 --private-key $PRIVATE_KEY

0xRecipientAddress - an address to which new tokens are minted 
1000000000000000000 - uint256 in function mint(address,uint256) - amount of minting tokens 
--private-key - private key of user that deployed contract, in other words - owner


