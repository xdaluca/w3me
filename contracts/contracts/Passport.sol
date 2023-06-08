// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import './Verifier.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/utils/Base64.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

contract Passport is ERC721, ERC721Enumerable, Verifier {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;

  mapping(uint256 => uint16) public scores;

  constructor() ERC721('Gitcoin Passport Score', 'GPS') {}

  function safeMint(address to, uint16 score, bytes memory signature) public {
    verifySignature(to, score, signature);

    uint256 tokenId = _tokenIdCounter.current();
    _tokenIdCounter.increment();
    _safeMint(to, tokenId);

    scores[tokenId] = score;
  }

  function update(uint256 tokenId, address to, uint16 score, bytes memory signature) public {
    verifySignature(to, score, signature);

    scores[tokenId] = score;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
    require(_exists(id), 'ERC721Metadata: URI query for nonexistent token');

    bytes memory dataURI = abi.encodePacked(
      '{',
      '"name": "Gitcoin Passport Score",',
      '"description": "Your on-chain Gitcoin Passport Score.",',
      '"image": "',
      generateSvg(id),
      '"',
      '}'
    );

    return string(abi.encodePacked('data:application/json;base64,', Base64.encode(dataURI)));
  }

  function generateSvg(uint256 tokenId) public view returns (string memory) {
    bytes memory svg = abi.encodePacked(
      '<svg width="512" height="512" style="padding:70px;background-color:#0e0333;" fill="none" xmlns="http://www.w3.org/2000/svg">'
      '<svg x="5" y="300">'
      '<path fill-rule="evenodd" fill="#02e2ac" d="m21 12.6c1 1.4 1.6 3.2 1.6 5 0 1.7-0.6 3.5-1.6 4.9l2.1 1.6c1.4-1.9 2.2-4.2 2.2-6.5 0-2.5-0.8-4.9-2.3-6.9l-1.3 1.1z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m25.3 26.1v5.3c0 0.3-0.3 0.6-0.6 0.6h-10.6c-3.2-0.1-6.4-1.3-8.9-3.4-2.5-2.1-4.3-5-4.9-8.2-0.7-3.2-0.2-6.6 1.3-9.5 1.5-2.9 4-5.2 6.9-6.6l0.1-3.2q-0.1-0.2 0-0.4 0.1-0.2 0.2-0.4 0.1-0.1 0.3-0.2 0.2-0.1 0.4-0.1 0.2 0 0.4 0.1 0.2 0.1 0.3 0.2 0.2 0.2 0.2 0.4 0.1 0.2 0 0.4v2.5q1.3-0.3 2.6-0.5v-2q0-0.2 0.1-0.4 0-0.2 0.2-0.4 0.1-0.1 0.3-0.2 0.2-0.1 0.4-0.1 0.2 0 0.4 0.1 0.1 0.1 0.3 0.2 0.1 0.2 0.2 0.4 0 0.2 0 0.4v2c3.7 0.1 7.1 1.6 9.7 4.3l0.5 0.5c0.3 0.2 0.3 0.6 0 0.8l-3.6 3.4-3.5 3.2c0.5 0.7 0.7 1.5 0.7 2.4-0.1 0.8-0.4 1.7-0.9 2.3l7.3 5.6q0.2 0.2 0.2 0.5zm-2.9 3.3c0.2 0 0.3-0.1 0.3-0.3l0.1-1.9q-0.1-0.1-0.2-0.2l-7-5.4q-0.9 0.3-1.8 0.1-1-0.1-1.7-0.6-0.8-0.5-1.3-1.3-0.5-0.8-0.6-1.7-0.2-0.9 0.1-1.8 0.3-0.9 0.9-1.6 0.6-0.7 1.4-1.1 0.9-0.3 1.8-0.3 0.8 0 1.6 0.3l5.5-5.1c0.2-0.1 0.1-0.3 0-0.4-2-1.6-4.5-2.4-7.1-2.4-1.4 0-2.7 0.2-4 0.7l-0.1 4.8q0.1 0.2 0 0.4 0 0.1-0.2 0.3-0.1 0.1-0.3 0.2-0.2 0.1-0.4 0.1-0.2 0-0.4-0.1-0.2-0.1-0.3-0.2-0.1-0.2-0.2-0.4 0-0.2 0-0.4v-3.9c-2.3 1.3-4 3.4-5 5.8-1 2.4-1.2 5-0.6 7.6 0.7 2.5 2.2 4.7 4.2 6.3 2.1 1.6 4.6 2.5 7.2 2.5zm-6.8-13.1c-0.3-0.3-0.8-0.5-1.2-0.5q-0.5 0-0.9 0.3-0.4 0.3-0.6 0.8-0.2 0.4-0.2 0.9 0.1 0.5 0.5 0.9c0.2 0.2 0.6 0.4 0.9 0.4q0.4 0.2 0.9 0 0.5-0.2 0.8-0.7 0.3-0.4 0.3-0.9c0-0.5-0.2-0.9-0.5-1.2z" />'
      '</svg>'
      '<svg x="80" y="300">'
      '<path fill="#6f3ff5" d="m8.5 22.4c-1.2-2.1-1.2-4.6-0.2-6.6l-4.8-2.8q-0.2-0.1-0.4-0.2-0.1 0.6-0.1 1.1v11.1c0 3.9 3.2 7 7 7 3.7 0 6.8-2.9 7-6.6-3.2 1.2-6.8 0-8.5-3z" />'
      '<path fill="#fc0" d="m10 7c2.5 0 4.6 1.2 5.8 3.1l4.8-2.8q0.2-0.1 0.4-0.2-0.4-0.3-0.9-0.6l-9.6-5.6c-3.4-1.9-7.6-0.7-9.6 2.6-1.8 3.2-0.8 7.3 2.2 9.3 0.6-3.3 3.5-5.8 6.9-5.8z" />'
      '<path fill="#8c65f7" d="m8.3 15.8c0.6-1.2 1.5-2.2 2.7-2.9l4.8-2.8c-1.2-1.9-3.4-3.1-5.8-3.1-3.4 0-6.3 2.5-6.9 5.8q0.2 0.1 0.4 0.2l4.8 2.8z" />'
      '<path fill="#02e2ac" d="m30.2 9.9c-1.9-3.2-5.9-4.4-9.2-2.8 2.6 2.2 3.3 5.9 1.6 8.9-1.2 2.1-3.3 3.3-5.6 3.5v5.5q0 0.2 0 0.4 0.5-0.2 1-0.5l9.6-5.5c3.3-1.9 4.5-6.2 2.6-9.5z" />'
      '<path fill="#5bf1cd" d="m17 19.5c-1.3 0.1-2.7-0.2-3.9-0.9l-4.8-2.8c-1 2-1 4.5 0.2 6.6 1.7 3 5.3 4.2 8.5 3q0-0.2 0-0.4v-5.5z" />'
      '<path fill="#ffdb4c" d="m15.8 10.1c0.8 1.1 1.2 2.4 1.2 3.8v5.6c2.3-0.2 4.4-1.4 5.6-3.5 1.7-3 1-6.7-1.6-8.9q-0.2 0.1-0.4 0.2l-4.8 2.8z" />'
      '<path fill="#fff" d="m15.8 10.1l-4.8 2.8c-1.2 0.7-2.1 1.7-2.7 2.9l4.8 2.8c1.2 0.7 2.6 1 3.9 0.9v-5.6c0-1.4-0.4-2.7-1.2-3.8z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m41.9 21.6h-2.9v-11.3h4.6q1 0 1.7 0.3 0.6 0.2 1.2 0.7 1.1 1 1.1 2.8 0 0.8-0.3 1.5-0.2 0.7-0.7 1.2-0.9 1-2.9 1h-1.8zm1-6q0.8 0 1.2-0.4 0.4-0.3 0.4-1 0-1.5-1.6-1.5h-1v2.9z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m52.2 19.6l-0.8 2h-3.1l4.3-11.3h3.2l4.2 11.3h-3.1l-0.7-2zm2-5.8l-1.2 3.6h2.4z" />'
      '<path fill="#fff" d="m68.4 13.3q-0.9-0.8-1.9-0.8-0.5 0-0.9 0.3-0.3 0.3-0.3 0.7 0 0.3 0.2 0.5 0.1 0.1 0.2 0.2 0.1 0.1 0.3 0.2 0.2 0 0.5 0.1 0.3 0.1 0.8 0.2 1.5 0.5 2.1 1.2 0.6 0.7 0.6 2 0 1.9-1.1 2.9-0.6 0.5-1.5 0.8-0.8 0.3-1.8 0.3-1 0-2-0.3-0.9-0.4-1.9-1l1.3-2.3q0.7 0.5 1.3 0.8 0.6 0.3 1.3 0.3 0.6 0 1-0.3 0.4-0.3 0.4-0.8 0-0.5-0.4-0.7-0.3-0.3-1.4-0.6-0.9-0.3-1.3-0.5-0.5-0.2-0.8-0.4-0.9-0.7-0.9-2.2 0-0.9 0.3-1.6 0.3-0.7 0.8-1.2 0.5-0.5 1.2-0.7 0.7-0.3 1.5-0.3 0.9 0 1.8 0.2 0.9 0.2 1.8 0.7z" />'
      '<path fill="#fff" d="m78.8 13.3q-0.9-0.8-1.9-0.8-0.5 0-0.9 0.3-0.3 0.3-0.3 0.7 0 0.3 0.2 0.5 0.1 0.1 0.2 0.2 0.1 0.1 0.3 0.2 0.2 0 0.5 0.1 0.3 0.1 0.8 0.2 1.5 0.5 2.1 1.2 0.7 0.7 0.7 2-0.1 1.9-1.2 2.9-0.6 0.5-1.4 0.8-0.9 0.3-1.9 0.3-1 0-2-0.3-0.9-0.4-1.9-1l1.3-2.3q0.7 0.5 1.3 0.8 0.6 0.3 1.3 0.3 0.6 0 1-0.3 0.4-0.3 0.4-0.8 0-0.5-0.4-0.7-0.3-0.3-1.4-0.6-0.9-0.3-1.3-0.5-0.5-0.2-0.8-0.4-0.9-0.7-0.9-2.2 0-0.9 0.3-1.6 0.3-0.7 0.8-1.2 0.5-0.5 1.2-0.7 0.7-0.3 1.5-0.3 0.9 0 1.8 0.2 0.9 0.2 1.8 0.7z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m86.1 21.6h-3v-11.3h4.7q1 0 1.6 0.3 0.7 0.2 1.2 0.7 1.1 1 1.1 2.8 0 0.8-0.2 1.5-0.3 0.7-0.7 1.2-0.9 1-2.9 1h-1.8zm0.9-6q0.9 0 1.3-0.4 0.3-0.3 0.3-1 0-1.5-1.6-1.5h-0.9v2.9z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m99.9 10q2.8 0 4.6 1.9 0.8 0.8 1.2 1.9 0.4 1 0.4 2.2 0 1.3-0.5 2.5-0.6 1.2-1.6 2.1-1.7 1.4-4.2 1.4-1.3 0-2.4-0.5-1.2-0.4-2-1.2-0.8-0.8-1.3-2-0.4-1.1-0.4-2.4 0-1.3 0.5-2.4 0.6-1.2 1.6-2.1 0.8-0.7 1.8-1 1.1-0.4 2.3-0.4zm0 2.8q-0.7 0-1.2 0.3-0.6 0.2-1.1 0.7-0.4 0.4-0.6 1-0.3 0.5-0.3 1.2 0 0.6 0.3 1.2 0.2 0.6 0.6 1 0.5 0.5 1 0.7 0.6 0.3 1.3 0.3 0.6 0 1.2-0.3 0.6-0.2 1-0.7 0.5-0.4 0.7-1 0.3-0.5 0.3-1.2 0-0.7-0.3-1.2-0.2-0.6-0.7-1-0.4-0.5-1-0.7-0.6-0.3-1.2-0.3z" />'
      '<path fill-rule="evenodd" fill="#fff" d="m118.2 21.6h-3.7l-2.8-4.3v4.3h-2.9v-11.3h4.6q0.9 0 1.6 0.3 0.6 0.2 1.1 0.7 0.5 0.5 0.7 1.2 0.3 0.6 0.3 1.3 0 0.8-0.3 1.4-0.2 0.7-0.7 1.1-0.3 0.3-0.6 0.4-0.4 0.2-0.9 0.3zm-5.9-6.2q0.9 0 1.3-0.3 0.2-0.2 0.4-0.5 0.1-0.3 0.1-0.6 0-0.3-0.1-0.6-0.2-0.3-0.4-0.5-0.4-0.3-1.3-0.3h-0.5v2.8z" />'
      '<path fill="#fff" d="m124.5 21.6h-2.9v-8.8h-2.4v-2.5h7.7v2.5h-2.4z" />'
      '</svg>'
      '<text x="50" y="324" font-size="1.4em" fill="white">|</text>'
      '<text x="5" y="12" font-size="1em" fill="#A7A2B6">GITCOIN</text>'
      '<text x="0" y="80" font-size="4em" fill="white">Passport</text>'
      '<text x="5" y="130" font-size="2em" fill="white">Score</text>'
      '<text x="50%" y="220" font-size="6em" fill="white" text-anchor="middle">',
      Strings.toString(scores[tokenId]),
      '</text>'
      '</svg>'
    );

    return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(svg)));
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
    scores[tokenId] = 0;
    super._beforeTokenTransfer(from, to, tokenId, batchSize);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
