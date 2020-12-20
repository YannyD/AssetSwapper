pragma solidity >=0.6.0 <0.8.0;

interface IERC721Receiver{
    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns(bytes4);
}