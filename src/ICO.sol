//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./lib/Price.sol";

error NeedMoreETH();
error NothingToWithdraw();

contract ICO is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    using Price for uint256;

    IERC20 private s_ihToken;
    mapping(address => uint256) private s_addressToToken;
    AggregatorV3Interface private s_price;
    uint256 private constant PRICE_OF_TOKEN = 10 * 10 ** 18;

    event TokenBought(address indexed _investor, uint256 indexed _tokenAmount);

    constructor(IERC20 _ihToken, AggregatorV3Interface _price) {
        s_ihToken = _ihToken;
        s_price = _price;
    }

    function buy(uint256 _tokenAmount) external payable {
        if(msg.value.getConversionRate(s_price) < PRICE_OF_TOKEN * _tokenAmount) {
            revert NeedMoreETH();
        }
        s_ihToken.transferFrom(owner(), msg.sender, _tokenAmount * 10 ** 18);
        s_addressToToken[msg.sender] += _tokenAmount;
        emit TokenBought(msg.sender, _tokenAmount);
    }

    function withdraw() external payable onlyOwner nonReentrant{
        if(address(this).balance == 0) {
            revert NothingToWithdraw();
        }
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success);
    }

    function seeAddressToToken(address _investor) external view returns(uint256) {
        return s_addressToToken[_investor];
    }
}