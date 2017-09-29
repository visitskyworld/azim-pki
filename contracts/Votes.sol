// the urbit votes data store
// untested draft

pragma solidity 0.4.15;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Votes is Ownable
{
  event ConcreteMajority(address constitution);
  event AbstractMajority(bytes32 hash);

  uint8 public totalVoters;

  // per constitution, we keep track of the votes for each proposed address.
  mapping(address => mapping(address => bool[256])) private concreteVotes;
  mapping(address => mapping(address => uint8)) public concreteVoteCounts;

  mapping(bytes32 => bool[256]) private abstractVotes;
  mapping(bytes32 => uint8) public abstractVoteCounts;
  bytes32[] public abstractMajorities;

  function Votes()
  {
    //
  }

  function incrementTotalVoters()
    external
    onlyOwner
  {
    totalVoters = totalVoters + 1;
  }

  function getVote(uint8 _galaxy, address _proposal)
    external
    constant
    returns(bool vote)
  {
    return concreteVotes[owner][_proposal][_galaxy];
  }

  function getVote(uint8 _galaxy, bytes32 _proposal)
    external
    constant
    returns(bool vote)
  {
    return abstractVotes[_proposal][_galaxy];
  }

  function getAbstractMajorities()
    external
    constant
    returns (bytes32[] majorities)
  {
    return abstractMajorities;
  }

  // ++vot
  // voting for change

  // vote on a concrete proposal.
  function castVote(uint8 _galaxy, address _proposal, bool _vote)
    external
    onlyOwner
    returns(bool newMajority)
  {
    require(_proposal != owner);
    bool prev = concreteVotes[owner][_proposal][_galaxy];
    require(prev != _vote);
    concreteVotes[owner][_proposal][_galaxy] = _vote;
    uint8 oldCount = concreteVoteCounts[owner][_proposal];
    if (_vote)
    {
      uint8 newCount = oldCount + 1;
      concreteVoteCounts[owner][_proposal] = newCount;
      if (newCount > totalVoters / 2)
      {
        ConcreteMajority(_proposal);
        return true;
      } else {
        return false;
      }
    } else {
      concreteVoteCounts[owner][_proposal] = oldCount - 1;
    }
  }

  // vote on an abstract proposal.
  //TODO doing wasMajority is sensitive to people un-voting and re-voting.
  //     depending on whether or not we want to be able to get a list of
  //     supported hashes, we either use a mapping or a construction similar
  //     to ship's pilots.
  function castVote(uint8 _galaxy, bytes32 _proposal, bool _vote)
    external
    onlyOwner
  {
    bool prev = abstractVotes[_proposal][_galaxy];
    require(prev != _vote);
    abstractVotes[_proposal][_galaxy] = _vote;
    if (_vote)
    {
      uint8 oldCount = abstractVoteCounts[_proposal];
      bool wasMajority = oldCount > totalVoters / 2;
      abstractVoteCounts[_proposal] = oldCount + 1;
      if (!wasMajority && oldCount + 1 > totalVoters / 2)
      {
        abstractMajorities.push(_proposal);
        AbstractMajority(_proposal);
      }
    } else {
      abstractVoteCounts[_proposal] = abstractVoteCounts[_proposal] - 1;
    }
  }
}
