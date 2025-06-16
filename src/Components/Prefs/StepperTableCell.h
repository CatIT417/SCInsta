#import <CepheiPrefs/CepheiPrefs.h>
#include <Foundation/Foundation.h>

#import "../../Manager.h"
#import "../../Utils.h"

#import "StepperTableCell.h"

@interface SCIStepperTableCell : PSControlTableCell

@property (nonatomic, retain) UIStepper *control;

@property (nonatomic, retain) NSString *titleTemplate;

@end