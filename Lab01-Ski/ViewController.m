//
//  ViewController.m
//  Lab01-Ski
//
//  Created by Legault, Mathieu on 2015-01-21.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldPrenom;
@property (weak, nonatomic) IBOutlet UITextField *fieldNom;
@property (weak, nonatomic) IBOutlet UITextField *fieldPays;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *TIMELabel;
- (IBAction)buttonAdd:(UIButton *)sender;
@end

@implementation ViewController
{
    NSMutableArray *tableParticipantsData;
    int nextId;
    bool running;
    NSTimeInterval startTime;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Init table data?????
    tableParticipantsData = [[NSMutableArray alloc] init];
    nextId = 0;
    _TIMELabel.text=@"0:00.0";
    running = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableParticipantsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableParticipantsData objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)buttonAdd:(UIButton *)sender {
    if (_fieldNom.text.length <= 0 || _fieldPrenom.text.length <= 0 || _fieldPays.text.length <= 0) {
        NSLog(@"Fields are not complete. Cannot add.");
    }
    else{
        NSString *participant = [NSString stringWithFormat:@"%@%@%@%@%@%@%d%@", _fieldPrenom.text, @" ", _fieldNom.text, @" | ", _fieldPays.text, @" | ", nextId, @" "];
        nextId++;
        bool alreadyPresent = false;
        for(NSString *string in tableParticipantsData){
            if([string isEqualToString:participant]){
                alreadyPresent = true;
            }
        }
        if(alreadyPresent == false){
            [tableParticipantsData addObject:participant];
            [self.tableView reloadData];
        }
    }
}


- (void)updateTime
{
    if(running == false) return;
    
    //calculate elapsed time
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    
    //Extract out the minutes, seconds, and fraction of seconds from elapsed time
    int mins = (int)(elapsed/60.0);
    elapsed -= mins * 60;
    int secs = (int)(elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    
    //Update label (format 0:00.0)
    _TIMELabel.text = [NSString stringWithFormat:@"%u:%02u.%u", mins, secs, fraction];
    
    //call updateTime again after 0.1 second
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)Start:(UIButton *)sender
{
    if(running == false){
        //Start timer
        running = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
    }
    else{
        //stop timer
        [sender setTitle:@"GO" forState:UIControlStateNormal];
        running = false;
    }
}


@end
