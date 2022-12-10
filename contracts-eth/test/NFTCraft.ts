import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFTCraft", function () {
  const fixture = async () => {
    const [signer] = await ethers.getSigners();
    const NFTCraft = await ethers.getContractFactory("NFTCraft");
    const nftCraft = await NFTCraft.deploy();
    return { signer, nftCraft };
  };

  it("Should work", async function () {
    const { nftCraft } = await fixture();
    const tokenId = 1;
    await nftCraft.set(0, 0, 1, 0, 0);
    expect(await nftCraft.ownerOf(tokenId)).to.eq(nftCraft.address);
    const setFilter = nftCraft.filters.Set();
    const logs = await ethers.provider.getLogs(setFilter);
    const tokenIds: any = {};
    logs.forEach((log) => {
      const { args } = nftCraft.interface.parseLog(log);
      tokenIds[args.x] = {
        [args.y]: {
          [args.x]: args.tokenId.toString(),
        },
      };
    });
    const map = [];
    for (let x = 0; x < 200; x++) {
      for (let y = 0; y < 200; y++) {
        for (let z = 0; z < 200; z++) {
          const id = tokenIds[x] && tokenIds[x][y] && tokenIds[x][y][z] ? tokenIds[x][y][z] : "0";
          map.push({ x, y, z, id });
        }
      }
    }
    const transferFilter = nftCraft.filters.Transfer();
    const transferLogs = await ethers.provider.getLogs(transferFilter);
    const holders: any = {};
    transferLogs.forEach((log) => {
      const { args } = nftCraft.interface.parseLog(log);
      holders[args.id.toString()] = args.to;
    });
    console.log(map);
    console.log(holders);
  });
});
