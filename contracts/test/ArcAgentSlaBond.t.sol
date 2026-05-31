// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "../src/ArcAgentSlaBond.sol";
contract ArcAgentSlaBondTest {
    function testCreateRecord() public {
        ArcAgentSlaBond app = new ArcAgentSlaBond();
        uint256 id = app.createRecord(1000000, keccak256("arc-agent"), "arc task");
        require(id == 1, "bad id");
    }
}
