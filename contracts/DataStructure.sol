pragma solidity ^0.5.16;

contract DataStructure {

    /* @desc Candidate details
     * @param name Name of the candidate
     * @param id Identification number of the candidate
     * @param group Group of the candidate belongs to
     */
    struct votingCandidate {
        string name;
        string id;
        string group;
        bool active;
    }

    /* @desc Voting event details
     * @param eventName the name for the event
     * @param dateStart the start date for the event
     * @param dateEnd the end date for the event
     * @param location the location of the event
     * @param extra any additional info
     */
    struct votingEvent {
        bytes32 eventID;
        string eventName;
        uint dateStart;
        uint dateEnd;
        string location;
        string extra;
    }

    /* @desc Each voter structure
     * @param name Name of the voter
     * @param id Identification number of the voter
     */
    struct voter {
        string name;
        string id;
        bool active;
    }

    struct votingResult {
        uint count;
    }

    struct voting {
        votingEvent evt;
        address[] candidateAddr;
        address[] voterAddr;
        mapping(address => votingResult) voteResults;
    }

    mapping(address => votingCandidate) public regCandidates;    
    mapping(address => voter) public regVoters;
    mapping(bytes32 => voting) internal regEvents;
    
    address public owner;

}