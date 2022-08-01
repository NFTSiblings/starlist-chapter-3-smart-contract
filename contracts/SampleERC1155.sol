// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract MyToken is ERC1155, ERC1155Burnable {
    constructor() ERC1155("") {}

    function mint(uint256 tokenID, uint256 amount) public {
        _mint(msg.sender, tokenID, amount, "");
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts) public {
        _mintBatch(msg.sender, ids, amounts, "");
    }

    function mintTo(address recipient, uint256 tokenID, uint256 amount) public {
        _mint(recipient, tokenID, amount, "");
    }

    function mintBatchTo(address recipient, uint256[] memory ids, uint256[] memory amounts) public {
        _mintBatch(recipient, ids, amounts, "");
    }
}