// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @fix using Chainlink VRF
//import "@chainlinkcontracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract HeadOrTail {

  uint256 public wins;
  uint256 hash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992334420282019728792003956564819968;

  ///@notice ChainLink VRF v2 parameters
  VRFCoordinatorV2Interface immutable coordinator;
  uint64 immutable subscriptionId;
  bytes32 immutable keyHash;
  uint256[] public randomWords;
  uint256 public requestId;
  ///@notice $LINK token instance
  LinkTokenInterface immutable link;

  /**
  * @notice initializing Chainlink VRF, PremiumPool and $LINK token.
   * @param _vrfCoordinator address of Chainlink VRF Coordinator
   * @param _link address of $LINK token
   * @param _subscriptionId Chainlink VRF subscription Id
   * @param _keyhash Chainlink VRF Key Hash
  */
  constructor(address _vrfCoordinator, address _link, uint64 _subscriptionId, bytes32 _keyhash) VRFConsumerBaseV2(_vrfCoordinator) {
    coordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
    keyHash = _keyhash;
    subscriptionId = _subscriptionId;
    pool = PremiumPool(msg.sender);
    link = LinkTokenInterface(_link);
  }

  /**
    * @notice fund Chainlink VRF subscription. Anybody can fund a subscription
    * @param _amount funds to send to subscription
  */
  function fundVRFSubscription(uint96 _amount) public {
    link.transferAndCall(address(coordinator), _amount, abi.encode(subscriptionId));
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (hash == blockValue) {
      revert();
    }

    hash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      wins++;
      return true;
    } else {
      wins = 0;
      return false;
    }
  }

  /**
     * @notice close the draw and request randomness via Chainlink VRF. Only PremiumPool contract can close draws
    */
    function closeDraw() external onlyOwner {
        Draw storage currentDraw = draws[drawId];
        currentDraw.isOpen = false;
        emit CloseDraw(currentDraw.drawId, currentDraw.endTime);

        requestId = coordinator.requestRandomWords(keyHash, subscriptionId, 3, 150000, 1);
        emit RandomnessRequested(requestId, currentDraw.drawId);
    }

    /**
     * @notice VRFConsumerBaseV2 fulfillRandomWords override. It picks a winner by using a roulette selection over a weighted array of partecipants addresses
     * @param _randomWords array of random words provided by Chainlink oracles
    */
    function fulfillRandomWords(uint256, uint256[] memory _randomWords) internal override {
        randomWords = _randomWords;
        uint256 drawToUpdate = drawId;
        drawToUpdate--;
        Draw storage currentDraw = draws[drawToUpdate];
        address[] memory users = pool.getUsers();
        PremiumPoolTicket ticket = PremiumPoolTicket(address(pool.ticket()));
        uint256 rnd = randomWords[0] % ticket.totalSupply();

        for(uint256 i=0; i<users.length && currentDraw.winner==address(0); i++) {
            address currentUser = pool.users(i);
            uint256 balance = ticket.balanceOf(currentUser);
            if(rnd < balance) {
                currentDraw.winner = currentUser;
                uint256 prize = currentDraw.prize;
                pool.mintTicket(currentUser, prize);
                emit WinnerElected(drawId, currentUser, prize);
            }
            else{
                rnd -= balance;
            }
        }
    }


}