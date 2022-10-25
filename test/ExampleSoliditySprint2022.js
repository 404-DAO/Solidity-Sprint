const {
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { Contract } = require("hardhat/internal/hardhat-network/stack-traces/model");

describe("ExampleSoliditySprint2022", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.

  async function deploySoliditySprint2022() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Sprint = await ethers.getContractFactory("ExampleSoliditySprint2022");
    const sprint = await Sprint.deploy();

    return { sprint, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set owner", async function () {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      expect(await sprint.owner()).to.equal(owner.address);
    });

    it("Should not be live", async function () {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      expect(await sprint.live()).to.equal(false);
    });
  });

  describe("Only owner check", function() {
    it("Should not start", async function() {
        const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);
  
        await expect(sprint.connect(otherAccount).start())
          .to.be.revertedWith("Only owner");
    });
    it("Should not stop", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);
  
      await expect(sprint.connect(otherAccount).stop())
        .to.be.revertedWith("Only owner");
    });
    it("Should start", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();

      expect(await sprint.live()).to.equal(true);
    });
    it("Should stop", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).stop();

      expect(await sprint.live()).to.equal(false);
    });
  });

  describe("registerTeam", function() {
    it("Should disallow when not live", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await expect(sprint.connect(otherAccount).registerTeam("Yackets"))
        .to.be.revertedWith("Hackathon not in session");
    });
    it("Should allow when live", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();

      await sprint.connect(otherAccount).registerTeam("Yackets");

      expect(await sprint.teams(otherAccount.address)).to.equal("Yackets");
    });
  });

  describe("f0 check", function() {
    it("Should not add score", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();
      await sprint.connect(otherAccount).registerTeam("Yackets");

      await sprint.connect(otherAccount).f0(true);

      expect(await sprint.scores(otherAccount.address)).to.equal(0);
    });
    it("Should increment score", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();
      await sprint.connect(otherAccount).registerTeam("Yackets");

      await sprint.connect(otherAccount).f0(false);

      expect(await sprint.scores(otherAccount.address)).to.equal(1);
    });
    it("Should disallow after completion", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();
      await sprint.connect(otherAccount).registerTeam("Yackets");

      await sprint.connect(otherAccount).f0(false);
      expect(await sprint.scores(otherAccount.address)).to.equal(1);

      await expect(sprint.connect(otherAccount).f0(false)).to.be.revertedWith("Already completed this function")
    });
  });
  describe("f1 check", function() {
    it("Should increment score", async function() {
      const { sprint, owner, otherAccount } = await loadFixture(deploySoliditySprint2022);

      await sprint.connect(owner).start();
      await sprint.connect(otherAccount).registerTeam("Yackets");

      await sprint.connect(otherAccount).f0(false);

      expect(await sprint.scores(otherAccount.address)).to.equal(1);

      // ADD YOUR CODE HERE!
      let val = 404;
      await sprint.connect(otherAccount).f1(val);

      // If this causes an AssertionError then your guess was incorrect
      // otherwise, you found the correct answer!!
      expect(await sprint.scores(otherAccount.address)).to.equal(3);
    });
  });
});
