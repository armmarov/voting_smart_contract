pragma solidity ^0.5.16;

import "./DataStructure.sol";
import "./Candidates.sol";
import "./Voters.sol";

contract EVM_Voting is DataStructure, Candidates, Voters {

    event eventAdded(bytes32 evtID);
    event candidateEventAdded(address candidate);
    event candidateEventRemoved(address candidate);
    event castVotingEvent(address voter);

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

    modifier existedEvent(bytes32 evtID) {
        _existedEvent(evtID);
        _;
    }

    function _existedEvent(bytes32 evtID) internal view {
        require(
            regEvents[evtID].evt.eventID == evtID,
            "Must be an existed post."
        );
    }

    modifier nonExistedEvent(bytes32 evtID) {
        _nonExistedEvent(evtID);
        _;
    }

    function _nonExistedEvent(bytes32 evtID) internal view {
        require(
            regEvents[evtID].evt.eventID != evtID,
            "Must be not an existed post."
        );
    }

    modifier existedVoter(address voter) {
        _existedVoter(voter);
        _;
    }

    function _existedVoter(address voter) internal view {
        require(
            regVoters[voter].active == true,
            "Must be an existed voter."
        );
    }

    modifier nonExistedVoter(address voter) {
        _nonExistedVoter(voter);
        _;
    }

    function _nonExistedVoter(address voter) internal view {
        require(
            regVoters[voter].active == false,
            "Must be not an existed voter."
        );
    }

    modifier existedCandidate(address candidate) {
        _existedCandidate(candidate);
        _;
    }

    function _existedCandidate(address candidate) internal view {
        require(
            regCandidates[candidate].active == true,
            "Must be an existed candidate."
        );
    }

    modifier nonExistedCandidate(address candidate) {
        _nonExistedCandidate(candidate);
        _;
    }

    function _nonExistedCandidate(address candidate) internal view {
        require(
            regCandidates[candidate].active == false,
            "Must be not an existed candidate."
        );
    }

    modifier existedCandidateEvent(address candidate, bytes32 evtID) {
        _existedCandidateEvent(candidate, evtID);
        _;
    }

    function _existedCandidateEvent(address candidate, bytes32 evtID) internal view {
        bool ret_val = false;
        for(uint i = 0; i < regEvents[evtID].candidateAddr.length; i++) {
            if (regEvents[evtID].candidateAddr[i] == candidate) {
                ret_val = true;
                break;
            }
        }
        require(
            ret_val == false,
            "Must be registered in event."
        );
    }

    modifier nonExistedCandidateEvent(address candidate, bytes32 evtID) {
        _nonExistedCandidateEvent(candidate, evtID);
        _;
    }

    function _nonExistedCandidateEvent(address candidate, bytes32 evtID) internal view {
        bool ret_val = false;
        for(uint i = 0; i < regEvents[evtID].candidateAddr.length; i++) {
            if (regEvents[evtID].candidateAddr[i] == candidate) {
                ret_val = true;
                break;
            }
        }
        require(
            ret_val == true,
            "Must be registered in event."
        );
    }

    modifier onlyOnceVoting(bytes32 evtID) {
        _onlyOnceVoting(evtID);
        _;
    }

    function _onlyOnceVoting(bytes32 evtID) internal view {
        bool ret_val = false;
        for(uint i = 0; i < regEvents[evtID].voterAddr.length; i++) {
            if (regEvents[evtID].voterAddr[i] == msg.sender) {
                ret_val = true;
                break;
            }
        }
        require(
            ret_val == false,
            "Must vote only once."
        );
    }

    modifier checkEndDate(bytes32 evtID) {
        _checkEndDate(evtID);
        _;
    }

    function _checkEndDate(bytes32 evtID) internal view {        
        require(
            now <= regEvents[evtID].evt.dateEnd,
            "Must be in voting period."
        );
    }

    function registerEvent(
        string memory eventName, 
        string memory location, 
        uint startDate, 
        uint period)
    public
    onlyOwner
    nonExistedEvent(keccak256(abi.encodePacked(eventName)))
    {
        bytes32 evtID = keccak256(abi.encodePacked(eventName));
        regEvents[evtID].evt.eventID = evtID;
        regEvents[evtID].evt.eventName = eventName;
        regEvents[evtID].evt.location = location;
        regEvents[evtID].evt.dateStart = startDate;
        regEvents[evtID].evt.dateEnd = startDate + period * 1 days;

        emit eventAdded(evtID);
    }

    function addCandidateToEvent(address candidate, bytes32 evtID)
    public
    onlyOwner
    existedEvent(evtID)
    nonExistedCandidateEvent(candidate, evtID)
    {

        regEvents[evtID].candidateAddr.push(candidate);

        emit candidateEventAdded(candidate);
    }

    function removeCandidateFromEvent(address candidate, bytes32 evtID)
    public
    onlyOwner
    existedEvent(evtID)
    existedCandidateEvent(candidate, evtID)
    {
        require(regEvents[evtID].candidateAddr.length > 0, "No candidate yet");

        uint idx;
        for(idx = 0; idx < regEvents[evtID].candidateAddr.length; idx++) {
            if(regEvents[evtID].candidateAddr[idx] == candidate) {
                break;
            }
        }

        regEvents[evtID].candidateAddr[idx] = regEvents[evtID].candidateAddr[regEvents[evtID].candidateAddr.length - 1];
        delete regEvents[evtID].candidateAddr[regEvents[evtID].candidateAddr.length - 1];

        regEvents[evtID].candidateAddr.length--;

        emit candidateEventRemoved(candidate);
    }

    function castVoting(address candidate, bytes32 evtID)
    public
    existedVoter(msg.sender)
    onlyOnceVoting(evtID)
    existedEvent(evtID)
    existedCandidateEvent(candidate, evtID)
    checkEndDate(evtID)
    {
        regEvents[evtID].voteResults[candidate].count++;
        regEvents[evtID].voterAddr.push(msg.sender);

        emit castVotingEvent(msg.sender);
    }

    function getResult(address candidate, bytes32 evtID)
    public
    view
    existedEvent(evtID)
    existedCandidateEvent(candidate, evtID)
    returns (uint)
    {
        return regEvents[evtID].voteResults[candidate].count;
    }
}
