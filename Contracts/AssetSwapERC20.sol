/*
sample asset swapper token contract
*/
import "./interfaces/IERC20.sol"
pragma solidity ^0.6.0

contract AssetSwap is IERC20{
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    string public name = "AssetSwap";
    string public symbol = "WAP";
    uint256 public decimals = 8;

    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;

    uint256 public totalSupply = 0;
    
}