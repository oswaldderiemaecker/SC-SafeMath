pragma solidity ^0.4.18;

/**
 * This library implements precision rounding. 
 * As of solidity 0.4.19 - no floating point type exists. 
 * A convenient work around (inspired by MakerDAO) involves
 * shifting common variables to higher precision, (HP), via the 
 * function toHP(). Operations can be performed in this precision
 * and when a result is required, the fromHP() function can be 
 * utilized to receive a rounded result. 
 * This library should be used with the SafeMathLib library to prevent
 * potential over/under flows. 
 *
 * This version currently supports uint256.
 */


 /** 
  * Example Use: 
  * uint256 public numerator = 100;
  * uint256 public divisorA = 9;
  * uint256 public divisorB = 6; 
  * in solidity: numerator/divisorA = 11 floating point result is (11.1111....)
  * and          numerator/divisorB = 6 floating point result is (16.666...)
  * using Precision: 
  * using Precision for uint256;
  * numeratorHP = numerator.toHP()  // We shift to higher precision (being careful of overflows)
  * divisorAHP = divisorA.toHP()     // Shift divisorA 
  * divisorBHP = divisorB.toHP()     // Shift divisorB 
  * result = numeratorHP.HPdiv(divisorAHP).fromHP() // This will = 11
  * result2 = numeratorHP.HPdiv(divisorBHP).fromHP() // This will = 17 (rounded)
  * 
  * This pattern can be extended to significantly more complex scenarios, where complex
  * mathematical operations should be performed in higher precision utilizing the 256bit
  * length of the integers for higher precision calculations. 
  */

library Precision {

    /** 
     * The precision at which to do calculations. This can be adjusted
     * given the scenario. But the size of the numbers being operated on
     * must be taken into account to avoid potential overflows. 
     */
    uint constant HP = 10 ** 18; 

    /**
     * toHP() - Convert the variable to the precision defined by HP;
     */
    function toHP(uint256 a) pure internal returns (uint256 b) {
        // assert(x < (2**256 / WAD));
        b = a * HP;
        assert(b > a);
    }

    /**
     * fromHP() - Return the variable to its original precision (including rounding);
     */
    function fromHP(uint256 a) pure internal returns (uint256 b) {
        assert(a > HP); // This must be at least as big as the precision we started with.
        // include rounding
        b = (a + HP/2) / HP;
    }

    /**
     * HPmul() - Multiplication in higher precision. Includes rounding. 
     */
    function HPmul(uint256 a, uint256 b) pure internal returns (uint256 c) {
        c = (a * b + HP / 2) / HP;
        assert(a == 0 || HPdiv(c, a) == b);
    }

    /**
     * HPdiv() - Division in higher precision. Includes rounding. 
     */
    function HPdiv(uint256 a, uint256 b) pure internal returns (uint256 c) {
        c = (a * HP + b / 2) / b;
    }
}
