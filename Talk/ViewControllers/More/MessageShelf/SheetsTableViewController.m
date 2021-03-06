//
//  SheetsTableViewController.m
//  Talk
//
//  Created by Suric on 15/6/18.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "SheetsTableViewController.h"
#import "TBMessage.h"
#import "MTLJSONAdapter.h"
#import "TBFile.h"
#import "TBUser.h"
#import "NSDate+TBUtilities.h"
#import "MORoom.h"
#import "CoreData+MagicalRecord.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TBUtility.h"
#import "UIColor+TBColor.h"
#import "TBHTTPSessionManager.h"
#import "MJRefresh.h"
#import "TBMenuItem.h"
#import "UIActionSheet+SHActionSheetBlocks.h"
#import "MOMessage.h"
#import "SVProgressHUD.h"
#import "PlaceHolderView.h"
#import "AddTagViewController.h"
#import "TBTag.h"
#import "TBAttachment.h"
#import "JLWebViewController.h"

@interface SheetsTableViewController ()

@end

@implementation SheetsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SyncData

- (void)syncData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *teamID = [defaults valueForKey:kCurrentTeamID];
    
    NSMutableDictionary *parasDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:teamID,@"_teamId",
                                            @"thirdapp",@"type",
                                            [[NSString alloc] initWithFormat:@"%d",self.pageNumber],@"page",
                                            [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"desc",@"order", nil],@"createdAt", nil],@"sort",
                                            nil];
    [parasDictionary addEntriesFromDictionary:self.filterDictionary];
    
    TBHTTPSessionManager *manager = [TBHTTPSessionManager sharedManager];
    [manager GET:kSearchURLString parameters:parasDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogVerbose(@"response data: %@", responseObject);
        [self processResponseData:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DDLogError(@"error: %@", error.localizedRecoverySuggestion);
    }];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TBMessage *model = self.messagesArray[indexPath.row];
    TBAttachment *attachment = model.attachments.firstObject;
    NSURL *redirectURL = [NSURL URLWithString:attachment.data[kQuoteRedirectUrl]];
    
    JLWebViewController *jsViewController = [[JLWebViewController alloc]init];
    jsViewController.hidesBottomBarWhenPushed = YES;
    jsViewController.urlString = redirectURL.absoluteString;
    [self.navigationController pushViewController:jsViewController animated:YES];
}

@end
