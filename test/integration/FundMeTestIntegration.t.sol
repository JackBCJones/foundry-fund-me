// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
  FundMe fundMe;
  address USER = makeAddr("Jack");
  uint256 constant SEND_VALUE = 0.1 ether;
  uint256 constant STARTING_BALANCE = 10 ether;
  uint256 constant GAS_PRICE = 1;

  function setUp() external {
    // Deploys the FundMe contract
    DeployFundMe deploy = new DeployFundMe();
    fundMe = deploy.run();
    // Create a user with Funding.
    vm.deal(USER, STARTING_BALANCE);
  }

  function testUserCanFundInteractions() public {
    // Deploy the FundFundMe contract.
    FundFundMe fundFundMe = new FundFundMe();
    // Calls FundFundMe to fund the fundMe contract using the fundMe address.
    fundFundMe.fundFundMe(address(fundMe));

    WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
    withdrawFundMe.withdrawFundMe(address(fundMe));

    assert(address(fundMe).balance == 0);
  }
}
