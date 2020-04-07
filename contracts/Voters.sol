pragma solidity ^0.5.16;

import "./DataStructure.sol";

contract Voters is DataStructure {

    /**
     * Voter list length
     */
    uint private VotersLen;

    event voterListAdded(address voter);
    event voterListRemoved(address voter);

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
     * @dev Function to add voter
     * @param addr is the voter address
     */
    function addToVoter(address addr)
    public
    onlyOwner
    {
        require(addr != address(0), "Error address zero");
        regVoters[addr].active = true;
        VotersLen++;
        emit voterListAdded(addr);
    }

    /**
     * @dev Function to remove voter
     * @param addr is the voter address
     */
    function removeFromVoter(address addr)
    public
    onlyOwner
    {
        require(addr != address(0), "Error address zero");
        require(isVoterListed(addr) == true, "Voter is not listed");
        regVoters[addr].active = false;
        VotersLen++;
        emit voterListRemoved(addr);
    }

    /**
     * @dev Function to check if voter existed
     * @param addr is the voter address
     * @return exist or not exist
     */
    function isVoterListed(address addr)
    public
    view
    returns (bool)
    {
        require(addr != address(0), "Error address zero");
        if(VotersLen == 0) {
            return false;
        }
        return regVoters[addr].active;
    }
}

