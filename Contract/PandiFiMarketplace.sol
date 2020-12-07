pragma solidity ^0.5.0;

import "./PandiFiAsset.sol";

/*
 * Market place to trade PandiFi Assets (managed on an ERC 1155 contract)
 * It needs an existing PandiFi Asset contract to interact with
 * Note: it does not inherit from the PandiFi contract
 * Note: The contract needs to be an operator for everyone who is selling through this contract.
 * Note: The contract assumes that each asset has only one totalSupply token.  
 */

 contract PandiFiMarketplace.sol{
     
    event MarketListing(address owner, uint256 assetId, uint256 price, bool activeStatus);
    event MarketSale(address seller, address buyer, uint256 assetId, uint256 price);

     PandiFiAsset private _pandiFiAsset;

     struct SaleListing{
         address payable seller;
         uint256 price;
         uint256 assetId;
         bool activeStatus;
         uint256 arrayIndex;
     }

    //does this array just keep getting bigger forever?
     SaleListing[] private salelistings;

     // assetId => sale listing
     mapping(uint256 => SaleListing) private saleListingByAssetId        
    
    constructor(address _pandiFiAssetContractAddress) public{
        _pandiFiAsset = PandiFiAsset(_pandiFiAssetContractAddress);
    }

  /**
    * Creates a new sale listing for _assetId for the price _price.
    * Emits the MarketListing event 
    * Requirement: Only the owner of _tokenId can create an offer.
    * Requirement: There can only be one active offer for a token at a time.
    * Requirement: Marketplace contract (this) needs to be an approved operator when the offer is created.
     */

    function setListing(uint256 _assetId, uint256 _value, uint256 _price, bool _activeStatus) external returns (bool){
        require(_pandiFiAsset.balanceOf(msg.sender, _assetId)<=_value && _value>0, "Please set for a positive value less than your balance");
        require(saleListingByAssetId[_assetId][activeStatus] != true, "Asset aleady on sale");
        require(_pandiFiAsset.isApprovedForAll(msg.sender, address(this)), "marketplace not an authorized oeprator");
        uint256 index = salelistings.length;

        SaleListing memory newSaleListing = SaleListing({
            seller: msg.sender,
            price: _price,
            assetId: _assetId,
            activeStatus: _activeStatus,
            arrayIndex: index
        });

        saleListings.push(newSaleListing);
        saleListingByAssetId[_assetId]=newSaleListing;
        emit MarketListing(msg.sender, _assetId, _price, _activeStatus);
        return true;
    }

      /**
    * Removes an existing listing.
    * Emits the MarketListing event 
    * Requirement: Only the seller of assetId can remove an offer.
    * Requirement: Asset must have an active listing.
     */
    function removeListing(uint256 _assetId) external returns(bool){
        require(saleListingByAssetId[_assetId].seller==msg.sender, "You are not the seller");
        require(saleListingByAssetId[_assetId].activeStatus==true, "This is not an active listing");

        uint256 listingIndex = saleListingByAssetId[assetId].arrayIndex;

        delete salelistings[listingIndex];
        saleListingByAssetId[_assetId].activeStatus=false;

        emit MarketListing(msg.sender, _assetId, 0, false);
        return true;
    }

    /**
    * Get the details about a listing for _assetId. Throws an error if there is no active offer for _assetId.
     */
    function getListing(uint256 _assetId) external view returns ( address seller, uint256 price, uint256 assetId, bool activeStatus){
        require(saleListingByAssetId[_assetId].activeStatus==true, "No active listing for this asset Id");
        
        //do we need memory here?
        SaleListing selectedListing = saleListingByAssetId[_assetId];

        return(selectedListing.seller, selectedListing.price, selectedListing.assetId, selectedListing.activeStatus, selectedListing.arrayIndex);
    }

    /**
    * Get all assetId's that are currently for sale. Returns an empty arror if none exist.
    * Can we push these or no?
     */
    function getAllAssetsOnSale() external view  returns(uint256[] memory listOfSales){
        uint256 arrayLength = salelistings.length;
        if(arrayLength==0) {
            uint256[] memory listOfSales = new uint256[](0);
            return listOfSales;
        }
        else{
            uint256[] memory listOfSales = new uint256[](arrayLength);
            
            for(uint256 i = 0; i<arrayLength;i++){
                if(salelistings[i].activeStatus=true) {
                    listOfSales[i]=salelistings[i].assetId;
                    }
            }
        }

    }

    function buyAssetWithEth(uint256 _assetId) external payable{
        SaleListing memory listingToBuy = saleListingByAssetId[assetId];
        require(msg.value==listingToBuy.price, "Incorrect amount of Eth sent");
        require(saleListingByAssetId[assetId].activeStatus==true, "This asset is not for sale");

        delete saleListingByAssetId[assetId];
        salelistings[listingToBuy.index].activeStatus=false;

        //can I do it with msg.value or do I need listinToBuy.price?
        listingToBuy.seller.transfer(msg.value);

        _pandiFiAsset.safeTransferFrom(listingToBuy.seller, msg.sender, _assetId, 1, )


        emit MarketSale(listingToBuy.seller, msg.sender, _assetId, msg.value);


    }
}
