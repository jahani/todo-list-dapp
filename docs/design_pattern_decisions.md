# Design Pattern Decisions

## ACL Design Pattern
`onlyOwner` modifier is used for functions that should only be called by contract owner.

## Pausable Design Pattern - Circuit Breaker
`pause` function is implemented to stop all deposits to the contract so that new users wouldn't loss their coins if there are any bugs in the contract.