//
//  ViewController.m
//  algoAetoile
//
//  Created by William Klein on 01/10/12.
//  Copyright (c) 2012 William Klein. All rights reserved.
//

#import "ViewController.h"

#define MAP_EMPTY   0
#define MAP_BLOCK   1
#define MAP_START   2
#define MAP_END     3
#define MAP_WIDTH   40
#define MAP_HEIGHT  40
#define MAP_OFFSETX 20
#define MAP_OFFSETY 50

struct aPoint {
    int x;
    int y;
    int g;
    int f;
};

NSInteger mapArray[MAP_WIDTH][MAP_HEIGHT];
NSInteger gArray[MAP_WIDTH][MAP_HEIGHT];
NSMutableArray *listPoints;
struct aPoint currentPoint;
struct aPoint startPoint;
struct aPoint endPoint;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    listPoints = [[NSMutableArray alloc] init];
    [calculate setEnabled:NO];
    [calculate setAlpha:0.5];
    [diagonalsAuthorized setEnabled:NO];
    [calculate setAlpha:0.5];
    [result setText:@""];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self createDynamicMap:nil];
}

- (void)generateMap
{
    startPoint.x = rand()%MAP_WIDTH;
    startPoint.y = rand()%MAP_HEIGHT;
    endPoint.x = rand()%MAP_WIDTH;
    endPoint.y = rand()%MAP_HEIGHT;
    
    for (int x = 0; x < MAP_WIDTH; x++) {
        for (int y = 0; y < MAP_HEIGHT; y++) {
            if(startPoint.x == x && startPoint.y == y)
            {
                mapArray[x][y] = MAP_START;
            }
            else if(endPoint.x == x && endPoint.y == y)
            {
                mapArray[x][y] = MAP_END;
            }            
            else if (rand()%100 < obstaclesAmount.value)
            {
                mapArray[x][y] = MAP_BLOCK;
            }
            else
            {
                mapArray[x][y] = MAP_EMPTY;
            }
            gArray[x][y] = -1;
        }
    }
}

- (void)drawMap
{
    for (UIView *view in self.view.subviews) {
        if(view.tag == 777)
        {
            [view removeFromSuperview];
        }
    }
    NSString *name = [[NSString alloc] init];
    for (int x = 0; x < MAP_WIDTH; x++) {
        for (int y = 0; y < MAP_HEIGHT; y++) {
            
            switch (mapArray[x][y]) {
                case MAP_START:
                    name = @"start";
                    break;
                case MAP_END:
                    name = @"end";
                    break;
                case MAP_BLOCK:
                    name = @"invalid";
                    break;
                case MAP_EMPTY:
                    name = @"valid";
                    break;
                default:
                    break;
            }
            
            UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]];
            [tmp setFrame:CGRectMake(x*7+MAP_OFFSETX, y*7+MAP_OFFSETY, 6, 6)];
            tmp.tag = 777;
            [self.view addSubview:tmp];
        }
    }
}

- (IBAction)createDynamicMap:(id)sender
{
    [self generateMap];
    [self drawMap];
    [calculate setEnabled:YES];
    [calculate setAlpha:1];
    [diagonalsAuthorized setEnabled:YES];
    [calculate setAlpha:1];
    [result setText:@""];
}

- (IBAction)calculateBestPath:(id)sender
{
    currentPoint.x = startPoint.x;
    currentPoint.y = startPoint.y;
    currentPoint.g = 0;
    currentPoint.f = 0;
    
    gArray[currentPoint.x][currentPoint.y] = 0;
    
    while (currentPoint.x != endPoint.x ||
           currentPoint.y != endPoint.y
           ) {
        
        if(currentPoint.g <= gArray[currentPoint.x][currentPoint.y])
        {
            struct aPoint voisin;
            if (diagonalsAuthorized.on) {
                // déplacement sur x
                for(int i = -1; i < 2; i++) {
                    // déplacement sur y
                    for(int j = -1; j < 2; j++) {
                        // on ne fait pas sur le même point
                        if(i != 0 || j != 0) {
                            voisin.x = currentPoint.x+i;
                            voisin.y = currentPoint.y+j;
                            // bords de la map
                            if( voisin.x >= 0 && voisin.x < MAP_WIDTH &&
                               voisin.y >= 0 && voisin.y < MAP_HEIGHT &&
                               // obstacle
                               mapArray[voisin.x][voisin.y] != MAP_BLOCK) {
                                voisin.f = currentPoint.g + 1 + Manhattan(voisin, endPoint);
                                if (gArray[voisin.x][voisin.y] == -1 ||
                                    gArray[voisin.x][voisin.y] > (currentPoint.g + 1)
                                    ) {
                                    gArray[voisin.x][voisin.y] = currentPoint.g + 1;
                                    voisin.g = currentPoint.g + 1;
                                    
                                    [listPoints addObject:[NSValue value:&voisin withObjCType:@encode(struct aPoint)]];
                                }
                            }
                        }
                    }
                }
            } else {
                // déplacement sur x
                for(int i = -1; i < 2; i++) {
                    // déplacement sur y
                    for(int j = -1; j < 2; j++) {
                        // on ne fait pas sur le même point
                        if((i != 0 || j != 0) &&
                           (i != -1 || j != -1) &&
                           (i != -1 || j != 1) &&
                           (i != 1 || j != -1) &&
                           (i != 1 || j != 1)) {
                            voisin.x = currentPoint.x+i;
                            voisin.y = currentPoint.y+j;
                            // bords de la map
                            if( voisin.x >= 0 && voisin.x < MAP_WIDTH &&
                               voisin.y >= 0 && voisin.y < MAP_HEIGHT &&
                               // obstacle
                               mapArray[voisin.x][voisin.y] != MAP_BLOCK) {
                                voisin.f = currentPoint.g + 1 + Manhattan(voisin, endPoint);
                                if (gArray[voisin.x][voisin.y] == -1 ||
                                    gArray[voisin.x][voisin.y] > (currentPoint.g + 1)
                                    ) {
                                    gArray[voisin.x][voisin.y] = currentPoint.g + 1;
                                    voisin.g = currentPoint.g + 1;
                                    
                                    [listPoints addObject:[NSValue value:&voisin withObjCType:@encode(struct aPoint)]];
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if([listPoints count] > 0) {
            struct aPoint point;
            [[listPoints objectAtIndex:0] getValue:&point];
            currentPoint = point;
            
            for (int index = 0; index < [listPoints count]; index++) {
                struct aPoint tmpPoint;
                [[listPoints objectAtIndex:index] getValue:&tmpPoint];
                
                if(currentPoint.f > tmpPoint.f)
                {
                    currentPoint = tmpPoint;
                }
            }
            
            [listPoints removeObject:[NSValue value:&currentPoint withObjCType:@encode(struct aPoint)]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Can't find a way here, sorry !" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [calculate setEnabled:NO];
    [calculate setAlpha:0.5];
    [diagonalsAuthorized setEnabled:NO];
    [calculate setAlpha:0.5];
    [result setText:[NSString stringWithFormat:@"The shortest path between G and B measures %ld.", (long)gArray[endPoint.x][endPoint.y]]];
    
    [self drawPathOnMap];
}

- (void)drawPathOnMap
{
    
    struct aPoint current;  
    struct aPoint voisin;
    BOOL next;
    
    current = endPoint;
    
    for (int g = gArray[endPoint.x][endPoint.y]; g > 0; g--) {
        next = NO;
        // déplacement sur x
        for(int i = -1; i < 2; i++) {
            // déplacement sur y
            for(int j = -1; j < 2; j++) {
                // on ne fait pas sur le même point
                if((i != 0 || j != 0) && !next) {
                    voisin.x = current.x+i;
                    voisin.y = current.y+j;
                    voisin.g = gArray[current.x+i][current.y+j];
                    if( voisin.g == g-1 )
                    {
                        UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"going.png"]];
                        [tmp setFrame:CGRectMake(voisin.x*7+MAP_OFFSETX, voisin.y*7+MAP_OFFSETY, 6, 6)];
                        tmp.tag = 777;
                        [self.view addSubview:tmp];
                        current = voisin;
                        next = YES;
                    }
                }
            }
        }
    }
    
    UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
    [tmp setFrame:CGRectMake(startPoint.x*7+MAP_OFFSETX, startPoint.y*7+MAP_OFFSETY, 6, 6)];
    tmp.tag = 777;
    [self.view addSubview:tmp];
    
    tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"end.png"]];
    [tmp setFrame:CGRectMake(endPoint.x*7+MAP_OFFSETX, endPoint.y*7+MAP_OFFSETY, 6, 6)];
    tmp.tag = 777;
    [self.view addSubview:tmp];
}

int Manhattan(struct aPoint voisin, struct aPoint end) {
    return (abs(voisin.x-end.x) + abs(voisin.y-end.y));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
