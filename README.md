# Smart Contract Security Challenge

## Challenge 1

### No Privacy (Vulnerability: Accessing Private Variables)

---

Alice has deployed a secret Lock on blockchain that opens with a password. Help Bob find out the password and unlock the lock to win this challenge.

**Check out the [No Privacy](contracts/NoPrivacy/AlicesLock.sol) smart-contract and find a way to unlock it.**

**Pass this [Test](test/no-privacy.js) to win the challenge.**

---

## Challenge 2

### Head or Tail (Vulnerablilty: Randomness through global variable)

---

Alice and Bob are flipping a coin to decide who is a better smart contract programer.

Help Bob win the coin flip 5 times in a row to win the challenge.

**Check out the [Head or Tail](contracts/HeadOrTale/HeadOrTail.sol) smart-contract and find a way to hack it.**

**Pass this [Test](test/head-or-tail.js) to win the challenge.**

---

## Challenge 3

### Mount Calyptus (Vulnerability: Denial of Service due to push pattern)

---

Everyone wants to be at the top of Mount Calyptus, but there's space for only one. As they say, everything can be bought with money, so can be the spot at the summit. Whoever sends the Mount Calyptus Smart Contract an amount of ether that is larger than the current bribe replaces the previous climber. On such an event, the replaced climber gets paid the new bribe, making a bit of ether in the process!

Alice wants to be at the top at all cost! Alice reclaims the top spot as soon as anyone claims it sending equal bribe.

Help Bob stop Alice from reclaiming the atTheTop position.

**Check out the [Calyptus Hill](contracts/CalyptusHill/CalyptusHill.sol) smart-contract and find a way to hack it.**

**Pass this [Test](test/calyptus-hill.js) to win the challenge.**

---

## Challenge 4

### Do Not Trust (Vulnerability: Insecure External Call)

---

Alice has deployed a `Do Trust Lender` pool that offers free flash-loans to everyone!

Awesome right?

The pool has 1 million Calyptus Tokens (CPT) in balance. Complete the challenge by making Bob steal all the CPTs from the pool and send them into the his account.

**Check out the [Do Trust Lender Pool](contracts/DoNotTrust/DoTrustLender.sol) smart-contract and find a way to hack it.**

**Pass this [Test](test/do-not-trust.js) to win the challenge.**

---

## Challenge 5

### Re-enter (Vulnerability: Reentrancy)

---

Alice has deployed a simple lending pool that allows its users to deposit ETH, and withdraw it at any point in time.

This simple lending pool already has 1000 ETH in balance, and is offering free flash loans using the deposited ETH.

Help Bob steal all the ETH from Alice's lending pool.

**Check out the [ReenterPool](contracts/Reenter/Reenter.sol) smart-contract and find a way to hack it.**

**Pass this [Test](test/reenter.js) to win the challenge.**