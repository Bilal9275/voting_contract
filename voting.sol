// SPDX-License-Identifier:MIT
pragma solidity 0.8.13;
contract Voting {
    address[] public candidates;
    address public owner;
    mapping(address=>uint256)public receivedVotes;
    uint256 public winnerVoteReceived;
     address public winner;
    enum votingStatus{notStarting, Running, Completed}
    votingStatus public status;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require( msg.sender == owner,"you not a Owner");
        _;
    }
    function checkStatus() public onlyOwner{
        if(status != votingStatus.Completed && status != votingStatus.Running){
            status = votingStatus.Running;
        }else{ 
            status = votingStatus.Completed;
        }
    }
    function candidateRegistration(address _addr) public onlyOwner{
        candidates.push(_addr);
    }
    function voting(address _addr) public {
        require(validCandidate(_addr), "Not a valid candidate");
        require(status == votingStatus.Running, "voting is not active");
        receivedVotes[_addr] = receivedVotes[_addr]+1;
    }        
    function validCandidate(address _addr) public view returns(bool){
        for(uint256 i; i<candidates.length; i++){
            if(candidates[i] == _addr){
                return true;
            }
        }
        return false;
    }
    function voteCount(address _addr) public view returns(uint256){
        require(validCandidate(_addr), "Not a valid candidate");
        assert(status == votingStatus.Running);
        return receivedVotes[_addr];
    }
    function votingResult() public{
        require(status == votingStatus.Completed, "voting is not completed, So result can't be declared");
        for(uint256 i; i<candidates.length; i++){
            if(receivedVotes[candidates[i]] > winnerVoteReceived){
                winnerVoteReceived = receivedVotes[candidates[i]];
                winner = candidates[i];
            }
        }
    }
}