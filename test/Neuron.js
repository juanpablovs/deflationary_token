const {loadFixture} = require('@nomicfoundation/hardhat-network-helpers');
const {expect} = require('chai');

describe('Neuron contract', async function () {
	async function deployNeuronFixture() {
		const Neuron = await ethers.getContractFactory('Neuron');
		const [owner, buyer1, buyer2] = await ethers.getSigners();

		// const neuronToken = new GasTracker(await Neuron.deploy(), {
		// 	logAfterTx: true,
		// });
		const neuronToken = await Neuron.deploy();

		await neuronToken.deployed();

		return {Neuron, neuronToken, owner, buyer1, buyer2};
	}

	describe('Deployment Tests', async function () {
		it('Check that Name is Neurons', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.name()).to.equal('Neurons');
		});

		it('Check that Symbol is NEON', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.symbol()).to.equal('NEON');
		});

		it('Check that neuronsScalingFactor is equal to BASE', async function () {
			const {neuronToken} = await loadFixture(deployNeuronFixture);
			expect(await neuronToken.neuronsScalingFactor()).to.equal(
				await neuronToken.BASE(),
			);
		});

		it('Check that owners balance is equal to Initial Supply and event is emitted', async function () {
			const {neuronToken, owner} = await loadFixture(deployNeuronFixture);
			// balanceOf overrides native ERC balanceOf function
			// as defined in the constructor balance is stored fragemented into Neurons
			const ownerBalance = (
				await neuronToken.balanceOf(owner.address)
			).toString();
			const initialSupply = (
				await neuronToken.neuronsToFragment(await neuronToken.initSupply())
			).toString();
			expect(ownerBalance).to.equal(initialSupply);


			await expect(neuronToken.transfer(owner.address, initialSupply))
				.to.emit(neuronToken, 'Transfer');
		});
	});

	describe(
		'ERC20 Overrides implementations',
		await function () {
			it('Checks Function neuronsToFragment', async function () {
				const {neuronToken} = await loadFixture(deployNeuronFixture);
				const amount = 1_000_000;
				expectedResult =
					(amount * (await neuronToken.neuronsScalingFactor())) /
					(await neuronToken.internalDecimals());
				expect(await neuronToken.neuronsToFragment(amount)).to.equal(
					expectedResult,
				);
			});

			it('Checks Function transfer', async function () {
				const {neuronToken, owner, buyer1} = await loadFixture(deployNeuronFixture);

				await expect(() =>
					neuronToken.transfer(buyer1.address, 50)).to.changeTokenBalances(neuronToken, [owner.address, buyer1.address], [-50, 50]);

				await expect(neuronToken.transfer(buyer1.address, 50))
					.to.emit(neuronToken, 'Transfer').withArgs(owner.address, buyer1.address, 50);
			});
		},
	);

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
