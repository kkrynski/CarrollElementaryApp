//
//  ActivityCreationTVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "ActivityCreationTVC.h"

#import "PageCreationVC.h"

#import "Activity.h"
#import "Page.h"
#import "Content.h"
#import "ClassConversions.h"

#import "ActivityInfoVC.h"

@interface ActivityCreationTVC ()
{
    UIFont *font;
    int currentIndex;
    UIBarButtonItem *editButton;
    UIBarButtonItem *saveButton;
}
@end

@implementation ActivityCreationTVC
@synthesize pagesArray;
@synthesize activity;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Activity";
    
    activity = [[Activity alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"myplist.plist"];
    NSLog(@"File path = %@", path);

    pagesArray = [[NSMutableArray alloc] initWithObjects: nil];

    if ([NSDictionary dictionaryWithContentsOfFile:path])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        ClassConversions *cc = [[ClassConversions alloc] init];
        activity = [cc activityFromDictionary:dict];
        pagesArray = [[NSMutableArray alloc] initWithArray: activity.pageArray];

    }
    
    currentIndex = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveActivity:)];
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItems = @[editButton, saveButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.pageCreationVC = (PageCreationVC *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.pageCreationVC.delegate = self;
    self.pageCreationVC.page = (Page *)pagesArray.firstObject;

    // Create our font. Later we'll want to hook this up to the
    // rest of the app for easier change.
    font = [[UIFont alloc]init];
    font = [UIFont fontWithName:@"Marker Felt" size:32.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)edit
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.editButtonItem setTitle:@"Edit"];
        [self.editButtonItem setStyle:UIBarButtonItemStylePlain];
        
        saveButton.enabled = YES;
        
        // Enable the detail view controller again
        self.pageCreationVC.pagePicker.userInteractionEnabled = YES;
        self.pageCreationVC.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.editButtonItem setTitle:@"Done"];
        [self.editButtonItem setStyle:UIBarButtonItemStyleDone];
        
        saveButton.enabled = NO;
        
        // Disable detail view controller
        self.pageCreationVC.pagePicker.userInteractionEnabled = NO;
        self.pageCreationVC.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)insertNewObject
{
    if (!self.pagesArray)
    {
        self.pagesArray = [[NSMutableArray alloc] init];
    }
    Page *newPage = [[Page alloc] init];
    
    // Insert at front and move to end
    //
    // It's ugly, so if you can find another way to do it, please do.
    [self.tableView beginUpdates];
    
    [self.pagesArray addObject: newPage];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pagesArray.count inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    currentIndex = self.pagesArray.count - 1;

    self.pageCreationVC.page = newPage;
    [self.pageCreationVC configureView];
}

-(void)saveActivity: (id)sender
{
    if (_activityInfoVC == nil)
    {
        //Create the ColorPickerViewController.
        _activityInfoVC = [[ActivityInfoVC alloc] initWithActivity:activity];
        
        //Set this VC as the delegate.
        _activityInfoVC.delegate = self;
        
    }else
    {
        _activityInfoVC.activity = activity;
    }
    
    if (_activityInfoPopOver == nil) {
        //The color picker popover is not showing. Show it.
        _activityInfoPopOver = [[UIPopoverController alloc] initWithContentViewController:_activityInfoVC];
        _activityInfoPopOver.popoverContentSize = CGSizeMake(self.activityInfoVC.view.frame.size.width, self.activityInfoVC.view.frame.size.height);
        [_activityInfoPopOver presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else
    {
        //The color picker popover is showing. Hide it.
        [_activityInfoPopOver dismissPopoverAnimated:YES];
        _activityInfoPopOver = nil;
    }
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = [self.pagesArray count];
    if(self.editing) count++;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following chunk of code is pretty standard. It allows you to
    // reuse cells, meaning that instead of making 1000 cells, it reuses
    // cells that have long since left the screen. This saves memory and
    // keeps the app from crashing.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if(indexPath.row == ([self.pagesArray count]) && self.editing)
    {
        cell.textLabel.text = @"Add new page";
        return cell;
    }
    
    // Update and format the title label, or the primary label in the cell.
    cell.textLabel.text = [(Page *)[pagesArray objectAtIndex:indexPath.row] pageVCType];
    //cell.textLabel.font = font;
    //cell.textLabel.textColor = primaryColor;
    //[self outlineTextInLabel:cell.textLabel];
    
    // Update cell colors
    //cell.backgroundColor = [self lighterColorForColor:backgroundColor];
    //tableView.backgroundColor = [self lighterColorForColor:backgroundColor];
    
    // Changes the color of the lines in between cells.
    //[tableView setSeparatorColor:primaryColor];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following line keeps the cell from staying selected.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath.row;
    self.pageCreationVC.page = (Page *)[self.pagesArray objectAtIndex:currentIndex];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([self.pagesArray count]))
        return UITableViewCellEditingStyleInsert;
    else
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.pagesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        [self insertNewObject];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Re-order page array
    Page *pageToMove = [self.pagesArray objectAtIndex:fromIndexPath.row];
    [self.pagesArray removeObjectAtIndex:fromIndexPath.row];
    [self.pagesArray insertObject:pageToMove atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






-(NSString *)createJSONForActivity
{
    return [NSString stringWithFormat:@""];
}


#pragma mark - ContentPickerDelegate method
-(void)updatePage:(Page *)p
{
    if (self.pagesArray.count == 0)
    {
        [self.pagesArray addObject:p];

    }else
    {
        [self.pagesArray replaceObjectAtIndex:currentIndex withObject:p];

    }
    
    [self.pageCreationVC setPage:p];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:currentIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    //[self.tableView reloadData];
}

-(void)finishSavingActivity: (Activity *)a
{
    NSLog(@"Finishing saving activity");
    
    activity.pageArray = pagesArray;
    activity.modDate = [NSDate date];
    
    // Generate activity ID
    //activity.activityID = @"aaaaaa"
    
    
    ClassConversions *cc = [[ClassConversions alloc] init];
    
    // Save to JSON here
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[cc dictionaryForActivity: activity]
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    
    
    
    
    // Or save to plist here
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentPath stringByAppendingPathComponent:@"myplist.plist"];
    NSLog(@"File path = %@", plistPath);
    NSFileManager *fileManager  =   [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:plistPath];
    // This line saves the dictionary to pList
    [[cc dictionaryForActivity: activity] writeToFile:plistPath atomically:YES];
    NSLog(@"%hhd", success);
    
    
    
    // Dismiss screen
    [_activityInfoPopOver dismissPopoverAnimated:YES];
    _activityInfoPopOver = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
