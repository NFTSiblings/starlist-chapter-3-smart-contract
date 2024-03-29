// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@siblings/modules/AdminPrivileges.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

interface IERC1155 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
}

contract StarlistLootboxBetaTest is AdminPrivileges {
    address private LOSTPOETS_PAGES; // Address should be initialised here, and be constant
    address private LOSTPOETS; // Address should be initialised here, and be constant
    address private vault; // Address should be initialised here

    mapping(address => uint8) public claimed;
    bytes32 private merkleRootOne;
    bytes32 private merkleRootTwo;
    uint16[] private poetTokenIDs = [0, 1, 2, 3, 4, 5]; // Update this array before deployment

    // Constructor included for Hardhat testing purposes only - this should not be included on deployment
    constructor(address pages, address poets, address _vault) {
        LOSTPOETS_PAGES = pages;
        LOSTPOETS = poets;
        vault = _vault;
    }

    function setMerkleRoots(bytes32 rootOne, bytes32 rootTwo) public onlyAdmins {
        merkleRootOne = rootOne;
        merkleRootTwo = rootTwo;
    }

    function setVaultAddress(address addr) public onlyAdmins {
        vault = addr;
    }

    function setPoetTokenIDs(uint16[] calldata ids) public onlyAdmins {
        poetTokenIDs = ids;
    }

    function claim(bytes32[] calldata _merkleProof) public {
        require(claimed[msg.sender] == 0, "This wallet has already claimed");
        claimed[msg.sender]++;

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (MerkleProof.verify(_merkleProof, merkleRootOne, leaf)) {
            IERC1155(LOSTPOETS_PAGES).safeTransferFrom(vault, msg.sender, 1, 1, "");
        } else {
            require(MerkleProof.verify(_merkleProof, merkleRootTwo, leaf), "Invalid Merkle proof");

            uint16 id = poetTokenIDs[poetTokenIDs.length - 1];
            poetTokenIDs.pop();

            IERC721(LOSTPOETS).safeTransferFrom(vault, msg.sender, id);
        }
    }

    // TESTING FUNCTIONS - NOT TO BE INCLUDED ON PRODUCTION VERSION

    function resetClaimed(address a) public onlyAdmins {
        claimed[a] = 0;
    }
}