//
//  ViewController.m
//  LazyLoading4
//
//  Created by Quazi Ridwan Hasib on 8/03/2016.
//  Copyright © 2016 Quazi Ridwan Hasib. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "AppRecord.h"
#import "IconDownloader.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    NSArray *lg;
    NSArray *lblTxt1;
    int row;

    NSMutableDictionary *imageDownloadsInProgress;
    
    NSArray *images ,*titles;
}
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    lg = [[NSArray alloc] initWithObjects:@"Placeholder.png" , @"Placeholder.png", @"Placeholder.png",
//          @"Placeholder.png", nil];
//    lblTxt1 = [[NSArray alloc] initWithObjects:@"a" , @"b", @"c", @"d", nil];
    [self loadStaticData];
    self->imageDownloadsInProgress = [[NSMutableDictionary alloc] init];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.entries .count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Reuse and create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Leave cells empty if there's no data yet
    AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
    cell.textLabel.text = appRecord.appName;
    cell.detailTextLabel.text = appRecord.artist;
    
    if (!appRecord.appIcon)
    {
        if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
        {
            [self startIconDownload:appRecord forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cell.imageView.image = appRecord.appIcon;
    }
    return cell;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    row = indexPath.row;
//    NSLog(@"aaaaa: %d", row);
//    
//    NSString *selectedValue1 = [arrayName objectAtIndex:indexPath.row];
//    NSLog(@"bbbbb1: %@", selectedValue1);
//    
//    NSString *selectedValue2 = [arrayId objectAtIndex:indexPath.row];
//    NSLog(@"bbbbb2: %@", selectedValue2);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self->imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self->imageDownloadsInProgress removeAllObjects];
}
#pragma mark - Table cell image support


- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self->imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            // Display the newly loaded image
            cell.imageView.image = appRecord.appIcon;
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self->imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        [self->imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}
// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!appRecord.appIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


-(void)loadStaticData{
    titles = [[NSArray alloc]initWithObjects:@"Heads Up! - Warner Bros.",@ "Minecraft – Pocket Edition - Mojang",@ "Blek - Denis Mikan",@ "Afterlight - Simon Filip",@ "Geometry Dash - Robert Topala",@ "Justin.tv - Twitch Interactive, Inc.",@"Heads Up! - Warner Bros.",@ "Minecraft – Pocket Edition - Mojang",@ "Blek - Denis Mikan",@ "Afterlight - Simon Filip",@ "Geometry Dash - Robert Topala",@ "Justin.tv - Twitch Interactive, Inc.",@"Heads Up! - Warner Bros.",@ "Minecraft – Pocket Edition - Mojang",@ "Blek - Denis Mikan",@ "Afterlight - Simon Filip",@ "Geometry Dash - Robert Topala",@ "Justin.tv - Twitch Interactive, Inc.",nil];
    
    images = [[NSArray alloc]initWithObjects:@"http://a764.phobos.apple.com/us/r30/Purple2/v4/8d/05/fe/8d05fecd-ef8e-1393-d7d4-3622078e2b52/mzl.aossebpw.53x53-50.png", @"http://a1592.phobos.apple.com/us/r30/Purple/v4/94/98/2f/94982fe2-4cec-8a02-fbf6-6fe0851276e2/mzl.nlynfkyw.53x53-50.png", @"http://a1356.phobos.apple.com/us/r30/Purple4/v4/35/7d/cc/357dccc3-4cf3-cf86-789d-8ea771138857/mzl.suptdinm.53x53-50.png", @"http://a932.phobos.apple.com/us/r30/Purple6/v4/43/b9/93/43b993fb-05c6-fcfb-bc3f-40c1207ddf0a/mzl.pnmvfolg.53x53-50.png", @"http://a1041.phobos.apple.com/us/r30/Purple4/v4/21/19/13/2119132e-de27-5419-27ff-cd01c017613a/mzl.smhzbsuv.53x53-50.png", @"http://a1628.phobos.apple.com/us/r30/Purple/v4/c9/ce/cf/c9cecfd7-af13-651b-dc2b-d0d22d01e1cd/mzl.vmxpemwk.53x53-50.png", @"http://a764.phobos.apple.com/us/r30/Purple2/v4/8d/05/fe/8d05fecd-ef8e-1393-d7d4-3622078e2b52/mzl.aossebpw.53x53-50.png", @"http://a1592.phobos.apple.com/us/r30/Purple/v4/94/98/2f/94982fe2-4cec-8a02-fbf6-6fe0851276e2/mzl.nlynfkyw.53x53-50.png", @"http://a1356.phobos.apple.com/us/r30/Purple4/v4/35/7d/cc/357dccc3-4cf3-cf86-789d-8ea771138857/mzl.suptdinm.53x53-50.png", @"http://a932.phobos.apple.com/us/r30/Purple6/v4/43/b9/93/43b993fb-05c6-fcfb-bc3f-40c1207ddf0a/mzl.pnmvfolg.53x53-50.png", @"http://a1041.phobos.apple.com/us/r30/Purple4/v4/21/19/13/2119132e-de27-5419-27ff-cd01c017613a/mzl.smhzbsuv.53x53-50.png", @"http://a1628.phobos.apple.com/us/r30/Purple/v4/c9/ce/cf/c9cecfd7-af13-651b-dc2b-d0d22d01e1cd/mzl.vmxpemwk.53x53-50.png",@"http://a764.phobos.apple.com/us/r30/Purple2/v4/8d/05/fe/8d05fecd-ef8e-1393-d7d4-3622078e2b52/mzl.aossebpw.53x53-50.png", @"http://a1592.phobos.apple.com/us/r30/Purple/v4/94/98/2f/94982fe2-4cec-8a02-fbf6-6fe0851276e2/mzl.nlynfkyw.53x53-50.png", @"http://a1356.phobos.apple.com/us/r30/Purple4/v4/35/7d/cc/357dccc3-4cf3-cf86-789d-8ea771138857/mzl.suptdinm.53x53-50.png", @"http://a932.phobos.apple.com/us/r30/Purple6/v4/43/b9/93/43b993fb-05c6-fcfb-bc3f-40c1207ddf0a/mzl.pnmvfolg.53x53-50.png", @"http://a1041.phobos.apple.com/us/r30/Purple4/v4/21/19/13/2119132e-de27-5419-27ff-cd01c017613a/mzl.smhzbsuv.53x53-50.png", @"http://a1628.phobos.apple.com/us/r30/Purple/v4/c9/ce/cf/c9cecfd7-af13-651b-dc2b-d0d22d01e1cd/mzl.vmxpemwk.53x53-50.png",nil];
    
    //@"http://quaziridwanhasib.com/products/5.jpg"
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSInteger i=0;i<(NSInteger)titles.count;i++) {
        AppRecord *app = [[AppRecord alloc]init];
        app.imageURLString = images[i];
        app.appName = titles[i];
        app.artist = [NSString stringWithFormat:@"%d",i];
        [arr addObject:app];
    }
    self.entries = [[NSArray alloc]initWithArray:arr];
}

@end
