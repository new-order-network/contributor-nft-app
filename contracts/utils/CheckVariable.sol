pragma solidity ^0.8.4;

/**
 * @title Check Variable
 * @author Aedelon for New Order
 * @notice Contract for testing variable.
 */
contract CheckVariable {

    // FUNCTIONS ---------------------------------------------------------------------------------------
    /**
     * @notice Check if the content of the bytes32 is empty or not.
     */
    function checkIfBytes32IsEmpty(bytes32 _bytes) internal returns (bool) {
        if (_bytes.length == 0) {
            return true;
        } else {
            return false;
        }
    }

    // FUNCTIONS ---------------------------------------------------------------------------------------
    /**
     * @notice Check if the content of the string is empty or not.
     */
    function checkIfStringIsEmpty(string _string) internal returns (bool) {
        bytes memory _stringEmptyTest = bytes(_string);
        if (_stringEmptyTest.length == 0) {
            return true;
        } else {
            return false;
        }
    }
}