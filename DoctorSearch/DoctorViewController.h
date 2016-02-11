//
//  DoctorViewController.h
//  DoctorSearch
//
//  Created by practo on 19/01/16.
//  Copyright © 2016 practo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorViewController : UIViewController<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pgCtr;

@property (weak, nonatomic) IBOutlet UIScrollView *scr;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDetail;
- (void)setMyJSON:(NSDictionary*)doctorDictJSON ;
- (IBAction)changePage:(id)sender;

@end
