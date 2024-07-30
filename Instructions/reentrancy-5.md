# ReEntrancy Exercise 5

This challenge was created by our student [Pawel Haldrzynski](https://twitter.com/phaldrzynski).
If you have any ideas for new cool challenges, please tell us over Email or on Discord! 💪

## Intro

Crazy Apes strike back!

Do you remember the `ApesAirdrop` from the Reentrancy 2 exercise? I bet you do!
Well, the devs had learnt their lesson and implemented an additional fix which was suppose to protect the contract from reentrancy attacks.
The new version of the contract (which was sophistically named as `ApesAirdrop2` ;>) implements just two minor changes:

- `ApesAirdrop2` inherits from the Open Zeppelin's `ReentrancyGuard`
- Function `mint()` is now `nonReentrant`

Do you think that these changes are enough to make this contract finally secure?

The rest of the code had not been altered:

- Only 50 unique Apes will be minted to the loyal community members of the Apes community

- 1 Ape mint per wallet

Similarly, as during the previous challenge - you were lucky enough to be chosen and become one of those 50 people since you contributed to the Apes community.

There is a smart contract `ApesAirdrop2.sol` that allows you to mint ONLY 1 NFT, your goal is to hack the smart contract and mint for yourself all the 50 NFT and become Super Duper Rich Ape.

## Accounts

- 0 - Deployer & Owner
- 1 - User 1
- 2 - User 2
- 3 - User 3
- 4 - User 4
- 5 - Attacker (You)

## Tasks

### Task 1

Bypass the 1 Ape per Wallet restriction and make sure you mint ALL the apes for yourself.

### Task 2

Protect the `ApesAirdrop2.sol` smart contract so your attack wouldn't succeed.
