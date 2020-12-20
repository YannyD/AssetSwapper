//a protocol to allow for an ERC 20 contract to be imported into an ERC 1155
pragma solidity >=0.6.0 <0.8.0;

interface IERC20PermitPicker{

    function permitPicker(bool vote) external returns(bool);

//we could give permission to only the picker if we'd like
    function balanceToTransfer() external returns(address[] memory, uint256[] memory);

}

