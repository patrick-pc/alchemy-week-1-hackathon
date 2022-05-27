// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract TextFace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: ";
    string svgPartTwo =
        "; font-size: 80px; }</style><rect width='100%' height='100%' fill='black'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] fontFamily = [
        "Arial",
        "Helvetica",
        "sans-serif",
        "serif",
        "monospace",
        "cursive",
        "fantasy"
    ];

    string leftCheek = "(";
    string[] leftEye = [
        "-",
        "^",
        "*",
        ">",
        "\xE2\x8A\x99",
        "\xC2\xB0",
        "\xE2\x9D\x9B",
        "\xE1\xB5\x94",
        "\xE0\xB2\xA0",
        "\xE2\x97\x8F",
        "\xC2\xAC",
        "\xE2\x86\x81",
        "\xE0\xBD\x80"
    ];
    string[] noseMouth = [
        "_",
        "\x5F",
        "\xEF\xB9\x8F",
        "\xE1\xB4\x97",
        "\xE1\xB4\xA5",
        "\xE2\x80\xBF",
        "\xE2\x80\xB8",
        "\x20\xCD\x9C\xCA\x96",
        "\xCA\x96\xCC\xAF"
    ];
    string[] rightEye = [
        "-",
        "^",
        "*",
        "<",
        "\xE2\x8A\x99",
        "\xC2\xB0",
        "\xE2\x9D\x9B",
        "\xE1\xB5\x94",
        "\xE0\xB2\xA0",
        "\xE2\x97\x8F",
        "\xC2\xAC",
        "\xE2\x86\x81",
        "\xE0\xBD\x80"
    ];
    string rightCheek = ")";

    event NewTextFaceMinted(address sender, uint256 tokenId);

    constructor() ERC721("TextFace", "^_^") {
        console.log("Gm (^_^)");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomFontFamily(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FONT_FAMILY", Strings.toString(tokenId)))
        );
        rand = rand % fontFamily.length;
        return fontFamily[rand];
    }

    function pickRandomLeftEye(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("LEFT_EYE", Strings.toString(tokenId)))
        );
        rand = rand % leftEye.length;
        return leftEye[rand];
    }

    function pickRandomNoseMouth(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("NOSE_MOUTH", Strings.toString(tokenId)))
        );
        rand = rand % noseMouth.length;
        return noseMouth[rand];
    }

    function pickRandomRightEye(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("RIGHT_EYE", Strings.toString(tokenId)))
        );
        rand = rand % rightEye.length;
        return rightEye[rand];
    }

    function mint() public {
        uint256 newItemId = _tokenIds.current() + 1;
        require(newItemId + 1 <= 100, "Reached max supply!");

        string memory randomFontFamily = pickRandomFontFamily(newItemId);
        string memory randomLeftEye = pickRandomLeftEye(newItemId);
        string memory randomNoseMouth = pickRandomNoseMouth(newItemId);
        string memory randomRightEye = pickRandomRightEye(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(
                leftCheek,
                randomLeftEye,
                randomNoseMouth,
                randomRightEye,
                rightCheek
            )
        );

        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomFontFamily,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "TextFace ',
                        Strings.toString(newItemId),
                        ' is a member of the TextFace DAO", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewTextFaceMinted(msg.sender, newItemId);
    }
}
