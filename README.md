# SC-SafeMath

This repository contains a collection of secure mathematical libraries designed for solidity smart contracts. 

## Overview 

### SafeMathLib

This library contains safe (protection against over/under flow) mathematical field operations (addition, subtraction, multiplication and division) to be used in arbitrary smart contracts. 

An example of using this library is given in the following code snippet. 

```solidity

import ./contracts/SafeMathLib.sol; 

contract exampleContract {
  using SafeMath for uint256;

  uint256 public veryImportantVariable = 2**256 - 100; 
  uint256 public anotherImportantVariable = 1; 

  function uncheckedOverflow() public {
    veryImportantVariable = veryImportantVariable + 300; //Unchecked Overflow. We should use SafeMath. 
  }

  // We do this correctly with the SafeMath library. 
  function safeMathAddition() public {
    veryImportantVariable = veryImportantVariable.add(300); // This will throw due to the overflow. 
  }

  function uncheckedUnderFlow() public {
    anotherImportantVariable = anotherImportantVariable - 10; // Unchecked underflow. 
  }

  function safeMathSubraction() public {
    anotherImportantVariable = anotherImportantVariable.sub(10); // This will throw due to the underflow. 
  }

}
```

### PrecisionLib.sol

This library enables variables to be shifted into and from higher precision forms. In the higher precision form, mathematical operations can be undertaken enabling higher precision calculations. Once completed, the variables can be converted back to their lower precision forms, with rounding being taken into account.

A trivial example use is given in the following code snippet: 
```solidity
   
   import ./contracts/PrecisionLib.sol; 

   contract testPrecision() {
     using Precision for uint256;

     uint256 public numerator = 100;
     uint256 public divisorA = 9;
     uint256 public divisorB = 6; 
     // in solidity: numerator/divisorA = 11 floating point result is (11.1111....)
     // and          numerator/divisorB = 6 floating point result is (16.666...)
     // using PrecisionLib: 
     numeratorHP = numerator.toHP()   // We shift to higher precision (being careful of overflows)
     divisorAHP = divisorA.toHP()     // Shift divisorA 
     divisorBHP = divisorB.toHP()     // Shift divisorB 
     result = numeratorHP.HPdiv(divisorAHP).fromHP()  // This will = 11
     result2 = numeratorHP.HPdiv(divisorBHP).fromHP() // This will = 17 (rounded)
```


