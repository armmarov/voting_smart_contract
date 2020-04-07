pragma solidity ^0.5.16;

import "./DataStructure.sol";

contract Candidates is DataStructure {

    /**
     * Candidate list length
     */
    uint private candidatesLen;

    event candidateListAdded(address candidate);
    event candidateListRemoved(address candidate);

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
     * @dev Function to add candidate
     * @param addr is the candidate address
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
     * @dev Function to remove candidate
     * @param addr is the candidate address
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
     * @dev Function to check if candidate existed
     * @param addr is the candidate address
     * @return exist or not exist
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

