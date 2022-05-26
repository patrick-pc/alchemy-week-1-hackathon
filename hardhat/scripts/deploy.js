const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory('TextFace')
    const nftContract = await nftContractFactory.deploy()
    await nftContract.deployed()
    
    console.log('Contract address:', nftContract.address)
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

main()
