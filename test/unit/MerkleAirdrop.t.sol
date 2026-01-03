//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {ZeroToken} from "../../src/ZeroToken.sol";
//import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleTest is Test {
    MerkleAirdrop public merkleAirdrop;
    ZeroToken public zeroToken;

    bytes32 public constant MERKLE_ROOT = 0xc08e171be66d373c096298857a4161fdd009165f46cebd423f7d2ab17655e0c9;
    bytes32 proofOne = 0x0000000000000000000000000000000000000000000000000000000000000000;
    bytes32 proofTwo = 0x62bc4537c5458fe382c7ac02d34807515c4763e025131d336b1cfadbc780c1eb;
    bytes32 proofThree = 0xf35b3f5b344ce56e8b5f25184b214f5d0a719c651e249009f4cc581a061a759c;
    bytes32[] public PROOF = [proofOne, proofTwo, proofThree];
    address user;
    address gasPayer;
    uint256 privKey;
    uint256 AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 AMOUNT_MINT = AMOUNT_TO_CLAIM * 4;

    function setUp() public {
        zeroToken = new ZeroToken();
        merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, zeroToken);
        zeroToken.mint(zeroToken.owner(), AMOUNT_MINT);
        zeroToken.transfer(address(merkleAirdrop), AMOUNT_MINT);
        (user, privKey) = makeAddrAndKey("user");

        gasPayer=makeAddr("gasPayer");
    }

    function testUserCanClaim() public {
        uint256 startingBalance = zeroToken.balanceOf(user);
        bytes32 diger = merkleAirdrop.getMessage(user, AMOUNT_TO_CLAIM);

        // Test user can claim their airdrop
                vm.prank(gasPayer);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privKey, diger);
        merkleAirdrop.claim(user, AMOUNT_TO_CLAIM, PROOF, v,r,s);

        uint256 endingBalance = zeroToken.balanceOf(user);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}
