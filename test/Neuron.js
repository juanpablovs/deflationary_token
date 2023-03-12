const {loadFixture} = require('@nomicfoundation/hardhat-network-helpers');
const {expect} = require('chai');

describe('Neuron contract', async function () {
	async function deployNeuronFixture() {
		const Neuron = await ethers.getContractFactory('Neuron');
		const [owner, buyer1, buyer2] = await ethers.getSigners();

		const neuronToken = new GasTracker(await Neuron.deploy(), {logAfterTx: true});

		await neuronToken.deployed();

		return {Neuron, neuronToken, owner, buyer1, buyer2};
	}

	describe('Deployment Tests', async function () {
		it('Check that Name = Neurons', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.name()).to.equal('Neurons');
		});

		it('Check that Symbol = NEON', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.symbol()).to.equal('NEON');
		});

		it('Check that neuronsScalingFactor = BASE', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.neuronsScalingFactor()).to.equal(
				await neuronToken.BASE(),
			);
		});

		it('Check that owners balance = Initial Supply', async function () {
            const { neuronToken, owner } = await loadFixture(deployNeuronFixture);
            const ownerBalance = await neuronToken.balanceOf(owner.address);
            console.log(
							await neuronToken.initSupply(),
							await neuronToken.owner()
						);
			expect(await neuronToken.initSupply()).to.equal(
				ownerBalance,
            );
		});
	});

	describe(
		'SafeMath implementations',
		await function () {
			it('Checks Function fragmentToNeurons', async function () {
				const {neuronToken} = await loadFixture(deployNeuronFixture);
				const ExpectedResult =
					(await neuronToken.internalDecimals()) / (await neuronToken.BASE());
				expect(await neuronToken.fragmentToNeurons(1)).to.equal(ExpectedResult);
			});
		},
	);
});
