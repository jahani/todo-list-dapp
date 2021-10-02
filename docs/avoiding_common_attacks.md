# Avoiding Common Attacks

## Pausable Deposits
`pause` function is implemented to stop all deposits to the contract so that new users wouldn't loss their coins if there are any bugs in contract.

## Reentrancy Attacks
Operations order are considered carefully to prevent reentrancy attacks. For example prize is credited to user after updating task in `_setComplete` function.
```
task.completed = true;
task.cleared = true;
replace(_id, task);
addPrize(msg.sender, task.value);
```
Also OpenZeppelin's `ReentrancyGuard` contract is used where `transfer` callback function is called.