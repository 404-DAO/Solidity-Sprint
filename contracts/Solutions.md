# Intro

Below are the solutions for the Solidity Spring and my explanations. I'm busy and kinda lazy so it took me a while to finally write these out. You can find an example contract that solves every challenge in `SoliditySprintSolutions.t.sol`

## Challenge 0

```
    function f0(bool val) public isLive {
        uint fNum = 0;
        require(!progress[msg.sender][fNum]);

        require(!val);

        givePoints(fNum, msg.sender, 200);
    }
```

You are asked to provide a boolean and `require(!val)` means that the value must be false so that it's opposite is true.

`sprint.f0(false);`

## Challenge 1

```
    function f1() public payable isLive {
        uint fNum = 1;

        require(!progress[msg.sender][fNum]);

        require(msg.value == 10 wei);
        givePoints(fNum, msg.sender, 400);
    }
```

The function is payable and `msg.value == 10 wei` means that you must send some amount of ether along with your transaction, in this case 10 wei in value.

`sprint.f1{value: 10 wei}();`

## Challenge 2

```
    function f2(uint val) public isLive {
        uint fNum = 2;
        require(!progress[msg.sender][fNum]);
        
        uint256 guess = uint256(keccak256(abi.encodePacked(val, msg.sender)));

        require(guess % 5 == 0);

        givePoints(fNum, msg.sender, 600);
    }
```

We need to provide some value such that when its concatenated with the sender address and hashed returns an int divisible by 5. Luckily since ethereum contracts are deterministic, we can just calculate our what guess will be before we call the contract, and brute force a value `val` that will pass before we call the contract. This way we don't need to waste gas on values that will fail and hope we get lucky.

```
        for(uint x = 0; x < type(uint).max; x++) {
            uint256 guess = uint256(keccak256(abi.encodePacked(x, address(this))));
            if (guess % 5 == 0) {
                sprint.f2(guess);
                return;
            }
        }
```

## Challenge 3
```
function f3(uint data) public isLive {
        uint fNum = 3;
        uint xorData = data ^ 0x987654321;

        require(!progress[msg.sender][fNum]);

        require(xorData == 0xbeefdead);
        givePoints(fNum, msg.sender, 800);

    }
```

We need to give some value that when XOR'd with `0x987654321` returns `0xdeadbeef`. The good news is that A^B = C and B ^ C  = A. Since we know B and C we just XOR them together and get the answer.

```
uint x = 0xbeefdead ^ 0x987654321;
sprint.f3(x);
```

## Challenge 4

```
    function f4(address destAddr) public isLive {
        uint fNum = 4;
        require(!progress[msg.sender][fNum]);

        require(destAddr == address(this));
        givePoints(fNum, msg.sender, 1000);
    }
```

The address `destAddr` should be the address of the contract we are trying to call, that's what `address(this)` does, gets the current contract's address.

`sprint.f4(address(sprint));`

## Challenge 5

```
    function f5(address destAddr) public isLive {
        uint fNum = 5;
        require(!progress[msg.sender][fNum]);

        require(destAddr == msg.sender);

        givePoints(fNum, msg.sender, 1200);

    }
```

Provide your own address when calling

`sprint.f6(address(this));`

## Challenge 6
```
    function f6(address destAddr) public isLive {
        uint fNum = 6;
        require(!progress[msg.sender][fNum]);

        require(destAddr == owner());

        givePoints(fNum, msg.sender, 1400);
    }
```

the sprint contract has a public variable called `owner` that is set at the time the contract is created. You only need to read that variable from the contract and return it.

`sprint.f6(sprint.owner());`

## Challenge 7
```
    function f7() public isLive {
        uint fNum = 7;
        require(!progress[msg.sender][fNum]);

        require(gasleft() > 6_969_420);

        givePoints(fNum, msg.sender, 1600);

    }
```

`gasleft()` is a special precompiled function that tells you how much gas is remaining. You only need to call the contract and specify how much gas to use with some amount greater than `6_969_420` by the time it gets to that statement.

`sprint.f7{gas: 8_000_000}();`

## Challenge 8
```
    function f8(bytes calldata data) public isLive {
        uint fNum = 8;
        require(!progress[msg.sender][fNum]);

        require(data.length == 32);

        givePoints(fNum, msg.sender, 1800);

    }
```

Just provide 32-bytes of data as input

```
bytes memory data = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; // 16 'A's
sprint.f8(data);
```

## Challenge 9
```
    function f9(bytes memory data) public isLive {
        uint fNum = 9;

        require(!progress[msg.sender][fNum]);

        data = abi.encodePacked(msg.sig, data);
        require(data.length == 32);

        givePoints(fNum, msg.sender, 2000);

    }
```

the key here is that every external contract call starts with a function signature, `msg.sig` which tells the contract which function to invoke. The signature is 4-bytes, so the data you provide plus the 4-byte signature needs to be 32-bytes total. I.E provide 28 bytes of data as input

`sprint.f9("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");`

## Challenge 10

```
function f10(int num1, int num2) public isLive {
        uint fNum = 10;
        require(!progress[msg.sender][fNum]);

        require(num1 < 0 && num2 > 0);
        unchecked {
            int num3 = num1 - num2;
            require(num3 > 10);
        }

        givePoints(fNum, msg.sender, 2200);

    }
```

While solidity version 0.8 will manually check for overflow/underflow errors, you can ignore those checks by putting it inside an unchecked block. This allows you to do math that underflows below the minimum back around to the maximum. So if you take a signed int it has a minimum value of `-(2^255) + 1`. If you try to subtract from that then you'll underflow the minimum value and wrap back around to the maximum value `2^255`. The challenge here is to provide two negative signed integers that when subtracted will underflow from a negative back around to a positive.

`sprint.f10(type(int).min, 5);`

## Challenge 11

```
function f11(int num1, int num2) public isLive {
        uint fNum = 11;
        require(!progress[msg.sender][fNum]);

        require(num1 > 0 && num2 > 0, "Numbers must be greater than zero");
        unchecked {
            int num3 = num1 + num2;
            require(num3 < -10);
        }

        givePoints(fNum, msg.sender, 2400);

    }
```

The same challenge as before but now you need to provide two positive signed integers that will overflow back to a negative number

`sprint.f11(type(int).max, 5);`

## Challenge 12

```
function f12(bytes memory data) public isLive {
        uint fNum = 12;

        require(!progress[msg.sender][fNum]);


        (bool success, bytes memory returnData) = address(this).call(data);
        require(success);
        
        require(keccak256(returnData) == keccak256(abi.encode(0xdeadbeef)));

        givePoints(fNum, msg.sender, 2600);
    }
```

When you look at the `.call()` you see we're calling the same contract, and then doing something with the return data. That return data needs to equal `keccak256(abi.encode(0xdeadbeef))`. Later on in the contract there's a function 
```
    function internalChallengeHook() public view isLive returns (uint) {
        require(msg.sender == address(this));
        return 0xdeadbeef;
    }
```
that returns 0xdeadbeef. We need to call this function, but we only have the `.call` function, BUT we get to provide the data, and this function makes sure that it can only be called by itself. We need to figure out how to use `.call()` to call a function we designate. Since the function `internalChallengeHook()` takes no parameters we only need to find out its function selector which is `keccack256("internalChallengeHook()")` which is `0x1625d7fe`. We just pass this selector as input to our contract call and the function gets called.

```
bytes memory c = hex"1625d7fe";
sprint.f12(c);
```

## Challenge 13

This is your garden variety re-entry attack. You can find more info here. We simply need to enter the contract, then wait for it to call back to us, and then re-enter the function to get the points.
https://solidity-by-example.org/hacks/re-entrancy/

```
    function testf13() public pointsIncreased {
        new tempAttacker(address(this), address(sprint));
    }

    contract tempAttacker {

    address public immutable teamAddr;
    address public immutable currSprint;

    constructor(address _teamAddr, address _currSprint) {
        teamAddr = _teamAddr;
        currSprint = _currSprint;
        SoliditySprint2022(currSprint).f14(teamAddr);
    }

    fallback() external {
        SoliditySprint2022(currSprint).f14(teamAddr);
    }
}
```

## Challenge 14
```
function f14(address team) public isLive {
    uint fNum = 14;

    require(!progress[team][fNum]);

    require(msg.sender.code.length == 0);
    require(msg.sender != tx.origin);

    if (entryCount[team] == 0) {
        entryCount[team]++;
        (bool sent, ) = msg.sender.call("");
        require(sent);
    }

    givePoints(fNum, team, 3000);
}
```

This is another re-entry but with a twist. It checks that the code length of the sender is zero. Since we have to use a contract (denoted by the `msg.sender != tx.origin`) we need to find a way to bypass the code length check. Luckily, it's a quirk of the EVM that the code length of a contract is only set at the end of a constructor being called. If we call the contract we're attacking from a contract executing in the constructor, then code length will be zero, and we can bypass this check and successfully re-enter the function. You can re-use hte code from above that executes in the constructor.

## Challenge 15

```
function f15(address team, address expectedSigner, bytes memory signature) external isLive {
        uint fNum = 15;

        require(!progress[team][fNum]);

        bytes32 digest = keccak256("I don't like sand. It's course and rough and it gets everywhere");
        
        address signer = Cryptography.recover(digest, signature);

        require(signer != address(0));

        require(signer == expectedSigner);
        require(!signers[signer]);

        signers[signer] = true;
        givePoints(fNum, team, 3200);
    }
```
This challenge tests your knowledge of cryptography of smart contracts, particularly digital-signatures. The challenge asks you to sign the value `digest`. All you need to do is sign the `string` with any address you want, and provide both the signature and the address that was used to sign it. You can use the foundry `cast` tool to sign it with your private key.

## Challenge 16
```
    function f16(address team) public isLive {
        uint fNum = 16;
        require(!progress[team][fNum]);

        require(ISupportsInterface(msg.sender).supportsInterface(type(IERC20).interfaceId), "msg sender does not support interface");
    
        givePoints(fNum, team, 3400);
    }
```

supportsInterface is a function that is implemented by contracts to let other contracts know that it implements certain interfaces. In this challenge the user should be a contract that implements the function `supportsInterface()`. However, we want it to return true when asked if it implements the interface `IERC20`. It doesn't need to actually implement it but we want the supportsInterface call to return true when prompted with the interface-selector. 

More info on ERC-165 can be found here. https://eips.ethereum.org/EIPS/eip-165

```
import "./IERC20.sol";
function supportsInterface(bytes4 interfaceId) external returns (bool) {
    return type(IERC20).interfaceId == interfaceId;
}
```

## Challenge 17
```
    function f17(address newContract, address team) public isLive {
        uint fNum = 17;
        require(!progress[team][fNum]);

        address clone = Clones.cloneDeterministic(address(template), keccak256(abi.encode(msg.sender)));
        require(newContract == clone);

        givePoints(fNum, team, 3600);
    }
```

Solidity implemented a new opcode in the past known as Create2. Create2 let you deploy contracts based on a template (cloner) from your contract in a deterministic manner, as long as you provide some salt. The salt is combined with the contract you want to clone, and used to calculate the address of the contract you deploy. However, the benefit of this is that if we know the salt ahead of time, we can calculate what the address will be before we even deploy the contract. This challenge asks you to calculate ahead of time what the address will be when the salt is the caller-address. 

The Clones library and the function I used, predictDeterministic, are taken directly from the OpenZeppelin library `Clones.sol`.
```
function testf17() public pointsIncreased {
    address prediction = predictDeterministicAddress(address(sprint.template()), keccak256(abi.encode(address(this))), address(sprint));
    sprint.f17(prediction, address(this));
}

function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), shl(0x60, implementation))
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
            mstore(add(ptr, 0x38), shl(0x60, deployer))
            mstore(add(ptr, 0x4c), salt)
            mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
            predicted := keccak256(add(ptr, 0x37), 0x55)
        }
    }
```

More info on Create2 - https://solidity-by-example.org/app/create2/

## Challenge 18

```
    function f18(address team) public isLive {
        uint fNum = 18;
        require(!progress[team][fNum]);

        require(IERC20(weth).balanceOf(msg.sender) > 1e9 wei);

        givePoints(fNum, team, 3800);
    }
```

As you might know, Ether the coin is not compatible with the ERC-20 standard. This can make it difficult to use in many Dapps. As a result people created WETH, an ERC-20 representation of Ether backed 1:1. Anyone can mint new WETH by locking up an equal amount of Eth, and burn their WETH for an equal amount of ETH in return. This challenge asks you to acquire some WETH, 1-gwei at minimum. There's several ways to do this but the easiest one would be to just send eth directly to the WETH contract, receiving WETH in return, and then just call the function. WETH was written in this way so that minting WETH was incredibly easy, all you have to do is send some amount of ETH to the contract.

```
function testf18() public pointsIncreased {
    console2.log("weth: ", sprint.weth());

    payable(sprint.weth()).call{value: 1 ether}("");

    sprint.f18(address(this));
}
```

## Challenge 19
```
function f19(address team) public isLive {
    uint fNum = 19;
    require(!progress[team][fNum]);

    IERC20(weth).transferFrom(msg.sender, address(this), 1e9 wei);

    givePoints(fNum, team, 4000);
}
```

This challenge first requires you to get some WETH, which we did in the last contract. It then tries to transfer some WETH from you to itself. The ERC-20 standard allows you to grant permission to contracts to transfer/spend the tokens on your behalf, through the notion of an allowance. All you need to do is grant the challenge contract an allowance over your WETH of `1e9 wei` or more, and then hold at least `1e9 wei` worth of WETH.

## Challenge 20
```
function f20(address team, bytes32[] calldata proof, bytes32 leaf) public isLive {
    uint fNum = 20;
    require(!progress[team][fNum]);
    require(!usedLeaves[leaf]);

    require(MerkleProof.verify(proof, merkleRoot, leaf));

    usedLeaves[leaf] = true;

    givePoints(fNum, team, 4200);

}
```

This is another cryptography question, involving Merkle-Trees. In the constructor of the contract we created a merkle tree and the associated-root. Merkle-Trees - https://www.geeksforgeeks.org/introduction-to-merkle-tree/
```
bytes32[] memory numbers = new bytes32[](20);
for (uint x = 0; x < 20; x++) {
    numbers[x] = bytes32(keccak256(abi.encodePacked(x)));
}

merkleRoot = MerkleTree.getRoot(numbers);
```

The values in the tree are simply the numbers `1-20`. All you need to do is present a valid merkle proof for some item in the tree that hasn't been used before. 
```
function testf20() public pointsIncreased {
    bytes32[] memory numbers = new bytes32[](20);
    for (uint x = 0; x < 20; x++) {
        numbers[x] = keccak256(abi.encodePacked(x));
    }

    bytes32 root = merkleProofs.getRoot(numbers);

    bytes32[] memory proof = merkleProofs.getProof(numbers, 0x0);

    sprint.f20(address(this), proof, keccak256(abi.encodePacked(uint(0))));
}
```

I used the `OpenZeppelin` Merkle Tree library to generate the root.

## Challenge 21

This is where the fun begins. Time to learn about EVM-Assembly. 
```
assembly {
    mstore(0, team)
    mstore(32, 1)
    let hash := keccak256(0, 64)
    result := sload(hash)
}

require(result == value);
```
You should first read this article if you're not familiar with how EVM storage works - https://www.adrianhetman.com/unboxing-evm-storage/

Variables in solidity kept in storage have a specific storage slot. If it's a value in a mapping, then the storage slot is a combination of both the key and the storage slot of the mapping itself. So in our vulnerable contract, the mapping ` mapping(address => uint) public scores;` is stored in storage slot 1. Notice however that we store two things in the first 64-bytes of memory. In the first 32-bytes we store the address of the team contract. In the 2nd 32-bytes we store the value 1, which also happens to be our mapping variable. We then hash those 64-bytes together. As you may be able to surmize, we're trying to get a specific value from a mapping in raw assembly, which is why we then use sload, passing in our hashed value. 

https://ethereum.stackexchange.com/questions/80529/how-to-get-access-to-the-storage-mapping-through-the-solidity-assembler

We then want to make sure that the passed in value `result` matches the value we fetched from storage. Since we're using the mapping `scores` it means that we're trying to get the current score for a `team`. This means the challenge asks you, **how many points do you currently have**, and asks you to provide that info.

```
assembly {
    mstore(0, team) // store the value in memory
    mstore(32, 1) //get the associated mapping it's in by using its storage slot
    let hash := keccak256(0, 64) //get the key in the hashmap
    result := sload(hash) //get the value in storage based on the key
}
```

## Challenge 22

This is another assembly challenge but goes further. Let's go line by line

```
let size := extcodesize(sender)
            if eq(size, 0) {
                revert(0,0)
            }
```
This gets the size of the code of the sender, where `sender = msg.sender`. This says to revert if the code size of the caller is equal to zero. So we need to be a contract to call this function.

```
if eq(sender, origin()) {
    revert(0,0)
}
```
`origin()` in assembly is just `tx.origin` so revert if `msg.sender == tx.origin`

```
bytes32 hashData = keccak256(data);
//hashSlingingSlasher = input bytes32
if gt(xor(hashData, hashSlingingSlasher), 0) {
                revert(0,0)
            }
```

This xor's two values together, the hash of our data, and the data itself. It then checks if the resulting value is greater than zero. When two identical values are XOR'd together the resulting value is zero. So we want to revert if the two values are not the same. Since they're both `bytes32`, and one is calculated via `keccak256`, we can interpret this to mean that the question wants us to provide some data, and its hash. It then checks the hash provided against the actual one and reverts if they're not the same.

```
let size := extcodesize(sender)
extcodecopy(sender, 0, 0, size)
let exthash := keccak256(0, size)
if gt(xor(exthash, hashData), 0) {
                revert(0,0)
            }
```

the `extcodecopy` opcode returns the `size`-bytes of code of the `sender` starting at index `0`, and storing it in index `zero` of the calling contract's memory. The `exthash` then hashes all that data together. However, it then checks that value against `hashData`. Recall from earlier we can pass any `bytes32` object as long as we pass the data used to create that hash with it. 

So to recap we need to pass as input
    1. some data
    2. the hash of that data
    3. the hash of the code of the sender

Since we know that it's getting the hash of the code of `sender` we can guess that the contract wants us to provide the code itself as well, which we can only do when its a contract, as we required earlier.

```
bytes memory code = address(this).code;
bytes32 dataHash;

address addr = address(this);

assembly {
    dataHash := extcodehash(addr)
}

sprint.f22(address(this), code, dataHash);
```

## Challenge 23

Another assembly challenge. As you can see it's doing the same kind of `mstore` and `sload` operations as we saw in challenge 21, which means that it's doing things witth mappings. LKet's break it down

```
mstore(0, team)
mstore(32, 1)
let hash := keccak256(0, 64)
let result := sload(hash)
```

This gets the value of team from storage slot 1, which we know is score. So first it gets the score of `team`.

```
mstore(0, team)
mstore(32, 1)
hash := keccak256(0, 64)
sstore(hash, value)
```

We see it gets the same value hash, but instead of using `sload` to get the value, it's using `sstore` to store some value in that mapping. It's storing the value `value`, an int passed in as a function parameter.

```
mstore(0, team)
mstore(32, 1)
hash := keccak256(0, 64)
let result3 := sload(hash)
```

Same as the first one, it retrieves the value from the storage slot we just wrote to. It should be equal to value at this point.

```
if gt(xor(result3, add(result, add(mul(23, 200), 200))), 0) {
    revert(0, 0)
}
```
This looks confusing so let's break it down by parts. On the outside we see `if gt(xor(), 0) {revert()}`. We know from before othat this means that if the two value being `xor'd` weren't equal to revert. So let's look inside the `xor`. 

`xor(result3, add(result, add(mul(23, 200), 200)))`

so we're `XOR'ing` result3, which is the value we just wrote to the storage slot, with something else.

`add(result, add(mul(23, 200), 200))`

We're going to add result, which was the value in `scores` BEFORE we overwrote it, to something else.

`add(mul(23, 200), 200)`
with `mul(23, 200)` we're gonna multiply `23 * 200`, which coincidentally is the number of points you would expect for the 22nd challenge, but then we're going to add `200` more points to that. So `200 * 23 + 200 = 4800` which is the same number of points for the 23rd challenge, 200 more than the last. 

So now that we know what we are going to add 4800 to `result` which was the value of score at the beginning of the challenge. We also know that after we're going to compare our current score value to that value, and that we got to set our own score based on what we set as value. So we need to pass in some int `value` that is equal to our current score plus `4800` points. 

Despite the fact the user gets to choose the value to set as their score, the final if is used as a failsafe to make sure that they aren't allowed to set their score to whatever they want, jumping immediately to the top of the leaderboard, so if you don't input the exact number we want you to input the challenge will revert.

```
uint currPoints = sprint.scores(address(this));
uint desiredPoints = currPoints + (200 + (200*23));

sprint.f23(address(this), desiredPoints);
```