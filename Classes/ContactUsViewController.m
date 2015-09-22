//
//  ContactUsViewController.m
//  Preit
//
//  Created by Aniket on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactUsViewController.h"
#import "RequestAgent.h"
#import <MessageUI/MessageUI.h>
#import "JSON.h"



@implementation ContactUsViewController

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
-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	tableData=[[NSMutableArray alloc]init];
    
    navigationLabel.text = [delegate.mallData objectForKey:@"name"];
    NSLog(@"ContactUsViewController ==%@",[delegate.mallData objectForKey:@"name"]);
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backNavigation.png"] forBarMetrics:UIBarMetricsDefault];
	[self getData];
    
   

}
-(IBAction)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



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


-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"setHeader ==%@",[delegate.mallData objectForKey:@"name"]);

	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];

    titleLabel = nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=NSLocalizedString(@"Screen10",@"");
	//	if(self.heading)
	//		title=[NSString stringWithFormat:@"%@-%@",title,self.heading];
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
	
	self.navigationItem.titleView=headerView;
    
    [self setNavigationLeftBackButton];
}

#pragma mark Response methods

-(void)getData{
	NSString *apiString=@"API10";
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
	RequestAgent *req=[[RequestAgent alloc] init];//autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[indicator_ startAnimating];
}

-(void)responseData:(NSData *)receivedData{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding] ;//autorelease];
		NSDictionary *dictTmp=[[jsonString JSONValue] objectForKey:@"property"];
		

		//NSLog(@"dictTmp===%@",dictTmp);
		NSString *address_city=@"";
		NSString *address_state=@"";
		NSString *address_zipcode=@"";
		NSString *addString=@"";
		NSString *address_street=@"";
		NSString *main_telephone=@"";
		NSString *contact_us_email=@"";
		
		if([dictTmp objectForKey:@"address_city"]!=[NSNull null])
			address_city=[dictTmp objectForKey:@"address_city"];
		if([dictTmp objectForKey:@"address_state"]!=[NSNull null])
			address_state=[dictTmp objectForKey:@"address_state"];
		if([dictTmp objectForKey:@"address_zipcode"]!=[NSNull null])
			address_zipcode=[dictTmp objectForKey:@"address_zipcode"];
		if([dictTmp objectForKey:@"address_street"]!=[NSNull null])
			address_street=[dictTmp objectForKey:@"address_street"];
		if([dictTmp objectForKey:@"main_telephone"]!=[NSNull null])
			main_telephone=[dictTmp objectForKey:@"main_telephone"];
		if([dictTmp objectForKey:@"contact_us_email"]!=[NSNull null])
			contact_us_email=[dictTmp objectForKey:@"contact_us_email"];


	    if([address_city length]!=0)
			addString=address_city;
		if([address_state length]!=0)
			addString= [NSString stringWithFormat:@"%@, %@",addString,address_state];
		if([address_zipcode length]!=0)
			addString=[NSString stringWithFormat:@"%@ %@",addString,address_zipcode];
		if([main_telephone length]==0)
			main_telephone=@"No contact";
		if([contact_us_email length]==0)
			contact_us_email=@"No email";
			
		NSArray *address=[[NSArray alloc]initWithObjects:[self convertHTML:address_street],[self convertHTML:addString],nil];
		[tableData addObject:address];
//		[address release];
		[tableContact insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];

		NSArray *phone=[[NSArray alloc]initWithObjects:[self convertHTML:main_telephone],nil];
		[tableData addObject:phone];
//		[phone release];
		[tableContact insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
		
		NSArray *email=[contact_us_email componentsSeparatedByString:@","];
		[tableData addObject:[email objectAtIndex:0]];
		[tableContact insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationRight];
		
	}
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section==2) return 1;
	
	return [[tableData objectAtIndex:section]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *txtString;
	if(indexPath.section==2)
	    txtString=[tableData objectAtIndex:indexPath.section];
	else {
		txtString=[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}

	CGSize constraint = CGSizeMake(200.0000, 20000.0f);
	CGSize titlesize = [txtString sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	return (titlesize.height<50?50:titlesize.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier=@"Cell";
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;//autorelease];

	if(indexPath.section==1)
	{
		NSString *contact=[[tableData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
		if([contact isEqualToString:@"No contact"])
			cell.selectionStyle=UITableViewCellSelectionStyleNone;	
		cell.textLabel.text=contact;
	}else if(indexPath.section==2)
	{
		NSString *email=[tableData objectAtIndex:indexPath.section];
		if([email isEqualToString:@"No email"])
		{
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
		}
		cell.textLabel.text=email;
	}
	
	else
	{
		cell.textLabel.text=[[tableData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
	cell.textLabel.numberOfLines=0;
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        NSArray *phone=[tableData objectAtIndex:indexPath.section];
        NSString *location = [phone componentsJoinedByString:@"+"];
        location = [location stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"http://maps.apple.com/?q=" stringByAppendingString:location]]];
        
        
    }
    else
	if(indexPath.section==1)
	{
		NSString *phone=[[tableData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
		if(![phone isEqualToString:@"No contact"])
			[self actionPhone:phone];	
	}
	else if(indexPath.section==2)
	{
		NSString *email=[tableData objectAtIndex:indexPath.section];
		if(![email isEqualToString:@"No email"])
			[self actionEmail:email];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5f)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *headerView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] ;//autorelease];
//	headerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
	
	[headerView setBackgroundColor:[UIColor clearColor]];
	headerView.textColor=[UIColor blackColor];
	headerView.font=[UIFont boldSystemFontOfSize:20];

//    [headerView setContentMode:UIViewContentModeBottom];
//    UIImageView *imageView = [[UIImageView alloc]init];
    UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView setTag:section];
    [imageView addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [imageView setFrame:CGRectMake(0, 0, 38, 38)];
//    [imageView addSubview:buttonImageView];
    
    if(section == 0){
		headerView.text=@"   Address";
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5f)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        
        [imageView setImage:[UIImage imageNamed:@"address_icon.png"] forState:UIControlStateNormal];
        [imageView setFrame:CGRectMake(tableView.bounds.size.width-32-15, 7, 32, 32)];
        [headerView addSubview:imageView];
        
        [headerView addSubview:view];
    }
    else if(section==1){
		headerView.text=@"   Telephone";
        [imageView setImage:[UIImage imageNamed:@"call_new.png"] forState:UIControlStateNormal];
        [imageView setFrame:CGRectMake(tableView.bounds.size.width-32-15, 7, 32, 32)];
        [headerView addSubview:imageView];
    }
    else {
		headerView.text=@"   Email";
        
        [imageView setImage:[UIImage imageNamed:@"email_new.png"] forState:UIControlStateNormal];
        [imageView setFrame:CGRectMake(tableView.bounds.size.width-32-15, 7, 32, 32)];
        [headerView addSubview:imageView];
        
    }
    [headerView setUserInteractionEnabled:YES];
//    [imageView setUserInteractionEnabled:YES];
	
	return headerView;
}

-(void)sectionButtonTapped:(UIButton*)sender{
    NSLog(@"sdsadsdsads   %d",sender.tag);
    
    if (sender.tag==0) {
        NSArray *phone=[tableData objectAtIndex:sender.tag];
        NSString *location = [phone componentsJoinedByString:@"+"];
        location = [location stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"http://maps.apple.com/?q=" stringByAppendingString:location]]];
        
        
    }
    else
    if(sender.tag==1)
    {
        NSString *phone=[[tableData objectAtIndex:sender.tag]objectAtIndex:0];
        if(![phone isEqualToString:@"No contact"])
            [self actionPhone:phone];
    }
    else if(sender.tag==2)
    {
        NSString *email=[tableData objectAtIndex:sender.tag];
        if(![email isEqualToString:@"No email"])
            [self actionEmail:email];
    }
}

-(void) actionEmail:(NSString *)email{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self sendDetailOnMail:email];
		}
		else
			[delegate showAlert:@"Please create an account in Mail app presented on your device first" title:@"Message" buttontitle:@"Ok"];
	}
	else
		[delegate showAlert:@"Please create an account in Mail app presented on your device first" title:@"Message" buttontitle:@"Ok"];
}

-(void)sendDetailOnMail:(NSString *)email{
	//[btnSendMail setUserInteractionEnabled:NO];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[picker setSubject:@"Enquiry"];
	// Set up recipients
	//NSArray *toRecipients = [NSArray arrayWithObjects:[detailarr objectAtIndex:3] ,nil]; 
	NSArray *toRecipients = [NSArray arrayWithObjects: email,nil]; 
	//NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
	//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
	[picker setToRecipients:toRecipients];
	///[picker setCcRecipients:ccRecipients];	
	//[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	// Fill out the email body text
	//NSString *emailBody = @"1) On your iPhone homescreen, click 'Settings'\n2) Choose 'Mail, Contacts, Calendars''\n3) Under Accounts, choose 'Add Account''\n4) Choose 'Other''\n5) Under Calendars, choose ‘Add CalDav Account’'\n6) Under ‘Server,’ enter caldav.famjama.com'\n7) Under 'user name,' enter your email address (the one used to register with Famjama) and then your password. You can also enter a description for your calendar such as 'My Famjama Calendar'";
	NSString *emailBody=@"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	//	LoginScreen *login=[[LoginScreen alloc]initWithNibName:@"LoginScreen" bundle:nil];
	//	//[self.navigationController dismissModalViewControllerAnimated:YES];	
	//	[self presentModalViewController:login animated:YES];
	
	[self presentModalViewController:picker animated:YES];
//	[picker release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	
	//NSLog(@"error %@",error);
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[delegate showAlert:@"Canceled by user" title:@"Message" buttontitle:@"Ok"];
			break;
		case MFMailComposeResultSaved:
			[delegate showAlert:@"Draft Saved" title:@"Message" buttontitle:@"Ok"];
			break;
		case MFMailComposeResultSent:
			[delegate showAlert:@"Mail sent" title:@"Message" buttontitle:@"Ok"];
			break;
		case MFMailComposeResultFailed:
			[delegate showAlert:@"Sending failed" title:@"Message" buttontitle:@"Ok"];
			break;
		default:
			[delegate showAlert:@"Mail not sent" title:@"Message" buttontitle:@"Ok"];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
	//[btnSendMail setUserInteractionEnabled:YES];
}

-(void) actionPhone:(NSString *)phone{
	NSLog(@"phone==%@",phone);
	phone=[phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	phone=[phone stringByReplacingOccurrencesOfString:@") " withString:@"-"];
	NSString *call_contact=@"tel:";
	call_contact=[call_contact stringByAppendingString:phone];
	NSLog(@"========%@",call_contact);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:call_contact]];
	//NSLog(@"call btn clicked == %@",call_contact);
	
	// NSURL *url = [ [ NSURL alloc ] initWithString: @"tel:212-555-1234" ];
	// [[UIApplication sharedApplication] openURL:url];
}

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

@end
