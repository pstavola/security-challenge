// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @fix using Chainlink VRF
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract HeadOrTail is VRFConsumerBaseV2 {

  uint256 public wins;
  uint256 hash;
  //uint256 FACTOR = 57896044618658097711785492504343953926634992334420282019728792003956564819968;
  bool guess;

  // @fix using Chainlink VRF
  ///@notice ChainLink VRF v2 parameters
  VRFCoordinatorV2Interface immutable coordinator;
  uint64 immutable subscriptionId;
  bytes32 immutable keyHash;
  uint256[] public randomWords;
  uint256 public requestId;
  ///@notice $LINK token instance
  LinkTokenInterface immutable link;

  /**
  * @notice initializing Chainlink VRF and $LINK token.
   * @param _vrfCoordinator address of Chainlink VRF Coordinator
   * @param _link address of $LINK token
   * @param _subscriptionId Chainlink VRF subscription Id
   * @param _keyhash Chainlink VRF Key Hash
  */
  constructor(address _vrfCoordinator, address _link, uint64 _subscriptionId, bytes32 _keyhash) VRFConsumerBaseV2(_vrfCoordinator) {
    coordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
    keyHash = _keyhash;
    subscriptionId = _subscriptionId;
    link = LinkTokenInterface(_link);
  }

  /**
    * @notice fund Chainlink VRF subscription. Anybody can fund a subscription
    * @param _amount funds to send to subscription
  */
  function fundVRFSubscription(uint96 _amount) public {
    link.transferAndCall(address(coordinator), _amount, abi.encode(subscriptionId));
  }

  function flip(bool _guess) public {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (hash == blockValue) {
      revert();
    }

    hash = blockValue;
    guess = _guess;
    requestId = coordinator.requestRandomWords(keyHash, subscriptionId, 3, 150000, 1);
  }

  /**
    * @notice VRFConsumerBaseV2 fulfillRandomWords override.
    * @param _randomWords array of random words provided by Chainlink oracles
  */
  function fulfillRandomWords(uint256, uint256[] memory _randomWords) internal override {
    uint256 coinFlip = hash / _randomWords[0];
    bool side = coinFlip == 1 ? true : false;

    if (side == guess) {
      wins++;
      result(true);
    } else {
      wins = 0;
      result(false);
    }
  }

  function result(bool _result) public pure returns (bool) {
    return _result;
  }
}