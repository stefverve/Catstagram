//
//  PhotoViewCell.h
//  Selfies
//
//  Created by Stefan Verveniotis on 2016-11-21.
//  Copyright © 2016 Stefan Verveniotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end
