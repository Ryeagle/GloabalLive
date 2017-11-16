//
//  RYFirstViewController.m
//  globalLive
//
//  Created by Ryeagler on 2017/11/5.
//  Copyright © 2017年 Ryeagle. All rights reserved.
//

#import "RYFirstViewController.h"
#import "RYLiveViewController.h"

@interface RYFirstViewController ()
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RYFirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Live";
    [self configData];
    self.tableView.tableFooterView = [UIView new];
}

- (void)configData
{
    NSMutableArray *mulArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [GLLiveUrlConfig sharedInstance].liveUrlDict.allKeys.count; i++) {
        NSString *title = [NSString stringWithFormat:@"Enter Live %03ld", i];
        [mulArr addObject:title];
    }
    
    self.dataArray = [mulArr copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"liveCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *apiStr = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:apiStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    [[RYLiveManager sharedInstance] enterLiveWithId:[NSString stringWithFormat:@"liveid_%03ld", indexPath.row]];
}

@end
