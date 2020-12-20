pragma solidity >=0.6.0 <0.8.0;
import "./TestERC20.sol";
import "./PandiFiAsset.sol";

contract CherryPicker{
    
    function convert(address _origin, address _destination, uint256 _pickerId) external returns(bool){
        //_pickerId: 0 import ERC20 into 1155 contract
        if(_pickerId==0){
            TestERC20 originalERC = TestERC20(_origin);
            PandiFiAsset pandi = PandiFiAsset(_destination);
            
            require(originalERC.pickerPermission()==true, "Your contract has owners who have not permitted transfer");
            string memory name = originalERC.name();
            string memory symbol = originalERC.symbol();
            uint8 decimals = originalERC.decimals();
            uint256 totalSupply = originalERC.totalSupply();
           (address[] memory _to, uint256[] memory _quantities) = originalERC.balanceToTransfer();
            pandi.createBatch(_to, _quantities);
            //we can add a URI with name, symbol, etc.
            originalERC.balanceToTransfer();
            return true;
        }
    }
    
    
    
  
}