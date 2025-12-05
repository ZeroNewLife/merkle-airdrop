// SPDX-License-Identifier: MIT


pragma solidity ^0.8.30;
import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";



contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    event Claimed(address indexed account, uint256 amount);


    address[] claemers;
    bytes32 private immutable I_MERCLE_ROOT;
    IERC20 private immutable I_AIRDROP_TOKEN; 
    mapping(address claimer => bool claimed) private s_hasClaimed;

    constructor(bytes32 mercleRoot, IERC20 airdropToken){
        I_MERCLE_ROOT = mercleRoot;
        I_AIRDROP_TOKEN = airdropToken;

    }


    function claim(address account,uint256 amount,bytes32[] calldata merkleProof) external {
        if(s_hasClaimed[account]){
            revert MerkleAirdrop__AlreadyClaimed();
        }

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount)))); 
        if(!MerkleProof.verify(merkleProof, I_MERCLE_ROOT, leaf)){
            revert MerkleAirdrop__InvalidProof();
        }
        emit Claimed(account, amount);
        I_AIRDROP_TOKEN.safeTransfer(account, amount);



    }

}
