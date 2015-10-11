
#import "ASViewController.h"
#import "ASGroup.h"
#import "ASStudent.h"


@interface ASViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic)    UITableView* tableView;
@property (strong, nonatomic)   NSMutableArray* groupsArray;
@end

@implementation ASViewController


-(void) loadView {
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    
     self.tableView = tableView;
     self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     self.tableView.delegate         = self;
     self.tableView.dataSource       = self;
    [self.view addSubview:self.tableView];

}


- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.navigationItem.title = @"Students iOS Dev Course ";

    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem* addButton  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    self.groupsArray = [NSMutableArray array];
    [self creatGroupStudent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groupsArray objectAtIndex:section] nameGroup];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
       
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.text = [[self.groupsArray objectAtIndex:section] nameGroup];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return 1;
    return [self.groupsArray count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ASGroup* tempGroup = [self.groupsArray objectAtIndex:section];
    return [tempGroup.students count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString* identifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    ASGroup*   tempGroup    = [self.groupsArray objectAtIndex:indexPath.section];
    ASStudent* tempStudents = [tempGroup.students objectAtIndex:indexPath.row];
    
    NSLog(@"tempGroup - %@",tempGroup);
    
    if (tempStudents.averagePrice >= 3.5f) {
        cell.backgroundColor = [UIColor greenColor];
    }
    else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@ %@",tempStudents.name , tempStudents.famaly];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",tempStudents.averagePrice];
    
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ASGroup*   sourceGroup    = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    ASStudent* sourceStudent  = [sourceGroup.students objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray* array     = [NSMutableArray new];
    array =  sourceGroup.students;
    
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [array replaceObjectAtIndex:destinationIndexPath.row withObject:sourceStudent];
        sourceGroup.students = array;
    } else {
        
        [array removeObjectAtIndex:sourceIndexPath.row];
        sourceGroup.students = array;
        
        ASGroup* destGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
        NSMutableArray* destArray = [NSMutableArray new];
        destArray = destGroup.students;
        
        [destArray insertObject:sourceStudent atIndex:destinationIndexPath.row];
        destGroup.students = destArray;
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ASGroup* sourceGroup     = [self.groupsArray objectAtIndex:indexPath.section];
        ASStudent* sourceStudent = [sourceGroup.students objectAtIndex:indexPath.row];
        
        
        NSMutableArray* array = sourceGroup.students;
        [array removeObject:sourceStudent];
        sourceGroup.students = array;
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
    }
    
}



#pragma mark -  UITableViewDelegate


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return proposedDestinationIndexPath;
}

#pragma mark - Navigation Button

-(void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}


-(void) actionAdd:(UIBarButtonItem*) sender {
    
    ASGroup* group  = [[ASGroup alloc] init];
    group.nameGroup = [NSString stringWithFormat:@"Group name - %d",[self.groupsArray count]+1];

    NSMutableArray* temp = [[NSMutableArray alloc]init];

    for (int j=0; j <= (arc4random()%(4-2))+2; j++) {
        
        ASStudent* student = [[ASStudent alloc] init];
        [temp addObject:student];
    }
    group.students = temp;
    //[self.groupsArray addObject:group];
    [self.groupsArray insertObject:group atIndex:0];
    

    [self.tableView beginUpdates];
    NSIndexSet* insertSections = [NSIndexSet indexSetWithIndex:0];
    [self.tableView insertSections:insertSections withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}



-(void) creatGroupStudent {
    
    int fromNumber = 5;
    int toNumber   = 10;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    
    
    
    for (int i=0; i <= randomNumber; i++) {
        
        ASGroup* group  = [[ASGroup alloc] init];
        group.nameGroup = [NSString stringWithFormat:@"Group name - %d",i];
        
        NSMutableArray* temp = [[NSMutableArray alloc]init];
        
        
        
        for (int j=0; j <= (arc4random()%(7-3))+3; j++) {
            
            ASStudent* student = [[ASStudent alloc] init];
            [temp addObject:student];
        }
        group.students = temp;
        [self.groupsArray addObject:group];
        //[self.groupsArray insertObject:group atIndex:0];
    }
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
