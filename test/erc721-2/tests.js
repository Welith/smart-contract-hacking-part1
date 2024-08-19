const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("ERC721 Tokens Exercise 2", function () {
  let deployer, user1, user2, user3;

  const CUTE_NFT_PRICE = ethers.utils.parseEther("5");
  const BOOBLES_NFT_PRICE = ethers.utils.parseEther("7");

  before(async function () {
    /** Deployment and minting tests */

    [deployer, user1, user2, user3] = await ethers.getSigners();

    // User1 creates his own NFT collection
    let NFTFactory = await ethers.getContractFactory(
      "contracts/utils/DummyERC721.sol:DummyERC721",
      user1
    );
    this.cuteNFT = await NFTFactory.deploy("Crypto Cuties", "CUTE", 1000);
    await this.cuteNFT.mintBulk(30);
    expect(await this.cuteNFT.balanceOf(user1.address)).to.be.equal(30);

    // User3 creates his own NFT collection
    NFTFactory = await ethers.getContractFactory("DummyERC721", user3);
    this.booblesNFT = await NFTFactory.deploy("Rare Boobles", "BOO", 10000);
    await this.booblesNFT.mintBulk(120);
    expect(await this.booblesNFT.balanceOf(user3.address)).to.be.equal(120);

    // Store users initial balance
    this.user1InitialBalance = await ethers.provider.getBalance(user1.address);
    this.user2InitialBalance = await ethers.provider.getBalance(user2.address);
    this.user3InitialBalance = await ethers.provider.getBalance(user3.address);
  });

  it("Deployment & Listing Tests", async function () {
    /** CODE YOUR SOLUTION HERE */

    // TODO: Deploy Marketplace from deployer
    const Marketplace = await ethers.getContractFactory("OpenOcean", deployer);
    this.marketplace = await Marketplace.deploy();

    // TODO: User1 lists Cute NFT tokens 1-10 for 5 ETH each
    await this.cuteNFT
      .connect(user1)
      .setApprovalForAll(this.marketplace.address, true);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 1, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 2, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 3, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 4, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 5, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 6, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 7, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 8, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 9, CUTE_NFT_PRICE);
    await this.marketplace
      .connect(user1)
      .listItem(this.cuteNFT.address, 10, CUTE_NFT_PRICE);

    // TODO: Check that Marketplace owns 10 Cute NFTs
    expect(await this.cuteNFT.balanceOf(this.marketplace.address)).to.be.equal(
      10
    );

    // TODO: Checks that the marketplace mapping is correct (All data is correct), check the 10th item.

    const item = await this.marketplace.listedItems(10);
    expect(item.itemId).to.be.equal(10);
    expect(item.collection).to.be.equal(this.cuteNFT.address);
    expect(item.tokenId).to.be.equal(10);
    expect(item.price).to.be.equal(CUTE_NFT_PRICE);
    expect(item.seller).to.be.equal(user1.address);
    expect(item.isSold).to.be.equal(false);

    // TODO: User3 lists Boobles NFT tokens 1-5 for 7 ETH each
    await this.booblesNFT
      .connect(user3)
      .setApprovalForAll(this.marketplace.address, true);
    await this.marketplace
      .connect(user3)
      .listItem(this.booblesNFT.address, 1, BOOBLES_NFT_PRICE);
    await this.marketplace
      .connect(user3)
      .listItem(this.booblesNFT.address, 2, BOOBLES_NFT_PRICE);
    await this.marketplace
      .connect(user3)
      .listItem(this.booblesNFT.address, 3, BOOBLES_NFT_PRICE);
    await this.marketplace
      .connect(user3)
      .listItem(this.booblesNFT.address, 4, BOOBLES_NFT_PRICE);
    await this.marketplace
      .connect(user3)
      .listItem(this.booblesNFT.address, 5, BOOBLES_NFT_PRICE);

    // TODO: Check that Marketplace owns 5 Booble NFTs
    expect(
      await this.booblesNFT.balanceOf(this.marketplace.address)
    ).to.be.equal(5);

    // TODO: Checks that the marketplace mapping is correct (All data is correct), check the 15th item.
    const item2 = await this.marketplace.listedItems(15);
    expect(item2.itemId).to.be.equal(15);
    expect(item2.collection).to.be.equal(this.booblesNFT.address);
    expect(item2.tokenId).to.be.equal(5);
    expect(item2.price).to.be.equal(BOOBLES_NFT_PRICE);
    expect(item2.seller).to.be.equal(user3.address);
    expect(item2.isSold).to.be.equal(false);
  });

  it("Purchases Tests", async function () {
    /** CODE YOUR SOLUTION HERE */
    // All Purchases From User2 //
    // TODO: Try to purchase itemId 100, should revert
    await expect(
      this.marketplace.connect(user2).purchase(100, { value: CUTE_NFT_PRICE })
    ).to.be.revertedWith("Item does not exist");
    // TODO: Try to purchase itemId 3, without ETH, should revert
    await expect(
      this.marketplace.connect(user2).purchase(3, { value: 0 })
    ).to.be.revertedWith("Insufficient funds");
    // TODO: Try to purchase itemId 3, with ETH, should work
    await this.marketplace
      .connect(user2)
      .purchase(3, { value: CUTE_NFT_PRICE });
    // TODO: Can't purchase sold item
    await expect(
      this.marketplace.connect(user2).purchase(3, { value: CUTE_NFT_PRICE })
    ).to.be.revertedWith("Item already sold");
    // TODO: User2 owns itemId 3 -> Cuties tokenId 3
    expect(await this.cuteNFT.ownerOf(3)).to.be.equal(user2.address);
    // TODO: User1 got the right amount of ETH for the sale
    const user1Balance = await ethers.provider.getBalance(user1.address);
    expect(user1Balance).to.be.gt(
      this.user1InitialBalance
        .add(CUTE_NFT_PRICE)
        .sub(ethers.utils.parseEther("0.2"))
    );
    // TODO: Purchase itemId 11
    await this.marketplace
      .connect(user2)
      .purchase(11, { value: BOOBLES_NFT_PRICE });
    // TODO: User2 owns itemId 11 -> Boobles tokenId 1
    expect(await this.booblesNFT.ownerOf(1)).to.be.equal(user2.address);
    // TODO: User3 got the right amount of ETH for the sale
    const user3Balance = await ethers.provider.getBalance(user3.address);
    expect(user3Balance).to.be.gt(
      this.user3InitialBalance
        .add(BOOBLES_NFT_PRICE)
        .sub(ethers.utils.parseEther("0.2"))
    );
  });
});
