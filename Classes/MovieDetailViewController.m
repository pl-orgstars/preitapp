//
//  MovieDetailViewController.m
//  Preit
//
//  Created by Aniket on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AsyncImageView.h"

@implementation MovieDetailViewController
@synthesize movieData;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:NSLocalizedString(@"Screen7.1",@"") withBackButton:YES];
    NSLog(@"movieData %@",movieData);
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	NSDictionary *movieDetails=[[movieData objectForKey:@"movie"]objectForKey:@"movie"];
	labelName.text=[movieDetails objectForKey:@"title"];
	textViewDesc.text=[movieDetails objectForKey:@"description"];
    
    CGFloat fixedWidth = textViewDesc.frame.size.width;
    CGSize newSize = [textViewDesc sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    NSLog(@"new Size %f",newSize.height);
    
    if (newSize.height > 225)
    {
        CGRect textViewFrame =textViewDesc.frame;
        CGSize textViewSize = textViewFrame.size;
        textViewSize.height = newSize.height;
        textViewFrame.size = textViewSize;
        textViewDesc.frame = textViewFrame;
        
        [scroolView setContentSize:CGSizeMake(0, textViewDesc.frame.origin.y + textViewDesc.frame.size.height)];
    }
    
    
	labelType.text=[NSString stringWithFormat:@"%@(%@)",movieDetails[@"genre"],movieDetails[@"rating"]];

	NSArray *tmpArray=[movieData objectForKey:@"timing"];
	if([tmpArray count])
	{		
        arrayTable = [NSMutableArray new];
        
		for(int i=1;i<[tmpArray count];i++)
		{
			NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
            [arrayTable addObject:[movie_schedule_Dict objectForKey:@"scheduled_time"]];
		}
	}
	
    AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:imageView.frame] ;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://redf.tmsimg.com/%@",movieDetails[@"poster"]]];
    [asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageView.image=delegate.image3;
    [activityIndicator stopAnimating];

}

#pragma mark - navigation
- (IBAction)menuBtncall:(id)sender
{
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayTable.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        if ([cellIdentifier isEqualToString:@"Cell"])
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        else
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text=arrayTable[indexPath.row];
    cell.textLabel.numberOfLines=1;
    cell.textLabel.font=  [UIFont systemFontOfSize:13];
    cell.textLabel.textColor= [UIColor whiteColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 33, cell.frame.size.width, 2)];
    imgview.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:imgview];
    return cell;	
}


@end
