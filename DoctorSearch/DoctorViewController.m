//
//  DoctorViewController.m
//  DoctorSearch
//
//  Created by practo on 19/01/16.
//  Copyright © 2016 practo. All rights reserved.
//

#import "DoctorViewController.h"
#import "ListViewController.h"

@implementation DoctorViewController
NSDictionary *doctorDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    _scr.delegate = self;
    _scr.autoresizingMask=UIViewAutoresizingNone;
    [self setupScrollView:_scr];
    
    _pgCtr.numberOfPages=[[doctorDict objectForKey:@"practice_photos"] count];
    _pgCtr.currentPage=0;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowDetail"]) {
        ListViewController *lc =[segue destinationViewController];
        lc.popoverPresentationController.delegate = self;
        lc.popoverPresentationController.barButtonItem = self.btnDetail;
        lc.modalPresentationStyle = UIModalPresentationPopover;
    }
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverController
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setupScrollView:_scr];
    //[self dismissViewControllerAnimated:YES completion:nil];

    //[self performSegueWithIdentifier:@"ShowDetail" sender:nil];
    NSLog(@"enter");
}

- (void)setMyJSON:(NSDictionary*)doctorDictJSON
{
    doctorDict = [[NSDictionary alloc] initWithDictionary:doctorDictJSON];
}

- (IBAction)changePage:(id)sender {
    UIPageControl *pager=sender;
    int page = pager.currentPage;
    CGRect frame = _scr.frame;
    
    frame.origin.x = self.view.frame.size.width * page;
    frame.origin.y = 0;
    [_scr scrollRectToVisible:frame animated:YES];
     
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        NSString *simpleTableIdentifier = @"rightDetail";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.textLabel.text = @"Consultation Fees";
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[doctorDict objectForKey:@"consultation_fees"]];
        return cell;

    } else if (indexPath.section == 1) {
        NSString *simpleTableIdentifier = @"subtitle";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.textLabel.text = @"Qualifications";
        cell.detailTextLabel.text = [[[doctorDict objectForKey:@"qualifications"] objectAtIndex:0] objectForKey:@"qualification"];
        for(int i = 1; i < [[doctorDict objectForKey:@"qualifications"] count]; i++) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", cell.detailTextLabel.text, [[[doctorDict objectForKey:@"qualifications"] objectAtIndex:i] objectForKey:@"qualification"]];
        }
        return cell;
        
    } else if(indexPath.section == 2) {
        NSString *simpleTableIdentifier = @"subtitle";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.textLabel.text = @"Specialties";
        cell.detailTextLabel.text = [[[doctorDict objectForKey:@"specialties"] objectAtIndex:0] objectForKey:@"sub_specialty"];
        for(int i = 1; i < [[doctorDict objectForKey:@"specialties"] count]; i++) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", cell.detailTextLabel.text, [[[doctorDict objectForKey:@"specialties"] objectAtIndex:i] objectForKey:@"sub_specialty"]];
        }
        return cell;
    
    } else if(indexPath.section == 3) {
        NSString *simpleTableIdentifier = @"rightDetail";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.textLabel.text = @"Experience";
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@ Years",[doctorDict objectForKey:@"experience_years"]];
        return cell;
    
    } else if(indexPath.section == 4) {
        NSString *simpleTableIdentifier = @"rightDetail";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.textLabel.text = @"Clinic name";
        cell.detailTextLabel.text =[doctorDict objectForKey:@"clinic_name"];
        return cell;
        
    } else if(indexPath.section == 5) {
        NSString *simpleTableIdentifier = @"rightDetail";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.textLabel.text = @"Locality";
        cell.detailTextLabel.text =[doctorDict objectForKey:@"locality"];
        return cell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float xPos = _scr.contentOffset.x;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    _pgCtr.currentPage = (int)(xPos/self.view.frame.size.width);
}

- (void)setupScrollView:(UIScrollView*)scrMain {
    int arrSize = [[doctorDict objectForKey:@"practice_photos"] count];
    __block int x=0;
        for (int i = 1; i<= arrSize; i++) {
            // create image
            __block NSData *data;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSString *path = [[[doctorDict objectForKey:@"practice_photos"] objectAtIndex:i-1] objectForKey:@"url"];
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    
                    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.view.frame.size.width, 264)];
                    // set scale to fill
                    x += self.view.frame.size.width;
                    imgV.contentMode=UIViewContentModeScaleToFill;
                    
                    
                    [imgV setImage:image];
                    
                    // add to scrollView
                    [scrMain addSubview:imgV];
                    scrMain.contentSize = CGSizeMake(x, 1.0f);
                });
           });
            
        }
        // set the content size to 10 image width
      //  [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width*10, scrMain.frame.size.height)];
        // enable timer after each 2 seconds for scrolling.
   //     [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}
    
   /* - (void)scrollingTimer {
        // access the scroll view with the tag
        UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
        // same way, access pagecontroll access
        UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
        // get the current offset ( which page is being displayed )
        CGFloat contentOffset = scrMain.contentOffset.x;
        // calculate next page to display
        int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
        // if page is not 10, display it
        if( nextPage!=10 )  {
            [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
            pgCtr.currentPage=nextPage;
            // else start sliding form 1 :)
        } else {
            [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
            pgCtr.currentPage=0;
        }
    }*/

@end
