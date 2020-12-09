# Lab 6: Video Game PONG
Generate a PONG game on an 800x600 VGA display using a 5kΩ potentiometer with ADC to control the paddle. 2019-11-15 pull request by Peter Ho with the 800x600@60Hz support for 100MHz clock.

**More Information:** https://github.com/kevinwlu/dsd/tree/master/Nexys-A7/Lab-6

## Original
Generates PONG game with controllable paddle. 

## Modifications
Modified source and constraint files include code additions that allow for the following changes:
- Allow user to change the speed of the ball using the switches on the Nexys
    - Also prevents user from setting ball speed to 0
- Allow user to change the width of the paddle
    - The paddle will shrink one pixel for every successful hit
    - The paddle will reset to starting width after missing the ball
- Allow user to keep track of successful hits on the 7-segment display

**Video:** 
