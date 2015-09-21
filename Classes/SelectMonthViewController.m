//
//  SelectMonthViewController.m
//  Preit
//
//  Created by Aniket on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectMonthViewController.h"


@implementation SelectMonthViewController
@synthesize selectedMonth;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title=NSLocalizedString(@"ScreenMonth",@"");

	UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonAction:)];
	cancelButton.tag=100;
	self.navigationItem.leftBarButtonItem=cancelButton;
	UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonAction:)];
	doneButton.tag=101;
	self.navigationItem.rightBarButtonItem=doneButton;
	
	tableData=[[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//	[tableData release];
//    [super dealloc];
//}

-(IBAction)buttonAction:(id)sender{
	UIButton *button=(UIButton *)sender;
	switch (button.tag) {
		case 100:
		{
			
		}
			break;
		case 101:
		{
			NSDictionary *dict=[[NSDictionary alloc]init];
			[dict setValue:[NSString stringWithFormat:@"%d",selectedMonth] forKey:@"month"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent" object:nil userInfo:dict];
//			[dict release];			
		}
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];

}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier=@"Cell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	
	cell.textLabel.text=[tableData objectAtIndex:indexPath.row];
	
	if(indexPath.row==selectedMonth)
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType=UITableViewCellAccessoryNone;
	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSArray *visibleCells=[tableMonth visibleCells];
	selectedMonth=indexPath.row+1;
	for(int i=0;i<[visibleCells count];i++)
	{
		UITableViewCell *cell=[visibleCells objectAtIndex:i];
		cell.accessoryType=(i!=indexPath.row)?UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;		
	}	
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
