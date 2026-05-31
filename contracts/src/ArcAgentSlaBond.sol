// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArcAgentSlaBond {
    address public owner;
    uint256 public nextRecordId;

    struct Record {
        address actor;
        uint256 usdcAmount;
        bytes32 refHash;
        string label;
        bool settled;
    }

    mapping(uint256 => Record) public records;

    event RecordCreated(uint256 indexed id, address indexed actor, uint256 usdcAmount, bytes32 refHash, string label);
    event RecordSettled(uint256 indexed id, bool accepted, string evidenceURI);

    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }

    constructor() { owner = msg.sender; }

    function createRecord(uint256 usdcAmount, bytes32 refHash, string calldata label) external returns (uint256 id) {
        require(usdcAmount > 0, "amount=0");
        require(refHash != bytes32(0), "ref=0");
        require(bytes(label).length > 2, "label short");
        id = ++nextRecordId;
        records[id] = Record(msg.sender, usdcAmount, refHash, label, false);
        emit RecordCreated(id, msg.sender, usdcAmount, refHash, label);
    }

    function settleRecord(uint256 id, bool accepted, string calldata evidenceURI) external onlyOwner {
        Record storage r = records[id];
        require(r.actor != address(0), "unknown");
        require(!r.settled, "settled");
        r.settled = true;
        emit RecordSettled(id, accepted, evidenceURI);
    }
}
