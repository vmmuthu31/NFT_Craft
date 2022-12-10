import Head from 'next/head'
import Image from 'next/image'
import Hero from './Hero'
import styles from '../styles/Home.module.css'

export default function Home() {

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
  )
}
