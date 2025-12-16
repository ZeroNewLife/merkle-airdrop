// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ZeroToken} from "../src/ZeroToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {

    function deployMerkle() public returns (MerkleAirdrop, ZeroToken) {
        vm.startBroadcast();
        Zerotoken token = new ZeroToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop();

        ZeroToken token = new
    function run() external returns (MerkleAirdrop, ZeroToken) {
        return deployMerkle();
    }
}
