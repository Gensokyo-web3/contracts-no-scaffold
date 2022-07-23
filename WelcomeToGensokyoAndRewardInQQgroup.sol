// SPDX-License-Identifier: MIT
// QQGroup/Rewards

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

pragma solidity ^0.8.5;

contract WelcomeToGensokyo is AccessControl {

    using SafeMath for uint256;

    bytes32 public constant REWARD_MANAGER = keccak256("REWARD_MANAGER");

    string public NAME = "WelcomeToGensokyo: a reward contract for offical QQ group";

    uint256 public rewardAmount = 1 ether;
    uint256 public rewardTimes = 0;

    struct Reward {
        bool already;
        address wallet;
        string QQID;
        uint256 amount;
        uint timestamp;
        uint blockNumber;
    }

    mapping(string => Reward) public QQIDRewardMapping; // QQID => Reward
    mapping(address => Reward) public WalletAddressRewardMapping;  // WalletAddress => Reward

    event Rewarded(address wallet, string QQID, uint256 amount, uint timestamp, uint blockNumber);
    event ThanksDeposit(address wallet, uint256 amount);

    constructor () {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(REWARD_MANAGER, msg.sender);
    }

    function isRewardedByQQID(string memory _QQID) public view returns(bool) {
        Reward memory _reward =  QQIDRewardMapping[_QQID];
        return _reward.already;
    }

    function isRewardedByWalletAddress(address _wallet) public view returns(bool) {
        Reward memory _reward = WalletAddressRewardMapping[_wallet];
        return _reward.already;
    }

    function setRewardAmount(uint256 _amount) public onlyRole(REWARD_MANAGER) {
        rewardAmount = _amount;
    }

    function withdrawAll(address payable _target) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _target.transfer(address(this).balance);
    }

    function deposit() public payable {
        emit ThanksDeposit(msg.sender, msg.value);
    }

    function issuance(string memory QQID, address payable _wallet) public onlyRole(REWARD_MANAGER) {
        require(address(this).balance > rewardAmount, "WelcomeToGensokyo: Already received the reward");
        require(isRewardedByQQID(QQID) == false, "WelcomeToGensokyo: Already received the reward");
        require(isRewardedByWalletAddress(_wallet) == false, "WelcomeToGensokyo: Rewarded by Wallet");

        Reward memory _reward = Reward(
            true,
            _wallet,
            QQID,
            rewardAmount,
            block.timestamp,
            block.number
        );

        QQIDRewardMapping[QQID] = _reward;
        WalletAddressRewardMapping[_wallet] = _reward;

        rewardTimes = rewardTimes.add(1);

        _wallet.transfer(rewardAmount);

        emit Rewarded(_wallet,QQID,rewardAmount,block.timestamp,block.number);
    }
}
