// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title OpenOcean
 * @author JohnnyTime (https://smartcontractshacking.com)
 */
contract OpenOcean {
    // TODO: Complete this contract functionality

    // TODO: Constants
    uint256 public constant MAX_PRICE = 100 ether;

    // TODO: Item Struct

    struct Item {
        uint256 itemId;
        address collection;
        uint256 tokenId;
        uint256 price;
        address payable seller;
        bool isSold;
    }

    // TODO: State Variables and Mappings

    uint256 public itemsCounter;
    mapping(uint256 => Item) public listedItems;

    constructor() {}

    // TODO: List item function
    // 1. Make sure params are correct
    // 2. Increment itemsCounter
    // 3. Transfer token from sender to the contract
    // 4. Add item to listedItems mapping
    function listItem(address _collection, uint256 _tokenId, uint256 _price) external {
        if (_price > MAX_PRICE) {
            revert("Price too high");
        }
        if (IERC721(_collection).ownerOf(_tokenId) != msg.sender) {
            revert("Not owner of token");
        }
        itemsCounter++;
        IERC721(_collection).transferFrom(msg.sender, address(this), _tokenId);
        listedItems[itemsCounter] = Item(itemsCounter, _collection, _tokenId, _price, payable(msg.sender), false);
    }

    // TODO: Purchase item function
    // 1. Check that item exists and not sold
    // 2. Check that enough ETH was paid
    // 3. Change item status to "sold"
    // 4. Transfer NFT to buyer
    // 5. Transfer ETH to seller
    function purchase(uint256 _itemId) external payable {
        if (listedItems[_itemId].itemId == 0) {
            revert("Item does not exist");
        }
        if (listedItems[_itemId].isSold) {
            revert("Item already sold");
        }
        if (msg.value < listedItems[_itemId].price) {
            revert("Insufficient funds");
        }

        listedItems[_itemId].isSold = true;

        IERC721(listedItems[_itemId].collection).safeTransferFrom(
            address(this), msg.sender, listedItems[_itemId].tokenId
        );

        listedItems[_itemId].seller.call{value: listedItems[_itemId].price}("");
    }
}
