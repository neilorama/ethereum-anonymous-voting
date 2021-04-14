pragma solidity >=0.7.0 <0.9.0;

import "./AnonymousElection.sol";

contract AnonymousElectionCreator {
    address private owner;
    
    
    mapping(string => address) private electionsMapping;
    string[] private electionsList;
    
    constructor() {
        owner = msg.sender;
        electionsList = new string[](0);
    }
    
    function createElection(string memory _electionName, string[] memory _candidates, address[] memory _voters, 
            uint256 _p, uint256 _g) public returns(address) {
        // make sure that the _electionName is unique
        require(electionsMapping[_electionName] == address(0), "Election name not unique. An election already exists with that name");
        require(_candidates.length > 0 && _voters.length > 0, "candidate list and voter list both need to have non-zero length");
        
        // create election
        AnonymousElection election = new AnonymousElection(_candidates, _voters, _p, _g, msg.sender);
        
        // create mapping between _electionName and election address
        electionsMapping[_electionName] = address(election);
        
        // add name to electionsList
        electionsList.push(_electionName);
        
        // return the address of the election created
        return address(election);
    }
    
    // return address of an election given the election's name
    function getElectionAddress(string memory _electionName) public view returns(address) {
        // ensure that _electionName is a valid election
        require(electionsMapping[_electionName] != address(0));
        
        // return the address of requested election
        return electionsMapping[_electionName];
    }
    
    
    // return list of all election names created with this election creator
    function getAllElections() public view returns (string[] memory){
        return electionsList;
    }
    
    
}