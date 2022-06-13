const { expect } = require("chai");

describe("Save Intellectual Property contract", () => {
  const tokenUnicalIdentifier = 'unical_identifier_token';
  const author = {
    name: 'Van Gog',
    description: 'Drawer, millioner, filantrop'
  }
  
  let contract;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async () => {
    const Token = await ethers.getContractFactory("SaveIntellectualProperty");
    const [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    contract = await Token.deploy();
    await contract.setAuthorName(owner.address, author.name);
    await contract.setAuthorDescription(owner.address, author.description);
  });

  const ownerAddress = await owner.address;

  it("Should set the right owner contract", async () => {
    expect(await contract.owner()).to.equal(ownerAddress);
    expect(await contract.getAuthorName(ownerAddress)).to.equal(author.name);
    expect(await contract.getAuthorDescription(ownerAddress)).to.equal(author.description);
  });

  it("Should mint", async () => {
    expect(
        await contract.registerNewToken(tokenUnicalIdentifier, ownerAddress)
    ).to.emit(contract, "Transfer").withArgs(ethers.constants.AddressZero, ownerAddress, 1);  
  });

  it("Should be right owner and author token", async () => {
      expect(await contract.ownerOf(1).to.equal(ownerAddress));
      expect(await contract.authorOfTokenId(1).to.equal(ownerAddress));

      expect(await contract.ownerOfIdentifier(tokenUnicalIdentifier).to.equal(ownerAddress));
      expect(await contract.authorOfIdentifier(tokenUnicalIdentifier).to.equal(ownerAddress));

      expect(await contract.getTokensByOwner(ownerAddress).to.equal([1]));
      expect(await contract.getTokensByAuthor(ownerAddress).to.equal([1]));
  });
  
  it("Should be right relation between identifier and tokenId", async () => {
      expect(await contract.getImageIdentifier(1).to.equal(tokenUnicalIdentifier));
  });
});
