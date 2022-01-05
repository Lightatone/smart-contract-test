// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Connector.sol';
// contract Kryptobird{ step 1
//     string public name;
//     string public symbol;

//     constructor(){ // write contract
//         name = 'Kryptobird';
//         symbol = 'KBIRDZ';


//     }

// }


contract KryptoBird is ERC721Connector { // step 2 connect connector
    // initialize this contract to inhert
    // nam and symbol from 721metadata
    // array to store our nfts

 // array to store our nfts, like collection
    string [] public kryptoBirdz;
    mapping(string => bool) _kryptoBirdzExists;
    function mint(string memory _kryptoBird) public {

        require(!_kryptoBirdzExists[_kryptoBird],
        'Error - kryptoBird already exists');
        // this is deprecated - uint _id = KryptoBirdz.push(_kryptoBird);
        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length - 1;

        // .push no longer returns the length but a ref to the added element
        _mint(msg.sender, _id);

        _kryptoBirdzExists[_kryptoBird] = true;

    }

    constructor() ERC721Connector('KryptoBird','KBIRDZ') // name = 'Kryptobird'; symbol = 'KBIRDZ';
 {}

}