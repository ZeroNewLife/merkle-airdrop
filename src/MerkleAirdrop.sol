// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712 {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    event Claimed(address indexed account, uint256 amount);

    struct AirdropClaim {
        address account;
        uint256 amount;
    }

    address[] claemers;
    bytes32 private immutable I_MERKLE_ROOT;
    IERC20 private immutable I_AIRDROP_TOKEN;

    bytes32 private constant MESSAGE_TYPE_HASH = keccak256("AirdropClaim(address account,uint256 amount)");
    mapping(address claimer => bool claimed) private s_hasClaimed;

    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("MerkleAirdrop", "1") {
        I_MERKLE_ROOT = merkleRoot;
        I_AIRDROP_TOKEN = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s)
        external
    {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }
        if (!_isValideSignature(account, getMessage(account, amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
        }

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if (!MerkleProof.verify(merkleProof, I_MERKLE_ROOT, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true;
        emit Claimed(account, amount);
        I_AIRDROP_TOKEN.safeTransfer(account, amount);
    }

    function getMessage(address account, uint256 amount) public view returns (bytes32) {
        return
            _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPE_HASH, AirdropClaim({account: account, amount: amount}))));
    }

    function getAirdropToken() external view returns (IERC20) {
        return I_AIRDROP_TOKEN;
    }

    function getMerkleRoot() external view returns (bytes32) {
        return I_MERKLE_ROOT;
    }

    function _isValideSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
    }
}
