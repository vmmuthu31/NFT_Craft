import Header from "./header";
import { Bars3Icon, XMarkIcon } from "@heroicons/react/24/outline";
import { Dialog } from "@headlessui/react";
/* eslint-disable camelcase */
import { createSession, SessionAccount, supportsSessions } from "@argent/x-sessions";
import { utils } from "ethers";
import { getStarknet } from "get-starknet";
import { useEffect, useState } from "react";
import { Contract, ec, number, RpcProvider, stark, uint256 } from "starknet";

import contractAbi from "../contracts/build/nftcraft_abi.json";
import deployments from "../contracts/deployments.json";
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

const navigation = [
  { name: "Home", href: "/" },
  { name: "Marketplace", href: "/Marketplace" },
  { name: "Our Team", href: "/Team" },
  { name: "Abstract", href: "/Abstract" },
];

export default function Example() {

  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
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
    <div className=" isolate bgimg ">
      <div className="absolute inset-x-0 top-[-10rem] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[-20rem]">
        <svg
          className="relative left-[calc(50%-11rem)] -z-10 h-[21.1875rem] max-w-none -translate-x-1/2 rotate-[30deg] sm:left-[calc(50%-30rem)] sm:h-[42.375rem]"
          viewBox="0 0 1155 678"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            fill="url(#45de2b6b-92d5-4d68-a6a0-9b9b2abad533)"
            fillOpacity=".3"
            d="M317.219 518.975L203.852 678 0 438.341l317.219 80.634 204.172-286.402c1.307 132.337 45.083 346.658 209.733 145.248C936.936 126.058 882.053-94.234 1031.02 41.331c119.18 108.451 130.68 295.337 121.53 375.223L855 299l21.173 362.054-558.954-142.079z"
          />
          <defs>
            <linearGradient
              id="45de2b6b-92d5-4d68-a6a0-9b9b2abad533"
              x1="1155.49"
              x2="-78.208"
              y1=".177"
              y2="474.645"
              gradientUnits="userSpaceOnUse"
            >
              <stop stopColor="#9089FC" />
              <stop offset={1} stopColor="#FF80B5" />
            </linearGradient>
          </defs>
        </svg>
      </div>
      <div className="px-6 pt-6 lg:px-8">
        <div>
          <nav
            className="flex h-9 items-center justify-between"
            aria-label="Global"
          >
            <div className="flex lg:min-w-0 lg:flex-1" aria-label="Global">
              <img
                className="w-28"
                src="https://raw.githubusercontent.com/JEC-Gryffindors/Python-Components/master/%5Bremoval.ai%5D_tmp-638825f6c4549.png"
              />
              <h1 className="h-8 py-7  text-3xl font-bold text-white">
                NFT Crafter
              </h1>
            </div>
            <div className="flex lg:hidden">
              <button
                type="button"
                className="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-white"
                onClick={() => setMobileMenuOpen(true)}
              >
                <span className="sr-only">Open main menu</span>
                <Bars3Icon className="h-6 w-6" aria-hidden="true" />
              </button>
            </div>

            <div className="hidden lg:flex lg:min-w-0 lg:flex-1 lg:justify-end">
              <div className="hidden lg:flex lg:min-w-0 lg:flex-1 lg:justify-center lg:gap-x-12">
                {navigation.map((item) => (
                  <a
                    key={item.name}
                    href={item.href}
                    className="font-semibold px-3 py-3 text-white hover:text-white"
                  >
                    {item.name}
                  </a>
                ))}
              </div>
              {!account && <button
                className="py-3 px-5 rounded-lg inline-block  text-sm font-semibold leading-6 text-white shadow-sm ring-1  bg-red-600 hover:ring-red-700"
                hidden={account}
                onClick={connectWallet}
              >
                Connect
              </button>}

              {account && (
                <div>
                  <p className="py-3 px-5 rounded-lg inline-block  text-sm font-semibold leading-6 text-white shadow-sm ring-1 hover:bg-lime-500 bg-lime-500" >Connected</p>
                </div>
              )}
            </div>
          </nav>
          <Dialog as="div" open={mobileMenuOpen} onClose={setMobileMenuOpen}>
            <Dialog.Panel
              focus="true"
              className="fixed inset-0 z-10 overflow-y-auto bg-black px-6 py-6 lg:hidden"
            >
              <div className="flex h-9 items-center justify-between">
                <div className="flex">
                  <a href="#" className="-m-1.5 p-1.5">
                    <img
                      className="w-28"
                      src="https://raw.githubusercontent.com/JEC-Gryffindors/Python-Components/master/%5Bremoval.ai%5D_tmp-638825f6c4549.png"
                    />
                  </a>
                </div>
                <div className="flex">
                  <button
                    type="button"
                    className="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-white"
                    onClick={() => setMobileMenuOpen(false)}
                  >
                    <span className="sr-only">Close menu</span>
                    <XMarkIcon className="h-6 w-6" aria-hidden="true" />
                  </button>
                </div>
              </div>
              <div className="mt-6 flow-root">
                <div className="-my-6 divide-y divide-gray-500/10">
                  <div className="space-y-2 py-6">
                    {navigation.map((item) => (
                      <a
                        key={item.name}
                        href={item.href}
                        className="-mx-3 block rounded-lg py-3 px-3 text-base font-semibold leading-7 text-white hover:bg-gray-400/10"
                      >
                        {item.name}
                      </a>
                    ))}
                  </div>
                  <div className="py-6">
                    <a
                      href="#"
                      className="-mx-3 block rounded-lg py-2.5 px-3 text-base font-semibold leading-6 text-white hover:bg-gray-400/10"
                    >
                      Sign in
                    </a>
                  </div>
                </div>
              </div>
            </Dialog.Panel>
          </Dialog>
        </div>
      </div>
      <main>
        <div className=" pt-12 sm:pt-16">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="max-w-4xl mx-auto text-center">
              <h2 className="text-3xl font-extrabold text-green-50 sm:text-4xl">
                Trusted by developers from over 80 planets
              </h2>
              <p className="mt-3 text-xl text-gray-400 sm:mt-4">
                Lorem ipsum dolor, sit amet consectetur adipisicing elit.
                Repellendus repellat laudantium.
              </p>
            </div>
          </div>
          <div className=" pb-12  sm:pb-16">
            <div className="relative">
              <div className="absolute inset-0 h-1/2 " />
              <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"></div>
            </div>
          </div>
        </div>
        <div>
          <div class="p-10 grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://play-lh.googleusercontent.com/dRI6WwCFIIHeUKF4eQM-4Nk-umW4s1aocXPnerCT-S4TwPI3k4hfrAn7mZsgo8raDA"
                alt="Snake And Ladder"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">Snake And Ladder</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>

            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://images.pexels.com/photos/220053/pexels-photo-220053.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="River"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">Tic Tac Toe</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>

            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://images.pexels.com/photos/163480/war-desert-guns-gunshow-163480.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Forest"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">2D Shooting game</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>
          </div>
        </div>
        <div>
          <div class="p-10 grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://i.pcmag.com/imagery/articles/01WBfGo5Dmjo09o1pJhERvo-2..v1569488273.jpg"
                alt="Mountain"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">Flappy Bird</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>

            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://m.media-amazon.com/images/M/MV5BYjA0OGEwY2EtZDE5ZS00MzgwLWI1NWUtZDNiMWM0Mzk5MDhlXkEyXkFqcGdeQWplZmZscA@@._V1_.jpg"
                alt="River"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">Squid Game</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>

            <div class="rounded overflow-hidden bg-white shadow-lg">
              <img
                class="w-full h-72"
                src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNDJB_w3TEzDEMsTXqQyBey9pqBBv-0FtI0s2eg1Gzlo5wA_Nnu5H2x_G2-PlrbYGZTAM&usqp=CAU"
                alt="Forest"
              />
              <div class="px-6 py-4">
                <div class="font-bold text-xl mb-2">Dyno Game</div>
                <p class="text-gray-700 text-base">
                  Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                  Voluptatibus quia, Nonea! Maiores et perferendis eaque,
                  exercitationem praesentium nihil.
                </p>
              </div>
              <div class="px-6 pt-2 pb-2">
                <button
                  type="submit"
                  className="block w-full btn-grad  py-3 px-4 rounded-md shadow border-solid border-2 border-slate-900  text-white font-medium hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2  focus:ring-offset-gray-900"
                >
                  Add to Cart
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
