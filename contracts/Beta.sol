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

contract StarlistLootboxBeta is AdminPrivileges {
    address constant private LOSTPOETS_PAGES = 0x34829540A3217E96a7F5DCE63FFFf61FA44500DA; // SampleERC1155 Rinkeby
    address constant private LOSTPOETS = 0x23eD4B6E5654a57c787D2869ED4AD011eec6974a; // SampleERC721 Rinkeby
    address private vault = 0x699a1928EA12D21dd2138F36A3690059bf1253A0; // Ethan's wallet

    mapping(address => uint8) public claimed;
    bytes32 private merkleRootOne;
    bytes32 private merkleRootTwo;
    uint16[] private poetTokenIDs = [0, 1, 2, 3, 4, 5]; // Update this array before deployment

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
}