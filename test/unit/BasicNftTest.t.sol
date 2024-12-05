// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft basicNft;
    DeployBasicNft deployer;
    address minter = makeAddr("minter");
    uint256 public constant STARTING_BALANCE = 1 ether;
    string public constant TOKEN_URI = "dog";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
        vm.deal(minter, STARTING_BALANCE);
    }

    function testHasCorrectName() public {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        assertEq(
            keccak256(abi.encodePacked(expectedName)),
            keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(minter);
        basicNft.mintNft(TOKEN_URI);

        assert(basicNft.balanceOf(minter) == 1);
        assert(
            keccak256(abi.encodePacked(TOKEN_URI)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }

    function testTokenIdIsUpdatedAfterSafeMint() public {
        vm.prank(minter);
        basicNft.mintNft(TOKEN_URI);
        assertEq(basicNft.getTokenId(), 1);
    }
}
