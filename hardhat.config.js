require('dotenv').config();
require('@nomicfoundation/hardhat-toolbox');
require('solidity-coverage');
require('hardhat-gas-reporter');
require('hardhat-gas-trackooor');
require('@nomicfoundation/hardhat-chai-matchers');

// process.env.NODE_URL

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: '0.8.18',
	gasReporter: {
		enabled: false,
		currency: 'EUR',
		gasPriceApi:
			'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice',
	},
};
