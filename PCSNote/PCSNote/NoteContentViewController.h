//
//  NoteContentViewController.h
//  PCSNote
//
//  Created by Yongmo Liang on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesListViewController.h"


@interface NoteContentViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, strong) NSDictionary *detailFile;

@end
