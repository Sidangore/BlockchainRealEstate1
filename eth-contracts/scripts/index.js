const Web3 = require('web3');
const web3 = new Web3('http://127.0.0.1:7545');
module.exports = async function main(callback) {
    try {
        console.log()
        callback(0);
    } catch (err) {
        console.error(err);
        callback(1);
    }
}