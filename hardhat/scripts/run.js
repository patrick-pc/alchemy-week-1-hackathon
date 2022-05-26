const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory('TextFace')
    const nftContract = await nftContractFactory.deploy()
    await nftContract.deployed()

    console.log('Contract address:', nftContract.address)

    let txn = await nftContract.mint()
    await txn.wait()
    console.log('Minted NFT #1')

    txn = await nftContract.mint()
    await txn.wait()
    console.log('Minted NFT #2')

    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

main()
