pragma solidity >=0.5.0;

/*
sample asset swapper token contract
we can consider: is this one asset, with a set token supply?
Or is each token representative of one asset?
*/
import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";


contract AssetSwap is IERC20{
    using SafeMath for uint256;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    string public name = "AssetSwap";
    string public symbol = "WAP";
    uint256 public decimals = 8;

    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;

    uint256 public totalSupply = 10;

    address public owner;

    constructor(){
        owner=msg.sender;
        balanceOf[owner]=totalSupply;
    }

    modifier isOwner {
        require(owner == msg.sender, "You are not the contract owner");
        _;
    }

    function transfer(address to, uint value) external returns (bool){
        require(value <= balanceOf[msg.sender], "Insufficient balance");
        require(value >0, "Nonpositive value sent");
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }


    function transferFrom(address from, address to, uint value) external returns (bool){
        require(balanceOf[_from] >= value, "Insufficient balance");
        require(balanceOf[_to] + value >= balanceOf[_to], "Nonpositive value sent");
        require(allowance[_from][msg.sender] >= value, "Not even permission");
        balanceOf[_to]=balanceOf[_to].add(value);
        balanceOf[_from] = balanceOf[_from].sub(value);
        allowance[_from][msg.sender]= allowance[_from][msg.sender].sub(value);
        emit Transfer(_from, _to, value);
        return true;
    }

    function approve(address spender, uint value) external returns (bool){
       allowance[msg.sender][_spender] = value;
       emit Approval(msg.sender, spender, value);
       return true;
       }

}