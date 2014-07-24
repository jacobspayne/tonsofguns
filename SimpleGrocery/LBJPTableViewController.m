//
//  LBJPTableViewController.m
//  SimpleGrocery
//
//  Created by X Code User on 7/21/14.
//  Copyright (c) 2014 Leonard Butz & Jacob Payne. All rights reserved.
//

#import "LBJPTableViewController.h"
#import "LBJPTableViewCell.h"
#import "LBJPGunDetailsViewController.h"
#import <Parse/Parse.h>

@interface LBJPTableViewController ()

@end

@implementation LBJPTableViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Gun";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"nickname";
        
        // The title for this table in the Navigation Controller.
        self.title = @"GunBuddy";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Gun";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"nickname";
        
        // The title for this table in the Navigation Controller.
        self.title = @"GunBuddy";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addNewItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self loadObjects];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadObjects];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.objects count];
//}



#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"nickname"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    LBJPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LBJPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.displayLabel.text = [object objectForKey:@"nickname"];
    cell.subtitleLabel.text = [object objectForKey:@"manufacturer"];
    
    
    [self loadParseImage:object forImageColumn:@"picture" withProgressBar:nil  andCompletionBlock:^(UIImage *imageFile, NSError *error){
         if (!error){
             cell.thumbnailImage.image = imageFile;
         }}];
    
    cell.parseObject = object;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    // prevent the method from trying to toggle the "checked"
    // status of the virtual "Load More..." table cell
    if ((indexPath.row + 1) > [self.objects count]) {
        NSLog(@"Load More... was tapped");
        return;
        //rest of didSelectRowAtIndexPath doesn't run because of return;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView reloadRowsAtIndexPaths: [tableView indexPathsForVisibleRows] withRowAnimation: UITableViewRowAnimationFade];
        [tableView endUpdates];
        PFObject * object = [self.objects objectAtIndex: indexPath.row];
        //NSLog(@"Objects before delete: %@", self.objects);
        [object delete];
        [self loadObjects];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)addNewItem
{
    NSLog(@"Just called the addNewItem method");
    [self performSegueWithIdentifier: @"newItem" sender: self];
}

// example from: https://coderwall.com/p/idwrhw
-(void)loadParseImage:(PFObject *)parseObject forImageColumn:(NSString *)columnName withProgressBar:(UIProgressView *)progressBar andCompletionBlock:(void (^)(UIImage *imageFile, NSError *error))completionBlock{
    NSString *parseFileName = [NSString stringWithFormat:@"%@", [[parseObject objectForKey:columnName] name]];
    
    // Get a path to the place in the local documents directory on the iOS device where the image file should be stored.
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // You can change the path as you see fit by altering the stringByAppendingPathComponent call here.
    NSString *imagesDirectory = [documentsDirectory stringByAppendingPathComponent:@"Images"];
    NSString *storePath = [imagesDirectory stringByAppendingPathComponent:parseFileName];
    
    if (progressBar){
        // Reset and show the progress bar
        [progressBar setProgress:0.0 animated:NO];
        progressBar.hidden = NO;
    }
    
    // Image data from Parse.com is retrieved in the background.
    [[parseObject objectForKey:columnName] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        if (!error){
            NSData *fileData = [[NSData alloc] initWithData:data];
            if (![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory]){
                // Create the folder if it doesn't already exist.
                [[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
            }
            
            // Write the PFFile data to the local file.
            [fileData writeToFile:storePath atomically:YES];
            
            UIImage *showcaseImage;
            if ([[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory]){
                showcaseImage = [UIImage imageWithContentsOfFile:storePath];
            } else // No file exists at the expected path. Perhaps the disk is full, etc.?
            {
                NSLog(@"Unable to find image file where we expected it: %@", storePath);
            }
            completionBlock(showcaseImage, error);
            
            // This may be a good place to clean up the target directory.
        }
        else // Unable to pull the image data from Parse.com. Consider more robust error handling.
        {
            NSLog(@"Error getting image data.");
            completionBlock(nil, error);
        }
    }
                                                          progressBlock:^(int percentDone){
                                                              if (progressBar){
                                                                  [progressBar setProgress:percentDone animated:YES];
                                                              }
                                                          }];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gunDetailsView"]) {
        
        // Get destination view
        LBJPGunDetailsViewController *destinationViewController = [segue destinationViewController];
        
        LBJPTableViewCell* cell = (LBJPTableViewCell*)sender;
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        PFObject *cellObject = [cell parseObject];
        
        // Pass the information to your destination view
        [destinationViewController setParseObject:cellObject];
    }
}


@end
