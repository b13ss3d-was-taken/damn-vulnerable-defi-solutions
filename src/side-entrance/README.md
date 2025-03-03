# Side Entrance

A surprisingly simple pool allows anyone to deposit ETH, and withdraw it at any point in time.

It has 1000 ETH in balance already, and is offering free flashloans using the deposited ETH to promote their system.

You start with 1 ETH in balance. Pass the challenge by rescuing all ETH from the pool and depositing it in the designated recovery account.

### Solution
There are three main functions in the contract: `deposit`, `withdraw`, and `flashLoan`.

The vulnerability lies in the `flashLoan` function's security check. It only verifies that the pool's balance after the flash loan is not less than the initial balance. This creates an exploit opportunity:

1. We request a flash loan for the entire `pool balance`.
2. Inside the flash loan execution, we `deposit` the borrowed ETH back into the pool.
3. This `deposit` registers us as legitimate depositors in the pool's `balance` mapping.
4. After the flash loan completes successfully (because we returned the ETH via deposit).
5. We can then `withdraw` our "deposited" ETH, effectively draining the pool.

The vulnerability exists because the contract lacks proper accounting mechanisms to track the source of funds, treating flash loan deposits the same as regular user deposits.

You can find the implementation of this attack in the [SideEntranceReceiver.sol](./SideEntranceReceiver.sol) contract.