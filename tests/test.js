const { expect } = require("chai");

describe("Save Intellectual Property contract", () => {
  const tokenUnicalIdentifier = 'unical_identifier_token';
  const baseURI = "https://hardhat.org/test/"
  
  let contract;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async () => {
    const Token = await ethers.getContractFactory("SaveIntellectualProperty");
    const [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    contract = await Token.deploy();
    await contract.setBaseURI(baseURI)
  });

  it("Should initialize contract", async () => {
    expect(await contract.baseURI).to.equal(baseURI);
  });
  it("Should set the right owner contract", async () => {
    expect(await contract.owner()).to.equal(await owner.address);
  });
  it("Should mint", async () => {
    expect(
        await contract.registerNewToken(tokenUnicalIdentifier)
    ).to.emit(contract, "Transfer").withArgs(ethers.constants.AddressZero, owner.address, 1);  
  });
  it("Should be right owner and author token", async () => {
      expect(await contract.ownerOf(1).to.equal(owner.address));
      expect(await contract.ownerOfIdentifier(tokenUnicalIdentifier).to.equal(owner.address));
      expect(await contract.authorOfIdentifier(tokenUnicalIdentifier).to.equal(owner.address));
      expect(await contract.authorOfTokenId(1).to.equal(owner.address));
  });
});
