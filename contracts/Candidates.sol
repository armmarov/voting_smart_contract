pragma solidity ^0.5.16;

import "./DataStructure.sol";

contract Candidates is DataStructure {

    /**
     * Candidate list length
     */
    uint private candidatesLen;

    event candidateListAdded(address voter);
    event candidateListRemoved(address voter);

    constructor()
    public
    {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require (
            msg.sender == owner,
            "Must be owner."
        );
    }

    /**
     * Function: Add new address to Candidate
     * Parameter: address
     * Return: -
     */
    function addToCandidate(address addr)
    public
    onlyOwner
    {
        require(addr != address(0), "Error address zero");
        regCandidates[addr].active = true;
        candidatesLen++;
        emit candidateListAdded(addr);
    }

    /**
     * Function: Remove address from Candidate
     * Parameter: address
     * Return: -
     */
    function removeFromCandidate(address addr)
    public
    onlyOwner
    {
        require(addr != address(0), "Error address zero");
        require(isCandidateListed(addr) == true, "Candidate is not listed");
        regCandidates[addr].active = false;
        candidatesLen++;
        emit candidateListRemoved(addr);
    }

    /**
     * Function: Check if Black listed
     * Parameter: address
     * Return: bool
     */
    function isCandidateListed(address addr)
    public
    view
    returns (bool)
    {
        require(addr != address(0), "Error address zero");
        if(candidatesLen == 0) {
            return false;
        }
        return regCandidates[addr].active;
    }
}

