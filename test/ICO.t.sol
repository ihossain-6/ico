// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ICO.sol";
import "../src/IHToken.sol";
import "../src/test/MockV3Aggregator.sol";

contract TestBuy is Test {
    ICO public _ico;
    IHToken public _ihToken;
    MockV3Aggregator public _mockV3Aggregator;
    uint256 _tokenAmount = 20;
    
    event TokenBought(address indexed _investor, uint256 indexed _tokenAmount);

    function setUp() public {
        _ihToken = new IHToken();
        _mockV3Aggregator = new MockV3Aggregator(8, 2e11);
        _ico = new ICO(_ihToken, _mockV3Aggregator);
        _ihToken.mint(_ico.owner(), 1e23);
        _ihToken.approve(address(_ico), 20 * 10 ** 18);
    }
 
    function test_RevertIfNotEnoughETH() public {
        vm.expectRevert(bytes4(keccak256("NeedMoreETH()")));
        _ico.buy{value: 1e16}(20);
    }

    function test_ReceivesEther() public {
        _ico.buy{value: 1e17}(20);
        assertEq(address(_ico).balance, 1e17);
    }
 
    function test_UpdatesMapping() public {
        _ico.buy{value: 1e17}(20);
        uint256 tokenAmount = _ico.seeAddressToToken(address(this));
        assertEq(tokenAmount, 20);
    }
    
    function test_EmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit TokenBought(address(this), _tokenAmount);
        _ico.buy{value: 1e17}(20);
    }
}

contract TestWithdraw is Test {
    ICO public _ico;
    IHToken public _ihToken;
    MockV3Aggregator public _mockV3Aggregator;
    uint256 _tokenAmount = 20;

    function setUp() public {
        _ihToken = new IHToken();
        _mockV3Aggregator = new MockV3Aggregator(8, 2e11);
        _ico = new ICO(_ihToken, _mockV3Aggregator);
        _ihToken.mint(_ico.owner(), 1e23);
        _ihToken.approve(address(_ico), 20 * 10 ** 18);
    }

    function test_RevertIfZero() public {
        vm.startPrank(_ico.owner());
        vm.expectRevert(bytes4(keccak256("NothingToWithdraw()")));
        _ico.withdraw();
        vm.stopPrank();
    }

    function test_Withdraw() public {
        _ico.buy{value: 1e17}(20);
        vm.prank(_ico.owner());
        _ico.withdraw();
        assertEq(address(_ico).balance, 0);
    }

    receive() external payable {}
}

contract TestSeeToken is Test {
    ICO public _ico;
    IHToken public _ihToken;
    MockV3Aggregator public _mockV3Aggregator;
    uint256 _tokenAmount = 20;

    function setUp() public {
        _ihToken = new IHToken();
        _mockV3Aggregator = new MockV3Aggregator(8, 2e11);
        _ico = new ICO(_ihToken, _mockV3Aggregator);
        _ihToken.mint(_ico.owner(), 1e23);
        _ihToken.approve(address(_ico), 20 * 10 ** 18);
        _ico.buy{value: 1e17}(20);
    }

    function test_SeeAddressToToken() public {
        uint256 token = _ico.seeAddressToToken(address(this));
        assertEq(token, 20);
    }
}
