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
module custom_card_case_bottom(card_width, card_height, deck_depth, minimum_wall_width=2)
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

    inner_dimensions = [
        card_width + card_fit_padding,
        deck_depth + card_fit_padding,
        card_height + card_fit_padding
    ];

    outer_dimensions = inner_dimensions + [4 * minimum_wall_width, 4 * minimum_wall_width, 2 * minimum_wall_width];

    lid_height = lid_fraction * outer_dimensions.z;
    lid_overlap_depth = 10;

    assert(lid_overlap_depth < lid_height - minimum_wall_width - 4);

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

// minimum_wall_width should be customized based on printer line width
module custom_card_case_top(card_width, card_height, deck_depth, minimum_wall_width=2)
{
    inner_dimensions = [
        card_width + card_fit_padding + 2 * minimum_wall_width,
        deck_depth + card_fit_padding + 2 * minimum_wall_width,
        card_height + card_fit_padding
    ];

    outer_dimensions = inner_dimensions + [2 * minimum_wall_width, 2 * minimum_wall_width, 2 * minimum_wall_width];

    lid_height = lid_fraction * outer_dimensions.z;

    union() {
        difference() {
            _outer_case_shell(outer_dimensions);
            cube(inner_dimensions, center=true);
            translate([0, 0, lid_height]) {
                cube([outer_dimensions.x, outer_dimensions.y, outer_dimensions.z - lid_height], center=true);
            }
        }
    }
}