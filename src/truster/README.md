# Truster

More and more lending pools are offering flashloans. In this case, a new pool has launched that is offering flashloans of DVT tokens for free.

The pool holds 1 million DVT tokens. You have nothing.

To pass this challenge, rescue all funds in the pool executing a single transaction. Deposit the funds into the designated recovery account.

### Solution
The vulnerability in this contract lies in the `flashLoan` function's unsafe external call feature. Here's how the exploit works:

1. The `flashLoan` function allows us to specify:
   - An amount to borrow
   - A borrower address
   - A target contract to call
   - Arbitrary data to execute on the target

2. The critical vulnerability is that we can make the pool execute any function call on any target contract through the `target.functionCall(data)` line.

3. We can exploit this by:
   - Setting amount to 0 (we don't need to actually borrow tokens)
   - Setting the target as the DVT token contract
   - Creating a call to the token's `approve` function that gives our contract unlimited allowance

4. Once we have the approval, we can use `transferFrom` to move all tokens from the pool to our recovery address.

The attack succeeds because the pool contract blindly executes external calls with its own context, allowing us to manipulate the token's permissions.

> **Note:** We have to do all of this in the constructor of our contract because to solve this challenge we need to do it in a single transaction.

You can find the implementation of this attack in the [TrusterReceiver.sol](./TrusterReceiver.sol) contract.