pragma solidity ^0.4.11;

import "./Ownable.sol";


contract PublicElection is Ownable {

    uint startDate;    
    uint endDate;

    function PublicElection(uint _startdate, uint _endDate) {

        startDate = _startdate;
        endDate = _endDate;
    }

    struct Candidate {
        string name;
        uint votes;
    }

    mapping(address => Candidate) candidates;
    address[] candidateIndex;

    function addCandidate(address _candidateAddress, string _candidateName) onlyOwner {
        
        candidate[_candidateAddress] = Candidate({name: _candidateName, votes: 0});
        candidateIndex.push(_candidateAddress);
    }

    function getCandidateIndexLength() constant returns (uint) {
        return candidateIndex.length;
    }

    function getCandidateAtIndex(uint index) constant returns (address candidate, string name, uint votes) {
        candidate = candidateIndex[index];
        name = candidates[candidate].votes;
    }

    modifier payedExact(uint amount) {
        require(msg.value == amount);
        _;
    }

    mapping (address => bool) registeredToVote;

    function registerToVote() payable payedExact(300 finney) {
        registeredToVote[msg.sender] = true;
    }

    modifier isRegisteredToVote() {
        require(registeredToVote[msg.sender]);
        _;
    }

    function castVote(address candidate) isRegisteredToVote onlyAfter(startDate) {
        candidates[candidate].votes += 1;
    }

    function conclude() onlyOwner onlyAfter(endDate) {
        uint winningVoteCount = 0;
        address winningCandidate;

        for (uint8 candidate = 0; candidate < candidate.length; index++) {
         
            Candidate c = candidates[candidateIndex[candidate]];

            if (c.votes > winningVoteCount) {
                winningVoteCount = c.votes;
                winningCandidate = candidateIndex[candidate];           

            }
        
        }

        winningCandidate.transfer(this.balance);

    }
}

    


// that symbolizes a vote with a start and end date.
// where only the owner of the contract can add candidates
// where any user can register to vote as long as they pay 3 ether
// where the registered users can vote on a candidate
// when triggered by the owner the winner gets all the funds, but only when the end date is passed