// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {
   // hash table to keep track fingerprint data of byte function conversions
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() {
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    function supportsInterface(bytes4 interfaceID) external view override returns (bool) {
        return _supportedInterfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, 'ERC165 Invalid interface request');
        _supportedInterfaces[interfaceId] = true;
    }



}