// Copyright 2025 Raymond M. Reskusich
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the “Software”),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// Units will be interpreted as millimeters.

// What fraction of the case length will be lid?
lid_fraction = 0.25;

// Extra space for a more reasonable fit
card_fit_padding=2;

module _outer_case_shell(shell_dimensions)
{
    $fn=30;
    fillet_radius=1.5;
    minkowski() {
        cube([
            shell_dimensions.x - 2 * fillet_radius,
            shell_dimensions.y - 2 * fillet_radius,
            shell_dimensions.z - 2 * fillet_radius
            ],
            center=true);
        sphere(fillet_radius);
    }
}

// minimum_wall_width should be customized based on printer line width
module custom_card_case_bottom(card_width, card_height, deck_depth, minimum_wall_width=2, center=true)
{
    module lid_inset(inner_dimensions, wall_width, overlap_depth)
    {
        linear_extrude(height = overlap_depth, center = true) {
            difference() {
                square([inner_dimensions.x + 2 * wall_width, inner_dimensions.y + 2 * wall_width], center=true);
                square([inner_dimensions.x, inner_dimensions.y], center=true);
            }
        }
    }

    module apply_final_position(outer_dimensions, lid_height, lid_overlap_depth)
    {
        if (center) {
            translate([0, 0, (lid_height - lid_overlap_depth)/2]) {
                children();
            }
        }
        else {
            translate(outer_dimensions/2) {
                children();
            }
        }
    }

    inner_dimensions = [
        card_width + card_fit_padding,
        deck_depth + card_fit_padding,
        card_height + card_fit_padding
    ];

    outer_dimensions = inner_dimensions + [4 * minimum_wall_width, 4 * minimum_wall_width, 2 * minimum_wall_width];

    lid_height = lid_fraction * outer_dimensions.z;
    lid_overlap_depth = 10;

    assert(lid_overlap_depth < lid_height - minimum_wall_width - 4);

    apply_final_position(outer_dimensions, lid_height, lid_overlap_depth) {
        union() {
            difference() {
                _outer_case_shell(outer_dimensions);
                cube(inner_dimensions, center=true);
                translate([0, 0,(outer_dimensions.z / 2) - (lid_height / 2)]) {
                    cube([outer_dimensions.x, outer_dimensions.y, lid_height], center=true);
                }
            }
            translate([0, 0, (outer_dimensions.z / 2) - lid_height + (lid_overlap_depth / 2)]) {
                lid_inset(inner_dimensions, minimum_wall_width, lid_overlap_depth);
            }
        }
    }
}

// minimum_wall_width should be customized based on printer line width
module custom_card_case_top(card_width, card_height, deck_depth, minimum_wall_width=2, center=true)
{
    module apply_final_position(outer_dimensions, lid_height)
    {
        if (center) {
            translate([0, 0, outer_dimensions.z/2 - lid_height/2]) {
                children();
            }
        }
        else {
            translate(outer_dimensions/2) {
                children();
            }
        }
    }

    inner_dimensions = [
        card_width + card_fit_padding + 2 * minimum_wall_width,
        deck_depth + card_fit_padding + 2 * minimum_wall_width,
        card_height + card_fit_padding
    ];

    outer_dimensions = inner_dimensions + [2 * minimum_wall_width, 2 * minimum_wall_width, 2 * minimum_wall_width];

    lid_height = lid_fraction * outer_dimensions.z;

    apply_final_position(outer_dimensions, lid_height) {
        union() {
            difference() {
                _outer_case_shell(outer_dimensions);
                cube(inner_dimensions, center=true);
                translate([0, 0, lid_height]) {
                    cube([outer_dimensions.x, outer_dimensions.y, outer_dimensions.z], center=true);
                }
            }
        }
    }
}