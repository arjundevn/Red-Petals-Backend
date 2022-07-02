
const fs = require('fs')
const { artifacts } = require("hardhat");

// yours, or create new ones.
async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  // ethers is available in the global scope
  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());


  const RedPetals = await hre.ethers.getContractFactory("RedPetals");
  const redPetals = await RedPetals.deploy();

  await redPetals.deployed();

  console.log("RedPetals deployed to:", redPetals.address);

  const RedPetalsArtifact = artifacts.readArtifactSync("RedPetals");

  fs.writeFileSync(
    "DeployedAddress.txt",
    JSON.stringify({ RedPetals: redPetals.address }, undefined, 2),
  );

  fs.writeFileSync(
    "RedPetals.json",
    JSON.stringify(RedPetalsArtifact, null, 2)
  );
  }


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
