pragma solidity ^0.8.4;

import "./interfaces/INewOrderNFTBase.sol";
import "./utils/Context.sol";
import "./utils/Address.sol";
import "./ERC165.sol";

/**
 * @title New Order NFT interface
 * @author Aedelon for New Order
 * @notice Contract for the manipulation of the different kind of NFTs in New Order.
 * @dev Implementation of the interface INewOrderNFTBase.
 */
contract NewOrderNFT is Context, Address, Ownable, ERC165, INewOrderNFTBase {
    using Address for address;

    // CONSTANTS ---------------------------------------------------------------------------------------
    uint LEVEL_NUMBER = 5;
    uint XP_PER_CONTRIBUTION = 50;

    // STRUCTURES --------------------------------------------------------------------------------------
    struct ContributionRewardNFT {
        WorkstreamType type;
        uint32 tokenReward;
    }


    struct WorkstreamNFT {
        WorkstreamType type;
        uint16 level;
        uint16 experiencePoints;
    }


    struct SpecialNFT {
        SpecialType type;
    }

    // STATE VARIABLES ---------------------------------------------------------------------------------
    ContributionRewardNFT[] public contributionRewardNFTs;
    WorkstreamNFT[] public workstreamNFTs;
    SpecialNFT[] public specialNFTs;

    mapping (uint => address) public contributionRewardNFTToOwner;
    mapping (uint => address) public workstreamNFTToOwner;
    mapping (uint => address) public specialNFTToOwner;

    mapping (address => uint) contributionRewardNFTBalance;
    mapping (address => uint) workstreamNFTBalance;
    mapping (address => uint) specialNFTBalance;

    uint[LEVEL_NUMBER-1] levelThreshold = [100, 300, 600, 1000];


    // MODIFIERS ---------------------------------------------------------------------------------------


    // FUNCTIONS ---------------------------------------------------------------------------------------
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(INewOrderNFTBase).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // CONTRIBUTION REWARD NFT FUNCTIONS ---------------------------------------------------------------
    /**
     * @dev See {INewOrderNFTBase-createContributionRewardNFT}.
     */
    function createContributionRewardNFT(WorkstreamType _type, uint32 _tokenReward) 
        internal
        virtual 
        override 
    {    
        uint id = contributionRewardNFTs.push(
            ContributionRewardNFT(_type, _tokenReward)
        );
        contributionRewardNFTToOwner[id] = _msgSender();
        contributionRewardNFTBalance[_msgSender()]++;

        emit NewNFT(id, _type);
    }


    /**
     * @dev See {INewOrderNFTBase-createContributionRewardNFTBatch}.
     */
    function createContributionRewardNFTBatch(
        WorkstreamType _type, 
        uint32 _tokenReward, 
        uint _numberOfNFTs
    ) 
        public 
        virtual 
        override 
        onlyOwner 
    {    
        for (uint i = 0; i < _numberOfNFTs; i++) {
            createContributionRewardNFT(_type, _tokenReward);
        }
    }


    /**
     * @dev See {INewOrderNFTBase-editContributionRewardNFT}
     * WARNING: Try to not create unusefull NFT. This costs gas for nothing.
     */
    function deleteContributionRewardNFT(uint _id) public virtual override onlyOwner {
        contributionRewardNFTBalance[owner]--;
        delete contributionRewardNFTs[_id];
    }


    // GET DATA FUNCTIONS ------------------------------------------------------------------------------
    /**
     * @dev See {INewOrderNFTBase-getContributionRewardNFTsByOwner} 
     */
    function getContributionRewardNFTsByOwner(address _nftOwner) 
        public 
        view 
        virtual
        override
        returns(uint[]) 
    {
        require(
            _nftOwner != address(0), 
            "NewOrderNFTBase: try get the Contribution Reward NFTs of the zero address."
        );

        uint[] memory resultForCRNFTs = new uint[](contributionRewardNFTBalance[_nftOwner]);

        uint counter = 0;
        for (uint i = 0; i < contributionRewardNFTs.length; i++) {
            if (contributionRewardNFTs[i] == _nftOwner) {
                resultForCRNFTs[counter] = i;
                counter++;
            }
        }

        return resultForCRNFTs;
    }

    /**
     * @dev See {INewOrderNFTBase-getWorkstreamNFTsByOwner}
     */
    function getWorkstreamNFTsByOwner(address _nftOwner) external view returns(uint[])
        public 
        view 
        virtual
        override
        returns(uint[]) 
    {
        require(
            _nftOwner != address(0), 
            "NewOrderNFTBase: try get the Workstream NFTs of the zero address."
        );
        uint[] memory resultForWNFTs = new uint[](workstreamNFTBalance[_nftOwner]);

        counter = 0;
        for (uint i = 0; i < workstreamNFTs.length; i++) {
            if (workstreamNFTs[i] == _nftOwner) {
                resultForWNFTs[counter] = i;
                counter++;
            }
        }

        return resultForWNFTs;
    }

    /**
     * @dev See {INewOrderNFTBase-getSpecialNFTsByOwner}
     */
    function getSpecialNFTsByOwner(address _nftOwner) external view returns(uint[])
        public 
        view 
        virtual
        override
        returns(uint[]) 
    {
        require(
            _nftOwner != address(0), 
            "NewOrderNFTBase: try get the Special NFTs of the zero address."
        );
        uint[] memory resultForSNFTs = new uint[](specialNFTBalance[_nftOwner]);

        counter = 0;
        for (uint i = 0; i < specialNFTs.length; i++) {
            if (specialNFTs[i] == _nftOwner) {
                resultForSNFTs[counter] = i;
                counter++;
            }
        }

        return resultForSNFTs;
    }

    /**
     * @dev See {INewOrderNFTBase-getNFTsByOwner}
     */
    function getNFTsByOwner(address _nftOwner) 
        external 
        view 
        virtual 
        override 
        returns(uint[], uint[], uint[]) 
    {
        require(_nftOwner != address(0), "NewOrderNFTBase: try get the NFTs of the zero address.");
        uint[] memory resultForCRNFTs = getContributionRewardNFTsByOwner(_nftOwner);
        uint[] memory resultForWNFTs = getWorkstreamNFTsByOwner(_nftOwner);
        uint[] memory resultForSNFTs = getSpecialNFTsByOwner((_nftOwner));

        return resultForCRNFTs, resultForWNFTs, resultForSNFTs;
    }


    // WORKSTREAM NFT FUNCTIONS ------------------------------------------------------------------------
    /**
     * @dev See {INewOrderNFTBase-createWorkstreamNFT}
     */
    function createWorkstreamNFT(address _to, WorkstreamType _type) internal virtual override {
        require(_nftOwner != address(0), "NewOrderNFTBase: try mint a NFT to the zero address.");
        uint id = workstreamNFTs.push(
            WorkstreamNFT(_type, 1, XP_PER_CONTRIBUTION);
        );

        workstreamNFTToOwner[id] = _to;
        workstreamNFTBalance[_to]++;

        emit NewNFT(id, _type);
    }


    /**
     * @dev See {INewOrderNFTBase-addXPToWorkStreamNFT}
     */
    function addXPToWorkStreamNFT(WorkstreamNFT storage _workstreamNFT) internal {
        require(
            _workstreamNFT.level < LEVEL_NUMBER, 
            "NewOrderNFTBase: try verify the Workstream NFTs of the zero address."
        );
        _workstreamNFT.experiencePoints += XP_PER_CONTRIBUTION;
        if (_workstreamNFT.experiencePoints >= levelThreshold[LEVEL_NUMBER]) {
            _workstreamNFT.level = LEVEL_NUMBER;
        } else if (_workstreamNFT.experiencePoints >= levelThreshold[_workstreamNFT.level]) {
            _workstreamNFT.level += 1;
        }
    }

    /**
     * @dev See {INewOrderNFTBase-verifyWorkstreamNFTs}
     */
    function verifyWorkstreamNFTs(address _to, WorkstreamType _type) internal {
        require(
            _nftOwner != address(0), 
            "NewOrderNFTBase: try verify the Workstream NFTs of the zero address."
        );
        ownedWorkstreamNFTs = getWorkstreamNFTsByOwner(_to);
        balance = workstreamNFTBalance[_to];

        // Check the gas cost of doing that
        for (uint i = 0; i < balance; i++) {
            uint tokenId = ownedWorkstreamNFTs[i];
            WorkstreamNFT storage workstreamNFT = workstreamNFTs[tokenId];

            if (_type == workstreamNFT.type) {
                addXPToWorkStreamNFT(workstreamNFT);
                return;
            }
        }

        createWorkstreamNFT(_to, _type);
    }

    // SPECIAL NFT FUNCTIONS ---------------------------------------------------------------------------
    /**
     * @dev See {INewOrderNFTBase-createSpecialNFT}
     */
    function createSpecialNFT(address _to, SpecialType _type) internal;

    /**
     * @dev See {INewOrderNFTBase-verifySpecialNFTs}
     */
    function verifySpecialNFTs(address _to) internal;
}