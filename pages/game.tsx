/* eslint-disable camelcase */
import { createSession, SessionAccount, supportsSessions } from "@argent/x-sessions";
import { utils } from "ethers";
import { getStarknet } from "get-starknet";
import { useEffect, useState } from "react";
import { Contract, ec, number, RpcProvider, stark, uint256 } from "starknet";

import contractAbi from "../../contracts/build/nftcraft_abi.json";
import deployments from "../../contracts/deployments.json";

const { genKeyPair, getStarkKey, getKeyPair } = ec;

declare global {
  interface Window {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    starknet?: any;
  }
}

function getUint256CalldataFromBN(bn: number.BigNumberish) {
  return { type: "struct" as const, ...uint256.bnToUint256(bn) };
}

export function parseInputAmountToUint256(input: string, decimals = 18) {
  return getUint256CalldataFromBN(utils.parseUnits(input, decimals).toString());
}

type Network = "testnet";

export default function Home() {
  const [account, setAccount] = useState<any>();
  const [sessionAccount, setSessionAccount] = useState<SessionAccount | undefined>();
  const [isSupportsSession, setIsSupportsSession] = useState(false);
  const [network, setNetwork] = useState<Network>("testnet");

  const [myNFTs, setMyNFTs] = useState<string[]>([]);

  const [inputX, setInputX] = useState("0");
  const [inputY, setInputY] = useState("0");
  const [inputZ, setInputZ] = useState("0");
  const [inputModelId, setInputModelId] = useState("0");
  const [inputTextureId, setInputTextureId] = useState("0");

  const connectWallet = async () => {
    try {
      const starknet = getStarknet();
      // const starknet = await connect();
      await starknet!.enable({
        starknetVersion: "v4",
      } as any);
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      setAccount(starknet?.account);
    } catch (e) {
      console.error(e);
    }
  };

  const getNFTs = async () => {
    if (!account) {
      throw new Error("account is not defined");
    }
    const provider = new RpcProvider({
      nodeUrl: "https://nd-133-096-096.p2pify.com/b7703f21b16704348bf592a2245f1aaf",
    });
    const { block_number } = await provider.getBlock("latest");
    const { events } = await provider.getEvents({
      from_block: { block_number: 0 },
      to_block: { block_number },
      address: deployments[network],
      keys: ["0x26b2c4828dd5c46b480c41d84ea8dc17fcae16cfb938437ecb30c5aad25378f"],
      chunk_size: 20,
    } as any);

    const holders: { [key: string]: string } = {};
    events.forEach((event) => {
      holders[parseInt(event.data[2]).toString()] = event.data[1].toLowerCase();
    });
    console.log(holders);
    const entries = Object.entries(holders);
    const mine = entries.filter(([, value]) => value === account.address).map(([tokenId]) => tokenId);
    console.log(mine);
    setMyNFTs(mine);
  };

  const enableSessionKey = async () => {
    if (!account) {
      throw new Error("account is not defined");
    }
    const sessionSigner = genKeyPair();
    // let sessionSigner;
    // const savedSessionSignerPk = window.localStorage.getItem("session-key-pk");
    // if (!savedSessionSignerPk) {
    //   sessionSigner = genKeyPair();
    //   window.localStorage.setItem("session-key-pk", sessionSigner.priv.toString());
    // } else {
    //   sessionSigner = getKeyPair(savedSessionSignerPk);
    // }
    const signedSession = await createSession(
      {
        key: getStarkKey(sessionSigner),
        expires: Math.floor((Date.now() + 1000 * 60 * 60 * 24) / 1000),
        policies: [
          {
            contractAddress: deployments[network],
            selector: "set_eccd65dc",
          },
        ],
      },
      account
    );

    const sessionAccount = new SessionAccount(account, account.address, sessionSigner, signedSession);
    setSessionAccount(sessionAccount);
  };

  const setMap = async () => {
    if (!account) {
      throw new Error("account is not defined");
    }

    if (sessionAccount) {
      const contract = new Contract(contractAbi as any, deployments[network], sessionAccount);
      // await contract.set_eccd65dc(
      //   [number.toFelt(inputX), 0],
      //   [number.toFelt(inputY), 0],
      //   [number.toFelt(inputZ), 0],
      //   [number.toFelt(inputModelId), 0],
      //   [number.toFelt(inputTextureId), 0]
      // );

      const result = await sessionAccount.execute(
        {
          entrypoint: "set_eccd65dc",
          contractAddress: deployments[network],
          calldata: [
            [number.toFelt(inputX), ""],
            [number.toFelt(inputY), ""],
            [number.toFelt(inputZ), ""],
            [number.toFelt(inputModelId), ""],
            [number.toFelt(inputTextureId), ""],
          ],
          // calldata: stark.compileCalldata({
          //   x: [number.toFelt(inputX), ""],
          //   y: [number.toFelt(inputY), ""],
          //   z: [number.toFelt(inputZ), ""],
          //   mId: [number.toFelt(inputModelId), ""],
          //   tId: [number.toFelt(inputTextureId), ""],
          // }),
        },
        undefined,
        {
          // maxFee: "10000",
        }
      );

      console.log(result);
    } else {
      const contract = new Contract(contractAbi as any, deployments[network], account);
      await contract.set_eccd65dc(
        [number.toFelt(inputX), ""],
        [number.toFelt(inputY), ""],
        [number.toFelt(inputZ), ""],
        [number.toFelt(inputModelId), ""],
        [number.toFelt(inputTextureId), ""]
      );
    }
  };

  const getMap = async () => {
    const provider = new RpcProvider({
      nodeUrl: "https://nd-133-096-096.p2pify.com/b7703f21b16704348bf592a2245f1aaf",
    });
    const { block_number } = await provider.getBlock("latest");
    const { events } = await provider.getEvents({
      from_block: { block_number: 0 },
      to_block: { block_number },
      address: deployments[network],
      keys: ["0x13c0314b84106a72283aa14b33b263d16c59e189dac255e4e44a042c0ef962f"],
      chunk_size: 20,
    } as any);
    console.log(events);
    const tokenIds: any = {};
    events.forEach((event) => {
      if (!tokenIds[parseInt(event.data[0]).toString()]) {
        tokenIds[parseInt(event.data[0]).toString()] = {};
      }
      if (!tokenIds[parseInt(event.data[0]).toString()][parseInt(event.data[2]).toString()]) {
        tokenIds[parseInt(event.data[0]).toString()][parseInt(event.data[2]).toString()] = {};
      }
      tokenIds[parseInt(event.data[0]).toString()][parseInt(event.data[2]).toString()][
        parseInt(event.data[4]).toString()
      ] = parseInt(event.data[10]).toString();
    });
    console.log(tokenIds);
    const map = [];
    for (let x = 0; x < 200; x++) {
      for (let y = 0; y < 200; y++) {
        for (let z = 0; z < 200; z++) {
          const id = tokenIds[x] && tokenIds[x][y] && tokenIds[x][y][z] ? tokenIds[x][y][z] : "0";
          map.push({ x, y, z, id });
        }
      }
    }
    console.log(map);
  };

  useEffect(() => {
    if (!account) {
      return;
    }
    supportsSessions(account.address, account).then((result) => setIsSupportsSession(result));
  }, [account]);

  return (
    <div>
      <p>Network</p>
      <select disabled onChange={(e) => setNetwork(e.target.value as Network)}>
        <option value="testnet">Testnet</option>
        <option value="localhost">Localhost</option>
      </select>
      <button disabled={!!account} onClick={connectWallet}>
        connect
      </button>
      {!account && <p>Please connect argent x wallet</p>}
      {account && (
        <div>
          <p>address: {account.address}</p>
          <p>isSupportsSession: {(!!isSupportsSession).toString()}</p>
          <button disabled={!!sessionAccount} onClick={enableSessionKey}>
            Enable Session Key
          </button>
          <p>isEnabled: {(!!sessionAccount).toString()}</p>
          <p>NFTCraft</p>
          <p>{deployments[network]}</p>
          <div>
            <p>Map</p>
            <p>X</p>
            <input value={inputX} onChange={(e) => setInputX(e.target.value)} max={200} type={"number"} />
            <p>Y</p>
            <input value={inputY} onChange={(e) => setInputY(e.target.value)} max={200} type={"number"} />
            <p>Z</p>
            <input value={inputZ} onChange={(e) => setInputZ(e.target.value)} max={200} type={"number"} />
            <p>Model ID</p>
            <input value={inputModelId} onChange={(e) => setInputModelId(e.target.value)} max={200} type={"number"} />
            <p>Texture ID</p>
            <input
              value={inputTextureId}
              onChange={(e) => setInputTextureId(e.target.value)}
              max={200}
              type={"number"}
            />
            <button onClick={setMap}>Set</button>
            <button onClick={getMap}>Get</button>
          </div>
        </div>
      )}
    </div>
  );
}