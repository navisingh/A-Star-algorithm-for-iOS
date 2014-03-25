//
//  ViewController.h
//  algoAetoile
//
//  Created by William Klein on 01/10/12.
//  Copyright (c) 2012 William Klein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIButton   *calculate;
    IBOutlet UILabel    *result;
    IBOutlet UISlider   *obstaclesAmount;
    IBOutlet UISwitch   *diagonalsAuthorized;
}

- (IBAction)createDynamicMap:(id)sender;
- (IBAction)calculateBestPath:(id)sender;

@end
