#import "StepperTableCell.h"
#include <Foundation/Foundation.h>

@implementation SCIStepperTableCell

// adapted from PHVerticalAdjustmentTableCell

@dynamic control;

/* * PSTableCell * */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
		self.accessoryView = self.control;
	}
	return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];

    // Unmodified title template
    if (!self.titleTemplate) {
        self.titleTemplate = self.textLabel.text;
    }

    self.control.minimumValue = ((NSNumber *)specifier.properties[PSControlMinimumKey]).doubleValue;
    self.control.maximumValue = ((NSNumber *)specifier.properties[PSControlMaximumKey]).doubleValue;
    self.control.stepValue = ((NSNumber *)specifier.properties[@"step"]).doubleValue;

	[self _updateLabel];
}

/* * PSControlTableCell * */

- (UIStepper *)newControl {
	UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];    
	stepper.continuous = NO;

	return stepper;
}

- (NSNumber *)controlValue {
	return @(self.control.value);
}

- (void)setValue:(NSNumber *)value {
	[super setValue:value];
	self.control.value = value.doubleValue;
}

- (void)controlChanged:(UIStepper *)stepper {
	[super controlChanged:stepper];
	[self _updateLabel];
}

- (void)_updateLabel {
	if (!self.control) {
		return;
	}

    double value = self.control.value;
        
    // Singular or plural labels
    NSString *label;

    if (value == 1) {
        label = (NSString *)self.specifier.properties[@"singularLabel"];
    }
    else {
        label = (NSString *)self.specifier.properties[@"label"];
    }

    // Get correct decimal value based on step value
    NSUInteger valueDecimalPoints = [SCIUtils decimalPlacesInDouble:value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:valueDecimalPoints ? NSNumberFormatterDecimalStyle : NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:valueDecimalPoints];
    [formatter setMinimumFractionDigits:0];

    NSString *stringValue = [formatter stringFromNumber:@(value)];

	self.textLabel.text = [NSString stringWithFormat:self.titleTemplate, stringValue, label];

	[self setNeedsLayout];
}
@end