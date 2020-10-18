pragma solidity >=0.4.22 <0.7.0;

contract MultiSigWallet {
    event Deposite(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);
    event ConfirmTransaction(address indexed owner, uint  indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint  indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint  indexed txIndex);
    
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public numConfirmationsRequired;
    
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        mapping(address => bool) isConfirmed;
        uint numConfirmations;
    }
    
    Transaction[] public transactions;
    
    constructor(address[] memory _owners, uint _numConfirmationsRequired) public {
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0 &&  _numConfirmationsRequired <= _owners.length, "Invalid number of required confirmations");
        
        for (uint i = 0;  i < _owners.length; i++) {
            address owner = _owners[i];
            
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");
            
            isOwner[owner] = true;
            owners.push(owner);
        }
        
        numConfirmationsRequired = _numConfirmationsRequired;
    }
    
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }
    
    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;
        
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed:  false,
            numConfirmations: 0
        }));
        
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }
    
    function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        
    }
    
    function executeTransaction() {}
    
    function revokeConfirmation() {}
}