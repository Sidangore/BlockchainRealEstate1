const SquareVerifier = artifacts.require('../contracts/verifier.sol');
const zokratesProof = require("../../zokrates/code/square/proof.json");

contract('TestVerifier', accounts => {
    describe('Exercise Verifier', function() {
        beforeEach(async function() {
            this.contract = await SquareVerifier.new();
        });

        // Test verification with correct proof
        // - use the contents from proof.json generated from zokrates steps
        it('should verify with the correct proof', async function() {
            let result = await this.contract.verifyTx.call(...Object.values(zokratesProof.proof), zokratesProof.inputs);
            assert.equal(result, true)
        });

        // Test verification with incorrect proof
        it('should NOT verify with the incorrect proof', async function() {
            let incorrectInputs = [
                "0x0000000000000000000000000000000000000000000000000000000000000001",
                "0x0000000000000000000000000000000000000000000000000000000000000001"
            ];
            let result = await this.contract.verifyTx.call(...Object.values(zokratesProof.proof), incorrectInputs);
            assert.equal(result, false);
        });
    });
});