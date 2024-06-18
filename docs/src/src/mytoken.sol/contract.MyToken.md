# MyToken
[Git Source](https://github.com/khisomovkomron/erc20/blob/ab4165eb77cda11abf94dfe95a55f8d6fe57f6d1/src/mytoken.sol)

**Inherits:**
ERC20, AccessControl, Pausable

**Author:**
Komron Khisomov

This contract is not audited, do not use it in mainnet


## State Variables
### MINTER_ROLE

```solidity
bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
```


### BURNER_ROLE

```solidity
bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
```


## Functions
### constructor

*added required address for roles during the deployment*


```solidity
constructor(address minter, address burner) ERC20("MyToken", "MTK");
```

### mint

this functions helps to mint new tokens

*requires role of minter given during deployment*


```solidity
function mint(address to, uint256 value) public onlyRole(MINTER_ROLE);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|an address to which required to mint new tokens|
|`value`|`uint256`|amount required to mint|


### burn

this functions helps to burn existing tokens from an address

*requires role of burner given during deployment*


```solidity
function burn(address from, uint256 value) public onlyRole(BURNER_ROLE);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`from`|`address`|an address from which will burn existing tokens|
|`value`|`uint256`|amount required to burn|


### pause

this functions helps to pause (lock) contract from minting and burning and other function


```solidity
function pause() public;
```

### unpause

this function helps to unpause (unlock) a contract for minting and burning


```solidity
function unpause() public;
```

## Events
### MintingEvent

```solidity
event MintingEvent(address to, uint256 value);
```

### BurningEvent

```solidity
event BurningEvent(address from, uint256 value);
```

### PausingEvent

```solidity
event PausingEvent();
```

### UnpausingEvent

```solidity
event UnpausingEvent();
```

