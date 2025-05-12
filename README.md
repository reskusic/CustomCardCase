# CustomCardCase library

This library creates 3D models of custom storage cases for gaming cards (from board games, collectible card games, classic playing cards, etc.). A case can be generated for any given card or deck size.

![A 3D graphical rendering of two parts of a card storage box. On the left is the main part of the box. On the right is the lid, which is inverted.](assets/both_parts_rendered.png)

## Library Modules

### **custom_card_case_bottom(card_width, card_height, deck_depth, minimum_wall_width=2, center=true)**

Generates the bottom part of the two piece case

### **custom_card_case_top(card_width, card_height, deck_depth, minimum_wall_width=2, center=true)**

Generates the top part of the two piece case

### Common parameters

**card_width** - the width of the type of card to be stored, in millimeters

**card_height** - the height of the type of card to be stored, in millimeters

**deck_depth** - the depth of the deck of cards to be stored, in millimeters

**minimum_wall_width** - the minimum thickness for the walls of the case, in millimeters. This may need adjusting for various materials or printer models.

**center** - will the generated model be centered on the origin?

## Example

The following creates a case for storing a typical playing card deck.

```
use <CustomCardCase.scad>

custom_card_case_bottom(card_width=64, card_height=89, deck_depth=16.5, center=false);

translate([0,40,0])
    custom_card_case_top(card_width=64, card_height=89, deck_depth=16.5, center=false);

```