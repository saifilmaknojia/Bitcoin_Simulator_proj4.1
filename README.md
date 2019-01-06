GROUP INFO

Jacob Ville	        4540-7373<br>
Shaifil Maknojia	7805-9466<br>

***

#### Instructions:

1. Extract proj4.zip
2. Go to proj4 folder
3. run "mix deps.get"
4. run "mix compile"
5. run "mix run proj4.exs" for a demonstration <br>
    _Note: Output prints which node is mining, the transactions included in that block, and the chain afterwords_ 
6. run "mix test" to run tests<br>
    _Note: Printed output is not formatted_
	
***

#### Instructions for Bonus:

1. Extract proj4_bonus.zip
2. Go to the proj4_bonus folder
3. run "mix deps.get"
4. run "mix compile"
5. run "mix run proj4.exs target_bit no_of_transactions"

    target_bit: bit shift operator 1(easy)-255(hard), 15 recommended
    no_of_transactions: number of transactions
    
6. Enter possible address "a", "b", "c", or "d" for sender and receiver
7. Enter the amount for each transaction

###### Bonus Example Input: 
$ mix run proj4.exs 15 1<br>
Enter sender's address --> a<br>
Enter receiver's address --> b<br>
Enter amount to transfer --> 10<br>

The output shows the transactions and mining taking place. Our bonus shows how the target manipulator can be adjusted to change the mining difficulty.

***

#### Functionality

###### Blockchain and Blocks
First the blockchain is initialized with the genesis block, an essentially empty block that acts as the base of our blockchain. New blocks are added when a node successfully mines, by appending a new block to the head of the blockchain. The blockchain keeps track of the transactions performed, and when a new block is added, those transactions are placed in the new block, clearing the current transactions.

###### Nodes and Transactions
Each node is an individual process, and keeps track of the number of coins in its wallet. 

Transactions transfer coins between nodes and is recorded on the blockchain. First the transaction is verified, ensuring the sender has enough coins to perform the transaction. Then the receiver gets the coins and the transaction is recorded on the blockchain's current transactions.

###### Proof of Work
This is where the mining takes place. To do this a block is generated with the current transactions, then a target value is created. The proof of work is hashed with a nonce, if the value of this hash is less than the target value the block has successfully been mined. Otherwise the nonce is incremented and hashed again.

Once the POW puzzle has been solved, a new block is created and the miner is rewarded with 5 coins.

We set the target to a value small enough to take only a few ms to mine. Note than in our bonus we can change the difficulty of mining by modifying this value.