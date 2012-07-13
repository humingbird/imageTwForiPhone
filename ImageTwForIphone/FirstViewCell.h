//
//  FirstViewCell.h
//  ImageTwForIphone
//
//  Created by  on 12/07/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewCell : UITableViewCell{
    IBOutlet UILabel *topUserName;
    IBOutlet UILabel *iine;
    IBOutlet UILabel *commentUserName;
    IBOutlet UILabel *comment;
    IBOutlet UIImageView *photo;
    IBOutlet UIButton *iineButton;
}
@property(nonatomic,retain) IBOutlet UILabel *topUserName;
@property(nonatomic,retain) IBOutlet UILabel *iine;
@property(nonatomic,retain) IBOutlet UILabel *commentUserName;
@property(nonatomic,retain) IBOutlet UILabel *comment;
@property(nonatomic,retain) IBOutlet UIImageView *photo;
@property(nonatomic,retain) IBOutlet UIButton *iineButton;
@end
