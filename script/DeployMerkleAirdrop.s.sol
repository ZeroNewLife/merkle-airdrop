// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop,IERC20} from "../src/MerkleAirdrop.sol";
import {ZeroToken} from "../src/ZeroToken.sol";


contract DeployMerkleAirdrop is Script {

    bytes32 public ROOT = 0xc08e171be66d373c096298857a4161fdd009165f46cebd423f7d2ab17655e0c9;

    uint256 public AMOUNT_TO_TRANSFER = 7 * (25 * 1e18);

    function deployMerkleAirdrop() public returns (MerkleAirdrop, ZeroToken) {
        vm.startBroadcast();
        ZeroToken zeroToken = new ZeroToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(zeroToken));
        // Send Bagel tokens -> Merkle Air Drop contract
        zeroToken.mint(zeroToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(zeroToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, zeroToken);        
        
    }

    function run() external  returns (MerkleAirdrop, ZeroToken) {
        return deployMerkleAirdrop();
    }
}
