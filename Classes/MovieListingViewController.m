//
//  MovieListingViewController.m
//  Preit
//
//  Created by Aniket on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovieListingViewController.h"
#import "RequestAgent.h"
#import "MovieDetailViewController.h"
#import "AsyncImageView.h"
#import "JSON.h"


@implementation MovieListingViewController

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
    
    //kk
//    self.trackedViewName = @"Movie Listing";
    
	delegate=(PreitAppDelegate*)[[UIApplication sharedApplication]delegate];
	[self setHeader];
	
//	tableMovie.separatorColor=[UIColor whiteColor];	
//	tableMovie.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
	
	if(!tableData)
		tableData=[[NSMutableArray alloc]init];

	[self getData];
	
	if(delegate.image3==nil)
	{
		imageViewMovie.image=[UIImage imageNamed:@"shopping.jpg"];
		if(delegate.imageLink3 && [delegate.imageLink3 length]!=0)
		{
			CGRect frame;
			frame.size.width=320;
			frame.size.height=480;
			frame.origin.x=0; frame.origin.y=0;
			AsyncImageView* asyncImage = [[AsyncImageView alloc] initWithFrame:frame];// autorelease];
			NSURL *url=[NSURL URLWithString:delegate.imageLink3];
			[asyncImage loadImageFromURL:url delegate:self requestSelector:@selector(responseData_Image:)];				
		
		}
	}
	else
	{
		imageViewMovie.image=delegate.image3;
	}	
	
	//Test Case
//    NSString *jsonString=@"[{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore 3D\",\"tribune_tmsid\":\"MV002743410000\",\"id\":1515,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me 3D\",\"tribune_tmsid\":\"MV002732980000\",\"id\":1505,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3 3D\",\"tribune_tmsid\":\"MV002527920000\",\"id\":1483,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore\",\"tribune_tmsid\":\"MV002729890000\",\"id\":1503,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Charlie St. Cloud\",\"tribune_tmsid\":\"MV002747990000\",\"id\":1510,\"runtime\":\"PT01H39M\",\"description\":\"Adored by his single mother and his little brother Sam, Charlie St. Cloud (Zac Efron) is an accomplished sailor and college-bound senior with a bright future ahead of him. When Sam dies in a terrible accident, Charlie's dreams die with him. But, so strong is the brothers' bond that, in the hour before each sunset, Charlie and Sam meet to play catch. The return of a former classmate (Amanda Crew) leads Charlie to a difficult choice: remain stuck in the past, or let love lead him to the future.\",\"quality_rating\":1,\"genre\":\"Drama\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me\",\"tribune_tmsid\":\"MV002732970000\",\"id\":1504,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Dinner for Schmucks\",\"tribune_tmsid\":\"MV002733080000\",\"id\":1507,\"runtime\":\"PT01H54M\",\"description\":\"Tim (Paul Rudd) a rising executive, works for a boss who hosts a monthly event in which the guest who brings the biggest buffoon gets a career boost. Though he declines the invitation at first, he changes his mind when he meets Barry (Steve Carell), a man who builds dioramas using stuffed mice. The scheme backfires when Barry's blundering good intentions send Tim's life into a downward spiral, threatening a major business deal and possibly scuttling Tim's romantic relationship.\",\"quality_rating\":2,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Twilight Saga: Eclipse\",\"tribune_tmsid\":\"MV002596510000\",\"id\":1487,\"runtime\":\"PT02H04M\",\"description\":\"Danger once again surrounds Bella (Kristen Stewart), as a string of mysterious killings terrorizes Seattle and a malicious vampire continues her infernal quest for revenge. Amid the tumult, Bella must choose between her love for Edward (Robert Pattinson) and her friendship with Jacob (Taylor Lautner), knowing that her decision may ignite the long-simmering feud between vampire and werewolf.\",\"quality_rating\":2,\"genre\":\"Romance, Thriller\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Grown Ups\",\"tribune_tmsid\":\"MV002693380000\",\"id\":1494,\"runtime\":\"PT01H42M\",\"description\":\"The death of their childhood basketball coach leads to a reunion for some old friends (Adam Sandler, Kevin James, Chris Rock), who gather at the site of a championship celebration years earlier. Picking up where they left off, the buddies -- with wives and children in tow -- discover why age does not, necessarily, equal maturity.\",\"quality_rating\":1,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Inception\",\"tribune_tmsid\":\"MV002624410000\",\"id\":1489,\"runtime\":\"PT02H28M\",\"description\":\"Dom Cobb (Leonardo DiCaprio) is a thief with the rare ability to enter people's dreams and steal their secrets from their subconscious. His skill has made him a hot commodity in the world of corporate espionage but has also cost him everything he loves. Cobb gets a chance at redemption when he is offered a seemingly impossible task: Plant an idea in someone's mind. If he succeeds, it will be the perfect crime, but a dangerous enemy anticipates Cobb's every move.\",\"quality_rating\":3,\"genre\":\"Science fiction, Thriller\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Ramona and Beezus\",\"tribune_tmsid\":\"MV002750960000\",\"id\":1511,\"runtime\":\"PT01H44M\",\"description\":\"Ramona Quimby (Joey King) is a plucky youngster with an irrepressible sense of fun and mischief -- a fact that keeps her big sister, Beezus, on her toes. Ramona's vivid imagination and boundless energy serve her well when the two girls must help save their family's home on Klickitat Street.\",\"quality_rating\":2,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Salt\",\"tribune_tmsid\":\"MV002693410000\",\"id\":1495,\"runtime\":\"PT01H40M\",\"description\":\"When Evelyn Salt (Angelina Jolie) became a CIA officer, she swore an oath to duty, honor and country. But, when a defector accuses her of being a Russian spy, Salt's oath is put to the test. Now a fugitive, Salt must use every skill gained from years of training and experience to evade capture, but the more she tries to prove her innocence, the more guilty she seems.\",\"quality_rating\":3,\"genre\":\"Action, Thriller\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Sorcerer's Apprentice\",\"tribune_tmsid\":\"MV002699170000\",\"id\":1499,\"runtime\":\"PT01H49M\",\"description\":\"Dave Stutler (Jay Baruchel) is just an average guy, but the wizard Balthazar Blake (Nicolas Cage) sees in him a hidden talent for sorcery. He becomes Balthazar's reluctant protege, getting a crash course in the art of magic. As Dave prepares to help his mentor defend Manhattan from a powerful adversary (Alfred Molina), he wonders if he can survive the training, save the city and find his true love.\",\"quality_rating\":2,\"genre\":\"Comedy, Fantasy, Adventure\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3\",\"tribune_tmsid\":\"MV002527890000\",\"id\":1482,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore 3D\",\"tribune_tmsid\":\"MV002743410000\",\"id\":1515,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me 3D\",\"tribune_tmsid\":\"MV002732980000\",\"id\":1505,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3 3D\",\"tribune_tmsid\":\"MV002527920000\",\"id\":1483,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore\",\"tribune_tmsid\":\"MV002729890000\",\"id\":1503,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Charlie St. Cloud\",\"tribune_tmsid\":\"MV002747990000\",\"id\":1510,\"runtime\":\"PT01H39M\",\"description\":\"Adored by his single mother and his little brother Sam, Charlie St. Cloud (Zac Efron) is an accomplished sailor and college-bound senior with a bright future ahead of him. When Sam dies in a terrible accident, Charlie's dreams die with him. But, so strong is the brothers' bond that, in the hour before each sunset, Charlie and Sam meet to play catch. The return of a former classmate (Amanda Crew) leads Charlie to a difficult choice: remain stuck in the past, or let love lead him to the future.\",\"quality_rating\":1,\"genre\":\"Drama\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me\",\"tribune_tmsid\":\"MV002732970000\",\"id\":1504,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Dinner for Schmucks\",\"tribune_tmsid\":\"MV002733080000\",\"id\":1507,\"runtime\":\"PT01H54M\",\"description\":\"Tim (Paul Rudd) a rising executive, works for a boss who hosts a monthly event in which the guest who brings the biggest buffoon gets a career boost. Though he declines the invitation at first, he changes his mind when he meets Barry (Steve Carell), a man who builds dioramas using stuffed mice. The scheme backfires when Barry's blundering good intentions send Tim's life into a downward spiral, threatening a major business deal and possibly scuttling Tim's romantic relationship.\",\"quality_rating\":2,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Twilight Saga: Eclipse\",\"tribune_tmsid\":\"MV002596510000\",\"id\":1487,\"runtime\":\"PT02H04M\",\"description\":\"Danger once again surrounds Bella (Kristen Stewart), as a string of mysterious killings terrorizes Seattle and a malicious vampire continues her infernal quest for revenge. Amid the tumult, Bella must choose between her love for Edward (Robert Pattinson) and her friendship with Jacob (Taylor Lautner), knowing that her decision may ignite the long-simmering feud between vampire and werewolf.\",\"quality_rating\":2,\"genre\":\"Romance, Thriller\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Grown Ups\",\"tribune_tmsid\":\"MV002693380000\",\"id\":1494,\"runtime\":\"PT01H42M\",\"description\":\"The death of their childhood basketball coach leads to a reunion for some old friends (Adam Sandler, Kevin James, Chris Rock), who gather at the site of a championship celebration years earlier. Picking up where they left off, the buddies -- with wives and children in tow -- discover why age does not, necessarily, equal maturity.\",\"quality_rating\":1,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Inception\",\"tribune_tmsid\":\"MV002624410000\",\"id\":1489,\"runtime\":\"PT02H28M\",\"description\":\"Dom Cobb (Leonardo DiCaprio) is a thief with the rare ability to enter people's dreams and steal their secrets from their subconscious. His skill has made him a hot commodity in the world of corporate espionage but has also cost him everything he loves. Cobb gets a chance at redemption when he is offered a seemingly impossible task: Plant an idea in someone's mind. If he succeeds, it will be the perfect crime, but a dangerous enemy anticipates Cobb's every move.\",\"quality_rating\":3,\"genre\":\"Science fiction, Thriller\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Ramona and Beezus\",\"tribune_tmsid\":\"MV002750960000\",\"id\":1511,\"runtime\":\"PT01H44M\",\"description\":\"Ramona Quimby (Joey King) is a plucky youngster with an irrepressible sense of fun and mischief -- a fact that keeps her big sister, Beezus, on her toes. Ramona's vivid imagination and boundless energy serve her well when the two girls must help save their family's home on Klickitat Street.\",\"quality_rating\":2,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Salt\",\"tribune_tmsid\":\"MV002693410000\",\"id\":1495,\"runtime\":\"PT01H40M\",\"description\":\"When Evelyn Salt (Angelina Jolie) became a CIA officer, she swore an oath to duty, honor and country. But, when a defector accuses her of being a Russian spy, Salt's oath is put to the test. Now a fugitive, Salt must use every skill gained from years of training and experience to evade capture, but the more she tries to prove her innocence, the more guilty she seems.\",\"quality_rating\":3,\"genre\":\"Action, Thriller\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Sorcerer's Apprentice\",\"tribune_tmsid\":\"MV002699170000\",\"id\":1499,\"runtime\":\"PT01H49M\",\"description\":\"Dave Stutler (Jay Baruchel) is just an average guy, but the wizard Balthazar Blake (Nicolas Cage) sees in him a hidden talent for sorcery. He becomes Balthazar's reluctant protege, getting a crash course in the art of magic. As Dave prepares to help his mentor defend Manhattan from a powerful adversary (Alfred Molina), he wonders if he can survive the training, save the city and find his true love.\",\"quality_rating\":2,\"genre\":\"Comedy, Fantasy, Adventure\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3\",\"tribune_tmsid\":\"MV002527890000\",\"id\":1482,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore 3D\",\"tribune_tmsid\":\"MV002743410000\",\"id\":1515,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me 3D\",\"tribune_tmsid\":\"MV002732980000\",\"id\":1505,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3 3D\",\"tribune_tmsid\":\"MV002527920000\",\"id\":1483,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Cats & Dogs: The Revenge of Kitty Galore\",\"tribune_tmsid\":\"MV002729890000\",\"id\":1503,\"runtime\":\"PT01H22M\",\"description\":\"In the age-old battle between felines and canines, one rogue kitty is stepping up the fight. Kitty Galore, former operative for MEOWS, is executing a diabolical plan against her sworn enemies, the dogs, as well as her cat comrades. In order to save themselves and their humans, both species must unite in an unprecedented alliance to stop Kitty Galore from making the world her scratching post.\",\"quality_rating\":1,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Charlie St. Cloud\",\"tribune_tmsid\":\"MV002747990000\",\"id\":1510,\"runtime\":\"PT01H39M\",\"description\":\"Adored by his single mother and his little brother Sam, Charlie St. Cloud (Zac Efron) is an accomplished sailor and college-bound senior with a bright future ahead of him. When Sam dies in a terrible accident, Charlie's dreams die with him. But, so strong is the brothers' bond that, in the hour before each sunset, Charlie and Sam meet to play catch. The return of a former classmate (Amanda Crew) leads Charlie to a difficult choice: remain stuck in the past, or let love lead him to the future.\",\"quality_rating\":1,\"genre\":\"Drama\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Despicable Me\",\"tribune_tmsid\":\"MV002732970000\",\"id\":1504,\"runtime\":\"PT01H35M\",\"description\":\"A man who delights in all things wicked, supervillain Gru (Steve Carell) hatches a plan to steal the moon. Surrounded by an army of little yellow minions and his impenetrable arsenal of weapons and war machines, Gru makes ready to vanquish all who stand in his way. But nothing in his calculations and groundwork has prepared him for his greatest challenge: three adorable orphan girls who want to make him their dad.\",\"quality_rating\":3,\"genre\":\"Comedy, Animated\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Dinner for Schmucks\",\"tribune_tmsid\":\"MV002733080000\",\"id\":1507,\"runtime\":\"PT01H54M\",\"description\":\"Tim (Paul Rudd) a rising executive, works for a boss who hosts a monthly event in which the guest who brings the biggest buffoon gets a career boost. Though he declines the invitation at first, he changes his mind when he meets Barry (Steve Carell), a man who builds dioramas using stuffed mice. The scheme backfires when Barry's blundering good intentions send Tim's life into a downward spiral, threatening a major business deal and possibly scuttling Tim's romantic relationship.\",\"quality_rating\":2,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Twilight Saga: Eclipse\",\"tribune_tmsid\":\"MV002596510000\",\"id\":1487,\"runtime\":\"PT02H04M\",\"description\":\"Danger once again surrounds Bella (Kristen Stewart), as a string of mysterious killings terrorizes Seattle and a malicious vampire continues her infernal quest for revenge. Amid the tumult, Bella must choose between her love for Edward (Robert Pattinson) and her friendship with Jacob (Taylor Lautner), knowing that her decision may ignite the long-simmering feud between vampire and werewolf.\",\"quality_rating\":2,\"genre\":\"Romance, Thriller\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Grown Ups\",\"tribune_tmsid\":\"MV002693380000\",\"id\":1494,\"runtime\":\"PT01H42M\",\"description\":\"The death of their childhood basketball coach leads to a reunion for some old friends (Adam Sandler, Kevin James, Chris Rock), who gather at the site of a championship celebration years earlier. Picking up where they left off, the buddies -- with wives and children in tow -- discover why age does not, necessarily, equal maturity.\",\"quality_rating\":1,\"genre\":\"Comedy\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Inception\",\"tribune_tmsid\":\"MV002624410000\",\"id\":1489,\"runtime\":\"PT02H28M\",\"description\":\"Dom Cobb (Leonardo DiCaprio) is a thief with the rare ability to enter people's dreams and steal their secrets from their subconscious. His skill has made him a hot commodity in the world of corporate espionage but has also cost him everything he loves. Cobb gets a chance at redemption when he is offered a seemingly impossible task: Plant an idea in someone's mind. If he succeeds, it will be the perfect crime, but a dangerous enemy anticipates Cobb's every move.\",\"quality_rating\":3,\"genre\":\"Science fiction, Thriller\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Ramona and Beezus\",\"tribune_tmsid\":\"MV002750960000\",\"id\":1511,\"runtime\":\"PT01H44M\",\"description\":\"Ramona Quimby (Joey King) is a plucky youngster with an irrepressible sense of fun and mischief -- a fact that keeps her big sister, Beezus, on her toes. Ramona's vivid imagination and boundless energy serve her well when the two girls must help save their family's home on Klickitat Street.\",\"quality_rating\":2,\"genre\":\"Comedy, Adventure\"}},{\"movie\":{\"rating\":\"PG-13\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Salt\",\"tribune_tmsid\":\"MV002693410000\",\"id\":1495,\"runtime\":\"PT01H40M\",\"description\":\"When Evelyn Salt (Angelina Jolie) became a CIA officer, she swore an oath to duty, honor and country. But, when a defector accuses her of being a Russian spy, Salt's oath is put to the test. Now a fugitive, Salt must use every skill gained from years of training and experience to evade capture, but the more she tries to prove her innocence, the more guilty she seems.\",\"quality_rating\":3,\"genre\":\"Action, Thriller\"}},{\"movie\":{\"rating\":\"PG\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"The Sorcerer's Apprentice\",\"tribune_tmsid\":\"MV002699170000\",\"id\":1499,\"runtime\":\"PT01H49M\",\"description\":\"Dave Stutler (Jay Baruchel) is just an average guy, but the wizard Balthazar Blake (Nicolas Cage) sees in him a hidden talent for sorcery. He becomes Balthazar's reluctant protege, getting a crash course in the art of magic. As Dave prepares to help his mentor defend Manhattan from a powerful adversary (Alfred Molina), he wonders if he can survive the training, save the city and find his true love.\",\"quality_rating\":2,\"genre\":\"Comedy, Fantasy, Adventure\"}},{\"movie\":{\"rating\":\"G\",\"updated_at\":\"2010-08-03T13:30:29Z\",\"title\":\"Toy Story 3\",\"tribune_tmsid\":\"MV002527890000\",\"id\":1482,\"runtime\":\"PT01H48M\",\"description\":\"With their beloved Andy preparing to leave for college, Woody (Tom Hanks), Buzz Lightyear (Tim Allen), Jessie (Joan Cusack), and the rest of the toys find themselves headed for the attic but mistakenly wind up on the curb with the trash. Woody's quick thinking saves the gang, but all but Woody end up being donated to a day-care center. Unfortunately, the uncontrollable kids do not play nice, so Woody and the gang make plans for a great escape.\",\"quality_rating\":3,\"genre\":\"Comedy, Fantasy, Adventure, Animated\"}}]";
//    //NSLog(@"data=%@",jsonString);
//	tableData=[jsonString JSONValue];
//	[tableMovie reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
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
//    [super dealloc];
//}

-(void)setHeader{
	UILabel *titleLabel;
	UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,200, 44)];
	[headerView sizeToFit];
	
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 20)];
	titleLabel.text=[delegate.mallData objectForKey:@"name"];
    NSLog(@"headerViewheaderView ==%@",[delegate.mallData objectForKey:@"name"]);
	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont boldSystemFontOfSize:18];
	titleLabel.shadowColor=[UIColor blackColor];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];
	titleLabel =nil;
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
	NSString *title=NSLocalizedString(@"Screen7",@"");
//	if(self.heading)
//		title=[NSString stringWithFormat:@"%@-%@",title,self.heading];
	
	titleLabel.text=title;
	titleLabel.textColor=[UIColor blackColor];
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.textAlignment=NSTextAlignmentCenter;
	titleLabel.backgroundColor=[UIColor clearColor];
	[headerView addSubview:titleLabel];
//	[titleLabel release];

	self.navigationItem.titleView=headerView;
    
    [self setNavigationLeftBackButton];
//	[headerView release];
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=60.0;
	if(!isNoData){
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		CGSize constraint = CGSizeMake(200.0000, 20000.0f);

		NSString *timingString=@"";
		NSArray *tmpArray=[tmpDict objectForKey:@"timing"];
		if([tmpArray count])
		{
			NSDictionary *movie_schedule_Dict_0=[[tmpArray objectAtIndex:0]objectForKey:@"movie_schedule_time"];
			timingString=[movie_schedule_Dict_0 objectForKey:@"scheduled_time"];
			
			for(int i=1;i<[tmpArray count];i++)
			{
				NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
				timingString=[NSString stringWithFormat:@"%@ - %@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
			}
			
		}
		NSDictionary *movieDict=[[tmpDict objectForKey:@"movie"] objectForKey:@"movie"];
		NSLog(@"tmpDict===%@===============%@",tmpDict,movieDict);
		timingString=[[movieDict objectForKey:@"title"] stringByAppendingString:timingString];
		NSLog(@"==========================%@",timingString);
		CGSize titlesize1 = [[movieDict objectForKey:@"title"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		CGSize titlesize2 = [timingString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		height=((titlesize1.height+titlesize2.height)<60?65:(titlesize1.height+titlesize2.height));
	}
	return height;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return isNoData?1:[tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier=isNoData?@"NoData":@"Cell";
	UITableViewCell *cell;
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
//		if(cellIdentifier==@"Cell")
        if ([cellIdentifier isEqualToString:@"Cell"])
 			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];// autorelease];
        else
			cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];// autorelease];
	}
//	if(cellIdentifier==@"Cell")
    if ([cellIdentifier isEqualToString:@"Cell"])
	{
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
		NSDictionary *tmpDict1=[[tmpDict objectForKey:@"movie"]objectForKey:@"movie" ];
		NSString *titleString=[NSString stringWithFormat:@"%@ (%@)",[tmpDict1 objectForKey:@"title"],[tmpDict1 objectForKey:@"rating"]];
		cell.textLabel.text=titleString;
		cell.textLabel.numberOfLines=0;
		cell.textLabel.font=  LABEL_TEXT_FONT;//[UIFont boldSystemFontOfSize:18];
		cell.textLabel.textColor= LABEL_TEXT_COLOR;//[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon1.png"]];
        [view setFrame:CGRectMake(0, 0, 8, 14)];
        cell.accessoryView = view;
//		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; 
		
		NSArray *tmpArray=[tmpDict objectForKey:@"timing"];
		if([tmpArray count])
		{
			NSDictionary *movie_schedule_Dict_0=[[tmpArray objectAtIndex:0]objectForKey:@"movie_schedule_time"];
			NSString *timingString=[movie_schedule_Dict_0 objectForKey:@"scheduled_time"];
			
			for(int i=1;i<[tmpArray count];i++)
			{
				NSDictionary *movie_schedule_Dict=[[tmpArray objectAtIndex:i]objectForKey:@"movie_schedule_time"];
				timingString=[NSString stringWithFormat:@"%@ - %@",timingString,[movie_schedule_Dict objectForKey:@"scheduled_time"]];
			}
			
			cell.detailTextLabel.text=timingString;
		}
		else {
			cell.detailTextLabel.text=@"";
		}
		cell.detailTextLabel.numberOfLines=0;
		cell.detailTextLabel.textColor= DETAIL_TEXT_COLOR;//[UIColor whiteColor];
		cell.detailTextLabel.backgroundColor=[UIColor clearColor];

	}
	else
	{
		cell.textLabel.text=@"No Result";
		cell.textLabel.textColor= LABEL_TEXT_COLOR;//[UIColor whiteColor];
		cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}	
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(!isNoData)
	{
		MovieDetailViewController *screenMovie=[[MovieDetailViewController alloc]initWithNibName:@"MovieDetailViewController" bundle:nil];
		NSDictionary *tmpDict=[tableData objectAtIndex:indexPath.row];
        
        ///kk
        NSDictionary *tmpDict1=[[tmpDict objectForKey:@"movie"]objectForKey:@"movie" ];
		NSString *titleString=[NSString stringWithFormat:@"%@ (%@)",[tmpDict1 objectForKey:@"title"],[tmpDict1 objectForKey:@"rating"]];
        
//        NSString *titleString=[NSString stringWithFormat:@"%@ (%@)",[tmpDict objectForKey:@"title"],[tmpDict objectForKey:@"rating"]];
        // Change google
        //[[GAI sharedInstance].defaultTracker sendView:titleString];
        [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:titleString];
        
        // Send a screenview.
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView]  build]];
        ////
        
		screenMovie.movieData=tmpDict;
		[self.navigationController pushViewController:screenMovie animated:YES];
//		[screenMovie release];
	}
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark Response methods

-(void)getData{
	NSString *apiString=@"API7";
	NSString *url=[NSString stringWithFormat:@"%@%@",[delegate.mallData objectForKey:@"resource_url"],NSLocalizedString(apiString,"")];
	RequestAgent *req=[[RequestAgent alloc] init];// autorelease];
	[req requestToServer:self callBackSelector:@selector(responseData:) errorSelector:@selector(errorCallback:) Url:url];
	[indicator_ startAnimating];
}

-(void)responseData:(NSData *)receivedData
{
	[indicator_ stopAnimating];
	if(receivedData!=nil){
		NSString *jsonString = [[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];// autorelease];
		NSArray *tmpArray=[jsonString JSONValue];
		NSLog(@"tmpArray==%@\n\ncount====%d",tmpArray,[tmpArray count]);
		
		if([tmpArray count]!=0)
		{
			[tableData removeAllObjects];
			[tableData addObjectsFromArray:tmpArray];
			
		}
		else
		{
			isNoData=YES;
			[delegate showAlert:@"Sorry,no movie schedule is available at this time" title:@"Message" buttontitle:@"Ok"];
		}
	}
	else
		isNoData=YES;
	[tableMovie reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)errorCallback:(NSError *)error{
	[indicator_ stopAnimating];
	[delegate showAlert:@"Sorry there was some error.Please check your internet connection and try again later." title:@"Message" buttontitle:@"Ok"];
}

-(void)responseData_Image:(NSData *)receivedData{
	delegate.image3=[UIImage imageWithData:receivedData];
	imageViewMovie.image=delegate.image3;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateGeneral_IMG" object:nil];

}

#pragma mark - navigation

- (IBAction)menuBtnCall:(id)sender {
    self.menuContainerViewController.menuState = MFSideMenuStateRightMenuOpen;

}


- (IBAction)backBtnCall:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


@end
