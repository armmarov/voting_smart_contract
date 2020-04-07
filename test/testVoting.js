const Voting = artifacts.require('Voting')

contract("Voting", async accounts => {

    it("should add new candidate to candidatelist", async function() {

        let contract = await Voting.new();

        // Candidate registered by Admin
        const { logs } = await contract.addToCandidate(accounts[1], {from: accounts[0]});

        // Check event
        let event = logs.find(l => l.event === 'candidateListAdded').args.candidate;
        assert.equal(event, accounts[1], "candidateListAdded event not emitted")

        // Check candidate existed
        let listed = await contract.isCandidateListed.call(accounts[1], {from: accounts[0]})
        assert.equal(listed, true, "Candidate is not registered !")        
    })


    it("should add new voter to voterlist", async function() {

        let contract = await Voting.new();

        // Candidate registered by Admin
        const { logs } = await contract.addToVoter(accounts[2], {from: accounts[0]});

        // Check event
        let event = logs.find(l => l.event === 'voterListAdded').args.voter;
        assert.equal(event, accounts[2], "voterListAdded event not emitted")

        // Check candidate existed
        let listed = await contract.isVoterListed.call(accounts[2], {from: accounts[0]})
        assert.equal(listed, true, "Voter is not registered !")        
    })

    it("should remove candidate from candidatelist", async function() {

        let contract = await Voting.new();

        // Candidate registered by Admin
        await contract.addToCandidate(accounts[3], {from: accounts[0]});

        // Check candidate existed
        let listed = await contract.isCandidateListed.call(accounts[3], {from: accounts[0]})
        assert.equal(listed, true, "Candidate is not registered !") 

        // Candidate removed by Admin
        const { logs } = await contract.removeFromCandidate(accounts[3], {from: accounts[0]});

        // Check event
        let event = logs.find(l => l.event === 'candidateListRemoved').args.candidate;
        assert.equal(event, accounts[3], "candidateListRemoved event not emitted")

        // Check candidate existed
        listed = await contract.isCandidateListed.call(accounts[3], {from: accounts[0]})
        assert.equal(listed, false, "Candidate is not removed !")        
    })

    it("should remove voter from voterlist", async function() {

        let contract = await Voting.new();

        // Candidate registered by Admin
        await contract.addToVoter(accounts[3], {from: accounts[0]});

        // Check candidate existed
        let listed = await contract.isVoterListed.call(accounts[3], {from: accounts[0]})
        assert.equal(listed, true, "Voter is not registered !") 

        // Candidate removed by Admin
        const { logs } = await contract.removeFromVoter(accounts[3], {from: accounts[0]});

        // Check event
        let event = logs.find(l => l.event === 'voterListRemoved').args.voter;
        assert.equal(event, accounts[3], "voterListRemoved event not emitted")

        // Check candidate existed
        listed = await contract.isVoterListed.call(accounts[3], {from: accounts[0]})
        assert.equal(listed, false, "Voter is not removed !")        
    })

    it("should be able to register event", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        const { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let event = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(event, hashedEventName, "eventAdded event not emitted")        
    })

    it("should be able to get event by name", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Get event by name
        let event = await contract.getEventByName(eventName, {from: accounts[0]});

        assert.equal(event[0], hashedEventName, "Unable to get event")       
    })

    it("should be able to get event by id", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Get event by name
        let event = await contract.getEventByID(hashedEventName, {from: accounts[0]});

        assert.equal(event[0], hashedEventName, "Unable to get event")       
    })

    it("should be able to add candidate to event", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        let { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let eventID = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(eventID, hashedEventName, "Event is not added")  

        // Add user to candidate
        await contract.addToCandidate(accounts[1], {from: accounts[0]});

        // Event registered by Admin
        let evt = await contract.addCandidateToEvent(accounts[1], eventID, {from: accounts[0]});

        // Check event
        let event = evt.logs.find(l => l.event === 'candidateEventAdded').args.candidate;
        assert.equal(event, accounts[1], "candidateEventAdded event not emitted") 
        
    })

    it("should be able to remove candidate from event", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        let { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let eventID = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(eventID, hashedEventName, "Event is not added")  

        // Add user to candidate
        await contract.addToCandidate(accounts[1], {from: accounts[0]});

        // Add candidate to event
        await contract.addCandidateToEvent(accounts[1], eventID, {from: accounts[0]});

        // Remove candidate from event
        let evt = await contract.removeCandidateFromEvent(accounts[1], eventID, {from: accounts[0]});

        // // Check event
        let event = evt.logs.find(l => l.event === 'candidateEventRemoved').args.candidate;
        assert.equal(event, accounts[1], "candidateEventRemoved event not emitted") 
    })

    it("should be able to get list of registered candidate from event", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        let { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let eventID = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(eventID, hashedEventName, "Event is not added")  

        // Add user to candidate
        await contract.addToCandidate(accounts[1], {from: accounts[0]});
        await contract.addToCandidate(accounts[2], {from: accounts[0]});

        // Add candidate to event
        await contract.addCandidateToEvent(accounts[1], eventID, {from: accounts[0]});
        await contract.addCandidateToEvent(accounts[2], eventID, {from: accounts[0]});

        // Get candidates list
        let candidates = await contract.getCandidatesByEventID(eventID, {from: accounts[0]});

        // Check event
        assert.equal(candidates.length, 2, "Wrong total number of registered candidates") 
    })

    it("should be able to cast voting", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        let { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let eventID = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(eventID, hashedEventName, "Event is not added")  

        // Add user to candidate
        await contract.addToCandidate(accounts[1], {from: accounts[0]});
        await contract.addToCandidate(accounts[2], {from: accounts[0]});
        await contract.addToVoter(accounts[3], {from: accounts[0]});

        // Add candidate to event
        await contract.addCandidateToEvent(accounts[1], eventID, {from: accounts[0]});
        await contract.addCandidateToEvent(accounts[2], eventID, {from: accounts[0]});

        // Get candidates list
        let evt = await contract.castVoting(accounts[1], eventID, {from: accounts[3]});

        // Check event
        let event = evt.logs.find(l => l.event === 'castVotingEvent').args.voter;
        assert.equal(event, accounts[3], "Unable to cast a vote") 
    })

    it("should be able to get result by candidate", async function() {

        let contract = await Voting.new();

        let eventName = "General Election Year 2020";
        let hashedEventName = "0x93291ca6c9f892dd0a879358a318edcca8e148e6da2c44a3ed5a81c3dba4fa5b";
        let location = "Batang Benar";
        let startDateInUnixTimestamp = 1586245546;
        let periodInDays = 5 

        // Event registered by Admin
        let { logs } = await contract.registerEvent(eventName, location, startDateInUnixTimestamp, periodInDays, {from: accounts[0]});

        // Check event
        let eventID = logs.find(l => l.event === 'eventAdded').args.evtID;
        assert.equal(eventID, hashedEventName, "Event is not added")  

        // Add user to candidate
        await contract.addToCandidate(accounts[1], {from: accounts[0]});
        await contract.addToCandidate(accounts[2], {from: accounts[0]});
        await contract.addToVoter(accounts[3], {from: accounts[0]});
        await contract.addToVoter(accounts[4], {from: accounts[0]});

        // Add candidate to event
        await contract.addCandidateToEvent(accounts[1], eventID, {from: accounts[0]});
        await contract.addCandidateToEvent(accounts[2], eventID, {from: accounts[0]});

        // Get candidates list
        await contract.castVoting(accounts[1], eventID, {from: accounts[3]});
        await contract.castVoting(accounts[2], eventID, {from: accounts[4]});

        // Get candidates list
        let evt = await contract.getResultByCandidate(accounts[1], eventID, {from: accounts[3]});

        // Check event
        assert.equal(evt, 1, "Unable to cast a vote") 
    })

})
