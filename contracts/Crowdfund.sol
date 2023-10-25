// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdfundingToken is ERC20 {
    address public campaignCreator;
    uint256 public campaignEndTime;
    uint256 public campaignGoal;
    uint256 public totalPledged;
    bool public campaignEnded;

    IERC20 public tokenContract; // Use IERC20 for ERC20 tokens

    mapping(address => uint256) public pledges;

    event CampaignCreated(address creator, uint256 goal, uint256 endTime);
    event Pledged(address backer, uint256 amount);
    event CampaignEnded(bool goalReached);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address _tokenContract
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        tokenContract = IERC20(_tokenContract);
    }

    function createCampaign(uint256 _durationInDays, uint256 _goal) external {
        require(balanceOf(msg.sender) >= _goal, "Insufficient balance to create a campaign");
        require(!campaignEnded, "A campaign is already active");
        campaignCreator = msg.sender;
        campaignEndTime = block.timestamp + (_durationInDays * 1 days);
        campaignGoal = _goal;
        campaignEnded = false;
        emit CampaignCreated(campaignCreator, campaignGoal, campaignEndTime);
    }

    function pledge(uint256 amount) external {
        require(!campaignEnded, "Campaign has ended");
        require(block.timestamp < campaignEndTime, "Campaign has ended");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to pledge");
        require(allowance(msg.sender, address(this)) >= amount, "You must approve the contract to spend tokens");

        transferFrom(msg.sender, address(this), amount);
        pledges[msg.sender] += amount;
        totalPledged += amount;
        emit Pledged(msg.sender, amount);
    }

    function endCampaign() external {
        require(msg.sender == campaignCreator, "Only the campaign creator can end the campaign");
        require(block.timestamp >= campaignEndTime, "Campaign is still active");
        require(!campaignEnded, "Campaign has already ended");

        campaignEnded = true;

        if (totalPledged >= campaignGoal) {
            transfer(campaignCreator, totalPledged);
        } else {
            refundPledges();
        }

        emit CampaignEnded(totalPledged >= campaignGoal);
    }

    function refundPledges() internal {
        uint256 tokenBalance = tokenContract.balanceOf(address(this));
        for (uint256 i = 0; i < tokenBalance; i++) {
            address account = msg.sender;
            uint256 pledgedAmount = pledges[account];
            if (pledgedAmount > 0) {
                transfer(account, pledgedAmount);
            }
        }
    }
}
