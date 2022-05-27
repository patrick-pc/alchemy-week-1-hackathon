import { ConnectButton } from '@rainbow-me/rainbowkit'
import { ethers } from 'ethers'
import { useState } from 'react'
import { CONTRACT_ADDRESS, CONTRACT_ABI } from '../constants'

const Home = () => {
  const [isMining, setIsMining] = useState(false)

  const mintTextFaceNFT = async () => {
    try {
      const { ethereum } = window

      let chainId = await ethereum.request({ method: 'eth_chainId' })
      console.log('Connected to chain ' + chainId)

      const rinkebyChainId = '0x4'
      if (chainId !== rinkebyChainId) {
        alert('You are not connected to the Rinkeby Test Network!')
        return
      }

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          CONTRACT_ABI,
          signer
        )

        console.log('Going to pop wallet now to pay gas...')
        let nftTxn = await connectedContract.mint()

        console.log('Mining...please wait.')
        setIsMining(true)
        await nftTxn.wait()
        setIsMining(false)

        console.log(
          `Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`
        )
      } else {
        console.log("Ethereum object doesn't exist!")
      }
    } catch (error) {
      console.log(error)
    }
  }

  const renderMintUI = () => (
    <>
      <button
        className="mt-4 rounded-xl bg-gray-100 py-2 px-8"
        onClick={mintTextFaceNFT}
      >
        {isMining ? 'Mining...' : 'Mint NFT'}
      </button>
    </>
  )

  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <ConnectButton />
      {renderMintUI()}
    </div>
  )
}

export default Home
