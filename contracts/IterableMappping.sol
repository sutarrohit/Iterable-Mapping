//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

contract IterableMappping {
    mapping(address => uint) public balance;
    mapping(address => bool) public inserted;
    address[] public key;

    // Receive Ether
    function sendETH() public payable {
        require(msg.value > 0, "you cannot sent 0 ETH");
        set(msg.sender, msg.value);
    }

    function set(address _key, uint _value) internal {
        balance[_key] += _value;

        if (!inserted[_key]) {
            inserted[_key] = true;
            key.push(_key);
        }
    }

    // Withdraw Ether
    function withdraw() external {
        uint getBalance = balance[msg.sender];
        require(getBalance > 0, "You don't have ETH to withdraw");

        uint getIndexOfAddress = getIndexFromAddress(msg.sender);
        inserted[msg.sender] = false;
        delete key[getIndexOfAddress];
        key[getIndexOfAddress] = key[key.length - 1];
        key.pop();
        balance[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: getBalance}("");
        require(success, "Transaction failled");
    }

    //Getter functions
    function getSize() public view returns (uint) {
        return key.length;
    }

    function getFirstAddress() public view returns (uint) {
        return balance[key[0]];
    }

    function getLastAddress() public view returns (uint) {
        return balance[key[key.length - 1]];
    }

    function getBalanceOfAllAccounts(uint index) public view returns (uint) {
        return balance[key[index]];
    }

    function getIndexFromAddress(address _address) public view returns (uint) {
        require(inserted[_address], "Don't have ETH for this address");

        for (uint i; i < key.length; i++) {
            if (_address == key[i]) {
                return i;
            }
        }
        return 0;
    }
}
