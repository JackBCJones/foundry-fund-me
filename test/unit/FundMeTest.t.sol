// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
  FundMe fundMe;

  address USER = makeAddr("Jack");

  uint256 constant SEND_VALUE = 0.1 ether;

  uint256 constant GAS_PRICE = 1;

  function setUp() external {
    // our fundMe variable of type FundMe is a new FundMe Contract
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER, 10 ether);
  }

  function testMinimumDollarIsFive() public view {
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }

  function testIsMsgSender() public view {
    assertEq(fundMe.i_owner(), msg.sender);
  }

  function testPriceVersionIsAccurate() public view{
    uint256 version = fundMe.getVersion();
    assertEq(version, 4);
  }

  function testFundMeFailsIfNotEnoughEth() public {
    vm.expectRevert();
    fundMe.fund();
  }

  function testFundUpdatedFundedDataStructure() public {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, SEND_VALUE);
  }

  modifier funded() {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
  }

  function testAddsFundersToArrayOfFunders() public funded {
    address funder = fundMe.getFunder(0);

    assertEq(USER, funder);
  }

  function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    vm.prank(USER);

    fundMe.withdraw();
  }

  function testWithdrawWithASingleFunder() public funded {
    // Arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;

    uint256 startingFundMeBalance = address(fundMe).balance;
    // Act
    uint256 gasStart = gasleft();
    vm.txGasPrice(GAS_PRICE);
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
    uint256 gasEnd = gasleft();
    uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
    console.log(gasUsed);

    // Asset
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;
    assertEq(endingFundMeBalance, 0);
    assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
  }

  function testWithdrawWithMultipleFunders() public funded {
    uint160 funders = 10;
    uint160 startingFunderIndex = 1;

    for (uint160 i = startingFunderIndex; i < funders; i++) {
      hoax(address(i), SEND_VALUE);
      fundMe.fund{value: SEND_VALUE}();
    }
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
  }

  function testWithdrawWithMultipleFundersCheaper() public funded {
    uint160 funders = 10;
    uint160 startingFunderIndex = 1;

    for (uint160 i = startingFunderIndex; i < funders; i++) {
      hoax(address(i), SEND_VALUE);
      fundMe.fund{value: SEND_VALUE}();
    }
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    vm.prank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();

    assert(address(fundMe).balance == 0);
    assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
  }
}
