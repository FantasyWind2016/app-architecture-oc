//
//  AAOFolderViewController.m
//  Recordings
//
//  Created by 季风 on 2018/9/24.
//  Copyright © 2018年 fantasywind. All rights reserved.
//

#import "AAOFolderViewController.h"
#import "AAOStore.h"
#import "AAOFolder.h"
#import "AAORecording.h"
#import "AAOUtil.h"
#import "AAORecordViewController.h"
#import "AAOPlayViewController.h"
#import "NSString+text.h"
#import "UIViewController+Alert.h"

@interface AAOFolderViewController ()
@property (nonatomic, strong) AAOItem *selectedItem;
@end

@implementation AAOFolderViewController
@synthesize folder=_folder;

- (void)setFolder:(AAOFolder *)folder {
    _folder = folder;
    [self.tableView reloadData];
    if (folder == [AAOStore shared].rootFolder) {
        self.navigationItem.title = [NSString recordings];
    } else {
        self.navigationItem.title = folder.name;
    }
}

- (AAOFolder *)folder {
    if (_folder) {
        return _folder;
    } else {
        return [AAOStore shared].rootFolder;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNotification:) name:AAOStoreChangeNotification object:nil];
}

- (void)handleChangeNotification:(NSNotification *)notification {
    AAOItem *item = notification.object;
    if (item == self.folder) {
        NSString *reason = [notification.userInfo valueForKey:AAONotifyKeyChangeReason];
        if ([reason isEqualToString:AAONotifyChangeReasonRemoved]) {
            UINavigationController *nc = self.navigationController;
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return evaluatedObject != self;
            }];
            [nc setViewControllers:[nc.viewControllers filteredArrayUsingPredicate:predicate] animated:false];
        } else {
            self.folder = (AAOFolder *)item;
        }
    }
    
    AAOItem *parent = [notification.userInfo valueForKey:AAONotifyKeyParentFolder];
    if (parent != self.folder) {
        return;
    }
    
    NSString *reason = [notification.userInfo valueForKey:AAONotifyKeyChangeReason];
    NSInteger oldValue = [[notification.userInfo valueForKey:AAONotifyKeyOldValue] integerValue];
    NSInteger newValue = [[notification.userInfo valueForKey:AAONotifyKeyNewValue] integerValue];
    if ([reason isEqualToString:AAONotifyChangeReasonRemoved]) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldValue inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    } else if ([reason isEqualToString:AAONotifyChangeReasonAdded]) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newValue inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    } else if ([reason isEqualToString:AAONotifyChangeReasonRenamed]) {
        [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:oldValue inSection:0] toIndexPath:[NSIndexPath indexPathForRow:newValue inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newValue inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadData];
    }
}

- (AAOItem *)selectedItem {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        return self.folder.contents[indexPath.row];
    }
    return nil;
}

- (IBAction)createNewFolder:(id)sender {
    [self modalTextAlertWithTitle:[NSString createFolder] accept:[NSString create] cancel:nil placeholder:[NSString folderName] callback:^(NSString *string) {
        if (string.length > 0) {
            AAOFolder *newFolder = [[AAOFolder alloc] initWithName:string uuid:[NSUUID UUID].UUIDString];
            [self.folder addItem:newFolder];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)createNewRecording:(id)sender {
    [self performSegueWithIdentifier:[NSString showRecorder] sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if (identifier.length==0) {
        return;
    }
    if ([identifier isEqualToString:[NSString showFolder]]) {
        if (!segue.destinationViewController || [segue.destinationViewController isKindOfClass:[AAOFolderViewController class]]) {
            raise(0);
        }
        AAOFolderViewController *vc = (AAOFolderViewController *)segue.destinationViewController;
        vc.folder = (AAOFolder *)self.selectedItem;
    } else if ([identifier isEqualToString:[NSString showRecorder]]) {
        if (!segue.destinationViewController || [segue.destinationViewController isKindOfClass:[AAORecordViewController class]]) {
            raise(0);
        }
        AAORecordViewController *vc = (AAORecordViewController *)segue.destinationViewController;
        vc.folder = self.folder;
    } else if ([identifier isEqualToString:[NSString showPlayer]]) {
        if (![segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            raise(0);
        }
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        if (![nc.topViewController isKindOfClass:[AAOPlayViewController class]]) {
            raise(0);
        }
        if ([self.selectedItem isKindOfClass:[AAORecording class]]) {
            raise(0);
        }
        AAOPlayViewController *vc = (AAOPlayViewController *)nc.topViewController;
        vc.recording = (AAORecording *)self.selectedItem;
        if (self.tableView.indexPathForSelectedRow) {
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folder.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AAOItem *item = self.folder.contents[indexPath.row];
    NSString *identifier = [item isKindOfClass:[AAORecording class]] ? @"RecordingCell" : @"FolderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.textLabel.text = [([item isKindOfClass:[AAORecording class]] ? @"🔊" : @"📁") stringByAppendingString:item.name];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.folder removeItem:self.folder.contents[indexPath.row]];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

#pragma mark - UIStateRestoring
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:self.folder.uuidPath forKey:[NSString uuidPathKey]];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    id uuidPath = [coder decodeObjectForKey:[NSString uuidPathKey]];
    if (![uuidPath isKindOfClass:[NSArray class]]) {
        raise(0);
    }
    AAOItem *item = [AAOStore.shared itemAtUUIDPath:uuidPath];
    if ([item isKindOfClass:[AAOFolder class]]) {
        self.folder = (AAOFolder *)item;
    } else {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index>0) {
            NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
            [vcs removeObjectAtIndex:index];
            [self.navigationController setViewControllers:vcs animated:NO];
        }
    }
}

@end
