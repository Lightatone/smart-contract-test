// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import './ERC165.sol';
import './interfaces/IERC721.sol';
/*
 create NFT what we need to care about : (build mint function)
 a. NFT to point address (Recipient)
 b. Keep track of the token IDs 
 c. Keep track of the token owner addresse to token IDs
 d. keep track of how many token the owner address have
 e. create an event that emits a 
 transfer log - contract address, where it is being minted to

for the transfer function: what we need to consider about?

*/

contract ERC721 is ERC165, IERC721 {

    //event Transfer(address indexed from, address indexed to, uint256  indexed tokenId);
// mapping in solidity creates a hash tables of key pair values
    //event Approval(address indexed owner, address indexed approved,uint256  indexed tokenId );
    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner; 

    // Mapping from owner to number of owned tokens 
    mapping(address => uint256) private _OwnedTokensCount;

    // Mapping from token id to approved addresses (transfer function)
    mapping(uint256 => address) private _tokenApprovals; 
    
    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }
    // in IERC 721 have a lot functions, but we hide a lot of them
    // register the interface for the ERC 721 so that it includes
    // balanceOf,ownerOf and transferFrom

    function balanceOf(address _owner) public override  view returns(uint256) {
            require(_owner != address(0), 'owner query for non-existent token');
            return _OwnedTokensCount[_owner];
        }
    function ownerOf(uint256 _tokenId) public override view  returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool){
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId 
         address owner = _tokenOwner[tokenId];
         // return truthiness tha address is not zero
         return owner != address(0);
    }
    

    function _mint(address to, uint256 tokenId) internal virtual {
        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero addres');
        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');

       // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to; 
        // keeping track of each address that is minting and adding one to the count
        _OwnedTokensCount[to]+=1;  

        emit Transfer(address(0),to,tokenId);
    }

    // this is not safe! 
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
    /* 
     1.add the token id to the address receiving the token
     2.update the balance of the address _from token
     3.update the balance of the address _to
     4.add the safe functionality
     I.require that the address reciving a token is not a zero addresses
     II require the address transfering the token actually owns the tokens

    */    
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');

        _OwnedTokensCount[_from]-=1;
        _OwnedTokensCount[_to]+=1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override  public  {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);

    }
    /*
    1 require that the person approving is the owner
    2 we are approving an address to a token (token ID)
    3.require that we can't approve sending token to ourselves
    4.update the mape of the approval addresses

    */
    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');//require that we cant approve sending tokens of the owner to the owner (current caller) 
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    } 

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner); 
        // return(spender == owner|| getApproved(tokenId) == spender); 
    }
}