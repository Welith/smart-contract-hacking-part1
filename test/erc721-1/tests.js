const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("ERC721 Tokens Exercise 1", function () {
  let deployer, user1, user2;

  // Constants
  const DEPLOYER_MINT = 5;
  const USER1_MINT = 3;
  const MINT_PRICE = ethers.utils.parseEther("0.1");

  before(async function () {
    /** Deployment and minting tests */

    [deployer, user1, user2] = await ethers.getSigners();

    /** CODE YOUR SOLUTION HERE */
    // TODO: Contract deployment

    const BokoERC721 = await ethers.getContractFactory("BokoERC721", deployer);
    this.token = await BokoERC721.deploy();
  });

  it("Minting Tests", async function () {
    /** CODE YOUR SOLUTION HERE */
    // TODO: Deployer mints
    await this.token.connect(deployer).mint({ value: MINT_PRICE });
    await this.token.connect(deployer).mint({ value: MINT_PRICE });
    await this.token.connect(deployer).mint({ value: MINT_PRICE });
    await this.token.connect(deployer).mint({ value: MINT_PRICE });
    await this.token.connect(deployer).mint({ value: MINT_PRICE });
    // Deployer should own token ids 1-5
    expect(await this.token.ownerOf(1)).to.equal(deployer.address);
    expect(await this.token.ownerOf(2)).to.equal(deployer.address);
    expect(await this.token.ownerOf(3)).to.equal(deployer.address);
    expect(await this.token.ownerOf(4)).to.equal(deployer.address);
    expect(await this.token.ownerOf(5)).to.equal(deployer.address);
    // TODO: User 1 mints
    await this.token.connect(user1).mint({ value: MINT_PRICE });
    await this.token.connect(user1).mint({ value: MINT_PRICE });
    await this.token.connect(user1).mint({ value: MINT_PRICE });
    // User1 should own token ids 6-8
    expect(await this.token.ownerOf(6)).to.equal(user1.address);
    expect(await this.token.ownerOf(7)).to.equal(user1.address);
    expect(await this.token.ownerOf(8)).to.equal(user1.address);
    // TODO: Check Minting
    expect(await this.token.totalSupply()).to.equal(8);
    expect(await this.token.balanceOf(deployer.address)).to.equal(5);
    expect(await this.token.balanceOf(user1.address)).to.equal(3);
  });

  it("Transfers Tests", async function () {
    /** CODE YOUR SOLUTION HERE */
    // TODO: Transfering tokenId 6 from user1 to user2
    await this.token
      .connect(user1)
      .transferFrom(user1.address, user2.address, 6);
    // TODO: Checking that user2 owns tokenId 6
    expect(await this.token.ownerOf(6)).to.equal(user2.address);
    // TODO: Deployer approves User1 to spend tokenId 3
    await this.token.connect(deployer).approve(user1.address, 3);
    // TODO: Test that User1 has approval to spend TokenId3
    expect(await this.token.getApproved(3)).to.equal(user1.address);
    // TODO: Use approval and transfer tokenId 3 from deployer to User1
    await this.token
      .connect(user1)
      .transferFrom(deployer.address, user1.address, 3);
    // TODO: Checking that user1 owns tokenId 3
    expect(await this.token.ownerOf(3)).to.equal(user1.address);
    // TODO: Checking balances after transfer
    // Deployer: 5 minted, 1 sent, 0 received
    // User1: 3 minted, 1 sent, 1 received
    // User2: 0 minted, 0 sent, 1 received
    expect(await this.token.balanceOf(deployer.address)).to.equal(4);
    expect(await this.token.balanceOf(user1.address)).to.equal(3);
    expect(await this.token.balanceOf(user2.address)).to.equal(1);
  });
});
