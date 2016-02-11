//
//  ListViewController.h
//  DoctorSearch
//
//  Created by practo on 27/01/16.
//  Copyright © 2016 practo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
