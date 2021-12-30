pragma solidity ^0.8.4;

/**
 * @title New Order NFT interface
 * @author Aedelon for New Order
 * @notice Interface for the manipulation of the different kind of NFTs in New Order.
 */
interface INewOrderNFTBase {
    // ENUM --------------------------------------------------------------------------------------------
    /**
     * @notice The different types of workstream for contribution in New Order.
     */
    enum WorkstreamType { 
        CommunityContent, 
        Marketing, 
        TreasuryManagement, 
        Engineering, 
        Partnerships, 
        VentureStrategist 
    }

    /**
     * @notice The different types of special NFT.
     */
    enum SpecialType { }
    

    // EVENT -------------------------------------------------------------------------------------------
    /**
     * @notice Emitted when a new NFT is created.
     */
    event NewNFT(uint indexed nftId, WorkstreamType indexed nftType);

    /**
     * @notice Emitted when a NFT is deleted.
     */
    event DeleteNFT(uint indexed nftId);

    /**
     * @notice Emitted when a new Workstream NFT is created.
     */
    event NewWorkstreamNFT(uint indexed nftId, WorkstreamType indexed nftType);

    /**
     * @notice Emitted when a new Special NFT is created.
     */
    event NewSpecialNFT(uint indexed nftId, SpecialType indexed nftType);


    // FUNCTIONS ---------------------------------------------------------------------------------------
    // CONTRIBUTION REWARD NFT FUNCTIONS ---------------------------------------------------------------
    /**
     * @notice Create a new Contribution Reward NFT and link the NFT to the owner of the contract.
     *
     * @dev Requirements:
     * 
     * - The sender of the message must be the owner of the contract. 
     */
    function createContributionRewardNFT(WorkstreamType _type, uint32 _tokenReward) internal;

    /**
     * @notice Create a batch of new Contribution Reward NFTs with the same characteristics and 
     *      link the NFT to the owner of the contract.
     *
     * @dev Requirements:
     * 
     * - The sender must be the owner of the contract. 
     */
    function createContributionRewardNFTBatch(
        WorkstreamType _type, 
        uint32 _tokenReward, 
        uint _numberOfNFTs
    ) public;

    /**
     * @notice Edit a Contribution Reward NFTs with the same characteristics and 
     *      link the NFT to the owner of the contract.
     *
     * @dev Requirements:
     * 
     * - `_id` token must exist and be owned by the owner of the contract.
     * - The sender must be the owner of the contract.
     */
    function deleteContributionRewardNFT(uint _id) public;


    // GET DATA FUNCTIONS ------------------------------------------------------------------------------
    /**
     * @notice Get every Contribution Reward NFTs from an owner.
     */
    function getContributionRewardNFTsByOwner(address _nftOwner) public view returns(uint[]);

    /**
     * @notice Get every Workstream NFTs from an owner.
     */
    function getWorkstreamNFTsByOwner(address _nftOwner) public view returns(uint[]);

    /**
     * @notice Get every Special NFTs from an owner.
     */
    function getSpecialNFTsByOwner(address _nftOwner) public view returns(uint[]);

    /**
     * @notice Get every NFT from an owner. There are 3 lists of ids for the Contribution Reward NFTs,
     *         Workstream NFTs & Special NFTs.
     */
    function getNFTsByOwner(address _nftOwner) external view returns(uint[], uint[], uint[]);


    // WORKSTREAM NFT FUNCTIONS ------------------------------------------------------------------------
    /**
     * @notice Create a workstream NFT for a contributor.
     * 
     * @dev Requirements:
     * - `_to` cannot be the 0 address.
     * - `_to` must own at least a contribution of the relevant workstream type.
     * - `_to` cannot create a Workstream NFT for a same `_type` which he is already owning.
     */
    function createWorkstreamNFT(address _to, WorkstreamType _type) internal;

    /**
     * @notice Add experience points to a contributor workstream NFT .
     * 
     * @dev Requirements:
     * - `_workstream.level` < LEVEL_NUMBER;
     */
    function addXPToWorkStreamNFT(WorkstreamNFT storage _workstreamNFT) internal;

    /**
     * @dev Verify the Workstream NFTs of the `to` address and decide if it creates a new NFT or
     *      it adds experience points to an existing NFT.
     *
     * @dev Requirements:
     * - `_to` cannot be the 0 address.
     */
    function verifyWorkstreamNFTs(address _to, WorkstreamType _type) internal;


    // SPECIAL NFT FUNCTIONS ---------------------------------------------------------------------------
    /**
     * @notice Add experience points to a contributor workstream NFT .
     * 
     * @dev Requirements:
     * - `_to` cannot be the 0 address.
     * - `_to` cannat have more than one special NFT of the type `_type`.
     */
    function createSpecialNFT(address _to, SpecialType _type) internal;
}